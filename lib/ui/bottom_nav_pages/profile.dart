import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/AppColors.dart';
import '../../widgets/customButton.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;
  TextEditingController? _dobController;

  setDataToTextField(data) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Padding(
                padding: EdgeInsets.only(left: 15, right: 5, top: 13),
                child: Text(
                  'Name: ',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 92, 91, 91)),
                )),
          ),
          style: TextStyle(fontSize: 20),
          controller: _nameController =
              TextEditingController(text: data['name']),
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Padding(
                padding: EdgeInsets.only(left: 15, right: 5, top: 13),
                child: Text(
                  'Number: ',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 92, 91, 91)),
                )),
          ),
          style: TextStyle(fontSize: 20),
          controller: _phoneController =
              TextEditingController(text: data['phone']),
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Padding(
                padding: EdgeInsets.only(left: 15, right: 5, top: 13),
                child: Text(
                  'Age: ',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 92, 91, 91)),
                )),
          ),
          style: TextStyle(fontSize: 20),
          controller: _ageController = TextEditingController(text: data['age']),
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Padding(
                padding: EdgeInsets.only(left: 15, right: 5, top: 13),
                child: Text(
                  'Birthday: ',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 92, 91, 91)),
                )),
          ),
          style: TextStyle(fontSize: 20),
          controller: _dobController = TextEditingController(text: data['dob']),
        ),
        SizedBox(height: 30.h,),
        customButton("Update", (){updateData();},),
      ],
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
      "dob": _dobController!.text,
    }).then((value) => print("Updated Successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 247, 247),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.deep_orange,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 80,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users-form-data")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                var data = snapshot.data;
                if (data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return setDataToTextField(data);
              },
            ),
          ),
          // Padding(
          //     padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
          //     child: Container(
          //       height: 70.h,
          //       decoration: const BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //       ),
          //       child: const CircleAvatar(child: Icon(Icons.person))
          //     ),
          //   ),
        ],
      )),
    );
  }
}
