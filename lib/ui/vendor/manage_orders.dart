import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/user.dart';

class ManageOrders extends StatefulWidget {
  final User vendorData;
  const ManageOrders({super.key, required this.vendorData});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  String selectedStatus = "Pending Delivery";

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
                  const Text(
                    "Order ID: #1234567890123456",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    "Product: Premium Dog Food",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Total Paid: \$45.99",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Customer: Alex Johnson",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Email: alex.johnson@example.com",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Estimated Delivery Date:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "April 10, 2025",
                    style: TextStyle(fontSize: 15, color: Colors.green),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Payment Method:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Credit Card (Visa **** 1234)",
                    style: TextStyle(fontSize: 15),
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


