import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  int a = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage("assets/images/Wallet_Card.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          "Wallet Balance",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14.sp,
          ),
        ),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 450.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        "assets/images/Wallet_Card.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.w,
                    top: 15.h,
                    child: Text(
                      "Trvlus balance",
                      style: TextStyle(
                        color: Color(0xFF606060),
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.w,
                    top: 50.h,
                    child: Text(
                      "₹ $a",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26.sp,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.w,
                    top: 40.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF37023),
                      ),
                      child: Text("Add Amount"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Wallet is empty",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
