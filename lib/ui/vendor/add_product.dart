import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_haven/data/model/product.dart';
import 'package:pet_haven/data/repository/vendors/product_implementation.dart';
import 'package:pet_haven/ui/component/snackbar.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../data/model/user.dart';
import '../customer/utils/image_utils.dart';

class AddProduct extends StatefulWidget {
  final User vendorData;
  final Product? product;
  final String mode; // "add" or "manage"

  const AddProduct({super.key, required this.vendorData, required this.mode, this.product});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  ProductImplementation productImpl = ProductImplementation();

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  int _invQuantity = 1;
  String imagePath = "";

  var _productNameError = "";
  var _priceError = "";
  var _descriptionError = "";
  var _categoryError = "";

  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'manage') {
      _loadProductData(widget.product?.productID);
    }
  }

  void _loadProductData(String? productId) async {
    if (productId == null) return; // end immediately if no product detected
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;

        setState(() {
          imagePath = data["imagePath"]; // Store the path as a string

          // Load image as Uint8List if it's a valid file path or URL
          _loadImage(imagePath);
          _productNameController.text = data["productName"];
          _priceController.text = data["price"].toString();
          _descriptionController.text = data["description"];
          _selectedCategory = data["category"];
          _invQuantity = data["inventoryQuantity"];
        });
      }
    } catch (e) {
      print("Error loading product: $e");
    }
  }

  Future<void> _loadImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        Uint8List imageBytes = await file.readAsBytes(); // Read file bytes

        setState(() {
          _image = imageBytes;
        });

        print("Image successfully loaded from file.");
      } else {
        print("File does not exist: $imagePath");
      }
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  void selectImage() async {
    try {
      Uint8List? img = await pickImage(ImageSource.gallery);
      if(img != null) {
        setState(() {
          _image = img;
        });
      } else {
        print("No image selected");
        return;
      }
    } catch(e) {
      print('Error selecting image: $e');
      return;
    }

    try {
      final Directory? externalDir = await getExternalStorageDirectory();

      if (externalDir == null) {
        print("Error: External storage directory not found.");
        return;
      }

      final Directory saveDir = Directory('${externalDir.path}/productPics');

      if (!await saveDir.exists()) {
        print("Directory does not exist. Creating now...");
        await saveDir.create(recursive: true);
      } else {
        print("Directory already exists.");
      }

      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savePath = '${saveDir.path}/$fileName';
      imagePath = savePath;
      final File localImage = File(savePath);

      print("Final save path: $savePath");

      await localImage.writeAsBytes(_image!).then((_) {
        print("Image successfully saved at: $savePath");
      }).catchError((error) {
        print("Error writing image: $error");
      });

    } catch(e) {
      print('Error saving image: $e');
    }
  }

  Future<void> addProduct(context) async {
    try {
      String productName = _productNameController.text.trim();
      double? price = double.tryParse(_priceController.text);
      String description = _descriptionController.text.trim();
      int quantity = _invQuantity;
      String? category = _selectedCategory;
      String imageFilePath = imagePath;
      int quantitySold = 0;
      String? vendorID = widget.vendorData.id;

      setState(() {
        _productNameError = productName.isEmpty ? "Empty product name is not allowed" : "";
        _priceError = price == null ? "Invalid price" : "";
        _descriptionError = description.isEmpty ? "Empty description is not allowed" : "";
        _categoryError = category != null ? "" : "Empty category is not allowed";
      });

      if (_productNameError.isEmpty && _priceError.isEmpty && _descriptionError.isEmpty && _categoryError.isEmpty) {
        Product newProduct = Product(
          productName: productName,
          category: category!,
          price: price!,
          inventoryQuantity: quantity,
          description: description,
          imagePath: imageFilePath,
          quantitySold: quantitySold,
          vendorID: vendorID!,
          reviews: []
        );

        productImpl.addNewProduct(newProduct);
        showSnackbar(context, "Product Added Successfully", Colors.green);

        setState(() {
          _productNameController.clear();
          _priceController.clear();
          _descriptionController.clear();
          _selectedCategory = "";
          _invQuantity = 1;

          _productNameError = "";
          _priceError = "";
          _descriptionError = "";
          _categoryError = "";
        });
      }
    } catch (e) {
      showSnackbar(context, "Error: $e", Colors.redAccent);
    }
  }

  Future<void> updateProduct(BuildContext context, Product product) async {
    try {
      String productName = _productNameController.text.trim();
      double? price = double.tryParse(_priceController.text);
      String description = _descriptionController.text.trim();
      int quantity = _invQuantity;
      String? category = _selectedCategory;
      String imageFilePath = imagePath;

      setState(() {
        _productNameError = productName.isEmpty ? "Empty product name is not allowed" : "";
        _priceError = price == null ? "Invalid price" : "";
        _descriptionError = description.isEmpty ? "Empty description is not allowed" : "";
        _categoryError = category != null ? "" : "Empty category is not allowed";
      });

      if (_productNameError.isEmpty && _priceError.isEmpty && _descriptionError.isEmpty && _categoryError.isEmpty) {
        product.productName = productName;
        product.category = category!;
        product.price = price!;
        product.inventoryQuantity = quantity;
        product.description = description;
        product.imagePath = imageFilePath;

        await productImpl.updateProduct(product);

        showSnackbar(context, "Product Updated Successfully!", Colors.green);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });

      }
    } catch (e) {
      showSnackbar(context, "Error: $e", Colors.redAccent);
    }
  }

  Future<bool> deleteProduct(BuildContext context, Product product) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await productImpl.deleteProduct(product);
      showSnackbar(context, "Product Deleted Successfully!", Colors.green);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(
        pageTitle: widget.mode == "add" ? "Upload Product" : "Manage Product",
        vendorData: widget.vendorData,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Upload Section
            Stack(
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _image == null
                          ? AssetImage('assets/images/pet-product-sample.jpg')
                          : MemoryImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () => selectImage(),
                      icon: const Icon(
                        Icons.add_a_photo_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Product Name
            const Text("Product Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                errorText: _productNameError.isEmpty ? null : _productNameError,
                hintText: "Enter product name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 15),

            // Product Category
            const Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: (_selectedCategory != null && [
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
              ].contains(_selectedCategory))
                  ? _selectedCategory
                  : null, // Ensuring the value exists
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
                errorText: _categoryError.isNotEmpty ? _categoryError : null,
              ),
              hint: const Text("Select a category"),
              items: [
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
              ].map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _categoryError = "";
                });
              },
            ),
            const SizedBox(height: 15),

            // Price
            const Text("Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                errorText: _priceError.isEmpty ? null : _priceError,
                hintText: "Enter price",
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 15),

            // Quantity
            const Text("Quantity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_invQuantity > 1) _invQuantity--;
                    });
                  },
                  icon: const Icon(Icons.remove_circle, color: Colors.red, size: 30),
                ),
                Text(_invQuantity.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _invQuantity++;
                    });
                  },
                  icon: const Icon(Icons.add_circle, color: Colors.green, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Description
            const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            TextField(
              maxLines: 6,
              controller: _descriptionController,
              decoration: InputDecoration(
                errorText: _descriptionError.isEmpty ? null : _descriptionError,
                hintText: "Enter product description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            if (widget.mode == "add") ...[
              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color.fromRGBO(172, 208, 193, 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => addProduct(context),
                  child: const Text(
                    "Upload Product",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                  ),
                ),
              ),
            ] else ...[
              // Update and Delete Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => updateProduct(context, widget.product!),
                      child: const Text(
                        "Update Product",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => deleteProduct(context, widget.product!),
                      child: const Text(
                        "Delete Product",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

