import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/user.dart';
import 'user_profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subTitle;
  final User user;
  const CustomAppBar({super.key, required this.title, required this.subTitle, required this.user});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(160), // Adjusted height
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20), // Rounded bottom left
          bottomRight: Radius.circular(20), // Rounded bottom right
        ),
        child: Container(
          color: const Color.fromRGBO(172, 208, 193, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  title,
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
                      onTap: () => context.push("/user_profile", extra: user),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/images/profile-user.png'),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(33, 31, 31, 1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(33, 31, 31, 1)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(190); // Adjusted height
}
