import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';
import 'package:pet_haven/ui/component/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_haven/ui/Admin/adminHome.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;

import 'customer/appbar.dart';
import 'customer/homePage.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  int _page = 0;
  UserRepoImpl UserRepo = UserRepoImpl();
  User? currentUser;
  user_model.User? userDetails;
  void _logout() async {
    UserRepo.logout();
  }

  void _loadCurrentUser() async {
    User? user = UserRepo.getCurrentUser();
    if (user != null) {
      setState(() {
        currentUser = user;
      });
      _getUserById(); // Fetch user only after currentUser is initialized
    }
  }

  void _getUserById() async {
    if (currentUser != null) {
      user_model.User? userDetail = await UserRepo.getUserById(currentUser!.uid);
      setState(() {
        userDetails = userDetail;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
        appBar: CustomAppBar(
          title: "PetHaven",
          subTitle: "Welcome Back, ${userDetails?.name ?? "Loading..."}!",
        ),
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              (userDetails?.role == 3) ?
              Adminhome():
              CustHomePage(),

            ],
          ),

        ),
      ),)
    );
  }
}
