import 'package:flutter/material.dart';
import '../../widgets/fetchProducts.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 247, 247),
      body: SafeArea(
        child: fetchData("users-favourite-items"),
      ),
    );
  }
}
