import 'package:flutter/material.dart';
import 'user_profile.dart';



class AlternativeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  const AlternativeAppBar({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(172, 208, 193, 1),
      elevation: 0,
      title: Text(
        pageTitle,
        style: const TextStyle(
          color: Color.fromRGBO(33, 31, 31, 1),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              if(pageTitle != 'My Profile' && pageTitle != "Edit Profile" && pageTitle != "Upcoming Schedules" && pageTitle != "Reset Password") {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserProfile())
                );
              }
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/profile-user.png'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default AppBar height
}
