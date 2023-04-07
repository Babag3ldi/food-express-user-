import 'dart:async';

import 'package:food_delivery_app/const/AppColors.dart';
import 'package:food_delivery_app/ui/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => LoginScreen())));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Text("Food", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 44.sp),),
            Text("Express", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 34.sp),),
            SizedBox(height: 340.h,),
            CircularProgressIndicator(color: Colors.white,),
          ]),
        ),
      ),
    );
  }
}