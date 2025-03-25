import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/user/payment_implementation.dart';
import 'package:pet_haven/ui/component/snackbar.dart';
import 'package:pet_haven/ui/vendor/order_container.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/payment.dart';
import '../../data/model/user.dart';

class OrderDashboard extends StatefulWidget {
  final User vendorData;
  const OrderDashboard({super.key, required this.vendorData});

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> {
  PaymentImplementation paymentImpl = PaymentImplementation();

  List<Payment> searchResults = [];
  var _searchError = "";
  String? _selectedDeliveryStatus;
  List<String> deliveryStatuses = [
    'ALL',
    'Pending Delivery',
    'Out for Delivery',
    'Delivered',
  ];

  Future<void> searchByCategory() async {
    // Ensure _selectedDeliveryStatus isn't null and is different from "ALL"
    if (_selectedDeliveryStatus == null || _selectedDeliveryStatus == "ALL") {
      clearSearch();
      return;
    }

    setState(() {
      _searchError = "";
      searchResults.clear(); // Clear previous search results
    });

    try {
      var db = FirebaseFirestore.instance;
      QuerySnapshot result = await db.collection('Payment')
          .where('deliveryStatus', isEqualTo: _selectedDeliveryStatus)
          .get();

      List<Payment> finalResults = result.docs.map((doc) => Payment(
        paymentID: doc.id,
        amount: doc['amount'],
        userID: doc['userID'],
        vendorID: doc['vendorID'],
        productID: doc['productID'],
        deliveryStatus: doc['deliveryStatus'],
        address: doc['address']
      )).toList();

      setState(() {
        if (finalResults.isEmpty) {
          showSnackbar(context, "No Order Found!", Colors.red);
        } else {
          _searchError = "";
          showSnackbar(context, "Order(s) Found!", Colors.green);
          searchResults = finalResults;
        }
      });

    } catch (e) {
      print("Error: $e");
      setState(() {
        _searchError = "An error occurred while searching.";
      });
    }
  }

  void clearSearch() {
    setState(() {
      _selectedDeliveryStatus = null;
      searchResults.clear();
      _searchError = "";
    });
  }

  Map<String, List<Payment>> categorizeOrders(List<Payment> payments) {
    List<Payment> pendingOrders = [];
    List<Payment> outForDeliveryOrders = [];
    List<Payment> deliveredOrders = [];

    for (var payment in payments) {
      switch (payment.deliveryStatus) {
        case 'Pending Delivery':
          pendingOrders.add(payment);
          break;
        case 'Out for Delivery':
          outForDeliveryOrders.add(payment);
          break;
        case 'Delivered':
          deliveredOrders.add(payment);
          break;
        default:
          break;
      }
    }

    return {
      'Pending Orders': pendingOrders,
      'Out for Delivery Orders': outForDeliveryOrders,
      'Delivered Orders': deliveredOrders,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(pageTitle: "Order Management", vendorData: widget.vendorData),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Orders Dashboard 📦',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                value: _selectedDeliveryStatus,
                items: deliveryStatuses.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDeliveryStatus = newValue;
                  });

                  // Only call searchByCategory when a value is selected and not null or "ALL"
                  if (_selectedDeliveryStatus != null && _selectedDeliveryStatus != "ALL") {
                    searchByCategory();
                  } else {
                    clearSearch(); // Clear results if "ALL" is selected
                  }
                },
                decoration: InputDecoration(
                  errorText: _searchError.isEmpty ? null : _searchError,
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  labelText: "Select Delivery Status",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 28),
              // Show Search Results if available
              if (searchResults.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Search Results 🔍",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return OrderContainer(orderData: searchResults[index], vendorData: widget.vendorData);
                      },
                    ),
                  ],
                )
              else
                StreamBuilder<List<Payment>>(
                  stream: paymentImpl.checkVendorOrders(widget.vendorData),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No Orders available"));
                    }

                    List<Payment> paymentList = snapshot.data!;
                    Map<String, List<Payment>> categorizedOrders = categorizeOrders(paymentList);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pending Orders
                        if (categorizedOrders['Pending Orders']!.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Pending Orders 📦',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.redAccent),
                            ),
                          ),
                        ...categorizedOrders['Pending Orders']!
                            .map((order) => OrderContainer(
                          vendorData: widget.vendorData,
                          orderData: order,
                        ))
                            .toList(),

                        // Out for Delivery Orders
                        if (categorizedOrders['Out for Delivery Orders']!.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Out for Delivery Orders 🚚',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.blueAccent),
                            ),
                          ),
                        ...categorizedOrders['Out for Delivery Orders']!
                            .map((order) => OrderContainer(
                          vendorData: widget.vendorData,
                          orderData: order,
                        ))
                            .toList(),

                        // Delivered Orders
                        if (categorizedOrders['Delivered Orders']!.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Delivered Orders ✅',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.green),
                            ),
                          ),
                        ...categorizedOrders['Delivered Orders']!
                            .map((order) => OrderContainer(
                          vendorData: widget.vendorData,
                          orderData: order,
                        ))
                            .toList(),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}


