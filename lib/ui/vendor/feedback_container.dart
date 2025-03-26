import 'package:flutter/material.dart';
import '../../data/model/review.dart';
import '../../data/model/user.dart';

class FeedbackContainer extends StatefulWidget {
  final User vendorData;
  final Review review;
  const FeedbackContainer({super.key, required this.vendorData, required this.review});

  @override
  State<FeedbackContainer> createState() => _FeedbackContainerState();
}

class _FeedbackContainerState extends State<FeedbackContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle, size: 40, color: Colors.grey),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.review.userName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < widget.review.starRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.review.reviewText,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}


