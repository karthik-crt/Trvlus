import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/Screens/FrontScreen.dart';

import '../utils/api_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      Get.to(
        FrontScreen(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 600),
      );
    });

    _checkAndCallApiOnStart();
  }

  Future<bool> shouldCallApi() async {
    final prefs = await SharedPreferences.getInstance();
    const String key = 'lastApiCallTime';

    final int? lastCallTime = prefs.getInt(key);
    final int now = DateTime.now().millisecondsSinceEpoch;
    const int oneDayInMillis = 24 * 60 * 60 * 1000;

    return lastCallTime == null || (now - lastCallTime) >= oneDayInMillis;
  }

  Future<void> callApiOnceDailyManually() async {
    final prefs = await SharedPreferences.getInstance();
    const String key = 'lastApiCallTime';

    if (await shouldCallApi()) {
      String? authenticateData =
          await ApiService().flightAuthenticate(); // Call the API
      // await ApiService().userAuthenticate();

      ///For GEtting agent token
      print("authenticateData: $authenticateData");

      await prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);

      // Parse JSON and save TokenId

      await prefs.setString('tokenId', authenticateData ?? "");
      print("TokenId saved: $authenticateData");

      print("API called and timestamp updated.");
    } else {
      print("API not called - less than 24 hours since last call.");
    }
  }

  Future<void> _checkAndCallApiOnStart() async {
    final prefs = await SharedPreferences.getInstance();
    print("TokenId saved: ${prefs.getString('tokenId')}");
    await callApiOnceDailyManually();
    setState(() {
      _statusMessage = "Checked on start. See console for details.";
    });
  }

  Future<void> _manualApiCall() async {
    await callApiOnceDailyManually();
    setState(() {
      _statusMessage = "API call attempted. Check console for result.";
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
              Colors.white,
              Color(0xFFFFE4D4),
              Color(0xFFF8BD91),
            ],
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
