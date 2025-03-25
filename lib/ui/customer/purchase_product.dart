import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/model/payment.dart';
import 'package:pet_haven/data/repository/user/payment_implementation.dart';
import 'package:pet_haven/data/repository/vendors/product_implementation.dart';
import 'package:pet_haven/ui/component/snackbar.dart';
import 'package:pet_haven/ui/customer/alternative_app_bar.dart';
import '../../data/model/product.dart';
import '../../data/model/user.dart';
import 'check_order_status.dart';

class PurchaseProduct extends StatefulWidget {
  final User user;
  final Product productData;
  const PurchaseProduct({super.key, required this.user, required this.productData});

  @override
  State<PurchaseProduct> createState() => _PurchaseProductState();
}

class _PurchaseProductState extends State<PurchaseProduct> {
  PaymentImplementation paymentImpl = PaymentImplementation();
  ProductImplementation productImpl = ProductImplementation();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _recipientAddressController = TextEditingController();
  final TextEditingController _recipientNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recipientNameController.text = widget.user.name; // Set recipient name to user’s name
  }

  Future<void> _processPayment() async {
    try {
      String? productID = widget.productData.productID;
      String? userID = widget.user.id;
      String? vendorID = widget.productData.vendorID;
      double amount = widget.productData.price;
      String deliveryStatus = "Pending Delivery";
      String address = _recipientAddressController.text.trim();
      if (_formKey.currentState!.validate()) {
        Payment newPayment = Payment(amount: amount, userID: userID!, productID: productID!, vendorID: vendorID, deliveryStatus: deliveryStatus, address: address);
        paymentImpl.newPayment(newPayment);
        productImpl.updateStatusAfterSales(widget.productData);


        setState(() {
          _cardNumberController.clear();
          _expiryController.clear();
          _cvvController.clear();
          _nameController.clear();
        });
        showSnackbar(context, "Payment Successful", Colors.green);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckOrderStatus(user: widget.user),
          ),
        );

      }
    } catch(e) {
      showSnackbar(context, "Error: $e", Colors.redAccent);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AlternativeAppBar(pageTitle: "Payment", user: widget.user),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary Container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(widget.productData.imagePath),
                        fit: BoxFit.contain,
                        height: 100,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productData.productName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.productData.category,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "RM${widget.productData.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Payment Section
              const Text(
                "Payment Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Card Number Input
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Card Number",
                        prefixIcon: const Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 16) {
                          return "Enter a valid card number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        // Expiry Date
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: "MM/YY",
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter expiry date";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),

                        // CVV
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "CVV",
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return "Enter valid CVV";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Cardholder Name
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Cardholder Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter cardholder name";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // Recipient Name (Disabled)
                    TextFormField(
                      controller: _recipientNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Recipient Name",
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true, // Make background grey
                        fillColor: Colors.grey[200],
                      ),
                      readOnly: true, // ❌ Prevent changes
                    ),

                    const SizedBox(height: 20),

                    // Recipient Address (Editable)
                    TextFormField(
                      controller: _recipientAddressController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Recipient Address",
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter recipient address";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),


                    // Pay Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
