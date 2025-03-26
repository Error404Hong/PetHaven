import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';
import '../../data/model/user.dart' as user_model;
import 'bottomnav/curved_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  final ValueChanged<int> onPageChanged; // Callback to update parent state

  const BottomNav({super.key, required this.onPageChanged});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int _page;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  user_model.User user = user_model.User.empty();
  UserRepoImpl user_repo = UserRepoImpl();
  bool isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _page = 2; // Default index
    getUser(); // Fetch user data
  }

  void getUser() async {
    setState(() => isLoading = true); // Start loading
    User? tempUser = await user_repo.getCurrentUser();
    String? id = tempUser?.uid;

    if (id != null) {
      user_model.User userDetails = await user_repo.getUserById(id) as user_model.User;
      setState(() {
        user = userDetails;
        _page = user.role == 1 ? 2 : 1;
        isLoading = false; // Data loaded
      });
    } else {
      setState(() => isLoading = false); // Stop loading even if user is null
    }
  }

  List<Widget> _bottomNavBarIcon() {
    if (user.role == 3) {
      return [
        Icon(Icons.person_remove_outlined, size: 30),
        Icon(Icons.dashboard, size: 30),
        Icon(Icons.perm_identity, size: 30),
      ];
    } else if (user.role == 2) {
      return [
        Icon(Icons.add, size: 30),
        Icon(Icons.dashboard, size:30),
        Icon(Icons.list, size: 30),
      ];
    } else if (user.role == 1) {
      return [
        Icon(Icons.shop, size: 30),
        Icon(Icons.fire_truck, size: 30),
        Icon(Icons.explore, size: 30),
        Icon(Icons.add, size: 30),
        Icon(Icons.schedule, size: 30),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator()) // Show loading spinner
        : CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _page,
      items: _bottomNavBarIcon(),
      color: const Color(0xffacd0c1),
      buttonBackgroundColor: const Color(0xffacd0c1),
      backgroundColor: const Color(0xfff7f6ee),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) {
        setState(() {
          _page = index;
        });
        widget.onPageChanged(index); // Notify parent
      },
      letIndexChange: (index) => true,
    );
  }
}
