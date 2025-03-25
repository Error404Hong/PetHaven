import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/add_product.dart';
import 'package:pet_haven/ui/vendor/order_dashboard.dart';
import 'package:pet_haven/ui/vendor/product_management.dart';
import 'package:pet_haven/ui/vendor/vendor_profile.dart';
import '../../data/model/user.dart';

class QuickActions extends StatefulWidget {
  final User vendorData;
  const QuickActions({super.key, required this.vendorData});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  AddProduct(vendorData: widget.vendorData, mode: "add"))
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const Icon(Icons.add, size: 30, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              const Text(
                "Add Product",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderDashboard(vendorData: widget.vendorData))
            );
          }, // Add navigation later
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const Icon(Icons.list_alt, size: 30, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage Orders",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductManagement(vendorData: widget.vendorData))
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const Icon(Icons.inventory, size: 30, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage Products",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VendorProfile(vendorData: widget.vendorData))
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const Icon(Icons.person, size: 30, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              const Text(
                "My Profile",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
