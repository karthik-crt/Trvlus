import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/search_data.dart';
import '../utils/api_service.dart';
import 'TravelerDetails.dart';

class OtpVerificationScreen extends StatefulWidget {
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
  final String? inresultindex;
  final String? total;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final String? mobileNumber;
  final bool? isLLC;
  final String? outdepDate;
  final String? outdepTime;
  final String? outarrDate;
  final String? outarrTime;
  final String? indepDate;
  final String? indepTime;
  final String? inarrDate;
  final String? inarrTime;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;

  OtpVerificationScreen(
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
      this.stop,
      this.duration,
      this.basefare,
      this.segments,
      this.segmentsJson,
      this.resultindex,
      this.traceid,
      this.outboundFlight,
      this.inboundFlight,
      this.outresultindex,
      this.inresultindex,
      this.total,
      this.tax,
      this.adultCount,
      this.childCount,
      this.infantCount,
      this.mobileNumber,
      this.isLLC,
      this.outdepDate,
      this.outdepTime,
      this.outarrDate,
      this.outarrTime,
      this.indepDate,
      this.indepTime,
      this.inarrDate,
      this.inarrTime});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

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

  Future<void> _verifyOtp() async {
    if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
      String otp = _otpControllers.map((c) => c.text).join();
      print("segmentsJsonsegmentsJson${widget.segmentsJson}");
      // Calling VerifyOTP API
      final verifyOTP =
          await ApiService().otpVerify(widget.mobileNumber ?? "", otp);
      print("VERIFY$verifyOTP");
      print("traceidtraceid${widget.traceid}");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      print(widget.outresultindex);
      print(widget.inresultindex);
      Get.to(() => TravelerDetailsPage(
            flight: {},
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
                6,
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
                        // Move to next field
                        if (value.isNotEmpty &&
                            index < _otpControllers.length - 1) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        }

                        // ✅ Print current field value
                        print("Digit ${index + 1}: $value");

                        // ✅ Print full OTP (joined from all 4 fields)
                        String currentOtp =
                            _otpControllers.map((c) => c.text).join();
                        print("Current OTP: $currentOtp");
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
                // child: Text(
                //   "Don't receive OTP? Resend in 30 s",
                //   style: TextStyle(
                //     fontSize: 14.sp,
                //     color: Colors.grey[600],
                //   ),
                // ),
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
