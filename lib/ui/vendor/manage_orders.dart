import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/payment.dart';
import '../../data/model/user.dart';
import '../../data/repository/user/payment_implementation.dart';
import 'package:intl/intl.dart';

import '../component/snackbar.dart';

class ManageOrders extends StatefulWidget {
  final User vendorData;
  final Payment orderData;
  const ManageOrders({super.key, required this.vendorData, required this.orderData});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  PaymentImplementation paymentImpl = PaymentImplementation();

  String customerName = "";
  String customerEmail = "";
  String productName = "";
  String estimatedProductDeliveryDate = "";

  String selectedStatus = "";

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails(widget.orderData.userID);
    fetchProductDetails(widget.orderData.productID);
    getEstimatedDeliveryDate();
    selectedStatus = widget.orderData.deliveryStatus;
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Out for Delivery":
        return Colors.orange;
      case "Pending Delivery":
      default:
        return Colors.red;
    }
  }

  Future<void> fetchCustomerDetails(String customerID) async {
    try {
      // Fetch customer details asynchronously
      var customerData = await paymentImpl.getCustomerDetails(customerID);
      if (customerData != null) {
        setState(() {
          // Update the state with both name and email
          customerName = customerData['name'] ?? 'Not Available';
          customerEmail = customerData['email'] ?? 'Not Available';
        });
      } else {
        setState(() {
          customerName = 'Not Available';
          customerEmail = 'Not Available';
        });
      }
    } catch (e) {
      print("Error fetching customer details: $e");
      setState(() {
        customerName = 'Not Available';
        customerEmail = 'Not Available';
      });
    }
  }

  Future<void> fetchProductDetails(String productID) async {
    try {
      // Fetch product details using the getProductDetails method
      Map<String, String> productDetails = await paymentImpl.getProductDetails(productID);

      // Update the state with the fetched product name
      setState(() {
        productName = productDetails['product name'] ?? 'Not Available';
      });
    } catch (e) {
      print("Error fetching product details: $e");
      setState(() {
        productName = 'Not Available';
      });
    }
  }

  void getEstimatedDeliveryDate() {
    DateTime paymentDate = widget.orderData.paymentDate;

    // Add 3 days to the payment date
    DateTime estimatedDeliveryDate = paymentDate.add(Duration(days: 3));
    String formattedDate = DateFormat('MMMM dd, yyyy').format(estimatedDeliveryDate);
    setState(() {
      estimatedProductDeliveryDate = formattedDate;
    });
  }

  Future<void> updateProductDeliveryStatus(BuildContext context, Payment payment) async {
    try {
      String deliveryStatus = selectedStatus;

      payment.deliveryStatus = deliveryStatus;

      await paymentImpl.updateDeliveryStatus(payment);
      showSnackbar(context, "Delivery Status Updated Successfully!", Colors.green);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });

    } catch (e) {
      showSnackbar(context, "Error: $e", Colors.redAccent);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(
          pageTitle: "Orders Management", vendorData: widget.vendorData),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 28, 18, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overview",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID: ${widget.orderData.paymentID}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    "Product: $productName",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Total Paid: RM${widget.orderData.amount.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Customer: $customerName",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Email: $customerEmail",
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Estimated Delivery Date:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    estimatedProductDeliveryDate,
                    style: const TextStyle(fontSize: 15, color: Colors.green),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Delivery Address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    widget.orderData.address,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Payment Method:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.orderData.paymentMethod,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),

                  // Current Order Status Label
                  const Text(
                    "Current Delivery Status:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedStatus,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: getStatusColor(selectedStatus),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dropdown to update status
                  const Text(
                    "Update Delivery Status:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        onChanged: (newStatus) {
                          setState(() {
                            selectedStatus = newStatus!;
                          });

                          updateProductDeliveryStatus(context, widget.orderData);
                        },
                        items: ["Pending Delivery", "Out for Delivery", "Delivered"]
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


