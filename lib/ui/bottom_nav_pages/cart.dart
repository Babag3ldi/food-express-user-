import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/const/AppColors.dart';
import 'package:food_delivery_app/widgets/customButton.dart';
import '../../widgets/fetchProducts.dart';

class Cart extends StatefulWidget {

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final firestoreInstance = FirebaseFirestore.instance;

  void _setData() async {
    firestoreInstance
        .collection("buy-products")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set({
      //  "name" : "john",
      //  "address" : "Ashgabat",
      "address": _textFieldController.text,
      "number": _numberController.text
    }).then((_) {
      print("success!");
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 247, 247),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: customButton('Buy all products', () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Form(
                      key: _formKey,
                      child: AlertDialog(
                        backgroundColor: Color.fromARGB(255, 239, 247, 247),
                        title: Text('Your information'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _textFieldController,
                              decoration: InputDecoration(hintText: "Address"),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Address is empty';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _numberController,
                              decoration:
                                  InputDecoration(hintText: "Phone number"),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Phone number is empty';
                                } else if (text.length < 6) {
                                  return 'Charachter length 6';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.deep_orange),
                            child: Text(
                              'OK',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _setData();
                                FirebaseFirestore.instance
                                    .collection('users-cart-items')
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .delete();
                                _numberController.clear();
                                _textFieldController.clear();
                                Navigator.pop(context);
                                
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            Expanded(child: fetchData("users-cart-items")),
          ],
        ),
      ),
    );
  }

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
}
