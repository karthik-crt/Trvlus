import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trvlus/Screens/DotDivider.dart';
import 'package:trvlus/Screens/EditProfile.dart';
import 'package:trvlus/Screens/Home_Page.dart';
import 'package:trvlus/Screens/customer_support.dart';
import 'package:trvlus/Screens/tearmsandcondition.dart';

import 'BookingHistory.dart';
import 'NotificationScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //final AuthController authController = Get.find<AuthController>();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  bool isNotificationsEnabled = true;

  String _selectedCountry = "India"; // default
  String _selectedFlag = "🇮🇳";
  String _selectedcurrency = "INR ₹";

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
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Open a bottom sheet for camera/gallery choice
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Wrap(
                                          children: [
                                            ListTile(
                                              leading:
                                                  Icon(Icons.photo_library),
                                              title: Text('Pick from Gallery'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImage(ImageSource.gallery);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.camera_alt),
                                              title: Text('Take a Photo'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImage(ImageSource.camera);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 65.h,
                                    width: 58.w,
                                    child: CircleAvatar(
                                      radius: 25.r,
                                      backgroundImage: _image != null
                                          ? FileImage(_image!) as ImageProvider
                                          : AssetImage("assets/profile.png"),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 40.w,
                                  top: 30.h,
                                  child: Image.asset(
                                      "assets/images/EditProfile.png"),
                                ),
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
                              "1234567895",
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.grey),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset("assets/images/Flag.png"),
                                SizedBox(width: 7.w),
                                GestureDetector(
                                  onTap: () async {
                                    final List<Map<String, String>> countries =
                                        [
                                      {"name": "India", "flag": "🇮🇳"},
                                      {"name": "UAE", "flag": "🇦🇪"},
                                      {"name": "UK", "flag": "🇬🇧"},
                                      {"name": "Japan", "flag": "🇯🇵"},
                                      {"name": "Germany", "flag": "🇩🇪"},
                                      {"name": "France", "flag": "🇫🇷"},
                                      {"name": "Canada", "flag": "🇨🇦"},
                                      {"name": "Australia", "flag": "🇦🇺"},
                                    ];

                                    // return full map
                                    final selected = await showModalBottomSheet<
                                        Map<String, String>>(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          height: 400,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Select Country",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.black)),
                                              SizedBox(height: 15),
                                              DotDivider(
                                                color: Colors.grey,
                                                dotSize: 1.5,
                                                dotCount: 90,
                                                spacing: 2.0,
                                              ),
                                              SizedBox(height: 15),
                                              Expanded(
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 25,
                                                    crossAxisSpacing: 15,
                                                    childAspectRatio: 2.5,
                                                  ),
                                                  itemCount: countries.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(
                                                            context,
                                                            countries[
                                                                index]); // return map
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade400),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                countries[index]
                                                                    ["flag"]!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                            SizedBox(width: 8),
                                                            Text(
                                                                countries[index]
                                                                    ["name"]!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    if (selected != null) {
                                      setState(() {
                                        _selectedCountry = selected["name"]!;
                                        _selectedFlag = selected["flag"]!;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "$_selectedFlag $_selectedCountry",
                                    // ✅ both flag + name
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.sp),
                                  ),
                                ),

                                SizedBox(width: 7.w),
                                Text("|"),
                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: () async {
                                    final List<Map<String, String>> countries =
                                        [
                                      {
                                        "flag": "🇮🇳",
                                        "currency": "INR ₹",
                                        "name": "India"
                                      },
                                      {
                                        "flag": "🇦🇪",
                                        "currency": "AED د.إ",
                                        "name": "UAE"
                                      },
                                      // {"flag": "🇬🇧", "currency": "GBP £", "name": "UK"},
                                      // {"flag": "🇯🇵", "currency": "JPY ¥", "name": "Japan"},
                                      // {"flag": "🇩🇪", "currency": "EUR €", "name": "Germany"},
                                      // {"flag": "🇫🇷", "currency": "EUR €", "name": "France"},
                                      // {"flag": "🇨🇦", "currency": "CAD C$", "name": "Canada"},
                                      // {"flag": "🇦🇺", "currency": "AUD A$", "name": "Australia"},
                                      //
                                    ];

                                    // ✅ Await the result
                                    final selected =
                                        await showModalBottomSheet<String>(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          height: 400,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Select Currency",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.black)),
                                              SizedBox(height: 15),
                                              DotDivider(
                                                color: Colors.grey,
                                                dotSize: 1.5,
                                                dotCount: 90,
                                                spacing: 2.0,
                                              ),
                                              SizedBox(height: 15),
                                              Expanded(
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 25,
                                                    crossAxisSpacing: 15,
                                                    childAspectRatio: 2.5,
                                                  ),
                                                  itemCount: countries.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(
                                                            context,
                                                            countries[index][
                                                                "currency"]); // return currency
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade400),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                countries[index]
                                                                    ["flag"]!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                            SizedBox(width: 8),
                                                            Text(
                                                                countries[index]
                                                                    ["name"]!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    // ✅ Update only if user selected something
                                    if (selected != null) {
                                      setState(() {
                                        _selectedcurrency = selected;
                                      });
                                    }
                                  },
                                  child: Text(
                                    _selectedcurrency ?? "Select Currency",
                                    // show selected currency
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.black),
                                  ),
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
                    "assets/icon/booking_history.svg",
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
                        "assets/icon/notification.svg",
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
                  buildListTile("assets/icon/translate.svg", "Language",
                      trailing: "English"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CustomerSupport()));
                    },
                    child: buildListTile(
                        "assets/icon/contacts.svg", "Help & Support"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Tearmsandcondition()));
                    },
                    child: buildListTile(
                        "assets/icon/T&C.svg", "T&C and Privacy policy"),
                  ),
                  GestureDetector(
                      onTap: () => _onShareXFileFromAssets(context),
                      child:
                          buildListTile("assets/icon/share.svg", "Share App")),
                  buildListTile("assets/icon/logout.svg", "Logout")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onShareXFileFromAssets(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    try {
      await Share.share(
        'Check out this awesome app: https://play.google.com/store/apps/details?id=com.example.myapp',
        subject: 'Download this app!',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  ListTile buildListTile(String imagePath, String title,
      {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: SvgPicture.asset(imagePath, width: 24.w, height: 20.h),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'Inter',
            color: Color(0xFF606060),
            fontWeight: FontWeight.bold,
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
