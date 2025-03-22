import 'package:flutter/material.dart';
import 'package:pet_haven/ui/vendor/hor_product_box.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/user.dart';
import 'add_product.dart';

class ProductManagement extends StatefulWidget {
  final User vendorData;
  const ProductManagement({super.key, required this.vendorData});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  String? selectedCategory; // Stores the selected category
  final List<String> categories = ["All", "Food", "Toys", "Accessories", "Health"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(pageTitle: "Products Management", vendorData: widget.vendorData),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28), // Top padding

            // Dropdown for category filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  prefixIcon: const Icon(Icons.category, color: Colors.teal),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text("Select Category"),
                    isExpanded: true,
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Text field for product name search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "Search Product by Name...",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Search Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(172, 208, 193, 1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    // TODO: Implement search functionality
                  },
                  child: const Text(
                    "Search Product",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15), // Spacing before container

            // Green Container (Without Padding)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(172, 208, 193, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(21, 18, 21, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "My Products",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  AddProduct(vendorData: widget.vendorData, mode: "add"))
                            );
                          },
                          child: const Text(
                            "Add Product",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    HorProductBox(vendorData: widget.vendorData),
                    HorProductBox(vendorData: widget.vendorData),
                    HorProductBox(vendorData: widget.vendorData),
                    HorProductBox(vendorData: widget.vendorData),
                    HorProductBox(vendorData: widget.vendorData),
                    HorProductBox(vendorData: widget.vendorData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



