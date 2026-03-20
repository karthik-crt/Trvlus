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
  String _statusMessage = "";

  @override
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () async {
      final prefs = await SharedPreferences.getInstance();
      final bool isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

      if (isFirstLaunch) {
        // First time → Show FrontScreen
        Get.to(
          FrontScreen(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
      } else {
        // Already launched before → Go directly to SearchFlightPage
        Get.to(
          SearchFlightPage(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
      }
    });

    _checkAndCallApiOnStart();
  }

  Future<bool> shouldCallApi() async {
    final prefs = await SharedPreferences.getInstance();

    String? lastDate = prefs.getString("token_date");
    String today = DateTime.now().toString().substring(0, 10);

    return lastDate != today;
  }

  Future<void> callApiOnceDailyManually() async {
    final prefs = await SharedPreferences.getInstance();
    const String key = 'lastApiCallTime';

    if (await shouldCallApi()) {
      String? authenticateData =
          await ApiService().flightAuthenticate(); // Call the API

      print("authenticateData: $authenticateData");

      // ✅ Only save date if token was actually received
      if (authenticateData != null && authenticateData.isNotEmpty) {
        await prefs.setString('tokenId', authenticateData);
        await prefs.setString(
            "token_date", DateTime.now().toString().substring(0, 10));
        print("TokenId saved: $authenticateData");
        print("Token date saved");
      } else {
        print("❌ Token was null - date NOT saved, will retry tomorrow");
      }
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
