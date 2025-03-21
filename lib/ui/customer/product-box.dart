import 'package:flutter/material.dart';
import '../../data/model/user.dart';
import 'product_details.dart';

class ProductBox extends StatefulWidget {
  final User user;
  const ProductBox({super.key, required this.user});

  @override
  State<ProductBox> createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 180,
        height: 200,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(238, 235, 220, 1), // Warm background color
          borderRadius: BorderRadius.circular(12.0), // Softer rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Shadow color
              spreadRadius: 1, // Subtle spread
              blurRadius: 6, // Soft blur
              offset: const Offset(2, 4), // Shadow position
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/pet-food-category.png',
                fit: BoxFit.contain,
                height: 110,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pet Kibbles',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Color.fromRGBO(90, 60, 40, 1),
                    ),
                  ),
                  Text(
                    '550 sold',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductDetails(user: widget.user))
        );
      },
    );
  }
}
