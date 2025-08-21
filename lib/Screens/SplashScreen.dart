import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trvlus/Screens/FrontScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      //systemNavigationBarColor: Colors.white,
    ));
    Timer(Duration(seconds: 5), () {
      Get.to(
        FrontScreen(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 600), // Smooth transition
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // Top: pure white
              Color(0xFFFFE4D4), // Middle: light shade of primary color
              Color(0xFFF8BD91), // Bottom: primary color
            ],
            //stops: [0.0, 0.5, 1.0], // Define gradient stops
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset('assets/images/Trvlus_Logo.png',
              width:
                  MediaQuery.sizeOf(context).width // Adjust the width as needed
              ),
        ),
      ),
    );
  }
}
