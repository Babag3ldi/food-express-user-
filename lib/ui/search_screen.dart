import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintText: "Search Data",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                     borderRadius:
                    BorderRadius.all(Radius.circular(7.0)),
                              ),),
                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .where("product-name",
                              isGreaterThanOrEqualTo: inputText)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading"),
                          );
                        }

                        return ListView(
                          children: snapshot.data!.docs.map((
                            DocumentSnapshot document,
                          ) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ProductDetails(data)));
                                },
                                child: Container(
                                  height: 90.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      leading: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), // Image border
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(40),
                                              child: Image.network(
                                                "${data['product-img'][0]}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )),
                                      title: Text(data['product-name'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500)),
                                      subtitle: Text(
                                        "${data['product-price']} TMT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            // Card(
                            //   elevation: 5,
                            //   child: ListTile(
                            //     title: Text(data['product-name']),
                            //     leading: Image.network(data['product-img'][0]),
                            //   ),
                            // );
                          }).toList(),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
