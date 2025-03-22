import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';
import 'package:pet_haven/ui/component/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_haven/ui/Admin/adminHome.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:pet_haven/ui/customer/alternative_app_bar.dart';
import 'package:pet_haven/ui/vendor/vendorHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';

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
      debugPrint("Current user found: \${user.uid}");
      setState(() {
        currentUser = user;
      });
      _waitForUserData();
    } else {
      debugPrint("No current user found in FirebaseAuth!");
      setState(() => isLoading = false);
    }
  }

  Future<void> _waitForUserData() async {
    for (int i = 0; i < 5; i++) {
      if (currentUser == null) return;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(user_model.User.tableName)
          .doc(currentUser!.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        debugPrint("Firestore data found after \${i + 1} attempts");
        setState(() {
          userDetails = user_model.User.fromMap(snapshot.data() as Map<String, dynamic>);
          isLoading = false;
        });
        return;
      }

      debugPrint("Retrying Firestore fetch in 1 second...");
      await Future.delayed(const Duration(seconds: 1));
    }

    debugPrint("Failed to fetch user data after 5 attempts.");
    setState(() => isLoading = false);
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
      appBar: isLoading || userDetails == null
          ? null
          : userDetails!.role == 2
          ? VendorAppBar(
        pageTitle: "PetHaven",
        vendorData: userDetails!,
      )
          : CustomAppBar(
        title: "PetHaven",
        subTitle: "Welcome Back, ${userDetails?.name ?? "Loading..."}!",
        user: userDetails!,
      ),
      bottomNavigationBar: isLoading ? null : BottomNav(onPageChanged: (index) => setState(() {})),
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
