import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/user/payment_implementation.dart';
import 'package:pet_haven/ui/vendor/manage_orders.dart';
import '../../data/model/payment.dart';
import '../../data/model/user.dart';

class OrderContainer extends StatefulWidget {
  final User vendorData;
  final Payment orderData;
  const OrderContainer({super.key, required this.vendorData, required this.orderData});

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  PaymentImplementation paymentImpl = PaymentImplementation();

  String customerName = "";
  String customerEmail = "";
  String productName = "";

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails(widget.orderData.userID);
    fetchProductDetails(widget.orderData.productID);
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
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageOrders(vendorData: widget.vendorData, orderData: widget.orderData))
            );
          },
          child: Container(
            width: 400,
            height: 140,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 220, 116, 1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(3.0, 3.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.5,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
              child: Row(
                // Changed from Column to Row
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset("assets/images/package.png"),
                    ],
                  ),
                  const SizedBox(width: 1), // Add spacing before divider
                  const VerticalDivider(
                    thickness: 2,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 1), // Add spacing after divider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.receipt_long, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "ID: ${widget.orderData.paymentID}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            "Product: $productName",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            "Customer: $customerName",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.local_shipping, size: 20),
                          const SizedBox(width: 6),
                          const Text(
                            "Delivery Status: ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.orderData.deliveryStatus,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 22)
      ],
    );
  }
}
