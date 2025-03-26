import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/vendors/product_implementation.dart';
import 'package:pet_haven/ui/vendor/hor_product_box.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/product.dart';
import '../../data/model/user.dart';
import 'add_product.dart';

class ProductManagement extends StatefulWidget {
  final User vendorData;
  const ProductManagement({super.key, required this.vendorData});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final _searchController = TextEditingController();
  var _searchError = "";
  var _searchCategoryError = "";

  List<Product> searchResults = [];
  ProductImplementation productImpl = ProductImplementation();

  String? selectedCategory;
  final List<String> categories = [
    "ALL",
    "Pet Food",
    "Pet Toys",
    "Pet Treats",
    "Pet Accessories",
    "Pet Grooming",
    "Pet Health & Wellness",
    "Pet Bedding & Housing",
    "Pet Training & Behavior",
    "Pet Travel & Carriers",
    "Pet Cleaning & Waste Management",
    "Pet Habitat & Furniture",
    "Pet Diapers & Hygiene"
  ];

  void clearSearch() {
    setState(() {
      _searchController.clear();
      selectedCategory = null;
      searchResults.clear();
      _searchError = "";
    });
  }

  Future<void> searchByCategory() async {
    if (selectedCategory == null) return;

    if(selectedCategory == "ALL") {
      clearSearch();
    }

    setState(() {
      _searchCategoryError = "";
      searchResults.clear(); // Clear previous search results
    });

    var db = FirebaseFirestore.instance;

    try {
      QuerySnapshot result = await db.collection('Products')
          .where('category', isEqualTo: selectedCategory)
          .get();

      List<Product> finalResults = result.docs.map((doc) => Product(
        productID: doc.id,
        productName: doc['productName'],
        description: doc['description'],
        category: doc['category'],
        price: doc['price'],
        inventoryQuantity: doc['inventoryQuantity'],
        quantitySold: doc['quantitySold'],
        vendorID: doc['vendorID'],
        imagePath: doc['imagePath'],
        reviews: doc['reviews']
      )).toList();

      setState(() {
        if (finalResults.isEmpty) {
          _searchCategoryError = "No products found in $selectedCategory.";
        } else {
          _searchCategoryError = "";
          searchResults = finalResults;
        }
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        _searchCategoryError = "An error occurred while searching.";
      });
    }
  }

  Future<void> searchProduct() async {
    String searchQuery = _searchController.text.trim().toLowerCase();

    setState(() {
      _searchError = searchQuery.isEmpty ? "Please specify a keyword to search." : "";
      searchResults.clear(); // Clear previous search results
    });

    if (searchQuery.isEmpty) return;

    var db = FirebaseFirestore.instance;

    try {
      QuerySnapshot result = await db.collection('Products').get();

      List<Product> finalResults = result.docs
          .where((doc) {
        String productName = doc['productName'].toString().toLowerCase();
        String description = doc['description'].toString().toLowerCase();

        return productName.contains(searchQuery) ||
            description.contains(searchQuery);
      })
          .map((doc) => Product(
          productID: doc.id,
          productName: doc['productName'],
          description: doc['description'],
          category: doc['category'],
          price: doc['price'],
          inventoryQuantity: doc['inventoryQuantity'],
          quantitySold: doc['quantitySold'],
          vendorID: doc['vendorID'],
          imagePath: doc['imagePath'],
          reviews: doc['reviews']
      ))
          .toList();

      setState(() {
        if (finalResults.isEmpty) {
          _searchError = "No results found for \"$searchQuery\".";
        } else {
          _searchError = "";
          searchResults = finalResults;
        }
      });

      for (var product in searchResults) {
        print("✅ Found: ${product.productName} at ${product.productID}");
      }

    } catch (e) {
      print("Error: $e");
      setState(() {
        _searchError = "An error occurred while searching.";
      });
    }
  }

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
                  errorText: _searchCategoryError.isEmpty ? null : _searchCategoryError,
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
                      searchByCategory();
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
                controller: _searchController,
                decoration: InputDecoration(
                  errorText: _searchError.isEmpty ? null : _searchError,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "Search Product by Name...",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: clearSearch,
                  )
                      : null,
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
                  onPressed: searchProduct,
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
                    if (searchResults.isNotEmpty) ...[
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Search Results 🔍",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return HorProductBox(vendorData: widget.vendorData, product: searchResults[index]);
                        },
                      ),
                    ] else ...[
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
                                MaterialPageRoute(
                                  builder: (context) => AddProduct(vendorData: widget.vendorData, mode: "add"),
                                ),
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
                      StreamBuilder<List<Product>>(
                        stream: productImpl.getVendorProducts(widget.vendorData.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text("No products available"));
                          }

                          List<Product> productList = snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: productList.length,
                                itemBuilder: (context, index) {
                                  return HorProductBox(vendorData: widget.vendorData, product: productList[index]);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ]
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



