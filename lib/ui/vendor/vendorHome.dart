import 'package:flutter/material.dart';

class Vendorhome extends StatefulWidget {
  const Vendorhome({super.key});

  @override
  State<Vendorhome> createState() => _VendorhomeState();
}

class _VendorhomeState extends State<Vendorhome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
        child: Text('Vendor Home'),
      ),
    );
  }
}
