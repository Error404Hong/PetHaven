import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/check_feedback.dart';
import '../../data/model/product.dart';
import '../../data/model/user.dart';
import 'add_product.dart';

class HorProductBox extends StatefulWidget {
  final Product product;
  final User vendorData;
  const HorProductBox({super.key, required this.vendorData, required this.product});

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
                  product: widget.product
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
                      Text(
                        widget.product.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "RM ${widget.product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
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
                              builder: (context) => CheckFeedback(vendorData: widget.vendorData,product: widget.product),
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
                Column(
                  children: [
                    Text(
                      widget.product.inventoryQuantity.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Quantity",
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
