import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/vendors/product_implementation.dart';
import '../../data/model/product.dart';
import '../../data/model/review.dart';
import 'appbar.dart';
import 'product-box.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;

class ProductList extends StatefulWidget {
  final user_model.User userData;
  const ProductList({super.key, required this.userData});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ProductImplementation productImpl = ProductImplementation();
  TextEditingController searchController = TextEditingController();
  List<Product> allProducts = [];
  List<Product> searchResults = [];
  String? selectedCategory = "ALL";
  bool isLoading = false;
  String errorMessage = "";

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

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      QuerySnapshot result;
      if (selectedCategory == "ALL") {
        result = await FirebaseFirestore.instance.collection('Products').get();
      } else {
        result = await FirebaseFirestore.instance
            .collection('Products')
            .where('category', isEqualTo: selectedCategory)
            .get();
      }

      List<Product> finalResults = result.docs.map((doc) {
        List<Review> reviews = (doc['reviews'] as List<dynamic>?)
            ?.map((review) => Review.fromMap(review as Map<String, dynamic>))
            .toList() ?? [];

        return Product(
          productID: doc.id,
          productName: doc['productName'],
          description: doc['description'],
          category: doc['category'],
          price: doc['price'],
          inventoryQuantity: doc['inventoryQuantity'],
          quantitySold: doc['quantitySold'],
          vendorID: doc['vendorID'],
          imagePath: doc['imagePath'],
          reviews: reviews,
        );
      }).toList();

      setState(() {
        allProducts = finalResults; // Store all products
        searchResults = finalResults; // Initially show all products
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred while fetching products.";
      });
      print("Error: $e");
    }
  }
  void searchProducts(String query) {
    setState(() {
      searchResults = allProducts
          .where((product) => product.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: CustomAppBar(
        title: "Product List",
        subTitle: "Looking for Something?",
        user: widget.userData,
        searchController: searchController,
        onSearchChanged: searchProducts, // Pass the function
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<List<Product>>(
                      stream: productImpl.getAllProducts(),
                      builder: (context, snapshot) {
                        int productCount = snapshot.hasData ? snapshot.data!.length : 0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'All Products',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$productCount in-store products',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(0, 139, 139, 1),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      width: 190,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonFormField<String>(
                              value: selectedCategory,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              items: categories.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategory = newValue;
                                });
                                fetchProducts();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
                  : searchResults.isEmpty
                  ? const Center(child: Text("No products available"))
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                  childAspectRatio: 0.85,
                ),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ProductBox(
                    user: widget.userData,
                    productData: searchResults[index],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
