import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_haven/data/model/review.dart';

class Product {
  String? productID;
  String productName;
  String category;
  double price;
  int inventoryQuantity;
  String description;
  String imagePath;
  int quantitySold;
  String vendorID;
  List<Review> reviews;

  Product({
    this.productID,
    required this.productName,
    required this.category,
    required this.price,
    required this.inventoryQuantity,
    required this.description,
    required this.imagePath,
    required this.quantitySold,
    required this.vendorID,
    required this.reviews,
  });

  Map<String, dynamic> toMap() {
    return {
      "productID": productID,
      "productName": productName,
      "category": category,
      "price": price,
      "inventoryQuantity": inventoryQuantity,
      "description": description,
      "imagePath": imagePath,
      "quantitySold": quantitySold,
      "vendorID": vendorID,
      "reviews": reviews.map((review) => review.toMap()).toList(), // Convert to list of maps
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productID: map["productID"] as String?,
      productName: map["productName"] as String,
      category: map["category"] as String,
      price: (map["price"] as num).toDouble(),
      inventoryQuantity: map["inventoryQuantity"] as int,
      description: map["description"] as String,
      imagePath: map["imagePath"] as String,
      quantitySold: map["quantitySold"] as int,
      vendorID: map["vendorID"] as String,
      reviews: (map["reviews"] as List<dynamic>?)?.map((reviewMap) => Review.fromMap(reviewMap)).toList() ?? [],
    );
  }
}
