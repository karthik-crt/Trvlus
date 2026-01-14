import 'dart:convert';
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

import '../models/countrycode.dart';
import '../models/getprofile.dart';
import '../utils/api_service.dart';
import 'BookingHistory.dart';
import 'EditProfile.dart';
import 'Mobile_Verification.dart';
import 'NotificationScreen.dart';
import 'countryCode.dart';
import 'legal.dart';

class ProfilePage extends StatefulWidget {
  final bool? islogin;

  ProfilePage({super.key, this.islogin});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //final AuthController authController = Get.find<AuthController>();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool isImageLoading = false;

  late Countrycode countrycode;
  late Getprofile profile;

  bool _hasUserId = false;
  bool isNotificationsEnabled = true;

  String _selectedCountry = "India";
  String _selectedFlag = "🇮🇳";
  String _selectedcurrency = "INR ₹";

  @override
  void initState() {
    super.initState();
    _checkUserId();
    getcountryCodeData();
    userprofileupdation(true);
  }

  Future<void> _checkUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print("userId$userId");

    setState(() {
      _hasUserId = userId != null && userId.isNotEmpty;
    });
  }

  userprofileupdation(load) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null || userId.isEmpty) return;

    setState(() => isLoading = load);
    try {
      profile = await ApiService().getprofileupdate(userId);
      print("profileget${jsonEncode(profile)}");
    } catch (e) {
      print("Profile API error: $e");
    }
    setState(() => isLoading = false);
  }

  // String getProfileImageUrl(String? url) {
  //   if (url == null || url.isEmpty) return "";
  //
  //   // If the URL already starts with http, return as is
  //   if (url.startsWith("http")) return url;
  //
  //   // Otherwise, add your backend base URL
  //   return "http://192.168.0.4:8000/api/$url";
  // }

  Future<void> _pickImage(ImageSource source) async {
    if (!_hasUserId) return;

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      final uploadResult =
          await ApiService().userprofileupdate(userId!, _image!.path);
      userprofileupdation(false);

      final serverImageUrl = uploadResult.data?.userImages;

      // if (serverImageUrl != null) {
      //   setState(() {
      //     profile.data.userImage = serverImageUrl;
      //   });
      // }

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile photo updated')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  getcountryCodeData() async {
    final prefs = await SharedPreferences.getInstance();
    countrycode = (await ApiService().countryCode())!;
    _selectedCountry = prefs.getString('selected_country') ?? "India";
    _selectedcurrency = prefs.getString('selected_currency') ?? "INR";
  }

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
                child: CircularProgressIndicator(
                  color: Colors.deepOrange,
                ),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    toolbarHeight: _hasUserId ? 280.h : 220.h,
                    // toolbarHeight: 60.h,
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
                                // GestureDetector(
                                //     onTap: () {
                                //       Get.back();
                                //       Get.to(SearchFlightPage());
                                //     },
                                //     child: Icon(Icons.close)),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (_hasUserId) ...[
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
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Wrap(
                                                  children: [
                                                    ListTile(
                                                      leading: Icon(
                                                          Icons.photo_library),
                                                      title: Text(
                                                          'Pick from Gallery'),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        _pickImage(ImageSource
                                                            .gallery);
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                          Icons.camera_alt),
                                                      title:
                                                          Text('Take a Photo'),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        _pickImage(
                                                            ImageSource.camera);
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
                                            child: profile.data.userImages != ""
                                                ? CircleAvatar(
                                                    radius: 25.r,
                                                    backgroundImage:
                                                        NetworkImage(profile
                                                            .data.userImages),
                                                  )
                                                : CircleAvatar(
                                                    radius: 25.r,
                                                    child: Icon(Icons.person),
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
                                      "${profile.data.firstName} ${profile.data.lastName}",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      profile.data.mobile,
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey),
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 7.w),
                                        GestureDetector(
                                          onTap: () async {
                                            final selected =
                                                await showModalBottomSheet<
                                                    Map<String, String>>(
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
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
                                                _selectedFlag =
                                                    selected["flag"]!;
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
                                                  'selected_flag',
                                                  _selectedFlag);
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
                                              shape:
                                                  const RoundedRectangleBorder(
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
                                                _selectedcurrency =
                                                    selectedCurrency[
                                                        "currency"]!; // ✅ extract string
                                              });

                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.setString(
                                                  'selected_country',
                                                  _selectedCountry);
                                              await prefs.setString(
                                                  'selected_flag',
                                                  _selectedFlag);
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
                                      onPressed: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final userId =
                                            prefs.getString('user_id');
                                        await Get.to(EditProfilePage());
                                        profile = await ApiService()
                                            .getprofileupdate(userId);
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFF37023),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                            ] else ...[
                              const CircleAvatar(
                                radius: 35,
                                child: Icon(Icons.person, size: 40),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Guest User",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  await Get.to(MobileVerificationScreen(
                                      flight: '',
                                      city: '',
                                      destination: '',
                                      airlineName: '',
                                      airlineCode: '',
                                      flightNumber: '',
                                      cityName: '',
                                      cityCode: '',
                                      descityName: '',
                                      descityCode: '',
                                      depDate: '',
                                      depTime: '',
                                      arrDate: '',
                                      arrTime: '',
                                      duration: '',
                                      refundable: '',
                                      stop: '',
                                      airportName: '',
                                      desairportName: '',
                                      basefare: 0,
                                      segments: [],
                                      resultindex: '',
                                      traceid: '',
                                      total: '',
                                      tax: 0,
                                      adultCount: 0,
                                      childCount: 0,
                                      infantCount: 0,
                                      // BY GOPAL
                                      isLLC: false,
                                      outdepDate: '',
                                      outdepTime: '',
                                      outarrDate: '',
                                      outarrTime: '',
                                      indepDate: '',
                                      indepTime: '',
                                      inarrDate: '',
                                      inarrTime: '',
                                      outBoundData: {},
                                      inBoundData: {},
                                      outresultindex: '',
                                      inresultindex: '',
                                      segmentsJson: [],
                                      islogin: false));
                                  _checkUserId();
                                  userprofileupdation(true);
                                },
                                child: const Text("Login Account"),
                              ),
                            ],
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
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => Tearmsandcondition(),
                        //       ),
                        //     );
                        //   },
                        //   child: buildListTile("assets/icon/T&C.svg", "T&C"),
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => PrivacyPolicyScreen(),
                        //       ),
                        //     );
                        //   },
                        //   child: buildListTile(
                        //     "assets/icon/privacypolicy.svg",
                        //     "Privacy Policy",
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => Refundpolicy(),
                        //       ),
                        //     );
                        //   },
                        //   child: buildListTile(
                        //       "assets/icon/refundpolicy.svg", "Refund Policy"),
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Legal(),
                              ),
                            );
                          },
                          child: buildListTile(
                              "assets/icon/legalpolicy.svg", "Legal Policy"),
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
        'Check out this awesome app: https://play.google.com/store/apps/details?id=com.booking.trvlus',
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
