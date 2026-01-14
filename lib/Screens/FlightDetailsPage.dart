import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/Screens/ViewFullDetails.dart';
import 'package:trvlus/Screens/price_alert_controller.dart';
import 'package:trvlus/utils/constant.dart';

import '../models/farequote.dart' as farequote;
import '../models/farerule.dart';
import '../models/search_data.dart';
import '../models/ssr.dart';
import '../utils/api_service.dart';
import 'DotDivider.dart';
import 'Mobile_Verification.dart';
import 'ShowModelSheet.dart';
import 'TravelerDetails.dart';

class FlightDetailsPage extends StatefulWidget {
  final Map<String, dynamic> flight;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;
  final String city;
  final String destination;
  final String airlineName;
  final String cityName;
  final String cityCode;
  final String? flightNumber;
  final String? depDate;
  final String? depTime;
  final String? outdepDate;
  final String? outdepTime;
  final String? indepDate;
  final String? indepTime;
  final String? arrDate;
  final String? arrTime;
  final String? stop;
  final String? outarrDate;
  final String? outarrTime;
  final String? inarrDate;
  final String? inarrTime;
  final String? descityName;
  final String? refundable;
  final String? descityCode;
  final String? airlineCode;
  final bool? isLLC;
  final String? duration;
  final String? airportName;
  final String? desairportName;
  final String? cabinBaggage;
  final String? baggage;
  final String? cancellation;
  final String? journeypoint;
  final String? reissue;
  final double? basefare;
  final List<List<Segment>>? segments;
  final List<Map<String, dynamic>>? segmentsJson; // 4th page uses this
  final String? resultindex;
  final String? outresultindex;
  final String? inresultindex;
  final String? traceid;
  final Result? outboundFlight;
  final Result? inboundFlight;
  final String? total;
  final double? tax;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final int? coupouncode;
  final double? adultBaseFare;
  final double? adultTax;
  final double? childBaseFare;
  final double? childTax;
  final double? infantBaseFare;
  final double? infantTax;
  final String? commonPublishedFare;
  final int? coupon;
  final String? tboOfferedFare;
  final double? tboCommission;
  final double? tboTds;
  final double? trvlusCommission;
  final double? trvlusTds;
  final int? trvlusNetFare;

  FlightDetailsPage(
      {required this.flight,
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
      this.stop,
      this.descityName,
      this.descityCode,
      this.outdepDate,
      this.outdepTime,
      this.outarrDate,
      this.outarrTime,
      this.indepDate,
      this.indepTime,
      this.inarrDate,
      this.inarrTime,
      this.duration,
      this.isLLC,
      this.cabinBaggage,
      this.baggage,
      this.cancellation,
      this.journeypoint,
      this.reissue,
      this.basefare,
      this.tax,
      this.segments,
      this.segmentsJson,
      this.resultindex,
      this.outresultindex,
      this.inresultindex,
      this.traceid,
      this.outboundFlight,
      this.inboundFlight,
      this.total,
      this.adultCount,
      this.childCount,
      this.infantCount,
      this.coupouncode,
      this.adultBaseFare,
      this.childBaseFare,
      this.infantBaseFare,
      this.commonPublishedFare,
      this.coupon,
      this.tboOfferedFare,
      this.tboCommission,
      this.tboTds,
      this.trvlusCommission,
      this.trvlusTds,
      this.trvlusNetFare,
      this.adultTax,
      this.childTax,
      this.infantTax});

  @override
  _FlightDetailsPageState createState() => _FlightDetailsPageState();
}

class _FlightDetailsPageState extends State<FlightDetailsPage> {
  int appliedPromoIndex = 0; // default applied promo
  bool isLoading = true; // Add loading state
  bool _isLoggedIn = false;
  late FareRuleData fare;
  late farequote.FareQuotesData fareQuote;
  late farequote.FareQuotesData infareQuote;
  late SsrData ssrdata;
  double totalBaseFare = 0;
  double totalTax = 0;
  double overallFare = 0;
  double inbaseFare = 0;
  double intax = 0;
  int totaladultCount = 0;
  int totalchildCount = 0;
  int totalinfantCount = 0;
  int coupouncode = 0;
  double adultFare = 0;
  double childFare = 0;
  double infantFare = 0;

  getFareData() async {
    setState(() {
      isLoading = true;
    });
    final vale = 0;
    print("FLIGHTDETAILPAGE");
    print(widget.commonPublishedFare);
    print(widget.tboCommission);
    print(widget.tboOfferedFare);
    print(widget.tboTds);
    print(widget.trvlusCommission);
    print(widget.trvlusTds);
    print(widget.trvlusNetFare);

    // ROUNDTRIP
    if (widget.outresultindex != null && widget.inresultindex != null) {
      print("ROUNDTRIPOUTBOUND");
      fare = await ApiService()
          .farerule(widget.outresultindex ?? "", widget.traceid ?? "");
      fare = await ApiService()
          .farerule(widget.inresultindex ?? "", widget.traceid ?? "");
      fareQuote = await ApiService()
          .farequote(widget.outresultindex ?? "", widget.traceid ?? "");
      infareQuote = await ApiService()
          .farequote(widget.inresultindex ?? "", widget.traceid ?? "");
      ssrdata = await ApiService()
          .ssr(widget.outresultindex ?? "", widget.traceid ?? "");
      ssrdata = await ApiService()
          .ssr(widget.inresultindex ?? "", widget.traceid ?? "");
    }
    // ONEWAY
    else {
      print("ONEWAY & INTERNATIONAL ROUNDTRIP");
      fare = await ApiService()
          .farerule(widget.resultindex ?? "", widget.traceid ?? "");
      fareQuote = await ApiService()
          .farequote(widget.resultindex ?? "", widget.traceid ?? "");
      ssrdata = await ApiService()
          .ssr(widget.resultindex ?? "", widget.traceid ?? "");
      //PRICEALERT
      var farequote = fareQuote.response.results.fare.publishedFare;
      print("farequotefarequote$farequote");
      var isPriceChanged = fareQuote.response.isPriceChanged;
      print("isPriceChangedisPriceChanged$isPriceChanged");

      Get.find<PriceAlertController>().checkFare(
        farequote,
        isPriceChanged,
      );
    }

    // FARE CALCULATION
    final fareBreakdown = fareQuote.response.results.fareBreakdown;
    print("fareBreakdownfareBreakdown${jsonEncode(fareBreakdown)}");
    final baseFare = fareQuote.response.results.fare.baseFare.round();
    print("baseFaretax$baseFare");
    final tax = fareQuote.response.results.fare.tax.round();
    print("taxtax$tax");

    final commision =
        fareQuote.response.results.fare.commissionEarned.toDouble();

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
    if (widget.inresultindex != null) {
      final infareBreakdown = infareQuote.response.results.fareBreakdown;
      print("infareBreakdownfareBreakdown${jsonEncode(infareBreakdown)}");
      inbaseFare = infareQuote.response.results.fare.baseFare;
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
      coupouncode = widget.coupouncode!;
      totalBaseFare = baseFare + inbaseFare;
      print("totalFare$totalFare");
      totalTax = tax + intax;
      print("totalTax$totalTax");
      overallFare = totalBaseFare + totalTax - coupouncode.round();
      totaladultCount = adultCount + inadultCount;
      totalchildCount = childCount + inchildCount;
      totalinfantCount = infantCount + ininfantCount;
      adultFare = adultBase + inadultBase;
      childFare = childBase + inchildBase;
      infantFare = infantBase + ininfantBase;
      print("overallFare$overallFare");
    });
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (loggedIn) {
      // User already logged in → navigate to home or skip login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TravelerDetailsPage(
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
                  segmentsJson: widget.segmentsJson,
                  coupouncode: widget.coupouncode,
                  commonPublishedFare: widget.commonPublishedFare,
                  tboOfferedFare: widget.tboOfferedFare,
                  tboCommission: widget.tboCommission,
                  tboTds: widget.tboTds,
                  trvlusCommission: widget.trvlusCommission,
                  trvlusTds: widget.trvlusTds,
                  trvlusNetFare: widget.trvlusNetFare,
                )),
      );
    } else {
      // User not logged in → show mobile login screen inside this page
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFareData();
    // checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    print("FLIGHTDETAILPAGE");
    print("segmentsJson${widget.segmentsJson}");
    print("hello${widget.tboCommission}");
    final total = widget.total;
    final llc = widget.isLLC;
    print("LLLLLLCCCCC$llc");
    print("totaltotal$total");
    print(
        "heloooooo${widget.adultCount} ${widget.childCount} ${widget.infantCount}");
    print(jsonEncode(widget.segments));
    print(widget.segments?.first.first.origin.airport.cityName);
    print(widget.segments?.first.first.origin.airport.cityCode);
    print(widget.segments?.first.last.destination.airport.cityName);
    print(widget.segments?.first.last.destination.airport.cityCode);

    print(widget.segments?.length);
    final flight =
        widget.outboundFlight?.segments.first.first.airline.airlineName;
    print("flight$flight");

    final flight1 = widget.outboundFlight?.segments.length;
    print("flight$flight1");
    final segments = jsonEncode(widget.segments);
    print("allsegments$segments");
    // ONEWAY DATE
    if (widget.segments != null) {
      final depDateformat = widget.depDate;
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(depDateformat!);
      final finaldepDateformat =
          DateFormat("EEE, dd MMM yy").format(parsedDate);

      final arrDateformat = widget.arrDate;
      print("arrDateformat$arrDateformat");
      DateTime arrparsedDate = DateTime.parse(arrDateformat!);
      final finalarrDateformat =
          DateFormat("EEE, dd MMM yy").format(arrparsedDate);
      print("finalarrDateformat$finalarrDateformat");

      print(finaldepDateformat);
      print(finalarrDateformat);
    } else {}

    return isLoading
        ? const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFFF37023),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Loading...",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            appBar: AppBar(
              title: Text(
                'Review Your Journey',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              foregroundColor: Colors.black,
              backgroundColor: Color(0xFFF5F5F5),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  // ONEWAY
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            widget.segments!.first.last
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
                                            widget.segments!.first.last
                                                .destination.airport.cityCode,
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
                      ...List.generate(widget.segments?.length ?? 0,
                          (segmentIndex) {
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.airlineName,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: widget.airlineCode ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                              children: [
                                                TextSpan(text: " "),
                                                TextSpan(
                                                  text:
                                                      widget.flightNumber ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color: Colors
                                                              .grey.shade700),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${widget.refundable ?? ""}",
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
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Economy Class",
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 6.w,
                                            ),
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            Image.asset(
                                                "assets/images/star.png")
                                          ],
                                        ),
                                      ],
                                    )
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              widget.depTime ?? "",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                          ],
                                        ),
                                        Text(
                                          DateFormat("dd MMM yy").format(
                                            DateTime.parse(
                                                widget.depDate.toString()),
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
                                        Image.asset(
                                            'assets/images/flightColor.png'),
                                        Text(
                                          widget.duration ?? "",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              widget.arrTime ?? "",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                          ],
                                        ),
                                        Text(
                                          DateFormat("dd MMM yy").format(
                                            DateTime.parse(
                                                widget.arrDate.toString()),
                                          ),
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                          child: Image.asset(
                                              "assets/images/Traingle.png"))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ...List.generate(
                        widget.outboundFlight?.segments.length ?? 0,
                        (segmentIndex) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                      "assets/${widget.outboundFlight!.airlineCode ?? ""}.gif"),
                                  SizedBox(width: 12),
                                  Container(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          // widget.outboundFlight!.segments.first
                                          //     .first.airline.airlineName,
                                          "",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                              color: Colors.black),
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
                                                        color: Colors
                                                            .grey.shade700),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${widget.refundable ?? ""}",
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
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          Image.asset("assets/images/star.png")
                                        ],
                                      ),
                                      Text(
                                        // "Aircraft Boeing",
                                        "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Colors.grey.shade700),
                                      ),
                                    ],
                                  )
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.depTime ?? "",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                        ],
                                      ),
                                      //SizedBox(height: 4.h),
                                      Text(
                                        finaldepDateformat,
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
                                      Image.asset(
                                          'assets/images/flightColor.png'),
                                      Text(
                                        widget.duration ?? "",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            widget.arrTime ?? "",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                        ],
                                      ),
                                      Text(
                                        finalarrDateformat,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                      );
                    }),
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
                                        if (widget.outboundFlight != null)
                                          Text(
                                            widget
                                                .outboundFlight!
                                                .segments
                                                .first
                                                .first
                                                .origin
                                                .airport
                                                .cityName,
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
                                          widget
                                              .outboundFlight!
                                              .segments
                                              .first
                                              .last
                                              .destination
                                              .airport
                                              .cityName,
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
                  ],

                  SizedBox(height: 16),

                  // Other Sections
                  _buildBaggagePolicy(),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      height: 70,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 0.3,
                                color: Colors.grey,
                                offset: Offset(0, 0.4))
                          ]),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/promocode.png',
                            height: 32,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Promo Code",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "TRVLUS",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.vertical(
                                    //       top: Radius.circular(16.r)),
                                    // ),
                                    shape: Border(
                                        left: BorderSide.none,
                                        right: BorderSide.none),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setModalState) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 25),
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Promo Code",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Image.asset(
                                                        "assets/icon/Close.png",
                                                        height: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 25),
                                                promoRowModal(
                                                    0,
                                                    "TRVLUS09",
                                                    "₹4,555 save",
                                                    "s provide the test data (atleast 3 loans) \n for starting the renewal flow test by",
                                                    setModalState),
                                                promoRowModal(
                                                    1,
                                                    "TRVLUS10",
                                                    "₹4,555 save",
                                                    "s provide the test data (atleast 3 loans) \n for starting the renewal flow test by",
                                                    setModalState),
                                                promoRowModal(
                                                    2,
                                                    "TRVLUS11",
                                                    "₹4,555 save",
                                                    "s provide the test data (atleast 3 loans) \n for starting the renewal flow test by",
                                                    setModalState),
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "CHANGE",
                                      style: TextStyle(
                                        color: Color(0xFFF37023),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "₹4,555 saved",
                                      style: TextStyle(
                                        color: Color(0xFF138808),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                  SizedBox(height: 10.h),
                  _buildCancellationPolicy(),
                  SizedBox(height: 10.h),
                  _buildDateChange(),
                  //_buildPromoCodeSection(),
                  // _buildRefundableBooking(),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MobileVerificationScreen(
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
                                      basefare: widget.basefare,
                                      segments: widget.segments,
                                      resultindex: widget.resultindex,
                                      traceid: widget.traceid,
                                      outboundFlight: widget.outboundFlight,
                                      inboundFlight: widget.inboundFlight,
                                      total: widget.total,
                                      tax: widget.tax,
                                      adultCount: widget.adultCount,
                                      childCount: widget.infantCount,
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
                                    )));
                      },
                      child: Text("")),
                  SizedBox(height: 16),
                ],
              ),
            ),
            bottomNavigationBar: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(0.r)),
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
                                "₹${overallFare.toStringAsFixed(0)}",
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
                        onPressed: () {
                          print("RESULTINDEXRESULTINDEX");
                          print(widget.traceid);
                          print(widget.resultindex);
                          checkLoginStatus();
                          Get.to(MobileVerificationScreen(
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
                            basefare: widget.basefare,
                            segments: widget.segments,
                            resultindex: widget.resultindex,
                            traceid: widget.traceid,
                            outboundFlight: widget.outboundFlight,
                            inboundFlight: widget.inboundFlight,
                            total: widget.total,
                            tax: widget.tax,
                            adultCount: widget.adultCount,
                            childCount: widget.infantCount,
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
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40.h),
                          backgroundColor: Color(0xFFF37023),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          "Continue",
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

  // Widget _buildPromoCodeSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white, // Background color for the TextField
  //           borderRadius: BorderRadius.circular(8), // Rounded corners
  //           border: Border.all(color: Colors.grey.shade300), // Border color
  //         ),
  //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //         // Internal padding
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Promo Code",
  //               style: TextStyle(
  //                 fontSize: 12.sp,
  //                 fontFamily: 'BricolageGrotesque',
  //                 color: Color(0xFF909090),
  //               ),
  //             ),
  //             TextField(
  //               decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 hintStyle: TextStyle(
  //                   color: Colors.grey.shade400,
  //                   fontSize: 14,
  //                 ),
  //               ),
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(height: 8),
  //       Padding(
  //         padding: EdgeInsets.only(left: 5.w),
  //         child: Text(
  //           'You save ₹50 with this Order',
  //           style: TextStyle(
  //             fontFamily: 'Inter',
  //             fontSize: 12.sp,
  //             color: Color(0xFF138808),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBaggagePolicy() {
    // ✅ Get segment list from API
    final List<dynamic> segments = fareQuote.response.results.segments[0];
    print("segmentssegments${jsonEncode(segments)}");

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("assets/images/Bagging.png"),
                SizedBox(width: 8.w),
                Text(
                  "Baggage",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 130.w),
              ],
            ),

            Text(
              "Add additional checking package at low price",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.sp,
                fontWeight: FontWeight.normal,
              ),
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

            SizedBox(height: 12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Cabin Bag",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF909090),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      "Check-in Bag",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // =============================
            //      DYNAMIC BAGGAGE LIST
            // =============================
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: segments.length,
              // ✅ dynamic
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                // Convert Segment object to Map
                final segment = segments[index].toJson();

                print("segment$segment");

                final cabin = segment["CabinBaggage"] ?? "";
                final baggage = segment["Baggage"] ?? "";
                final from = segment["Origin"]["Airport"]["CityCode"] ?? "";
                final to = segment["Destination"]["Airport"]["CityCode"] ?? "";

                return Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 0.w),
                      child: Row(
                        children: [
                          Text(
                            cabin,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 50.w),
                          Text(
                            baggage,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 60.h),
                          Text(
                            " $from - $to",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              color: Color(0xFF909090),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundtrip() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("assets/images/Bagging.png"),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  "Baggage",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 130.w),
              ],
            ),
            Text(
              "Add additional checking package at low price",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.normal),
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
            //SizedBox(height: 8.h),
            SizedBox(height: 12.h),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(), // Empty space for alignment
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Cabin Bag",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF909090),
                      ),
                    ),
                    SizedBox(width: 20.w), // Space between headers
                    Text(
                      "Check-in Bag",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Baggage List
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              // Adjust based on your data
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon and Route
                    // Row(
                    //   children: [
                    //     Container(
                    //       height: 24.w,
                    //       width: 24.w,
                    //       decoration: BoxDecoration(
                    //         color: Color(0xFFF37023),
                    //         borderRadius: BorderRadius.circular(4.r),
                    //       ),
                    //     ),
                    //     SizedBox(width: 12.w),
                    //     Text(
                    //       "DEL-MAA (Adult)", // Update with flight data
                    //       style: TextStyle(
                    //         fontFamily: 'Inter',
                    //         fontSize: 14.sp,
                    //         fontWeight: FontWeight.bold,
                    //         color: Color(0xFF909090),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // Baggage Details
                    Padding(
                      padding: EdgeInsets.only(right: 0.w),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.cabinBaggage ?? "",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          //Spacer(),
                          SizedBox(width: 50.w),
                          Text(
                            widget.baggage ?? "",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 60.h),
                          Text(
                            " ${widget.cityCode} - ${widget.descityCode}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                color: Color(0xFF909090)),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCancellationPolicy() {
    return _buildSectionCard(
      "Cancellation Charges",
      [
        Text(
          "Cancellation between (IST)",
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8.h),
        Divider(),
        //SizedBox(height: 8.h),
        SizedBox(height: 8.h),
        _buildPolicyRow(
          "0-4 hrs to departure: ${widget.journeypoint ?? ""}",
          widget.cancellation ?? "",

          // valueColor: Color(0xFFF32323),
        ),
        SizedBox(height: 12.h),
        _buildPolicyRow("4hrs - 4 days to departure:", "No Data"),
        SizedBox(height: 12.h),
        _buildPolicyRow("4 - 999 days to departure:", "No Data"),
      ],
    );
  }

  Widget _buildDateChange() {
    return _buildDateChangeCard(
      "Date Change Charges",
      [
        SizedBox(height: 8.h),
        _buildPolicyRow(
          "0-4 hrs to departure: ${widget.journeypoint ?? ""}",
          widget.reissue ?? "",
          // valueColor: Color(0xFFF32323),
        ),
        SizedBox(height: 12.h),
        _buildPolicyRow("4hrs - 4 days to departure:", "No Data"),
        SizedBox(height: 12.h),
        _buildPolicyRow("4 - 999 days to departure:", "No Data"),
      ],
    );
  }

  Widget _buildSectionCard(String title, List<Widget> content) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Row(
              children: [
                Image.asset("assets/images/cancellation.png"),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ...content,
          ],
        ),
      ),
    );
  }

  _buildDateChangeCard(String title, List<Widget> content) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Row(
              children: [
                SvgPicture.asset("assets/icon/datechange.svg"),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyRow(String label, String value,
      {Color valueColor = Colors.black}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5), // Light gray background for each row
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 12.sp, fontFamily: 'Inter', color: Color(0xFFF32323)),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              color: valueColor,
              fontWeight: FontWeight.bold,
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
          convenienceFee: 0,
          adultCount: totaladultCount,
          childCount: totalchildCount,
          infantCount: totalinfantCount,
          adultfare: adultFare,
          childfare: childFare,
          infantfare: infantFare,
          total: overallFare,
          adultTax: widget.adultTax,
          childTax: widget.childTax,
          infantTax: widget.infantTax,
          coupouncode: widget.coupouncode,
        );
      },
    );
  }

  Widget promoRowModal(int index, String code, String amount, String about,
      StateSetter setModalState) {
    bool isApplied = appliedPromoIndex == index;

    return Column(
      children: [
        Row(
          children: [
            Image.asset('assets/images/promocode.png', height: 35),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(amount,
                    style: TextStyle(
                        color: Color(0xFF138808), fontWeight: FontWeight.bold)),
                Text(about,
                    style: TextStyle(
                        color: Color(0xFF909090),
                        fontWeight: FontWeight.bold,
                        fontSize: 9)),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setModalState(() {
                  appliedPromoIndex = index; // update applied promo
                });
                setState(() {}); // optional: update main page if needed
              },
              child: Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isApplied ? Color(0xFFF37023) : Colors.transparent,
                  border: Border.all(color: Color(0xFFF37023)),
                ),
                alignment: Alignment.center,
                child: Text(
                  isApplied ? "Applied" : "Apply",
                  style: TextStyle(
                    color: isApplied ? Colors.white : Color(0xFFF37023),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
