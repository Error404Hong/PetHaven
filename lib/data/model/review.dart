import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String reviewID;
  final String userID;
  final String userName;
  final int starRating;
  final String reviewText;
  final DateTime timestamp; // Use DateTime

  Review({
    required this.reviewID,
    required this.userID,
    required this.userName,
    required this.starRating,
    required this.reviewText,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "reviewID": reviewID,
      "userID": userID,
      "userName": userName,
      "starRating": starRating,
      "reviewText": reviewText,
      "timestamp": timestamp.toIso8601String(), // Convert to string before saving
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewID: map["reviewID"] as String,
      userID: map["userID"] as String,
      userName: map["userName"] as String,
      starRating: map["starRating"] as int,
      reviewText: map["reviewText"] as String,
      timestamp: map["timestamp"] is Timestamp
          ? (map["timestamp"] as Timestamp).toDate() // Convert Firestore Timestamp
          : DateTime.parse(map["timestamp"] as String), // Convert stored String date
    );
  }

}
