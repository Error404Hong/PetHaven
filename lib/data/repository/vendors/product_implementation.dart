import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product.dart';
import '../../model/review.dart';

class ProductImplementation {
  final db = FirebaseFirestore.instance;
  final String collectionName = "Products";

  Future<void> addNewProduct(Product product) async {
    try {
      DocumentReference productRef = await db.collection(collectionName).add(product.toMap());
      await db.collection(collectionName).doc(productRef.id).update({"productID": productRef.id});
      print("Success adding product with ID: ${productRef.id}");
    } catch(e) {
      print("Error adding product: $e");
    }
  }

  Stream<List<Product>> getAllProducts() {
    return db.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error getting products: $error");
    });
  }

  Stream<List<Product>> getVendorProducts(String vendorID) {
    return db.collection(collectionName)
        .where('vendorID', isEqualTo: vendorID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error getting products for vendor $vendorID: $error");
    });
  }


  Future<void> updateProduct(Product product) async {
    try {
      DocumentReference productRef = db.collection(collectionName).doc(product.productID);

      await productRef.update({
        'imagePath': product.imagePath,
        'productName': product.productName,
        'category': product.category,
        'price': product.price,
        'inventoryQuantity': product.inventoryQuantity,
        'description': product.description,
      });

      print("Product updated successfully");
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      await db.collection(collectionName).doc(product.productID).delete();
      print("Product Deleted Successfully");
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> updateStatusAfterSales(Product product) async {
    try {
      DocumentReference productRef = db.collection(collectionName).doc(product.productID);

      await productRef.update({
        "inventoryQuantity": product.inventoryQuantity - 1,
        "quantitySold": product.quantitySold +1,
      });

      print("Product updated successfully");
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  Future<double> calculateVendorSales(String vendorID) async {
    try {
      QuerySnapshot querySnapshot = await db.collection(collectionName)
          .where('vendorID', isEqualTo: vendorID) // Filter by vendorID
          .get();

      double totalSales = 0;

      for (var doc in querySnapshot.docs) {
        var productData = doc.data() as Map<String, dynamic>;

        double price = productData['price'];
        int quantitySold = productData['quantitySold'];
        double productSales = price * quantitySold;
        totalSales += productSales;
      }

      print('Total sales for vendor $vendorID: \$${totalSales.toStringAsFixed(2)}');
      return totalSales;  // Return the total sales value
    } catch (e) {
      print("Error calculating vendor sales for $vendorID: $e");
      return 0;  // Return 0 in case of error
    }
  }

  Future<int> calculateVendorQuantitySold(String vendorID) async {
    try {
      QuerySnapshot querySnapshot = await db.collection(collectionName)
          .where('vendorID', isEqualTo: vendorID) // Filter by vendorID
          .get();

      int totalQuantitySold = 0;

      for (var doc in querySnapshot.docs) {
        var productData = doc.data() as Map<String, dynamic>;

        int quantitySold = productData['quantitySold'] ?? 0; // Default to 0 if null
        totalQuantitySold += quantitySold;
      }

      print('Total quantity sold for vendor $vendorID: $totalQuantitySold');
      return totalQuantitySold;
    } catch (e) {
      print("Error calculating vendor quantity sold for $vendorID: $e");
      return 0;
    }
  }
  Future<int> getNumProduct() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Products").get();
      return querySnapshot.size; // Returns the number of documents in the collection
    } catch (e) {
      print("Error fetching event count: $e");
      return 0; // Return 0 if there's an error
    }
  }

  Future<Map<int, double>> fetchMonthlyPayments() async {
    Map<int, double> monthlyPayments = {}; // Start with an empty map

    DateTime now = DateTime.now();
    DateTime sixMonthsAgo = DateTime(now.year, now.month - 5, 1); // Past 6 months

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Payment')
        .get(); // Fetch all payments

    for (var doc in snapshot.docs) {
      String dateString = doc['paymentDate']; // Get stored date string
      DateTime date = DateTime.parse(dateString); // Convert to DateTime

      if (date.isAfter(sixMonthsAgo) && date.isBefore(now)) { // Filter last 6 months
        int monthIndex = date.month; // Extract month (1-12)
        double amount = (doc['amount'] ?? 0.0) as double; // Ensure amount is not null

        monthlyPayments[monthIndex] = (monthlyPayments[monthIndex] ?? 0.0) + amount;
        // ^^^ Fix: Ensure a default value of 0.0 before adding
      }
    }

    return monthlyPayments; // Only returns months with payments
  }
  Future<void> submitReview({
    required String productID,
    required String userID,
    required String userName,
    required int starRating,
    required String reviewText,
  }) async {
    final db = FirebaseFirestore.instance;
    final productRef = db.collection("Products").doc(productID);

    Review newReview = Review(
      reviewID: productRef.id,
      userID: userID,
      userName: userName,
      starRating: starRating,
      reviewText: reviewText,
      timestamp: DateTime.now(), // Now it's a DateTime
    );

    try {
      await productRef.update({
        "reviews": FieldValue.arrayUnion([newReview.toMap()])
      });
      print("Review submitted successfully!");
    } catch (e) {
      print("Error submitting review: $e");
    }
  }

}
