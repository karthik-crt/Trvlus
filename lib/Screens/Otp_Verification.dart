import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'TravelerDetails.dart';

class OtpVerificationScreen extends StatefulWidget {
  final dynamic flight;
  final String city;
  final String destination;

  const OtpVerificationScreen({
    super.key,
    required this.flight,
    required this.city,
    required this.destination,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
      Get.to(() => TravelerDetailsPage(
            flight: const {},
            city: 'mdu',
            destination: 'chennai',
          ));
    } else {
      print("Enter complete OTP");
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _otpControllers.length; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.length == 1 &&
            i < _otpControllers.length - 1) {
          FocusScope.of(context).nextFocus();
        }
      });
    }

    // Optional: Start countdown timer for resend OTP button
    // _startResendOtpTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Image.asset(
              'assets/images/Home_Logo.png',
              width: 120.w,
            ),
            SizedBox(height: 40.h),
            Text(
              'Verify OTP',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please use the mobile number linked with your Aadhaar',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50.w,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    // Required for RawKeyboardListener
                    onKey: (RawKeyEvent event) {
                      if (event.runtimeType == RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.backspace) {
                        if (_otpControllers[index].text.isEmpty && index > 0) {
                          // Clear the previous field and move focus backward
                          _otpControllers[index - 1].clear();
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index - 1]);
                        }
                      }
                    },
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      maxLength: 1,
                      style: TextStyle(
                        color: Colors.black, // <-- Force black OTP text
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < _otpControllers.length - 1) {
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index + 1]);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "Don't receive OTP? Resend in 30 s",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 60.h),
            Center(
              child: SizedBox(
                width: 290.w,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text('Verify OTP',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
