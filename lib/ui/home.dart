import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';
import 'package:pet_haven/ui/component/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_haven/ui/Admin/adminHome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    super.initState();
    _loadCurrentUser(); // Fetch user when the widget initializes
  }
  int _page = 0;
  UserRepoImpl UserRepo = UserRepoImpl();
  User? currentUser;

  void _loadCurrentUser() async {
    User? user = UserRepo.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: Container(
        color: Color(0xfff7f6ee),
          child: SafeArea(
        child: Column(
          children: <Widget>[
            Adminhome(),
            ElevatedButton(
              child: const Text('Go To Page of index 1'),
              onPressed: () {
                setState(() {
                  _page = 1;
                });
              },
            ),
          ],
        ),
      ),)
    );
  }
}
