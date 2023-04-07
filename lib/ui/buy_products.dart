import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/customButton.dart';
import '../../widgets/fetchProducts.dart';

class BuyProducts extends StatefulWidget {
  @override
  _BuyProductsState createState() => _BuyProductsState();
}

class _BuyProductsState extends State<BuyProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 247, 247),
      body: SafeArea(
        child: Column(
          children: [
            
            Expanded(child: fetchData("buy-products")),
          ],
        ),
      ),
    );
  }
}
