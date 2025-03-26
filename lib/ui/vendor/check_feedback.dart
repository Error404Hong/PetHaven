import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/feedback_container.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/product.dart';
import '../../data/model/user.dart';

class CheckFeedback extends StatefulWidget {
  final User vendorData;
  final Product product;
  const CheckFeedback({super.key, required this.vendorData, required this.product});

  @override
  State<CheckFeedback> createState() => _CheckFeedbackState();
}

class _CheckFeedbackState extends State<CheckFeedback> {
  double calculateAverageRating() {
    if (widget.product.reviews.isEmpty) return 0.0; // No reviews case
    double totalRating = widget.product.reviews.fold(0, (sum, review) => sum + review.starRating);
    return totalRating / widget.product.reviews.length;
  }
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
                    Text(
                      calculateAverageRating().toStringAsFixed(1), // Show 1 decimal place
                      style: const TextStyle(
                        fontSize: 65,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        double avgRating = calculateAverageRating();
                        return Icon(
                          index < avgRating.floor() ? Icons.star : (index < avgRating ? Icons.star_half : Icons.star_border),
                          color: Colors.amber,
                          size: 30,
                        );
                      }),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      "Based on ${widget.product.reviews.length} Reviews",
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
                        Text(
                          widget.product.productName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "RM${widget.product.price}",
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
                  if (widget.product.reviews.isEmpty)
                    const Text("No reviews yet", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ...widget.product.reviews.map((review) => FeedbackContainer(vendorData: widget.vendorData, review: review)).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
