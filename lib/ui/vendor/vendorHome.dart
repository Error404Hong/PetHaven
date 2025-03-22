import 'package:flutter/material.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:pet_haven/ui/vendor/order_container.dart';
import 'package:pet_haven/ui/vendor/quick_actions.dart';
import '../../data/repository/user/user_repository_impl.dart';
import 'order_dashboard.dart';

class Vendorhome extends StatefulWidget {
  const Vendorhome({super.key});

  @override
  State<Vendorhome> createState() => _VendorhomeState();
}

class _VendorhomeState extends State<Vendorhome> {
  user_model.User? vendorData;
  UserRepoImpl userRepo = UserRepoImpl();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      var firebaseUser = userRepo.getCurrentUser();
      if (firebaseUser != null) {
        user_model.User? fetchedUser = await userRepo.getUserById(firebaseUser.uid);
        if (mounted) {
          setState(() {
            vendorData = fetchedUser;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Error fetching user: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(172, 208, 193, 1),
                borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(3.0, 3.0),
                      blurRadius: 2.0,
                      spreadRadius: 0.5,
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pets, size: 28, color: Colors.brown), // Pet icon for a friendly touch
                        const SizedBox(width: 8),
                        Text(
                          'Hi ${vendorData?.name}',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Welcome to the team! Let's make pet care amazing!",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(3.0, 3.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.5,
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/bar-chart.png"),
                            const SizedBox(height: 12),
                            const Text("3069", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                            const Text("Sold Product", style: TextStyle(fontSize: 15, color: Colors.grey)),
                          ],
                        ),
                      )
                    )
                  ],
                ),
                const SizedBox(width: 18),
                Row(
                  children: [
                    Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(3.0, 3.0),
                                blurRadius: 10.0,
                                spreadRadius: 0.5,
                              )
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/dollar-symbol.png"),
                              const SizedBox(height: 12),
                              const Text("RM9999.99", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                              const Text("Total Sales", style: TextStyle(fontSize: 15, color: Colors.grey)),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            QuickActions(vendorData: vendorData!),

            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Orders",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OrderDashboard(vendorData: vendorData!))
                        );
                      },
                      child: const Text(
                        "Check All",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 139, 139, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                  ]
                ),
                const SizedBox(height: 10),
                OrderContainer(vendorData: vendorData!),
                OrderContainer(vendorData: vendorData!),
              ],
            )
          ],
        ),
      ),
    );
  }
}
