import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import 'Otp_Verification.dart';

class MobileVerificationScreen extends StatefulWidget {
  const MobileVerificationScreen(
      {Key? key,
      required Map<String, dynamic> flight,
      required String city,
      required String destination})
      : super(key: key);

  @override
  _MobileVerificationScreenState createState() =>
      _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController _mobileController = TextEditingController();
  Country? _selectedCountry;

  final RegExp _mobileRegex =
      RegExp(r'^[1-9]\d{9}$'); // Validate 10-digit Indian mobile numbers

  @override
  void initState() {
    super.initState();
    // Manually set default country to India
    _selectedCountry = Country(
      phoneCode: '91',
      countryCode: 'IN',
      e164Key: '+91-IN',
      e164Sc: 0,
      name: 'India',
      geographic: true,
      level: 1,
      example: '',
      displayName: '',
      displayNameNoCountryCode: '',
    );
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          authController.setMobileNumber(
            '+${country.phoneCode} ${authController.mobileNumber.value.replaceFirst(RegExp(r'^\+\d+\s?'), '')}',
          );
          print("selected country");
          print(_selectedCountry);
        });
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
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
              'Verify Mobile',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Please use the mobile number linked\nwith your Aadhaar',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30.h),
            Obx(() {
              String errorText =
                  _mobileRegex.hasMatch(authController.mobileNumber.value)
                      ? ''
                      : 'Enter a valid 10-digit Indian mobile number';

              return Row(
                children: [
                  GestureDetector(
                    onTap: _openCountryPicker,
                    child: Container(
                      width: 120.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Country Code"),
                              SizedBox(height: 5.h),
                              if (_selectedCountry != null)
                                Text(
                                  '${_selectedCountry!.flagEmoji} +${_selectedCountry!.phoneCode}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              SizedBox(width: 5.w),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Icon(Icons.expand_more,
                                color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextFormField(
                        controller: _mobileController,
                        validator: (value) {
                          if (value != null && !_mobileRegex.hasMatch(value)) {
                            return 'Enter a valid 10-digit Indian mobile number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          authController.setMobileNumber(value.trim());
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 15.h,
                          ),
                          hintText: 'Mobile number',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.check_circle,
                            color: _mobileRegex
                                    .hasMatch(authController.mobileNumber.value)
                                ? Colors.green
                                : Colors.grey[300],
                            size: 20.sp,
                          ),
                          counterText: '',
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                      ),
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 80.h),
            Center(
              child: Obx(() {
                bool isMobileValid =
                    _mobileRegex.hasMatch(authController.mobileNumber.value);

                return ElevatedButton(
                  onPressed: isMobileValid
                      ? () {
                          Get.to(() => const OtpVerificationScreen(
                                flight: 'AirIndia',
                                city: 'mdu',
                                destination: 'chennai',
                              ));
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isMobileValid ? Colors.orange : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 120.w),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: isMobileValid ? Colors.white : Colors.grey[500],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
