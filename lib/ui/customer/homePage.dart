import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/ui/customer/check_order_status.dart';
import '../../data/model/event.dart';
import '../../data/model/product.dart';
import '../../data/repository/customers/event_implementation.dart';
import '../../data/repository/user/user_repository_impl.dart';
import '../../data/repository/vendors/product_implementation.dart';
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
  EventImplementation eventImpl = EventImplementation();
  UserRepoImpl userRepo = UserRepoImpl();
  ProductImplementation productImpl = ProductImplementation();

  bool isUserLoading = true;
  user_model.User? userData;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      User? firebaseUser = userRepo.getCurrentUser();
      if (firebaseUser != null) {
        user_model.User? fetchedUser = await userRepo.getUserById(firebaseUser.uid);
        if (mounted) {
          setState(() {
            userData = fetchedUser;
            isUserLoading = false; // Mark user data as loaded
          });
        }
      }
    } catch (e) {
      print("Error fetching user: $e");
      if (mounted) {
        setState(() {
          isUserLoading = false; // Stop loading even if an error occurs
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isUserLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Show loading screen
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text("Error fetching user data.")), // Error fallback
      );
    }

    return StreamBuilder<List<Product>>(
      stream: productImpl.getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No products available"));
        }

        List<Product> productList = snapshot.data!;

        return SingleChildScrollView(
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
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push("/product_list", extra: userData);
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: productList.take(2).map((product) {
                    return ProductBox(user: userData!, productData: product);
                  }).toList(),
                ),

                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nearby Adventures 🏞️',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push("/view_activities", extra: userData);
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
                StreamBuilder<List<DocumentSnapshot>>(
                  stream: eventImpl.getRandomEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No events found"));
                    }

                    List<DocumentSnapshot> events = snapshot.data!;

                    return Column(
                      children: events.map((eventDoc) {
                        Event event = Event.fromMap(eventDoc.data() as Map<String, dynamic>);
                        return ActivityBox(user: userData!, event: event);
                      }).toList(),
                    );
                  },
                ),
                TextButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckOrderStatus(user: userData!))
                  );
                },
                  child: const Text("Check my purchase")
                )
              ],
            ),
          ),
        );
      },
    );
  }
}



