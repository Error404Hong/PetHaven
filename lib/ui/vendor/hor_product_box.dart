import 'package:flutter/material.dart';
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
              MaterialPageRoute(builder: (context) => AddProduct(vendorData: widget.vendorData, mode: "manage"))
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
            child: const Row(
              children: [
                // Product Icon
                Icon(Icons.shopping_bag, color: Colors.teal, size: 40),
                SizedBox(width: 12),

                // Product Info (Name & Price)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "\$10.00",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity Section (Number on top, Text below)
                Column(
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
