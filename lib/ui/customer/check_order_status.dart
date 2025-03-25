import 'package:flutter/material.dart';
import '../../data/model/payment.dart';
import '../../data/model/user.dart';
import '../../data/repository/user/payment_implementation.dart';
import 'alternative_app_bar.dart';
import 'order_tracking_container.dart';

class CheckOrderStatus extends StatefulWidget {
  final User user;

  const CheckOrderStatus({Key? key, required this.user}) : super(key: key);

  @override
  _CheckOrderState createState() => _CheckOrderState();
}

class _CheckOrderState extends State<CheckOrderStatus> {
  PaymentImplementation paymentImpl = PaymentImplementation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AlternativeAppBar(pageTitle: "My Activity", user: widget.user),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Tracking & Activity",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<List<Payment>>(
                stream: paymentImpl.customerGetOrderDetails(widget.user.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No orders found"));
                  }

                  var orders = snapshot.data!;
                  var pendingDelivery = orders.where((o) => o.deliveryStatus == "Pending Delivery").toList();
                  var outForDelivery = orders.where((o) => o.deliveryStatus == "Out for Delivery").toList();
                  var delivered = orders.where((o) => o.deliveryStatus == "Delivered").toList();

                  return ListView(
                    children: [
                      if (pendingDelivery.isNotEmpty)
                        buildCategorySection("Pending Delivery", pendingDelivery, Colors.orange, "🟡"),
                      if (outForDelivery.isNotEmpty)
                        buildCategorySection("Out for Delivery", outForDelivery, Colors.blue, "🚚"),
                      if (delivered.isNotEmpty)
                        buildCategorySection("Delivered", delivered, Colors.green, "✅"),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategorySection(String title, List<Payment> orders, Color color, String emoji) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "$emoji $title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: orders
              .map((payment) => OrderTrackingContainer(
            productID: payment.productID,
            paymentData: payment,
          ))
              .toList(),
        ),
        const SizedBox(height: 20), // Adds spacing between categories
      ],
    );
  }
}

