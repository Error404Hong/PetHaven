import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';
import 'package:pet_haven/ui/component/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_haven/ui/Admin/adminHome.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:pet_haven/ui/vendor/vendorHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'customer/appbar.dart';
import 'customer/homePage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserRepoImpl userRepo = UserRepoImpl();
  User? currentUser;
  user_model.User? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    User? user = userRepo.getCurrentUser();
    if (user != null) {
      setState(() {
        currentUser = user;
      });
      _listenToUserUpdates();
    }
  }

  void _listenToUserUpdates() {
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection(user_model.User.tableName) // "Users"
          .doc(currentUser!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          setState(() {
            userDetails = user_model.User.fromMap(snapshot.data()!);
            isLoading = false;
          });
        }
      });
    }
  }

  Widget _getHomePage() {
    if (userDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    switch (userDetails!.role) {
      case 3:
        return const Adminhome();
      case 2:
        return const Vendorhome();
      default:
        return const CustHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: isLoading
          ? null
          : CustomAppBar(
        title: "PetHaven",
        subTitle: "Welcome Back, ${userDetails?.name ?? "Loading..."}!",
        user: userDetails!,
      ),
      bottomNavigationBar: isLoading
          ? null
          : BottomNav(
        onPageChanged: (index) {
          setState(() {});
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: const Color(0xfff7f6ee),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[_getHomePage()]),
          ),
        ),
      ),
    );
  }
}
