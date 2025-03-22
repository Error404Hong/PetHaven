import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/order_container.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/user.dart';

class OrderDashboard extends StatefulWidget {
  final User vendorData;
  const OrderDashboard({super.key, required this.vendorData});

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> {
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
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  labelText: "Search For Specific Order...",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              OrderContainer(vendorData: widget.vendorData),
              OrderContainer(vendorData: widget.vendorData),
              OrderContainer(vendorData: widget.vendorData),
            ],
          ),
        ) ,
      )
    );
  }
}
