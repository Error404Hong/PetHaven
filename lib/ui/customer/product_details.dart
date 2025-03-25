import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/ui/customer/purchase_product.dart';
import '../../data/model/product.dart';
import '../../data/model/user.dart';
import 'alternative_app_bar.dart';
import 'customer_review_box.dart';

class ProductDetails extends StatefulWidget {
  final User user;
  final Product productData;
  const ProductDetails({super.key, required this.user, required this.productData});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? vendorName;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    getVendorData(widget.productData.vendorID);
  }

  Future<void> getVendorData(String vendorID) async {
    final db = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await db.collection('Users').get();

      for (var doc in querySnapshot.docs) {
        var userData = doc.data() as Map<String, dynamic>;

        if (userData["id"] == vendorID) {
          setState(() {
            vendorName = userData["name"];
            isLoading = false; // Data loaded
          });
          return;
        }
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      isLoading = false; // Stop loading even if there's an error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: AlternativeAppBar(pageTitle: "Product Details", user: widget.user),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(widget.productData.imagePath)),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.productData.productName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'RM${widget.productData.price}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${widget.productData.quantitySold} sold'),
                  const Divider(height: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(245, 245, 245, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: const Icon(
                                  Icons.storefront,
                                  size: 38,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isLoading
                                        ? const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                        : Text(
                                      "Vendor: $vendorName",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Highly Trusted & Reliable ✅',
                                      style: TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        'Product Description',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.productData.description,
                        style: const TextStyle(fontSize: 15),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                  const Divider(height: 50),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Reviews',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                      CustomerReviewBox(),
                      CustomerReviewBox(),
                      CustomerReviewBox(),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PurchaseProduct(user: widget.user, productData: widget.productData))
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Color.fromRGBO(172, 208, 193, 1)),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
