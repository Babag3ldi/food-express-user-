import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/AppColors.dart';
import '../product_details_screen.dart';
import '../search_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["product-description"],
          "product-price": qn.docs[i]["product-price"],
          "product-img": qn.docs[i]["product-img"],
        });
      }
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width / 100;
    double sizeHeight = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 247, 247),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: TextFormField(
                readOnly: true,
                // decoration: InputDecoration(
                //   fillColor: Colors.white,
                //   focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(0)),
                //       borderSide: BorderSide(color: Colors.blue)),
                //   enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(0)),
                //       borderSide: BorderSide(color: Colors.grey)),
                //   hintText: "Search products here",
                //   hintStyle: TextStyle(fontSize: 15.sp),
                // ),
                decoration: InputDecoration(
                    hintText: "Search Data",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                     borderRadius:
                    BorderRadius.all(Radius.circular(7.0)),
                              ),),
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => SearchScreen())),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: ListView(
                children: [
                  
                        AspectRatio(
                          aspectRatio: 2.5,
                          child: CarouselSlider(
                              items: _carouselImages
                                  .map((item) => Padding(
                                        padding: const EdgeInsets.only(left: 3, right: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(item),
                                                  fit: BoxFit.fitWidth)),
                                        ),
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.8,
                                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                                  onPageChanged: (val, carouselPageChangedReason) {
                                    setState(() {
                                      _dotPosition = val;
                                    });
                                  })),
                        ),
                        
                    SizedBox(
                      height: 10.h,
                    ),
                    DotsIndicator(
                      dotsCount:
                          _carouselImages.length == 0 ? 1 : _carouselImages.length,
                      position: _dotPosition.toDouble(),
                      decorator: DotsDecorator(
                        activeColor: AppColors.deep_orange,
                        color: AppColors.deep_orange.withOpacity(0.5),
                        spacing: EdgeInsets.all(2),
                        activeSize: Size(8, 8),
                        size: Size(6, 6),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _products.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetails(_products[index])));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Image.network(
                                            _products[index]["product-img"][0],
                                            height: 130.0,
                                            width: 190.0,
                                          )),
                                    ),
                                    // SizedBox(
                                    //   height: 10.h,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${_products[index]["product-name"]}",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Container(
                                      height: sizeHeight*5,
                                      width: sizeWidth*42,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 239, 247, 247),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                            "${_products[index]["product-price"].toString()} TMT", style: TextStyle(fontSize: 20),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
