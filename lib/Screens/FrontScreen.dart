import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'Home_Page.dart';

class FrontScreen extends StatelessWidget {
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
        child: Stack(
          children: [
            Positioned(
              top: 0.h,
              bottom: 0,
              right: 0,
              left: 0,
              child: Image.asset(
                'assets/images/landing.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.sizeOf(context)
                    .width, // Adjust the width as needed
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: Image.asset(
                'assets/TrvlusLogo.png',
                width: 100.w, // Adjust the width as needed
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 45.h),
                  Image.asset(
                    'assets/images/FlightLogo.png',
                    width: 650.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10.h),
                  // Main Text
                  Text(
                    'Travel Your Way!',
                    style: TextStyle(
                      fontFamily: 'BricolageGrotesque',
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF37023),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Subtext
                  Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      color: Color(0xFF031A40),
                    ),
                  ),
                  SizedBox(height: 65.h),
                  // "Get Started" Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.to(SearchFlightPage());
                        // await ApiService().userAuthenticate();
                        // await ApiService().flightAuthenticate();
                        // await ApiService().authenticate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF37023),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                      ),
                      child: Center(
                        child: Text(
                          "Let's get started",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
