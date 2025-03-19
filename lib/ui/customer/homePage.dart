import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/repository/user/user_repository_impl.dart';
import 'product-box.dart';
import 'appbar.dart';
import 'activity_box.dart';
import 'product_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;

void main() {
  runApp(const MaterialApp(home: CustHomePage()));
}

class CustHomePage extends StatefulWidget {
  const CustHomePage({super.key});

  @override
  State<CustHomePage> createState() => _CustHomePageState();
}

class _CustHomePageState extends State<CustHomePage> {
  UserRepoImpl userRepo = UserRepoImpl();
  user_model.User? userData;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    User? firebaseUser = userRepo.getCurrentUser();
    if (firebaseUser != null) {
      user_model.User? fetchedUser = await userRepo.getUserById(firebaseUser.uid);
      if (fetchedUser != null) {
        setState(() {
          userData = fetchedUser;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: CustomAppBar(
        title: "PetHaven",
        subTitle: "Welcome Back, ${userData?.name ?? "Loading..."}!",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Categories 🔥',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (userData != null) {
                        context.push("/product_list", extra: userData);
                      }
                    },
                    child: const Text(
                      'Check All',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 139, 139, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProductBox(),
                  ProductBox(),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby Adventures 🏞️',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (userData != null) {
                        context.push("/view_activities", extra: userData);
                      }
                    },
                    child: const Text(
                      'Check All',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 139, 139, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const ActivityBox(),
              const ActivityBox(),
            ],
          ),
        ),
      ),
    );
  }
}
