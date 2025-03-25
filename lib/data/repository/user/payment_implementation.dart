import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/payment.dart';
import '../../model/user.dart';

class PaymentImplementation {
  final db = FirebaseFirestore.instance;
  final String collectionName = "Payment";

  Future<void> newPayment(Payment payment) async {
    try {
      DocumentReference paymentRef = await db.collection(collectionName).add(payment.toMap());
      await db.collection(collectionName).doc(paymentRef.id).update({"paymentID": paymentRef.id});
      print("Success adding payment with ID: ${paymentRef.id}");
    } catch(e) {
      print("Error adding payment: $e");
    }
  }

  Stream<List<Payment>> checkVendorOrders(User vendor) {
    return db.collection(collectionName)
        .where('vendorID', isEqualTo: vendor.id)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Payment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error getting products for vendor ${vendor.id}: $error");
    });
  }

  // FOR ADMIN CHECK ALL ORDERS MADE
  Stream<List<Payment>> checkAllOrders() {
    return db.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Payment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error getting products: $error");
    });
  }

  Future<Map<String, String>> getCustomerDetails(String customerID) async {
    try {
      QuerySnapshot querySnapshot = await db.collection('Users')
          .where('id', isEqualTo: customerID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var customerData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print("Customer Data: $customerData");

        String customerName = customerData['name'] ?? 'Unknown';
        String customerEmail = customerData['email'] ?? 'Unknown';

        return {'name': customerName, 'email': customerEmail};
      } else {
        return {'name': 'Unknown', 'email': 'Unknown'};
      }
    } catch (e) {
      return {'name': 'Unknown', 'email': 'Unknown'};
    }
  }

  Future<Map<String, String>> getProductDetails(String productID) async {
    try {
      QuerySnapshot querySnapshot = await db.collection('Products')
          .where('productID', isEqualTo: productID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var productData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print("Product Data: $productData");

        String productName = productData['productName'] ?? 'Unknown';

        return {'product name': productName};
      } else {
        return {'product name': 'Unknown'};
      }
    } catch (e) {
      return {'product name': 'Unknown'};
    }
  }

  Future<void> updateDeliveryStatus(Payment payment) async {
    try {
      DocumentReference paymentRef = db.collection(collectionName).doc(payment.paymentID);

      await paymentRef.update({
        "deliveryStatus": payment.deliveryStatus
      });
    } catch (e) {
      print("Error updating delivery status: $e");
    }
  }

  Stream<List<Payment>> customerGetOrderDetails(String customerID) {
    return db.collection(collectionName)
        .where('userID', isEqualTo: customerID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Payment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error getting products for vendor $customerID: $error");
    });
  }


}