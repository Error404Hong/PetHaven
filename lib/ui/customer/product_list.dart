import 'package:flutter/material.dart';
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
  String dropDownValue = "Item 1";

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: CustomAppBar(
          title: "Product List", subTitle: "Looking for Something?", user: widget.userData),
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dog Kibbles',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '50 in-store products',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(0, 139, 139, 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 130,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropDownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            items: items.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue = newValue!;
                              });
                            },
                          ),
                        ),
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                  childAspectRatio: 0.85,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ProductBox(user: widget.userData);
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
