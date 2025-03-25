import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/ui/customer/manage_organized_events.dart';
import '../../core/service/shared_preferences.dart';
import '../../data/model/user.dart';
import '../../data/repository/user/user_repository_impl.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';
import '../../data/model/chat.dart';
import '../../data/model/user.dart' as user_model;
import '../../data/repository/chat/chat_repository_impl.dart';
import '../customer/reset_password.dart';


class Adminuserprofile extends StatefulWidget {
  final user_model.User user;
  const Adminuserprofile({super.key, required this.user});

  @override
  State<Adminuserprofile> createState() => _UserProfileState();
}

class _UserProfileState extends State<Adminuserprofile> {
  UserRepoImpl UserRepo = UserRepoImpl();
  late user_model.User _userInfo;
  bool _isLoading = true;

  void getUserID() async {
    user_model.User? userDetails= await UserRepo.getUserById(widget.user.id);
    setState(() {
      _userInfo = userDetails!;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserID();
    getUserDetails();

  }

  void _logout() async {
    await SharedPreference.setIsLoggedIn(false);
    UserRepo.logout();
    context.go('/login');
  }

  Future<void> navigateToEditProfile() async {
    final updatedUser = await context.push<user_model.User>('/edit_profile', extra: _userInfo);

    if (updatedUser != null) {
      setState(() {
        _userInfo = updatedUser; // Update the profile with new data
      });
    }
  }

  user_model.User? userDetails;
  ChatRepositoryImpl chatRepo = ChatRepositoryImpl();
  UserRepoImpl userRepo = UserRepoImpl();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  void getUserDetails () async {
    user_model.User? userDetail = await userRepo.getUserById(userId);
    setState(() {
      userDetails = userDetail;
    });
  }
  void _navigateToSelectChat (){
    context.go("/selectChat");
  }
  void _navigateToChat () async{

    DatabaseReference ref = FirebaseDatabase.instance.ref("chats");
    DatabaseEvent event = await ref.orderByChild("isClosed").equalTo(false).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value == null) {
      // No open chats exist, create a new one
      Chat newChat = await chatRepo.createNewChat(userId);
      context.go("/customer_support", extra: {"chatId": newChat.id});
      print("No open chat, created new chat: ${newChat.id}");
      return;
    }

    Map<dynamic, dynamic> chatData = snapshot.value as Map<dynamic, dynamic>;

    // Find the chat that matches the userId
    String? existingChatId;
    chatData.forEach((key, value) {
      if (value["userId"] == userId) {
        existingChatId = value["id"];
      }
    });
    print(existingChatId);
    if (existingChatId != null) {
      // Open chat exists, navigate to it
      context.go("/customer_support", extra: existingChatId);
    } else {
      // No matching chat, create a new one
      Chat newChat = await chatRepo.createNewChat(userId);
      context.go("/customer_support", extra: newChat.id);
    }
  }
  Widget build(BuildContext context) {
    return Container(
        child: _isLoading ? const Center(child: CircularProgressIndicator())
            :Padding(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile-user-big.png'),
                  radius: 40,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _userInfo.name,
                      style: const TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userInfo.email,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: navigateToEditProfile,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                            Color.fromRGBO(172, 208, 193, 1)),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 50, color: Colors.black54),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'General',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(

                        child: Row(
                          children: [
                            Image.asset('assets/images/calendar-icon.png'),
                            const SizedBox(width: 15),
                            const Text(
                              'My Upcoming Schedules',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Image.asset('assets/images/pet-event-icon.png'),
                            const SizedBox(width: 15),
                            const Text(
                              'Manage Organized Event',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ManageOrganizedEvents(user: widget.user))
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min, // Ensures button wraps content
                          children: [
                            Text('View', style: TextStyle(color: Color.fromRGBO(0, 139, 139, 1)),),
                            SizedBox(width: 5), // Space between text and icon
                            Icon(Icons.navigate_next_rounded, color: Color.fromRGBO(0, 139, 139, 1)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Image.asset('assets/images/reset-password-icon.png'),
                            const SizedBox(width: 15),
                            const Text(
                              'Reset Password',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResetPassword(user: widget.user))
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min, // Ensures button wraps content
                          children: [
                            Text('Change', style: TextStyle(color: Color.fromRGBO(0, 139, 139, 1)),),
                            SizedBox(width: 5), // Space between text and icon
                            Icon(Icons.navigate_next_rounded, color: Color.fromRGBO(0, 139, 139, 1)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Image.asset('assets/images/customer-service.png'),
                            const SizedBox(width: 15),
                            const Text(
                              'Contact Customer Support',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed:
                        (userDetails?.role == 3 ? _navigateToSelectChat: _navigateToChat)
                        ,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min, // Ensures button wraps content
                          children: [
                            Text('Contact', style: TextStyle(color: Color.fromRGBO(0, 139, 139, 1)),),
                            SizedBox(width: 5), // Space between text and icon
                            Icon(Icons.navigate_next_rounded, color: Color.fromRGBO(0, 139, 139, 1)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Image.asset('assets/images/logout.png'),
                            const SizedBox(width: 15),
                            const Text(
                              'Logout Account',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _logout(),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min, // Ensures button wraps content
                          children: [
                            Text('Log out Now', style: TextStyle(color: Color.fromRGBO(0, 139, 139, 1)),),
                            SizedBox(width: 5), // Space between text and icon
                            Icon(Icons.navigate_next_rounded, color: Color.fromRGBO(0, 139, 139, 1)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
