import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/model/payment.dart';
import '../../data/model/product.dart';

class OrderTrackingContainer extends StatefulWidget {
  final String productID;
  final Payment paymentData;
  const OrderTrackingContainer({super.key, required this.productID, required this.paymentData});

  @override
  State<OrderTrackingContainer> createState() => _OrderTrackingContainerState();
}

class _OrderTrackingContainerState extends State<OrderTrackingContainer> {
  Map<String, dynamic>? productData;
  bool isLoading = true;
  String estimatedProductDeliveryDate = "";

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    getEstimatedDeliveryDate();
  }

  void getEstimatedDeliveryDate() {
    DateTime paymentDate = widget.paymentData.paymentDate;

    // Add 3 days to the payment date
    DateTime estimatedDeliveryDate = paymentDate.add(const Duration(days: 3));
    String formattedDate = DateFormat('MMMM dd, yyyy').format(estimatedDeliveryDate);

    setState(() {
      estimatedProductDeliveryDate = formattedDate;
    });
  }

  Future<void> fetchProductDetails() async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.productID)
          .get();

      if (productDoc.exists) {
        setState(() {
          productData = productDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false; // Product not found, but still stop loading
        });
      }
    } catch (e) {
      print("Error fetching product details: $e");
      setState(() {
        isLoading = false; // Handle errors gracefully
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }

    if (productData == null) {
      return const Center(child: Text("Product not found")); // Handle missing product
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade200], // Subtle gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Image Centered at the Top
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(productData!['imagePath']),
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
              ),

              const SizedBox(height: 12),

              // Divider Line
              const Divider(
                thickness: 1.2,
                color: Colors.grey,
              ),

              const SizedBox(height: 12),

              // Details Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.payment, color: Colors.blue, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Payment ID: ${widget.paymentData.paymentID}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.shopping_bag, color: Colors.orange, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Product: ${productData!['productName']}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.delivery_dining, color: Colors.green, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "ETA Delivery Date: $estimatedProductDeliveryDate",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: widget.paymentData.deliveryStatus == "Delivered"
                          ? Colors.green.withOpacity(0.15)
                          : Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Status: ${widget.paymentData.deliveryStatus}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.paymentData.deliveryStatus == "Delivered"
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );


  }
}
