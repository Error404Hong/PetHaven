import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:pet_haven/data/repository/user/payment_implementation.dart';
import 'package:pet_haven/data/repository/vendors/product_implementation.dart';
import 'package:pet_haven/ui/vendor/order_container.dart';
import 'package:pet_haven/ui/vendor/quick_actions.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/payment.dart';
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
  PaymentImplementation paymentImpl = PaymentImplementation();
  ProductImplementation productImpl = ProductImplementation();
  bool isLoading = true;
  double totalSales = 0.0;
  int totalQuantity = 0;

  @override
  void initState() {
    super.initState();
    listenToUserChanges();
  }

  void listenToUserChanges() {
    var firebaseUser = userRepo.getCurrentUser();
    if (firebaseUser != null) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser.uid)
          .snapshots()
          .listen((documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            vendorData = user_model.User(
              id: documentSnapshot.id,
              name: documentSnapshot["name"],
              email: documentSnapshot["email"],
              phoneNumber: documentSnapshot["phoneNumber"],
              gender: documentSnapshot["gender"],
              password: documentSnapshot["password"],
              role: documentSnapshot["role"],
            );
            isLoading = false;
          });

          // Calculate total sales once vendor data is loaded
          if (vendorData?.id != null) {
            calculateTotalSales(vendorData!.id!);
            calculateQuantitySold(vendorData!.id!);
          }
        }
      }, onError: (error) {
        print("Error listening to user changes: $error");
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> calculateTotalSales(String vendorID) async {
    double sales = await productImpl.calculateVendorSales(vendorID);
    setState(() {
      totalSales = sales;  // Update totalSales variable
    });
  }

  Future<void> calculateQuantitySold(String vendorID) async {
    int quantitySold = await productImpl.calculateVendorQuantitySold(vendorID);
    setState(() {
      totalQuantity = quantitySold;  // Update totalSales variable
    });
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading || vendorData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return
      Scaffold(
        appBar: VendorAppBar(pageTitle: "PetHaven", vendorData: vendorData!),
        body: SingleChildScrollView(
          child: isLoading ? const Center(child: CircularProgressIndicator())
              :Padding(
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
                                  Text("$totalQuantity", style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
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
                                  Text("RM${totalSales.toStringAsFixed(2)}", style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
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
                    StreamBuilder(
                        stream: paymentImpl.checkVendorOrders(vendorData!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text("No Orders available"));
                          }

                          List<Payment> paymentList = snapshot.data!;

                          // Return only the first 3 orders, or all if there are fewer than 3
                          List<Payment> firstThreePayments = paymentList.take(3).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var order in firstThreePayments)
                                OrderContainer(
                                  vendorData: vendorData!,
                                  orderData: order,
                                ),
                            ],
                          );
                        }
                    )
                    // OrderContainer(vendorData: vendorData!),
                    // OrderContainer(vendorData: vendorData!),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  }
}
