import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product.dart';

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

}
