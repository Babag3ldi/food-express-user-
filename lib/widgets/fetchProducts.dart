import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/const/AppColors.dart';

Widget fetchData(String collectionName) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection(collectionName)
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Center(
          child: Text("Something is wrong"),
        );
      }

      return ListView.builder(
          itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
          itemBuilder: (_, index) {
            DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];

            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
              child: Container(
                height: 90.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Center(
                  child: ListTile(
                    leading: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10), // Image border
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(40),
                            child: Image.network(
                              "${_documentSnapshot['images'][1]}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    title: Text(_documentSnapshot['name'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      "${_documentSnapshot['price']} TMT",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    trailing: GestureDetector(
                      child: const CircleAvatar(
                        backgroundColor: AppColors.deep_orange,
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection(collectionName)
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .collection("items")
                            .doc(_documentSnapshot.id)
                            .delete();
                      },
                    ),
                  ),
                ),
              ),
            );
          });
    },
  );
}
