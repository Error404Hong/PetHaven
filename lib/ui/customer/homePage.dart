import 'package:flutter/material.dart';
import 'product-box.dart';
import 'package:pet_haven/ui/customer/view_activities.dart';
import 'appbar.dart';
import 'activity_box.dart';
import 'product_list.dart';

void main() {
  runApp(const MaterialApp(home: CustHomePage()));
}

class CustHomePage extends StatefulWidget {
  const CustHomePage({super.key});

  @override
  State<CustHomePage> createState() => _CustHomePageState();
}

class _CustHomePageState extends State<CustHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: const CustomAppBar(title: "PetHaven", subTitle: "Welcome Back!"),
      body: SingleChildScrollView(
        // Wrap content to make it scrollable
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Categories 🔥',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductList()));
                      },

                      child: const Text(
                        'Check All',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 139, 139, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProductBox(),
                  ProductBox(),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby Adventures 🏞️',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewActivity()));
                    },
                    child: const Text(
                      'Check All',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 139, 139, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const ActivityBox(),
              const ActivityBox(),
            ],
          ),
        ),
      ),
    );
  }
}
