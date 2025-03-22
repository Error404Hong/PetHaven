import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/check_feedback.dart';
import '../../data/model/user.dart';
import 'add_product.dart';

class HorProductBox extends StatefulWidget {
  final User vendorData;
  const HorProductBox({super.key, required this.vendorData});

  @override
  State<HorProductBox> createState() => _HorProductBoxState();
}

class _HorProductBoxState extends State<HorProductBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(
                  vendorData: widget.vendorData,
                  mode: "manage",
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 22),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Product Icon
                const Icon(Icons.shopping_bag, color: Colors.teal, size: 40),
                const SizedBox(width: 12),

                // Product Info (Name & Price)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Product Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "\$10.00",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Check Feedback Link
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckFeedback(vendorData: widget.vendorData),
                            ),
                          );
                        },
                        child: const Text(
                          "Check Feedback",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity Section (Number on top, Text below)
                const Column(
                  children: [
                    Text(
                      "5", // Quantity Number
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4), // Spacing
                    Text(
                      "Quantity", // Quantity Label
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
