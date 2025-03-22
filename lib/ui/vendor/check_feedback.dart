import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/feedback_container.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/user.dart';

class CheckFeedback extends StatefulWidget {
  final User vendorData;
  const CheckFeedback({super.key, required this.vendorData});

  @override
  State<CheckFeedback> createState() => _CheckFeedbackState();
}

class _CheckFeedbackState extends State<CheckFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(
          pageTitle: "Product Reviews", vendorData: widget.vendorData),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Rating Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'Overall Rating',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Text(
                      '4.0',
                      style: TextStyle(
                        fontSize: 65,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 30),
                        Icon(Icons.star, color: Colors.amber, size: 30),
                        Icon(Icons.star, color: Colors.amber, size: 30),
                        Icon(Icons.star, color: Colors.amber, size: 30),
                        Icon(Icons.star,
                            color: Colors.grey, size: 30), // Half rating effect
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Based on 404 Reviews",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Divider(thickness: 1.2),

              // Product Info Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: const Icon(Icons.shopping_bag,
                          color: Colors.teal, size: 40),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Product Name",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$10.00",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(thickness: 1.2),
              const SizedBox(height: 10),

              // Customer Reviews Section
              const Text(
                "Customer Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Sample Reviews (can be mapped from a list)
              Column(
                children: [
                  FeedbackContainer(vendorData: widget.vendorData),
                  FeedbackContainer(vendorData: widget.vendorData),
                  FeedbackContainer(vendorData: widget.vendorData),
                  FeedbackContainer(vendorData: widget.vendorData),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
