import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trvlus/Screens/EditProfile.dart';
import 'package:trvlus/Screens/Home_Page.dart';

import 'BookingHistory.dart';
import 'NotificationScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //final AuthController authController = Get.find<AuthController>();
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        Get.to(SearchFlightPage());
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              toolbarHeight: 280.h,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
                background: Center(
                    child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFF8BD91)],
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                                Get.to(SearchFlightPage());
                              },
                              child: Icon(Icons.arrow_back_rounded)),
                          const Spacer(),
                          Text(
                            " My Profile",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                                Get.to(SearchFlightPage());
                              },
                              child: Icon(Icons.close)),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 0),
                        decoration: BoxDecoration(
                            /* gradient: LinearGradient(
                        colors: [Colors.orange.shade200, Colors.orange.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),*/
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              //alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height: 65.h,
                                  width: 58.w,
                                  child: CircleAvatar(
                                    radius: 25.r,
                                    backgroundImage: AssetImage(
                                      "assets/profile.png",
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                Positioned(
                                    //bottom: 4.h,
                                    left: 40.w,
                                    top: 30.h,
                                    child: Image.asset(
                                        "assets/images/EditProfile.png"))
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Tessa Vivek",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "987667788",
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.grey),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/Flag.png"),
                                SizedBox(width: 7.w),
                                Text(
                                  "India",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.sp),
                                ),
                                SizedBox(width: 7.w),
                                Text("|"),
                                SizedBox(width: 8.w),
                                Text(
                                  "₹INR",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.black),
                                ),
                                SizedBox(width: 10.w),
                                Image.asset("assets/images/TraingleBlack.png"),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(EditProfilePage());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF37023),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  buildListTile(
                    "assets/images/History.png",
                    "Booking history",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingHistoryPage()),
                      );
                    },
                  ),
                  Column(
                    children: [
                      buildListTile(
                        "assets/images/bell.png",
                        "Notification",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()),
                          );
                        },
                      )
                    ],
                  ),
                  buildListTile("assets/images/translate-2.png", "Language",
                      trailing: "English"),
                  buildListTile(
                      "assets/images/contacts-line.png", "Help & Support"),
                  buildListTile(
                      "assets/images/privacy.png", "T&C and Privacy policy"),
                  buildListTile("assets/images/share.png", "Share App"),
                  buildListTile("assets/images/logout.png", "Logout")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(String imagePath, String title,
      {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Image.asset(imagePath, width: 24.w, height: 24.h),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'Inter',
            color: Color(0xFF606060),
            fontWeight: FontWeight.normal,
            fontSize: 14.sp),
      ),
      trailing: trailing != null
          ? Text(trailing,
              style: TextStyle(
                  color: Color(0xFFF37023),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp))
          : null,
      onTap: onTap,
    );
  }
}
