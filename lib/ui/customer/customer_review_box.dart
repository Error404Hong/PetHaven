import 'package:flutter/material.dart';

class CustomerReviewBox extends StatefulWidget {
  const CustomerReviewBox({super.key});

  @override
  State<CustomerReviewBox> createState() => _CustomerReviewBoxState();
}

class _CustomerReviewBoxState extends State<CustomerReviewBox> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review from: hong0321'),
        SizedBox(height: 5),
        Text(
          'Product Purchased: Royal Canin Kibbles 10kg',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        SizedBox(height: 5),
        Text(
          'Great product! My dog loves it. His coat looks shinier, and he has more energy. No digestive issues, and he finishes every meal happily. Highly recommended!',
          textAlign: TextAlign.justify,
        ),
        Divider(height: 50),
      ],
    );
  }
}
