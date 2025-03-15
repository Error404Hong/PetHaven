import 'package:flutter/material.dart';
import 'alternative_app_bar.dart';
import 'customer_review_box.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
        appBar: const AlternativeAppBar(pageTitle: "Product Details"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/pet-food-image.png'),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Royal Canin Kibbles 10kg',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'RM300',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('105 sold'),
                      const Divider(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(245, 245, 245, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.2), // Shadow color with transparency
                                    spreadRadius:
                                        2, // How much the shadow spreads
                                    blurRadius: 5, // Softness of the shadow
                                    offset: const Offset(0,
                                        3), // Changes position of shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 280,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  50),
                                              child: Image.asset(
                                                'assets/images/royal-canin.png',
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 90,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: 200,
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Royal Canin', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)
                                                  ),
                                                  SizedBox(height: 3),
                                                  Text('Highly Trusted', style: TextStyle(fontSize: 13),)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 78,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            OutlinedButton(
                                              onPressed: () {},
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(color: Colors.black, width: 1), // Outline color & width
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Adjust padding
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5), // Rounded corners
                                                ),
                                              ),
                                              child: const Text(
                                                'Visit >',
                                                style: TextStyle(fontSize: 12, color: Colors.black), // Adjust text size & color
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              )),
                          const SizedBox(height: 18),
                          const Text(
                            'Product Description',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Give your furry friend the nutrition they deserve! Packed with high-quality proteins, essential vitamins, and omega fatty acids, this kibble supports strong muscles, a shiny coat, and overall well-being. Perfect for all breeds, with a delicious taste pets love! 🐶🐱✨',
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 12),
                          const Text.rich(
                            TextSpan(
                              text: 'Brand: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: 'Royal Canin',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text.rich(
                            TextSpan(
                              text: 'Weight: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: '10kg',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text.rich(
                            TextSpan(
                              text: 'Suitability: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: 'Puppy within 12 months',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const SizedBox(
                            width: double
                                .infinity, // Ensures alignment works properly
                            child: Text.rich(
                              TextSpan(
                                text: 'Ingredients: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text:
                                        'Chicken Meal, Salmon Oil, Sweet Potatoes, Glucosamine & Chondroitin, Probiotics',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign
                                  .justify, // Change to TextAlign.justify if needed
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 50),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Reviews',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),

                          // Review Section
                          CustomerReviewBox(),
                          CustomerReviewBox(),
                          CustomerReviewBox(),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(Color.fromRGBO(172, 208, 193, 1)),
                          ),
                          child: const Text('Buy Now', style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
    );
  }
}
