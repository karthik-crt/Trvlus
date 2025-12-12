import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/Screens/price_alert_controller.dart';

import '../models/farequote.dart' as farequote;
import '../models/search_data.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';
import 'ShowModelSheet.dart';
import 'ViewFullDetails.dart';
import 'afterPayment.dart';

String finaldepDateformat = '';
String finalarrDateformat = '';
double totalFare = 0;

class MakePaymentScreen extends StatefulWidget {
  final Map<String, dynamic> flight;
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
  final List<Map<String, dynamic>>? initialData;
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
  final bool? isLLC;
  final List<Map<String, dynamic>>? passenger;
  final List<Map<String, dynamic>>? childpassenger;
  final List<Map<String, dynamic>>? infantpassenger;
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
  Map<String, dynamic> meal;

  MakePaymentScreen(
      {required this.flight,
      required this.outBoundData,
      required this.inBoundData,
      required this.city,
      required this.destination,
      required this.airlineName,
      required this.cityName,
      required this.cityCode,
      required this.meal,
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
      this.initialData,
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
      this.passenger,
      this.childpassenger,
      this.infantpassenger,
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
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  String selectedPaymentMethod = 'Google Pay';
  final TextEditingController _cardNumberController = TextEditingController();
  late farequote.FareQuotesData fareQuote;
  late farequote.FareQuotesData infareQuote;
  bool isLoading = true;
  double totalBaseFare = 0;
  double totalTax = 0;
  double overallFare = 0;
  double inbaseFare = 0;
  double intax = 0;
  int totaladultCount = 0;
  int totalchildCount = 0;
  int totalinfantCount = 0;
  double adultFare = 0;
  double childFare = 0;
  double infantFare = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfarequotedata();
  }

  getfarequotedata() async {
    setState(() {
      isLoading = true;
    });
    if (widget.outBoundData['outresultindex'] != null &&
        widget.inBoundData['inresultindex'] != null) {
      print(widget.outresultindex);
      fareQuote = await ApiService().farequote(
          widget.outBoundData['outresultindex'] ?? "", widget.traceid ?? "");
      infareQuote = await ApiService().farequote(
          widget.inBoundData['inresultindex'] ?? "", widget.traceid ?? "");
    } else {
      print("ONEWAYfareQuote");
      fareQuote = await ApiService()
          .farequote(widget.resultindex ?? "", widget.traceid ?? "");
      // PRICEALERT
      var farequote = fareQuote.response.results.fare.publishedFare;
      print("farequotefarequote$farequote");
      var isPriceChanged = fareQuote.response.isPriceChanged;
      print("isPriceChangedisPriceChanged$isPriceChanged");

      Get.find<PriceAlertController>().checkFare(
        farequote,
        isPriceChanged,
      );
    }
    // FARECALCULATION
    final fareBreakdown = fareQuote.response.results.fareBreakdown;
    print("fareBreakdownfareBreakdown${jsonEncode(fareBreakdown)}");
    final baseFare = fareQuote.response.results.fare.baseFare;
    final tax = fareQuote.response.results.fare.tax.toDouble();

    double adultBase = 0, adultTax = 0;
    double childBase = 0, childTax = 0;
    double infantBase = 0, infantTax = 0;
    int adultCount = 0, childCount = 0;
    int infantCount = 0;
    // INBOUNDFARE
    double inadultBase = 0, inadultTax = 0;
    double inchildBase = 0, inchildTax = 0;
    double ininfantBase = 0, ininfantTax = 0;
    int inadultCount = 0, inchildCount = 0;
    int ininfantCount = 0;

    for (var item in fareBreakdown) {
      if (item.passengerType == 1) {
        adultBase = item.baseFare.toDouble();
        adultTax = item.tax.toDouble();
        adultCount = item.passengerCount.toInt();
      } else if (item.passengerType == 2) {
        childBase = item.baseFare.toDouble();
        childTax = item.tax.toDouble();
        childCount = item.passengerCount.toInt();
      } else if (item.passengerType == 3) {
        infantBase = item.baseFare.toDouble();
        infantTax = item.tax.toDouble();
        infantCount = item.passengerCount.toInt();
      }
    }
    // INBOUNDFARE
    if (widget.inBoundData['inresultindex'] != null) {
      final infareBreakdown = infareQuote.response.results.fareBreakdown;
      print("infareBreakdownfareBreakdown${jsonEncode(infareBreakdown)}");
      inbaseFare = infareQuote.response.results.fare.baseFare;
      print("inbaseFare$inbaseFare");
      intax = infareQuote.response.results.fare.tax.toDouble();
      for (var item in infareBreakdown) {
        if (item.passengerType == 1) {
          inadultBase = item.baseFare.toDouble();
          inadultTax = item.tax.toDouble();
          inadultCount = item.passengerCount.toInt();
        } else if (item.passengerType == 2) {
          inchildBase = item.baseFare.toDouble();
          inchildTax = item.tax.toDouble();
          inchildCount = item.passengerCount.toInt();
        } else if (item.passengerType == 3) {
          ininfantBase = item.baseFare.toDouble();
          ininfantTax = item.tax.toDouble();
          ininfantCount = item.passengerCount.toInt();
        }
      }
    }
    setState(() {
      isLoading = false;
      totalBaseFare = baseFare + inbaseFare;
      print("totalFare$totalFare");
      totalTax = tax + intax;
      print("totalTax$totalTax");
      overallFare = totalBaseFare + totalTax;
      totaladultCount = adultCount + inadultCount;
      totalchildCount = childCount + inchildCount;
      totalinfantCount = infantCount + ininfantCount;
      adultFare = adultBase + inadultBase;
      childFare = childBase + inchildBase;
      infantFare = infantBase + ininfantBase;
      print("overallFare$overallFare");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("PAYMENT");
    print("segmentsJson${widget.segmentsJson}");
    final flight = widget.flight;
    final city = widget.city;
    final destination = widget.destination;
    final passenger = widget.flightNumber ?? "";

    if (widget.depDate != null) {
      final depDateformat = widget.depDate;
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(depDateformat!);
      final finaldepDateformat = DateFormat("EEE,dd MMM yy").format(parsedDate);

      final arrDateformat = widget.arrDate;
      DateTime arrparsedDate = DateFormat("yyyy-MM-dd").parse(arrDateformat!);
      final finalarrDateformat =
          DateFormat("EEE,dd MMM yy").format(arrparsedDate);
    }
    print(
        "payment${widget.passenger} ${widget.childpassenger} ${widget.infantpassenger}");

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Make Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
            fontSize: 14.sp,
            fontFamily: 'Inter',
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // optional spacing from edges
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              // height: 15, // smaller circle
              // width: 15,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8E8E8),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icon/appbar_arrow.png',
                  height: 13,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFFF5F5F5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              SizedBox(
                height: 10,
              ),
              if (widget.segments != null) ...[
                if (widget.segments!.length >= 2)
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.segments!.first.first.origin
                                            .airport.cityName,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.segments!.first.first.origin
                                            .airport.cityCode,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    "assets/icon/roundtripright.png",
                                    width: 25,
                                    height: 15,
                                    color: Colors.deepOrange,
                                  ),
                                  Image.asset(
                                    "assets/icon/roundtripline.png",
                                    width: 70,
                                    height: 15,
                                    color: Colors.grey,
                                  ),
                                  Image.asset(
                                    "assets/icon/roundtripleft.png",
                                    width: 25,
                                    height: 15,
                                    color: Colors.deepOrange,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.segments!.first.last.destination
                                            .airport.cityName,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.segments!.first.last.destination
                                            .airport.cityCode,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          SizedBox(height: 8.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DotDivider(
                              dotSize: 1.h, // Adjust size
                              spacing: 2.r, // Adjust spacing
                              dotCount: 97, // Adjust number of dots
                              color: Colors.grey, // Adjust color
                            ),
                          ),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => Viewfulldetails(
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
                                  segments: widget.segments,
                                  inboundFlight: widget.inboundFlight,
                                  outboundFlight: widget.outboundFlight,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View full details',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFF37023),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Padding(
                                    padding: EdgeInsets.only(top: 4.h),
                                    child: Image.asset(
                                        "assets/images/Traingle.png"))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Flight header
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                // adjust radius
                                child: Image.asset(
                                  "assets/${widget.airlineCode ?? ""}.gif",
                                  fit: BoxFit.cover,
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.airlineName,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: widget.airlineCode ?? "",
                                        // first text
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        // base style
                                        children: [
                                          TextSpan(text: " "),
                                          TextSpan(
                                            text: widget.flightNumber ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color:
                                                        Colors.grey.shade700),
                                          ),
                                          TextSpan(
                                            text: " ${widget.refundable ?? ""}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: primaryColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // SizedBox(width: 43.w),
                              // Image.asset(
                              //   "assets/images/Line.png",
                              // ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Economy Class",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Image.asset("assets/images/star.png"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DotDivider(
                              dotSize: 1.h,
                              spacing: 2.r,
                              dotCount: 97,
                              color: Colors.grey, // Adjust color
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.depTime ?? "",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    DateFormat("dd MMM yy").format(
                                      DateTime.parse(widget.depDate.toString()),
                                    ),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(widget.stop ?? "",
                                      style: TextStyle(fontSize: 12.sp)),
                                  Image.asset('assets/images/flightColor.png'),
                                  Text(widget.duration ?? "",
                                      style: TextStyle(fontSize: 12.sp)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.arrTime ?? "",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    DateFormat("dd MMM yy").format(
                                      DateTime.parse(widget.arrDate.toString()),
                                    ),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.cityName,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        widget.cityCode,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //SizedBox(height: 4.h),
                                  // Text(
                                  //   flight["departure"],
                                  //   style: TextStyle(
                                  //     fontSize: 12.sp,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.descityName ?? "",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        widget.descityCode ?? "",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   flight["arrival"],
                                  //   style: TextStyle(fontSize: 12.sp),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DotDivider(
                              dotSize: 1.h,
                              spacing: 2.r,
                              dotCount: 97,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => Viewfulldetails(
                                  flight: flight,
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
                                  segments: widget.segments,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View full details',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFF37023),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child:
                                      Image.asset("assets/images/Traingle.png"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ] else ...[
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.outboundFlight!.segments.first
                                          .first.origin.airport.cityName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.outboundFlight!.segments.first
                                          .first.origin.airport.cityCode,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Image.asset(
                                  "assets/icon/roundtripright.png",
                                  width: 25,
                                  height: 15,
                                  color: Colors.deepOrange,
                                ),
                                Image.asset(
                                  "assets/icon/roundtripline.png",
                                  width: 70,
                                  height: 15,
                                  color: Colors.grey,
                                ),
                                Image.asset(
                                  "assets/icon/roundtripleft.png",
                                  width: 25,
                                  height: 15,
                                  color: Colors.deepOrange,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.outboundFlight!.segments.first.last
                                          .destination.airport.cityName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.outboundFlight!.segments.first
                                          .first.origin.airport.cityCode,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DotDivider(
                            dotSize: 1.h, // Adjust size
                            spacing: 2.r, // Adjust spacing
                            dotCount: 97, // Adjust number of dots
                            color: Colors.grey, // Adjust color
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => Viewfulldetails(
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
                                segments: widget.segments,
                                inboundFlight: widget.inboundFlight,
                                outboundFlight: widget.outboundFlight,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View full details',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(0xFFF37023),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child:
                                      Image.asset("assets/images/Traingle.png"))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
              SizedBox(
                height: 8.h,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PAY THROUGH UPI',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              fontFamily: 'Inter')),
                      SizedBox(height: 5.h),
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Image.asset("assets/images/Gpay.png"),
                        title: Text('Google Pay'),
                        subtitle: Text(
                          'save ₹49 by paying online',
                          style: TextStyle(
                            color: Color(0xFF138808),
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'Google Pay';
                            });
                          },
                          child: Icon(
                            selectedPaymentMethod == 'Google Pay'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedPaymentMethod == 'Google Pay'
                                ? Color(0xFFF37023)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Image.asset("assets/images/Pay_tm.png"),
                        title: Text('Paytm'),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'Paytm';
                            });
                          },
                          child: Icon(
                            selectedPaymentMethod == 'Paytm'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedPaymentMethod == 'Paytm'
                                ? Color(0xFFF37023)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Image.asset("assets/images/Phone_pay.png"),
                        title: Text('Paytm'),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'PhonePay';
                            });
                          },
                          child: Icon(
                            selectedPaymentMethod == 'PhonePay'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedPaymentMethod == 'PhonePay'
                                ? Color(0xFFF37023)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PAY THROUGH CARD',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            "+ADD NEW CARD",
                            style: TextStyle(color: Color(0xFFF37023)),
                          )
                        ],
                      ),
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Image.asset("assets/images/Card.png"),
                        title: Text('HDFC Credit Card'),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'HDFC Credit Card';
                            });
                          },
                          child: Icon(
                            selectedPaymentMethod == 'HDFC Credit Card'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedPaymentMethod == 'HDFC Credit Card'
                                ? Color(0xFFF37023)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      TextField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          CardNumberInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          filled: true,

                          fillColor: Color(0xFFF3F4F6),
                          // Background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NET BANKING",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'NET BANKING';
                          });
                        },
                        child: Icon(
                          selectedPaymentMethod == 'NET BANKING'
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selectedPaymentMethod == 'NET BANKING'
                              ? Color(0xFFF37023)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "WALLET",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'WALLET';
                          });
                        },
                        child: Icon(
                          selectedPaymentMethod == 'WALLET'
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selectedPaymentMethod == 'WALLET'
                              ? Color(0xFFF37023)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              // Card(
              //   color: Colors.white,
              //   child: Padding(
              //     padding:
              //         EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              //     // child: Row(
              //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     //   children: [
              //     //     Text(
              //     //       "",
              //     //       style: TextStyle(
              //     //           fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              //     //     ),
              //     //     GestureDetector(
              //     //       onTap: () {
              //     //         setState(() {
              //     //           selectedPaymentMethod = 'CASH ON DELIVERY';
              //     //         });
              //     //       },
              //     //       child: Icon(
              //     //         selectedPaymentMethod == 'CASH ON DELIVERY'
              //     //             ? Icons.check_circle
              //     //             : Icons.radio_button_unchecked,
              //     //         color: selectedPaymentMethod == 'CASH ON DELIVERY'
              //     //             ? Color(0xFFF37023)
              //     //             : Colors.grey,
              //     //       ),
              //     //     ),
              //     //   ],
              //     // ),
              //   ),
              // ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(0.r)),
              boxShadow: [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showFareBreakupSheet(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                'View full details',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(0xFFF37023),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(Icons.arrow_drop_up,
                                  color: Color(0xFFF37023), size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹$overallFare",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF37023),
                          ),
                        ),
                        Text(
                          "Including GST+ taxes",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.getString("ResultIndex");
                    print("ISLLC${widget.isLLC}");
                    // await ApiService().ticket();
                    print("ADULTCHILD${widget.meal}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Afterpayment(
                                  flightNumber: widget.flightNumber,
                                  airlineName: widget.airlineName,
                                  depTime: widget.depTime,
                                  depDate: widget.depDate,
                                  airportName: widget.airportName,
                                  arrTime: widget.arrTime,
                                  arrDate: widget.arrDate,
                                  desairportName: widget.desairportName,
                                  duration: widget.duration,
                                  airlineCode: widget.airlineCode,
                                  cityCode: widget.cityCode,
                                  descityCode: widget.descityCode,
                                  cityName: widget.cityName,
                                  descityName: widget.descityName,
                                  outboundFlight: widget.outboundFlight,
                                  inboundFlight: widget.inboundFlight,
                                  outresultindex: widget.outresultindex,
                                  inresultindex: widget.inresultindex,
                                  passenger: widget.passenger,
                                  childpassenger: widget.childpassenger,
                                  infantpassenger: widget.infantpassenger,
                                  basefare: widget.basefare,
                                  tax: widget.tax,
                                  isLLC: widget.isLLC,
                                  outBoundData: widget.outBoundData,
                                  inBoundData: widget.inBoundData,
                                  meal: widget.meal,
                                  stop: widget.stop,
                                  resultindex: widget.resultindex,
                                  traceid: widget.traceid,
                                  segmentsJson: widget.segmentsJson,
                                )));
                    // Get.to(MakePaymentScreen(
                    //   flight: flight,
                    //   city: widget.city,
                    //   destination: widget.destination,
                    // ));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40.h),
                    backgroundColor: Color(0xFFF37023),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Proceed to pay",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -12.h,
            left: 135.w,
            child: GestureDetector(
              onTap: () {
                showFareBreakupSheet(context);
              },
              child: Container(
                height: 28.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  "assets/images/TriangleButton.png",
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showFareBreakupSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return FareBreakupSheet(
          basefare: totalBaseFare,
          tax: totalTax,
          adultCount: totaladultCount,
          childCount: totalchildCount,
          infantCount: totalinfantCount,
          adultfare: adultFare,
          childfare: childFare,
          infantfare: infantFare,
          total: overallFare,
          adultTax: 0,
          childTax: 0,
          infantTax: 0,
        );
      },
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', ''); // Remove existing spaces
    String formatted = '';

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' '; // Add space after every 4 digits
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
