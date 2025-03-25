import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  String? paymentID;
  double amount;
  DateTime paymentDate;
  String paymentMethod;
  String deliveryStatus;
  String userID;
  String productID;
  String vendorID;
  String address;

  Payment({
    this.paymentID,
    required this.amount,
    required this.userID,
    required this.productID,
    required this.vendorID,
    required this.deliveryStatus,
    required this.address
  })  : paymentDate = DateTime.now(),
        paymentMethod = "Card Payment";

  // Convert Payment object to a Map
  Map<String, dynamic> toMap() {
    return {
      'paymentID': paymentID,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'deliveryStatus': deliveryStatus,
      'userID': userID,
      'productID': productID,
      'vendorID': vendorID,
      'address': address
    };
  }

  // Create Payment object from a Map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentID: map['paymentID'],
      amount: map['amount'],
      userID: map['userID'],
      productID: map['productID'],
      vendorID: map['vendorID'],
      address: map['address'],
      deliveryStatus: map['deliveryStatus']
    )..paymentDate = DateTime.parse(map['paymentDate'])
      ..paymentMethod = map['paymentMethod'];
  }

  factory Payment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Payment(
      paymentID: doc.id,
      amount: (data['amount'] as num).toDouble(),
      userID: data['userID'],
      productID: data['productID'],
      vendorID: data['vendorID'],
      address: data['address'],
      deliveryStatus: data['deliveryStatus'],
    )..paymentDate = (data['paymentDate'] as Timestamp).toDate()
      ..paymentMethod = data['paymentMethod'] ?? "Card Payment";
  }
}
