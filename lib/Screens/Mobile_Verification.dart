import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../models/search_data.dart';
import '../utils/api_service.dart';
import 'Otp_Verification.dart';

class MobileVerificationScreen extends StatefulWidget {
  final dynamic flight;
  final String city;
  final String destination;
  final String airlineName;
  final String cityName;
  final String cityCode;
  final String? flightNumber;
  final String? depDate;
  final String? depTime;
  final String? refundable;
  final String? arrDate;
  final String? arrTime;
  final String? descityName;
  final String? descityCode;
  final String? airlineCode;
  final String? stop;
  final String? duration;
  final String? airportName;
  final String? desairportName;
  final double? basefare;
  final double? tax;
  final List<List<Segment>>? segments;
  final List<Map<String, dynamic>>? segmentsJson; // 4th page uses this
  final String? resultindex;
  final String? traceid;
  final Result? outboundFlight;
  final Result? inboundFlight;
  final String? outresultindex;
  final String? outdepDate;
  final String? outdepTime;
  final String? outarrDate;
  final String? outarrTime;
  final String? indepDate;
  final String? indepTime;
  final String? inarrDate;
  final String? inarrTime;
  final String? inresultindex;
  final String? total;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final int? coupouncode;
  final String? commonPublishedFare;
  final String? tboOfferedFare;
  final double? tboCommission;
  final double? tboTds;
  final double? trvlusCommission;
  final double? trvlusTds;
  final int? trvlusNetFare;
  final bool? isLLC;
  final bool? islogin;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;

  MobileVerificationScreen(
      {super.key,
      required this.flight,
      required this.outBoundData,
      required this.inBoundData,
      required this.city,
      required this.destination,
      required this.airlineName,
      required this.cityName,
      required this.cityCode,
      this.airlineCode,
      this.airportName,
      this.desairportName,
      this.flightNumber,
      this.depDate,
      this.depTime,
      this.refundable,
      this.arrDate,
      this.arrTime,
      this.descityName,
      this.descityCode,
      this.duration,
      this.basefare,
      this.segments,
      this.segmentsJson,
      this.resultindex,
      this.traceid,
      this.outboundFlight,
      this.inboundFlight,
      this.total,
      this.tax,
      this.outresultindex,
      this.inresultindex,
      this.stop,
      this.adultCount,
      this.childCount,
      this.infantCount,
      this.coupouncode,
      this.commonPublishedFare,
      this.tboOfferedFare,
      this.tboCommission,
      this.tboTds,
      this.trvlusCommission,
      this.trvlusTds,
      this.trvlusNetFare,
      this.isLLC,
      this.outdepDate,
      this.outdepTime,
      this.outarrDate,
      this.outarrTime,
      this.indepDate,
      this.indepTime,
      this.inarrDate,
      this.inarrTime,
      this.islogin});

  @override
  _MobileVerificationScreenState createState() =>
      _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController _mobileController = TextEditingController();
  Country? _selectedCountry;

  final RegExp _mobileRegex = RegExp(r'^[1-9]\d{9}$');
  String enteredMobileNumber = '';

  final FocusNode _mobileFocus = FocusNode();

  @override
  void initState() {
    var ell = widget.airlineName;
    print("segmentsJsonsegmentsJson${widget.segmentsJson}");

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
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_mobileFocus);
    });
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
              "Verify Mobile",
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
              print("errorText$errorText");
              print("traceidtraceid${widget.traceid}");

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
                        border:
                            Border.all(color: Colors.grey[300]!, width: 1.0),
                      ),
                      child: TextFormField(
                        focusNode: _mobileFocus,
                        controller: _mobileController,
                        validator: (value) {
                          if (value != null && !_mobileRegex.hasMatch(value)) {
                            return 'Enter a valid 10-digit Indian mobile number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          authController.setMobileNumber(value.trim());
                          setState(() {
                            enteredMobileNumber = value.trim();
                            if (value.length == 10) {
                              _mobileFocus.unfocus(); // removes cursor
                            }
                          });
                          print("Entered mobile number: $enteredMobileNumber");
                          print(widget.outresultindex);
                          print(widget.inresultindex);
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 15.h,
                          ),
                          fillColor: Colors.white,
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
                      ? () async {
                          await ApiService().otpRequest(enteredMobileNumber);
                          print(
                              "Final entered mobile: ${authController.mobileNumber.value}");
                          print(widget.outresultindex);
                          print(widget.inresultindex);
                          Get.to(() => OtpVerificationScreen(
                                flight: {},
                                mobileNumber: enteredMobileNumber,
                                city: widget.city,
                                destination: widget.destination,
                                airlineName: widget.airlineName,
                                airlineCode: widget.airlineCode,
                                flightNumber: widget.flightNumber,
                                cityName: widget.cityName,
                                cityCode: widget.cityCode,
                                descityName: widget.descityName,
                                descityCode: widget.descityCode,
                                depDate: widget.depDate,
                                depTime: widget.depTime,
                                arrDate: widget.arrDate,
                                arrTime: widget.arrTime,
                                duration: widget.duration,
                                refundable: widget.refundable,
                                stop: widget.stop,
                                airportName: widget.airportName,
                                desairportName: widget.desairportName,
                                basefare: widget.basefare,
                                segments: widget.segments,
                                resultindex: widget.resultindex,
                                traceid: widget.traceid,
                                outboundFlight: widget.outboundFlight,
                                inboundFlight: widget.inboundFlight,
                                total: widget.total,
                                tax: widget.tax,
                                adultCount: widget.adultCount,
                                childCount: widget.childCount,
                                infantCount: widget.infantCount,
                                isLLC: widget.isLLC,
                                outdepDate: widget.outdepDate,
                                outdepTime: widget.outdepTime,
                                outarrDate: widget.outarrDate,
                                outarrTime: widget.outarrTime,
                                indepDate: widget.indepDate,
                                indepTime: widget.indepTime,
                                inarrDate: widget.inarrDate,
                                inarrTime: widget.inarrTime,
                                outBoundData: widget.outBoundData,
                                inBoundData: widget.inBoundData,
                                outresultindex: widget.outresultindex,
                                inresultindex: widget.inresultindex,
                                segmentsJson: widget.segmentsJson,
                                islogin: widget.islogin,
                                coupouncode: widget.coupouncode,
                                commonPublishedFare: widget.commonPublishedFare,
                                tboOfferedFare: widget.tboOfferedFare,
                                tboCommission: widget.tboCommission,
                                tboTds: widget.tboTds,
                                trvlusCommission: widget.trvlusCommission,
                                trvlusTds: widget.trvlusTds,
                                trvlusNetFare: widget.trvlusNetFare,
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
