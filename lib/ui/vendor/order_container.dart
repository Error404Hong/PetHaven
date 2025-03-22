import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/manage_orders.dart';
import '../../data/model/user.dart';

class OrderContainer extends StatefulWidget {
  final User vendorData;
  const OrderContainer({super.key, required this.vendorData});

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageOrders(vendorData: widget.vendorData))
            );
          },
          child: Container(
            width: 400,
            height: 140,
            decoration: BoxDecoration(
                color: Color.fromRGBO(240, 220, 116, 1),
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
                  const SizedBox(width: 10), // Add spacing before divider
                  const VerticalDivider(
                    thickness: 2,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 10), // Add spacing after divider
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt_long, color: Colors.brown, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Order ID: 12345obj",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.brown),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.shopping_bag, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Product: Dog Kibbles",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.person, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Customer: Hong Jing Xin",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.local_shipping, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Delivery Status: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Delivered",
                            style: TextStyle(
                                fontSize: 15,
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
