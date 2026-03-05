import 'dart:async';

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
  final num? coupouncode;
  final String? commonPublishedFare;
  final String? tboOfferedFare;
  final double? tboCommission;
  final double? tboTds;
  final double? trvlusCommission;
  final double? trvlusTds;
  final double? othercharges;
  final int? trvlusNetFare;
  final String? mobileNumber;
  final bool? isLLC;
  final bool? islogin;
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
      this.islogin,
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
      this.coupouncode,
      this.commonPublishedFare,
      this.tboOfferedFare,
      this.tboCommission,
      this.tboTds,
      this.trvlusCommission,
      this.trvlusTds,
      this.trvlusNetFare,
      this.othercharges,
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
  int _secondsRemaining = 300; // 5 minutes = 300 seconds
  Timer? _timer;
  bool _isExpired = false;
  bool _isLoading = true;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
    _timer?.cancel();
  }

  Future<void> _verifyOtp() async {
    if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
      String otp = _otpControllers.map((c) => c.text).join();
      print("segmentsJsonsegmentsJson${widget.segmentsJson}");
      print("OTPPPPP$otp");
      // Calling VerifyOTP API
      final verifyOTP =
          await ApiService().otpVerify(widget.mobileNumber ?? "", otp);
      print("VERIFY$verifyOTP");
      print("traceidtraceid${widget.traceid}");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      print(widget.outresultindex);
      print(widget.inresultindex);
      print("hellloo${widget.islogin}");
      if (widget.islogin != false) {
        // Get.to(() => SelectTraveller(
        //       flight: {},
        //       city: widget.city,
        //       destination: widget.destination,
        //       airlineName: widget.airlineName,
        //       airlineCode: widget.airlineCode,
        //       flightNumber: widget.flightNumber,
        //       cityName: widget.cityName,
        //       cityCode: widget.cityCode,
        //       descityName: widget.descityName,
        //       descityCode: widget.descityCode,
        //       depDate: widget.depDate,
        //       depTime: widget.depTime,
        //       arrDate: widget.arrDate,
        //       arrTime: widget.arrTime,
        //       duration: widget.duration,
        //       refundable: widget.refundable,
        //       stop: widget.stop,
        //       airportName: widget.airportName,
        //       desairportName: widget.desairportName,
        //       basefare: widget.basefare,
        //       segments: widget.segments,
        //       resultindex: widget.resultindex,
        //       traceid: widget.traceid,
        //       outboundFlight: widget.outboundFlight,
        //       inboundFlight: widget.inboundFlight,
        //       total: widget.total,
        //       tax: widget.tax,
        //       adultCount: widget.adultCount,
        //       childCount: widget.childCount,
        //       infantCount: widget.infantCount,
        //       isLLC: widget.isLLC,
        //       outdepDate: widget.outdepDate,
        //       outdepTime: widget.outdepTime,
        //       outarrDate: widget.outarrDate,
        //       outarrTime: widget.outarrTime,
        //       indepDate: widget.indepDate,
        //       indepTime: widget.indepTime,
        //       inarrDate: widget.inarrDate,
        //       inarrTime: widget.inarrTime,
        //       outBoundData: widget.outBoundData,
        //       inBoundData: widget.inBoundData,
        //       outresultindex: widget.outresultindex,
        //       inresultindex: widget.inresultindex,
        //       segmentsJson: widget.segmentsJson,
        //       coupouncode: widget.coupouncode,
        //     ));
        Get.offAll(
            () => TravelerDetailsPage(
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
                  coupouncode: widget.coupouncode,
                  commonPublishedFare: widget.commonPublishedFare,
                  tboOfferedFare: widget.tboOfferedFare,
                  tboCommission: widget.tboCommission,
                  tboTds: widget.tboTds,
                  trvlusCommission: widget.trvlusCommission,
                  trvlusTds: widget.trvlusTds,
                  trvlusNetFare: widget.trvlusNetFare,
                  othercharges: widget.othercharges,
                ),
            predicate: (route) =>
                route.settings.name == '/flightDetails' || route.isFirst);
      } else {
        Get.until((route) => route.settings.name == '/ProfilePage');
      }
    } else {
      print("Enter complete OTP");
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
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

  void _startTimer() {
    _isExpired = false;

    _timer?.cancel();
    _secondsRemaining = 300; // reset timer

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isExpired = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    String maskedNumber = maskMobileNumber(widget.mobileNumber ?? "");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ Your full existing UI
          Padding(
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
                  'Otp has been send to your mobile number $maskedNumber',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30.h),

                // 🔥 Your OTP Row (unchanged)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 50.w,
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (RawKeyEvent event) {
                          if (event.runtimeType == RawKeyDownEvent &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.backspace) {
                            if (_otpControllers[index].text.isEmpty &&
                                index > 0) {
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
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (index < _otpControllers.length - 1) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[index + 1]);
                              } else {
                                _focusNodes[index].unfocus();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                Center(
                  child: _isExpired
                      ? GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Text(
                          "OTP expires in ${_formatTime(_secondsRemaining)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                ),

                SizedBox(height: 50.h),

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
                      child: Text(
                        'Verify OTP',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Loader Overlay (Correct Position)
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String maskMobileNumber(String mobile) {
    if (mobile.length <= 3) return mobile;

    String lastThreeDigits = mobile.substring(mobile.length - 3);
    String maskedPart = '*' * (mobile.length - 3);

    return maskedPart + lastThreeDigits;
  }

  Future<void> _resendOtp() async {
    try {
      await ApiService().otpRequest(widget.mobileNumber ?? "");

      // Clear old OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }

      // Restart timer
      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent again")),
      );
    } catch (e) {
      print("Resend error: $e");
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }
}
