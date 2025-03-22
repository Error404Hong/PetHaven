import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/vendor_profile.dart';
import '../../data/model/user.dart';


class VendorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final User vendorData;
  const VendorAppBar({super.key, required this.pageTitle, required this.vendorData});

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
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VendorProfile(vendorData: vendorData))
                );
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
