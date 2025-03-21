import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/ui/customer/manage_organized_events.dart';
import '../../core/service/shared_preferences.dart';
import '../../data/model/user.dart';
import '../../data/repository/user/user_repository_impl.dart';
import 'alternative_app_bar.dart';
import 'edit_profile.dart';
import 'upcoming_schedules.dart';
import 'reset_password.dart';

class UserProfile extends StatefulWidget {
  final User user;
  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserRepoImpl UserRepo = UserRepoImpl();
  late User _userInfo;
  bool _isLoading = true;

  void getUserID() async {
    User? userDetails= await UserRepo.getUserById(widget.user.id);
    setState(() {
      _userInfo = userDetails!;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  void _logout() async {
    await SharedPreference.setIsLoggedIn(false);
    UserRepo.logout();
    context.go('/login');
  }

  Future<void> navigateToEditProfile() async {
    final updatedUser = await context.push<User>('/edit_profile', extra: _userInfo);

    if (updatedUser != null) {
      setState(() {
        _userInfo = updatedUser; // Update the profile with new data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
        appBar: AlternativeAppBar(pageTitle: "My Profile", user: widget.user),
        body: _isLoading ? const Center(child: CircularProgressIndicator())
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UpcomingSchedules(user: widget.user))
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
                        onPressed: () {},
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
