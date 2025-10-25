import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/Screens/Home_Page.dart';
import 'package:trvlus/Screens/customer_support.dart';
import 'package:trvlus/Screens/tearmsandcondition.dart';

import '../models/countrycode.dart';
import '../utils/api_service.dart';
import 'BookingHistory.dart';
import 'EditProfile.dart';
import 'NotificationScreen.dart';
import 'countryCode.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //final AuthController authController = Get.find<AuthController>();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;
  late Countrycode countrycode;

  @override
  void initState() {
    print("Profile PAge");
    super.initState();
    _checkUserId();
    getcountryCodeData();
  }

  getcountryCodeData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    countrycode = await ApiService().countryCode();
    _selectedCountry = prefs.getString('selected_country') ?? "India";
    _selectedcurrency = prefs.getString('selected_currency') ?? "INR";
    print("countrycodecountrycodecountrycode$countrycode");
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _checkUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id'); // use same key you stored
    print("User ID: $userId"); // ✅ Will print correctly
    setState(() {
      _hasUserId = userId != null && userId.isNotEmpty;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  bool isNotificationsEnabled = true;
  bool _hasUserId = false;

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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    toolbarHeight: 280.h,
                    // toolbarHeight: 10.h,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 20.h),
                      background: Center(
                          child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Color(0xFFF8BD91)],
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
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
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
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
                                        // onTap: () {
                                        //   // Open a bottom sheet for camera/gallery choice
                                        //   showModalBottomSheet(
                                        //     context: context,
                                        //     builder: (context) {
                                        //       return Wrap(
                                        //         children: [
                                        //           ListTile(
                                        //             leading:
                                        //                 Icon(Icons.photo_library),
                                        //             title: Text('Pick from Gallery'),
                                        //             onTap: () {
                                        //               Navigator.pop(context);
                                        //               _pickImage(ImageSource.gallery);
                                        //             },
                                        //           ),
                                        //           ListTile(
                                        //             leading: Icon(Icons.camera_alt),
                                        //             title: Text('Take a Photo'),
                                        //             onTap: () {
                                        //               Navigator.pop(context);
                                        //               _pickImage(ImageSource.camera);
                                        //             },
                                        //           ),
                                        //         ],
                                        //       );
                                        //     },
                                        //   );
                                        // },
                                        child: Container(
                                          height: 65.h,
                                          width: 58.w,
                                          child: CircleAvatar(
                                            radius: 25.r,
                                            // backgroundImage: _image != null
                                            //     ? FileImage(_image!) as ImageProvider
                                            //     : AssetImage("assets/profile.png"),
                                            child: Icon(Icons.person),
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
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const countryCode()));
                                    },
                                    child: Text(
                                      "Tessa Vivek",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
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
                                      SizedBox(width: 7.w),
                                      GestureDetector(
                                        onTap: () async {
                                          final selected =
                                              await showModalBottomSheet<
                                                  Map<String, String>>(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return const countryCode(
                                                  type: "country");
                                            },
                                          );

                                          if (selected != null) {
                                            print(
                                                "Selected Country Map: $selected");

                                            setState(() {
                                              _selectedCountry =
                                                  selected["name"]!;
                                              _selectedFlag = selected["flag"]!;
                                              _selectedcurrency = selected[
                                                  "currency"]!; // ✅ updates currency too
                                            });

                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setString(
                                                'selected_country',
                                                _selectedCountry);
                                            await prefs.setString(
                                                'selected_flag', _selectedFlag);
                                            await prefs.setString(
                                                'selected_currency',
                                                _selectedcurrency);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/flag/$_selectedCountry.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              _selectedCountry,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 7.w),
                                      const Text("|"),
                                      SizedBox(width: 8.w),
                                      GestureDetector(
                                        onTap: () async {
                                          final selectedCurrency =
                                              await showModalBottomSheet<
                                                  Map<String, String>>(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return const countryCode(); // type defaults to currency
                                            },
                                          );

                                          if (selectedCurrency != null) {
                                            setState(() {
                                              _selectedCountry = selectedCurrency[
                                                  "name"]!; // optional: if you want country update too
                                              _selectedFlag =
                                                  selectedCurrency["flag"]!;
                                              _selectedcurrency = selectedCurrency[
                                                  "currency"]!; // ✅ extract string
                                            });

                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setString(
                                                'selected_country',
                                                _selectedCountry);
                                            await prefs.setString(
                                                'selected_flag', _selectedFlag);
                                            await prefs.setString(
                                                'selected_currency',
                                                _selectedcurrency);
                                            print(
                                                "Saved selected currency: $_selectedcurrency");
                                          }
                                        },
                                        child: Text(
                                          _selectedcurrency ??
                                              "Select Currency",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Image.asset(
                                          "assets/images/TraingleBlack.png"),
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
                          onTap: () async {
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
                                      builder: (context) =>
                                          NotificationScreen()),
                                );
                              },
                            )
                          ],
                        ),
                        buildListTile("assets/icon/translate.svg", "Language",
                            trailing: "English"),
                        _hasUserId
                            ? GestureDetector(
                                onTap:
                                    _showDeleteDialog, // ✅ Call the confirmation dialog
                                child: buildListTile(
                                  "assets/icon/deleteUser.svg",
                                  "Delete Profile",
                                ),
                              )
                            : SizedBox.shrink(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CustomerSupport()));
                          },
                          child: buildListTile(
                              "assets/icon/contacts.svg", "Help & Support"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Tearmsandcondition()));
                          },
                          child: buildListTile(
                              "assets/icon/T&C.svg", "T&C and Privacy policy"),
                        ),
                        GestureDetector(
                            onTap: () => _onShareXFileFromAssets(context),
                            child: buildListTile(
                                "assets/icon/share.svg", "Share App")),
                        GestureDetector(
                          onTap: () => _showLogoutDialog(),
                          child:
                              buildListTile("assets/icon/logout.svg", "Logout"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Call your delete API
                final response = await ApiService().deleteUser();
                print("Deleted response: $response");

                // Clear SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.of(context).pop(); // Close dialog

                // Navigate to home screen
                Get.offAll(SearchFlightPage());
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Clear SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.of(context).pop(); // Close dialog

                // Navigate to login/home page
                Get.offAll(
                    SearchFlightPage()); // Replace with your login screen
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
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
      leading: SvgPicture.asset(
        imagePath,
        width: 24.w,
        height: 20.h,
        color: Colors.grey,
      ),
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
