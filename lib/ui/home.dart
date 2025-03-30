import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';
import 'package:pet_haven/ui/Admin/manageUser.dart';
import 'package:pet_haven/ui/admin/adminAppBar.dart';
import 'package:pet_haven/ui/admin/adminUserProfile.dart';
import 'package:pet_haven/ui/component/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_haven/ui/Admin/adminHome.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:pet_haven/ui/customer/check_order_status.dart';
import 'package:pet_haven/ui/customer/host_new_activity.dart';
import 'package:pet_haven/ui/customer/product_list.dart';
import 'package:pet_haven/ui/customer/upcoming_schedules.dart';
import 'package:pet_haven/ui/vendor/add_product.dart';
import 'package:pet_haven/ui/vendor/manage_orders.dart';
import 'package:pet_haven/ui/vendor/product_management.dart';
import 'package:pet_haven/ui/vendor/vendorHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import 'package:pet_haven/ui/customer/user_profile.dart';

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
  int _page = 2;
  List<Widget> _pages = []; // Store pages here

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    setState(() => isLoading = true);
    User? user = userRepo.getCurrentUser();

    if (user != null) {
      setState(() => currentUser = user);
      _listenToUserUpdates();
      await _waitForUserData();
    } else {
      setState(() => isLoading = false);
    }
  }

  void _listenToUserUpdates() {
    FirebaseFirestore.instance
        .collection(user_model.User.tableName)
        .doc(currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        if (!mounted) return;
        setState(() {
          userDetails = user_model.User.fromMap(snapshot.data() as Map<String, dynamic>);
          _initializePages(); // Refresh UI with updated user data
        });
      }
    });
  }

  Future<void> _waitForUserData() async {
    for (int i = 0; i < 5; i++) {
      if (currentUser == null) return;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(user_model.User.tableName)
          .doc(currentUser!.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          userDetails = user_model.User.fromMap(snapshot.data() as Map<String, dynamic>);
          _initializePages(); // Fix: Initialize _pages correctly
          _page = userDetails?.role == 1 ? 2 : 1;
          isLoading = false;
        });
        return;
      }

      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() => isLoading = false);
  }

  void _initializePages() {
    if (userDetails == null) return; // Ensure userDetails is loaded before initializing

    setState(() {
      if (userDetails!.role == 1) {
        _pages = [
          ProductList(userData: userDetails!),
          CheckOrderStatus(user: userDetails!),
          CustHomePage(),
          HostNewActivity(userData: userDetails!),
          UpcomingSchedules(user: userDetails!)
        ];
      } else if (userDetails!.role == 2) {
        _pages = [
          AddProduct(vendorData: userDetails!, mode: "add"),
          Vendorhome(), // 🚨 Error might be inside this widget!
          ProductManagement(vendorData: userDetails!)
        ];
      } else {
        _pages = [
          const ManageUser(),
          const Adminhome(),
          Adminuserprofile(user: userDetails!),
        ];
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: isLoading || userDetails == null
          ? null
          : userDetails!.role == 2
          ? null
          : userDetails!.role == 3
          ? Adminappbar(
        title: "PetHaven",
        subTitle: "Welcome Back, ${userDetails?.name ?? "Loading..."}!",
        user: userDetails!,
      )
          : null,
      bottomNavigationBar: isLoading
          ? null
          : BottomNav(onPageChanged: (index) {
        setState(() {
          _page = index;
        });
      }),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages.isNotEmpty
          ? _pages[_page] // Correctly access pages
          : const Center(child: Text("No pages available")),
    );
  }
}