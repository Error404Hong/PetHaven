import 'dart:io';

import 'package:flutter/material.dart';
import '../../data/model/product.dart';
import '../../data/model/user.dart';
import 'product_details.dart';

class ProductBox extends StatefulWidget {
  final User user;
  final Product productData;
  const ProductBox({super.key, required this.user, required this.productData});

  @override
  State<ProductBox> createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(238, 235, 220, 1),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.center,
              child: Image.file(
                File(widget.productData.imagePath),
                fit: BoxFit.contain,
                height: 100,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productData.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Color.fromRGBO(90, 60, 40, 1),
                    ),
                  ),
                  Text(
                    '${widget.productData.quantitySold} sold',
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductDetails(user: widget.user, productData: widget.productData))
        );
      },
    );
  }
}
