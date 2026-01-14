import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPopup extends StatefulWidget {
  @override
  _LoginPopupState createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  bool _isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        width: 350.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Login / OTP Verification",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            SizedBox(height: 20.h),

            // Mobile number input
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Mobile Number",
                prefixIcon: Icon(Icons.phone_android, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // OTP input (visible after sending OTP)
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  prefixIcon: Icon(Icons.lock, color: Colors.orange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            SizedBox(height: 20.h),

            // Send OTP / Verify button
            ElevatedButton(
              onPressed: () {
                if (!_isOtpSent) {
                  // Trigger OTP API
                  setState(() {
                    _isOtpSent = true;
                  });
                  // You can call your API here
                  print("Send OTP to ${_mobileController.text}");
                } else {
                  // Verify OTP API
                  print("Verify OTP ${_otpController.text}");
                  // Close popup after successful login
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                _isOtpSent ? "Verify OTP" : "Send OTP",
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),

            SizedBox(height: 10.h),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage Example:
// showDialog(context: context, builder: (_) => LoginPopup());
