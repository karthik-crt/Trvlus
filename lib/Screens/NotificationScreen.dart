import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/api_service.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;

  privacyPolicy() async {
    setState(() {
      isLoading = true;
    });
    await ApiService().privacyPolicy();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    privacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.0.w),
            child: Image.asset(
              "assets/images/Arrow_back.png",
            ),
          ),
        ),
        title: Text(
          "Notification",
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14.sp),
        ),
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/notification.png', height: 60),
            SizedBox(
              height: 10,
            ),
            Text(
              "No Notification",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
