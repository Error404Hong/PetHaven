import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/chat.dart';
import '../../data/repository/chat/chat_repository_impl.dart';
import 'alternative_app_bar.dart';
import 'edit_profile.dart';
import 'upcoming_schedules.dart';
import 'reset_password.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  ChatRepositoryImpl chatRepo = ChatRepositoryImpl();
  void _navigateToChat () async{
      String userId = FirebaseAuth.instance.currentUser!.uid;
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
        child: Padding(
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
                    const Text(
                      'Hong Jing Xin',
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'hongjx0321@gmail.com',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfile())
                        );
                      },
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const UpcomingSchedules())
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
                        onPressed: () {},
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
                              MaterialPageRoute(builder: (context) => const ResetPassword())
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
                        onPressed: _navigateToChat,
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
                        onPressed: () {},
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
