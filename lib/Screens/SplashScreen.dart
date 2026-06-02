import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/Screens/FrontScreen.dart';

import '../utils/api_service.dart';
import 'Home_Page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _authenticate();
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      Get.to(
        () => FrontScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(seconds: 1),
      );
    } else {
      Get.to(
        () => SearchFlightPage(),
        transition: Transition.rightToLeft,
        duration: const Duration(seconds: 1),
      );
    }
  }

  // Future<void> dialog(String errorMessage, Color color) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             "Token Check",
  //             style: TextStyle(color: Colors.red),
  //           ),
  //           content: Text(
  //             errorMessage,
  //             style: TextStyle(color: color),
  //           ),
  //           actions: [
  //             ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("Ok"))
  //           ],
  //         );
  //       });
  // }

  Future<void> _authenticate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedDate = prefs.getString('token_date');
    final String todayDate = DateTime.now().toIso8601String().substring(0, 10);

    // if (storedDate == todayDate) {
    //   print("✅ Token already valid for today");
    //   return;
    // }

    try {
      String? token = await ApiService().flightAuthenticate();
      // ✅ Always show dialog with token (success)
      // await dialog("✅ Token Generated:\n\n${token ?? 'No token received'}",
      //     Colors.green);
    } catch (e) {
      // ❌ Show dialog with error
      // await dialog("❌ Auth Failed:\n\n${e.toString()}", Colors.red);
      print("❌ Auth error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFE4D4), Color(0xFFF8BD91)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/Trvlus_Logo.png',
            width: MediaQuery.sizeOf(context).width,
          ),
        ),
      ),
    );
  }
}
