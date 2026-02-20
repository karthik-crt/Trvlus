import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trvlus/Screens/price_alert_controller.dart';

import '../models/farequote.dart' as farequote;
import '../models/search_data.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'ConfirmTraveler.dart';
import 'DotDivider.dart';
import 'ShowModelSheet.dart';
import 'ViewFullDetails.dart';

List<Map<String, dynamic>> adultTravelers = [];
List<Map<String, dynamic>> childTravelers = [];
List<Map<String, dynamic>> infantTravelers = [];
String finaldepDateformat = '';
String finalarrDateformat = '';
double totalFare = 0;

class TravelerDetailsPage extends StatefulWidget {
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
  final Map<String, dynamic>? selectedpassenger; // 4th page uses this
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

  TravelerDetailsPage(
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
      this.isLLC,
      this.outdepDate,
      this.outdepTime,
      this.outarrDate,
      this.outarrTime,
      this.indepDate,
      this.indepTime,
      this.inarrDate,
      this.inarrTime,
      this.selectedpassenger});

  @override
  _TravelerDetailsPageState createState() => _TravelerDetailsPageState();
}

class _TravelerDetailsPageState extends State<TravelerDetailsPage> {
  int totalAmount = 8000;

  bool hasGST = false;
  String selectedState = 'Tamil Nadu';
  List<String> states = ['Tamil Nadu']; // Add more states as needed
  List<Map<String, dynamic>> traveler = [];
  List<Map<String, dynamic>> childtraveler = [];
  List<Map<String, dynamic>> infanttraveler = [];
  late farequote.FareQuotesData fareQuote;
  late farequote.FareQuotesData infareQuote;
  bool isLoading = true;
  bool isPassportRequiredAtTicket = false;
  bool isPassportFullDetailRequiredAtBook = false;
  double totalBaseFare = 0;
  double totalTax = 0;
  double othercharges = 0;
  double overallFare = 0;
  double inbaseFare = 0;
  double intax = 0;
  int totaladultCount = 0;
  int totalchildCount = 0;
  int totalinfantCount = 0;
  double adultFare = 0;
  double childFare = 0;
  double infantFare = 0;
  num coupouncode = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfarequotedata();
    print("fgcgfcf${widget.selectedpassenger}");
    setPassenger();
  }

  setPassenger() {
    if (widget.selectedpassenger == null) return;

    final selectedEmail = widget.selectedpassenger?['email'];
    final typeLabel = widget.selectedpassenger?['typeLable'] ?? '';

    // Remove from all lists if exists
    adultTravelers.removeWhere((adult) => adult['email'] == selectedEmail);
    childtraveler.removeWhere((child) => child['email'] == selectedEmail);
    infanttraveler.removeWhere((infant) => infant['email'] == selectedEmail);

    // Add to the correct list based on typeLable
    if (typeLabel == 'Adult') {
      adultTravelers.add(widget.selectedpassenger!);
    } else if (typeLabel == 'Child') {
      childtraveler.add(widget.selectedpassenger!);
    } else if (typeLabel == 'Infant') {
      infanttraveler.add(widget.selectedpassenger!);
    }

    setState(() {});
  }

  getfarequotedata() async {
    setState(() {
      isLoading = true;
      print("beforeOutput");
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
      debugPrint("ssrDATA: ${jsonEncode(fareQuote)}", wrapWidth: 4500);
      final isInternational = isInternationalFromFareQuote(fareQuote);

      isPassportRequiredAtTicket = isInternational ||
          (fareQuote.response.results.isPassportRequiredAtTicket ?? false);

      isPassportFullDetailRequiredAtBook = isInternational ||
          (fareQuote.response.results.isPassportFullDetailRequiredAtBook ??
              false);

      final helo = fareQuote.response;
      final ticket =
          fareQuote.response.results.isPassportRequiredAtTicket ?? false;
      print("TICKETREQUIRES$ticket");
      // final passportticket =
      //     fareQuote.response.results.isPassportFullDetailRequiredAtBook ??
      //         false;
      // isPassportFullDetailRequiredAtBook = passportticket;
      //
      // isPassportRequiredAtTicket = ticket;

      debugPrint("RESPONSESSRDTAA${jsonEncode(helo)}", wrapWidth: 1500);
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
        print("adultCountadultCount$adultCount");
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
      print("TRAVELERDERAILS");
      print("sgsrghergeh${widget.selectedpassenger}");
      print("basefare${widget.basefare}");
      print("basefare${widget.tax}");
      isLoading = false;
      coupouncode = widget.coupouncode!;
      othercharges = widget.othercharges ?? 0.0;
      totalBaseFare = baseFare + inbaseFare;
      print("totalFare$totalFare");
      totalTax = tax + intax + othercharges;
      print("totalTax$totalTax");
      if (widget.coupouncode! > 0) {
        overallFare = totalBaseFare + totalTax - coupouncode;
        print("overallFare1$overallFare");
      } else {
        overallFare = totalBaseFare + totalTax + othercharges;
        print("overallFare$overallFare");
        print("overallFare$totalBaseFare");
        print("overallFare$totalTax");
        print("overallFare$othercharges");
      }
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
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFF37023),
          ),
        ),
      );
    }
    print("TRAVELERSDETAIL");
    print("segmentsJson${widget.segmentsJson}");
    print("segmentsJson${widget.isLLC}");
    print("othercharges${widget.othercharges}");
    final flight = widget.flight;
    final childCount = widget.childCount;
    final infantCount = widget.infantCount;
    if (widget.depTime != null) {
      final depDateformat = widget.depDate;
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(depDateformat!);
      final finaldepDateformat = DateFormat("EEE,dd MMM yy").format(parsedDate);
      final arrDateformat = widget.arrDate;
      DateTime arrparsedDate = DateFormat("yyyy-MM-dd").parse(arrDateformat!);
      final finalarrDateformat =
          DateFormat("EEE,dd MMM yy").format(arrparsedDate);
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Add Traveler Details',
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
            if (widget.segments != null) ...[
              if (widget.segments!.length >= 2)
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
                  child: Card(
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
                  ),
                )
              else
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
                  child: Card(
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
                                // adjust radius
                                child: Image.asset(
                                  "assets/${widget.airlineCode ?? ""}.gif",
                                  fit: BoxFit.fill,
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
                                      widget.airlineName ?? "",
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
                                                    color:
                                                        Colors.grey.shade700),
                                          ),
                                          TextSpan(text: " "),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Text(
                                    widget.duration ?? "",
                                    style: TextStyle(
                                        fontFamily: 'Inter', fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                      DateTime.parse(widget.arrDate.toString()),
                                    ),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
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
                                  SizedBox(height: 4.h),
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
                            }, // Action to execute on tap
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
                                // const SizedBox(width: 5),
                                // Padding(
                                // padding: EdgeInsets.only(top: 2.h),
                                // child: Image.asset("assets/images/Traingle.png"))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ] else ...[
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
                child: Card(
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
                ),
              )
            ],
            SizedBox(height: 10.h),
            Text(
              'Traveler Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Image.asset("assets/images/Adult.png"),
                SizedBox(
                  width: 10,
                ),
                Text('ADULT (12yrs+)',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Spacer(),
                Text('${adultTravelers.length} added',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ],
            ),

            SizedBox(height: 8.h),
            // if (widget.selectedpassenger != null)
            //   Card(
            //     color: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.r),
            //     ),
            //     elevation: 2,
            //     child: Padding(
            //       padding:
            //           EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            //       child: Row(
            //         children: [
            //           Text(
            //             '${widget.selectedpassenger?['gender']} '
            //             '${widget.selectedpassenger?['firstName']} '
            //             '${widget.selectedpassenger?['lastName']}',
            //             style: TextStyle(
            //               fontSize: 14.sp,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black,
            //             ),
            //           ),
            //           const Spacer(),
            //           Icon(Icons.check_circle, color: Colors.orange),
            //         ],
            //       ),
            //     ),
            //   ),

            ...adultTravelers.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> traveler = entry.value;
              return Column(
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Text(
                            '${traveler['gender']} ${traveler['Firstname']} ${traveler['lastname']}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          if (traveler['wheelchair'] == true)
                            Text(
                              'Wheelchair',
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.grey),
                            ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              print("fewfwe${widget.adultCount}");
                              var result = await Get.to(
                                () => AddTravelerPage(
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
                                  initialData: traveler,
                                  travelerType: 'adult',
                                  isPassportRequiredAtTicket:
                                      isPassportRequiredAtTicket,
                                  isPassportFullDetailRequiredAtBook:
                                      isPassportFullDetailRequiredAtBook,
                                  adultCount: adultTravelers.length + 1,
                                  selectedpassenger: widget.selectedpassenger,
                                  traceid: widget.traceid,
                                  resultindex: widget.resultindex,
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  adultTravelers[index] = result;
                                });
                              }
                            },
                            child: Icon(Icons.edit, color: Color(0xFFF37023)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              );
            }),
            if (adultTravelers.length < (widget.adultCount?.toInt() ?? 0))
              GestureDetector(
                onTap: () async {
                  print("adultTravelers: $adultTravelers");
                  final maxAdults = widget.adultCount?.toInt() ?? 0;
                  print("Max Adults: $maxAdults");
                  print("helllllo${adultTravelers.length + 1}");

                  // ✅ Check if we can still add new adults
                  if (adultTravelers.length < maxAdults) {
                    // Go to add new traveler
                    var result = await Get.to(
                      () => AddTravelerPage(
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
                        travelerType: 'adult',
                        isPassportRequiredAtTicket: isPassportRequiredAtTicket,
                        isPassportFullDetailRequiredAtBook:
                            isPassportFullDetailRequiredAtBook,
                        adultCount: adultTravelers.length + 1,
                        //     selectedpassenger: widget.selectedpassenger,
                      ),
                    );
                    print("resultresultresult$result");

                    if (result != null) {
                      setState(() {
                        print("resultresultresult$result");
                        adultTravelers.add(result);
                      });
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 5),
                        title: Text(
                          'Limit Exceeded',
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                        ),
                        content: Text(
                          'You can add only $maxAdults adult passenger(s).',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF37023)),
                  ),
                  child: Text(
                    '+ ADD NEW ADULT',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF37023),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16.h),
            // CheckboxListTile(
            //   value: hasGST,
            //   onChanged: (v) => setState(() => hasGST = v!),
            //   title: Text('I have a GST number (Optional)'),
            //   controlAffinity: ListTileControlAffinity.leading,
            //   activeColor: Color(0xFFF37023),
            // ),
            // SizedBox(height: 10.h),
            // Text(
            //   'Booking details will be sent to',
            //   style: TextStyle(
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black),
            // ),
            // SizedBox(height: 10.h),
            // _buildTextField(
            //     label: 'Email',
            //     hintText: 'Text here',
            //     controller: TextEditingController()),
            // SizedBox(height: 10.h),
            // GestureDetector(
            //   onTap: () {},
            //   child: Text(
            //     '+ Add Mobile',
            //     style: TextStyle(
            //       color: Color(0xFFF37023),
            //       fontWeight: FontWeight.bold,
            //       fontSize: 14.sp,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10.h),
            // Text(
            //   'Your State',
            //   style: TextStyle(
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black),
            // ),
            // SizedBox(height: 10.h),
            // _buildDropdownField(
            //   'State',
            //   selectedState,
            //   states,
            //   (value) {
            //     setState(() {
            //       selectedState = value!;
            //     });
            //   },
            // ),
            // SizedBox(height: 4.h),
            // Text(
            //   'Required for GST purpose on your tax invoice',
            //   style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            // ),
            // Child Travelers

            if (widget.childCount! > 0) ...[
              Row(
                children: [
                  Image.asset("assets/images/Child.png"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'CHILD(2 -12 Yrs)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text('${childTravelers.length} added',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 10.h),
              ...childTravelers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> traveler = entry.value;
                print("childTravelerschildTravelers$childTravelers");
                print("helllllochild${childTravelers.length + 1}");

                return Column(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Text(
                              '${traveler['gender']} ${traveler['Firstname']} ${traveler['lastname']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (traveler['wheelchair'])
                              Text(
                                'Wheelchair',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey),
                              ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                final maxChild =
                                    widget.childCount?.toInt() ?? 0;
                                print("Max Adults: $maxChild");

                                // ✅ Check if we can still add new adults
                                var result = await Get.to(
                                  () => AddTravelerPage(
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
                                    initialData: traveler,
                                    travelerType: 'child',
                                    isPassportRequiredAtTicket:
                                        isPassportRequiredAtTicket,
                                    isPassportFullDetailRequiredAtBook:
                                        isPassportFullDetailRequiredAtBook,
                                    childCount: childTravelers.length + 1,
                                    selectedpassenger: null,
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    childTravelers[index] = result;
                                  });
                                }
                              },
                              child: Icon(Icons.edit, color: Color(0xFFF37023)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                );
              }),
              if (childTravelers.length < (widget.childCount?.toInt() ?? 0))
                GestureDetector(
                  onTap: () async {
                    final maxChild = widget.childCount?.toInt() ?? 0;
                    print("Max Adults: $maxChild");

                    // ✅ Check if we can still add new adults
                    if (childTravelers.length < maxChild) {
                      var result = await Get.to(
                        () => AddTravelerPage(
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
                          travelerType: 'child',
                          isPassportRequiredAtTicket:
                              isPassportRequiredAtTicket,
                          isPassportFullDetailRequiredAtBook:
                              isPassportFullDetailRequiredAtBook,
                          childCount: childTravelers.length + 1,
                          selectedpassenger: null,
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          childTravelers.add(result);
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Limit Exceeded',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                          content: Text(
                            'You can add only $maxChild child passenger(s).',
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFFF37023))),
                    child: Text(
                      '+ ADD NEW CHILD',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF37023),
                      ),
                    ),
                  ),
                ),
            ],
            SizedBox(height: 16.h),

// Infant Travelers (same as child)
            if (widget.infantCount! > 0) ...[
              Row(
                children: [
                  Image.asset("assets/images/Infant.png"),
                  SizedBox(width: 10),
                  Text(
                    'INFANT(<2 Yrs)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${infantTravelers.length} added',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ...infantTravelers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> traveler = entry.value;
                print("infantTravelersinfantTravelers$traveler");
                return Column(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Text(
                              '${traveler['gender']} ${traveler['Firstname']} ${traveler['lastname']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (traveler['wheelchair'])
                              Text(
                                'Wheelchair',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey),
                              ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                final maxInfant =
                                    widget.infantCount?.toInt() ?? 0;
                                print("Max Adults: $maxInfant");
                                var result = await Get.to(
                                  () => AddTravelerPage(
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
                                    initialData: traveler,
                                    travelerType: 'infant',
                                    isPassportRequiredAtTicket:
                                        isPassportRequiredAtTicket,
                                    isPassportFullDetailRequiredAtBook:
                                        isPassportFullDetailRequiredAtBook,
                                    infantCount: infantTravelers.length + 1,
                                    selectedpassenger: null,
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    infantTravelers[index] = result;
                                  });
                                }
                              },
                              child: Icon(Icons.edit, color: Color(0xFFF37023)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                );
              }),
              if (infantTravelers.length < (widget.infantCount?.toInt() ?? 0))
                GestureDetector(
                  onTap: () async {
                    final maxInfant = widget.infantCount?.toInt() ?? 0;
                    print("Max Adults: $maxInfant");
                    var result = await Get.to(
                      () => AddTravelerPage(
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
                        travelerType: 'infant',
                        isPassportRequiredAtTicket: isPassportRequiredAtTicket,
                        isPassportFullDetailRequiredAtBook:
                            isPassportFullDetailRequiredAtBook,
                        infantCount: infantTravelers.length + 1,
                        selectedpassenger: null,
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        infantTravelers.add(result);
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Limit Exceeded',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                          content: Text(
                            'You can add only $maxInfant infant passenger(s).',
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFF37023)),
                    ),
                    child: Text(
                      '+ ADD NEW INFANT',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF37023),
                      ),
                    ),
                  ),
                ),
            ],
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
                    if (adultTravelers.length <
                        (widget.adultCount?.toInt() ?? 0)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Please add all ${widget.adultCount} adult traveler(s)")),
                      );
                    } else if ((widget.childCount ?? 0) > 0 &&
                        childTravelers.length <
                            (widget.childCount?.toInt() ?? 0)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Please add all ${widget.childCount} child traveler(s)")),
                      );
                    } else if ((widget.infantCount ?? 0) > 0 &&
                        infantTravelers.length <
                            (widget.infantCount?.toInt() ?? 0)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Please add all ${widget.infantCount} infant traveler(s)")),
                      );
                    } else {
                      print("adultTravelersContinue$adultTravelers");
                      print("childTravelers$childTravelers");
                      print("infantTravelers$infantTravelers");
                      Get.to(
                        () => ConfirmTravelerDetails(
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
                          initialData: adultTravelers,
                          childData: childTravelers,
                          infantData: infantTravelers,
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
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40.h),
                    backgroundColor: const Color(0xFFF37023),
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

  void showFareBreakupSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        print(widget.othercharges);
        print("sdfdfsf");
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
          convenienceFee: 0,
          coupouncode: coupouncode,
          meal: {},
          seat: [],
          othercharges: othercharges,
          baggage: 0.0,
        );
      },
    );
  }

  Widget _buildTravelerCard(
      String label, String imagePath, VoidCallback onAddTap) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(imagePath, height: 40.h, width: 40.w),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onAddTap,
              child: Text(
                '+ ADD',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF37023),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    String? prefixText,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixText: prefixText,
              prefixStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700)),
              fillColor: Colors.white,
              filled: true,
              label: Text(label),
              focusColor: Colors.orange,
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontSize: 14.sp,
              ),
            ),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class AddTravelerPage extends StatefulWidget {
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
  final Map<String, dynamic>? initialData;
  final Map<String, dynamic>? selectedpassenger;
  final String? travelerType;
  final String? traceid;
  final String? resultindex;
  final bool isPassportRequiredAtTicket;
  final bool isPassportFullDetailRequiredAtBook;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final int? coupouncode;
  final List<Map<String, dynamic>>? segmentsJson; // 4th page uses this
  final bool? isLLC;

  AddTravelerPage({
    required this.flight,
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
    this.isLLC,
    this.duration,
    this.basefare,
    this.tax,
    this.segments,
    this.initialData,
    this.travelerType,
    this.adultCount,
    this.selectedpassenger,
    this.traceid,
    this.resultindex,
    this.coupouncode,
    this.segmentsJson,
    this.childCount,
    this.infantCount,
    required this.isPassportRequiredAtTicket,
    required this.isPassportFullDetailRequiredAtBook,
  });

  @override
  _AddTravelerPageState createState() => _AddTravelerPageState();
}

class _AddTravelerPageState extends State<AddTravelerPage> {
  String selectedGender = "Mr";
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final passportNoController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  final expiryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool requireWheelchair = false;
  bool _submitted = false;

  List<String> nationality = <String>['Indian', 'Saudi', 'Malayasian'];
  String selectedNationality = 'Indian';

  String selectedCountry = 'India';
  List<String> IssusingCountry = <String>['India', 'Saudi', 'Malaysian', 'USA'];
  DateTime? selectedDate;

  late List<String> genderOptions;

  @override
  void initState() {
    super.initState();
    print("AddTravelerPage");

    print(widget.isPassportFullDetailRequiredAtBook);
    print(widget.isPassportRequiredAtTicket);

    if (widget.selectedpassenger != null) {
      selectedGender = widget.selectedpassenger!['gender'];
      firstNameController.text = widget.selectedpassenger!['Firstname'];
      lastNameController.text = widget.selectedpassenger!['lastname'];
      passportNoController.text = widget.selectedpassenger!['Passport No'];
      mobileController.text = widget.selectedpassenger!['mobile'];
      dateController.text = widget.selectedpassenger!['Date of Birth'];
      expiryController.text = widget.selectedpassenger!['Expiry'];
      emailController.text = widget.selectedpassenger!['email'];
    }
    // Determine gender options based on traveler type
    if (widget.travelerType == 'child' || widget.travelerType == 'infant') {
      genderOptions = ['Mstr', 'Ms'];
    } else {
      genderOptions = ['Mr', 'Mrs', 'Ms'];
    }

    if (widget.initialData != null) {
      print(widget.initialData!['gender']);
      print(widget.initialData!['Firstname']);
      print(widget.initialData!['lastname']);
      print("pass${widget.initialData!['Passport No']}");
      print("mobile${widget.initialData!['mobile']}");
      print("email${widget.initialData!['email']}");
      print("birth${widget.initialData!['Date of Birth']}");
      print("expiry${widget.initialData!['Expiry']}");
      print("adultCountadultCountfff${widget.adultCount}");

      selectedGender = widget.initialData!['gender'] ?? genderOptions.first;
      firstNameController.text = widget.initialData!['Firstname'];
      lastNameController.text = widget.initialData!['lastname'];
      passportNoController.text = widget.initialData!['Passport No'];
      mobileController.text = widget.initialData!['mobile'];
      emailController.text = widget.initialData!['email'];
      dateController.text = widget.initialData!['Date of Birth'] ?? '';
      expiryController.text = widget.initialData!['Expiry'] ?? '';
      requireWheelchair = widget.initialData!['wheelchair'];
    } else {
      // Set default gender based on options
      selectedGender = genderOptions.first;
    }
  }

  Future<void> _selectDate(BuildContext context, String travelerType) async {
    final now = DateTime.now();

    DateTime firstDate;
    DateTime lastDate;
    DateTime initialDate;

    if (travelerType == "adult") {
      print("ADULT");
      firstDate = DateTime(1900);
      lastDate = DateTime(now.year - 12, 12, 31);
      initialDate = lastDate;
    } else if (travelerType == "child") {
      print("CHILD");
      firstDate = DateTime(now.year - 12, 1, 1);
      lastDate = DateTime(now.year - 2, 12, 31);
      initialDate = DateTime(now.year - 6, now.month, now.day);
    } else if (travelerType == "infant") {
      print("INFANT");
      firstDate = DateTime(now.year - 2, 1, 1);
      lastDate = DateTime(now.year, 12, 31);
      initialDate = DateTime(now.year - 1, now.month, now.day);
    } else {
      firstDate = DateTime(1900);
      lastDate = now;
      initialDate = now;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

  Future<void> _expiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2225),
    );
    print("psicked date$picked");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        expiryController.text = DateFormat("dd-MM-yyyy").format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Add Traveler',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        child: Form(
          key: _formKey,
          autovalidateMode: _submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              SizedBox(height: 10.h),
              Row(
                children: genderOptions
                    .map((gender) => Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: GenderStatus(
                            label: gender,
                            isSelected: selectedGender == gender,
                            onTap: () {
                              setState(() {
                                selectedGender = gender;
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Please make sure you enter the Name as per your \nGovernment photo id.",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              _buildTextField(
                label: 'First Name(Givenname)',
                hintText: 'Text here',
                controller: firstNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First Name is required';
                  }
                  if (!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+)*$')
                      .hasMatch(value.trim())) {
                    return 'Only letters and spaces are allowed';
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: 'Last Name(Surname)',
                hintText: 'Text here',
                controller: lastNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last Name is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: 'Date of Birth *',
                hintText: 'Select date',
                controller: dateController,
                readOnly: true,
                // important for date picker
                onTap: () => _selectDate(context, widget.travelerType ?? ""),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Date of Birth is required';
                  }
                  return null;
                },
              ),
              if (widget.isPassportFullDetailRequiredAtBook == true) ...[
                // FULL PASSPORT DETAILS (INTERNATIONAL)
                _buildTextField(
                  label: 'Passport No',
                  hintText: '',
                  controller: passportNoController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Passport No is required';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Expiry Date*',
                  hintText: '',
                  controller: expiryController,
                  readOnly: true,
                  onTap: () => _expiryDate(context),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Expiry Date is required';
                    }
                    return null;
                  },
                ),
                // _buildTextField(
                //   label: 'Issue Date*',
                //   hintText: '',
                //   controller: issueDateController,
                //   // ✅ FIXED
                //   readOnly: true,
                //   onTap: () => _expiryDate(context),
                // ),
                // _buildDropdownField(
                //   'Issusing Country *',
                //   selectedCountry,
                //   IssusingCountry,
                //       (value) {
                //     setState(() {
                //       selectedCountry = value!;
                //     });
                //   },
                // ),
              ] else if (widget.isPassportRequiredAtTicket == true) ...[
                // PASSPORT REQUIRED (LIMITED)
                _buildTextField(
                  label: 'Passport No',
                  hintText: '',
                  controller: passportNoController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Passport No is required';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Expiry Date*',
                  hintText: '',
                  controller: expiryController,
                  readOnly: true,
                  onTap: () => _expiryDate(context),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Expiry Date is required';
                    }
                    return null;
                  },
                ),
              ],

              // _buildDropdownField(
              //   'Nationality *',
              //   selectedNationality,
              //   nationality,
              //   (value) {
              //     setState(() {
              //       selectedNationality = value!;
              //     });
              //   },
              // ),
              Text(
                "Contact details",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              _buildTextField(
                label: 'Mobile Number',
                hintText: '',
                controller: mobileController,
                // prefixText: '+91 - ',
                // keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mobile Number is required';
                  }

                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Only numbers are allowed';
                  }

                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }

                  return null;
                },
              ),
              _buildTextField(
                label: 'Email',
                hintText: '',
                controller: emailController,
                // prefixText: '',
                // keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required'; // Email is optional
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }

                  return null;
                },
              ),
              CheckboxListTile(
                value: requireWheelchair,
                onChanged: (v) => setState(() => requireWheelchair = v!),
                title: Text('I require wheelchair (Optional)'),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Color(0xFFF37023),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _submitted = true; // enable validation messages
                  });

                  if (!_formKey.currentState!.validate()) {
                    // ❌ Invalid form → STOP here
                    return;
                  }
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        String typeLabel = '';
                        int count = 0;
                        if (widget.travelerType == 'adult') {
                          typeLabel = 'Adult';
                          count = widget.adultCount ?? 0;
                        } else if (widget.travelerType == 'child') {
                          typeLabel = 'Child';
                          count = widget.childCount ?? 0;
                        } else if (widget.travelerType == 'infant') {
                          typeLabel = 'Infant';
                          count = widget.infantCount ??
                              0; // Now available after adding to constructor
                        } else {
                          typeLabel = 'Traveler'; // Fallback
                          count = 1;
                        }
                        print("typeLabel$typeLabel");
                        print("count$count");

                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 20,
                            ),
                            child: Wrap(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Image.asset(
                                          'assets/icon/cancel.png',
                                          height: 17,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Review Traveller",
                                      style: TextStyle(
                                        color: Color(0xFF444444),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("$typeLabel $count"),
                                    SizedBox(height: 10),
                                    if (widget.travelerType == 'adult')
                                      selectedGender == "Mr"
                                          ? Image.asset('assets/icon/adult.png',
                                              height: 50)
                                          : Image.asset(
                                              'assets/icon/adultFemale.png',
                                              height: 50),
                                    if (widget.travelerType == 'child')
                                      selectedGender == "Mstr"
                                          ? Image.asset('assets/icon/child.png',
                                              height: 50)
                                          : Image.asset(
                                              'assets/icon/adultFemale.png',
                                              height: 50),
                                    if (widget.travelerType == 'infant')
                                      selectedGender == "Mstr"
                                          ? Image.asset(
                                              'assets/icon/infant.png',
                                              height: 50)
                                          : Image.asset(
                                              'assets/icon/adultFemale.png',
                                              height: 50),
                                    SizedBox(height: 10),
                                    Text(
                                      "$selectedGender ${firstNameController.text.trim()} ${lastNameController.text.trim()}",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                /// ⬇️ SPACE AFTER HEADER (FIXED USING PADDING)
                                Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("First Name",
                                          style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15)),
                                      Text(firstNameController.text.trim(),
                                          style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Last Name",
                                          style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15)),
                                      Text(lastNameController.text.trim(),
                                          style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Gender",
                                          style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15)),
                                      Text(
                                        widget.travelerType == 'adult'
                                            ? (selectedGender == "Mr"
                                                ? "Male"
                                                : "Female")
                                            : (selectedGender == "Mstr"
                                                ? "Male"
                                                : "Female"),
                                        style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Date Of Birth",
                                          style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15)),
                                      Text(dateController.text.trim(),
                                          style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),

                                if (widget.isPassportRequiredAtTicket == true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("PassportNo",
                                            style: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 15)),
                                        Text(passportNoController.text.trim(),
                                            style: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),

                                if (widget.isPassportRequiredAtTicket == true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Passport Expiry",
                                            style: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 15)),
                                        Text(expiryController.text.trim(),
                                            style: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),

                                /// ⬇️ SPACE BEFORE BUTTON (FIXED)
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      String genderValue =
                                          selectedGender == "Mr"
                                              ? "Male"
                                              : "Female";

                                      if (_formKey.currentState!.validate()) {
                                        Map<String, dynamic> data = {
                                          'gender': selectedGender,
                                          'Firstname':
                                              firstNameController.text.trim(),
                                          'lastname':
                                              lastNameController.text.trim(),
                                          'mobile':
                                              mobileController.text.trim(),
                                          'email': emailController.text.trim(),
                                          'Passport No':
                                              passportNoController.text.trim(),
                                          'Date of Birth':
                                              dateController.text.trim(),
                                          'Expiry':
                                              expiryController.text.trim(),
                                          'wheelchair': requireWheelchair,
                                          'Nationality': selectedNationality,
                                          'IssusingCountry': selectedCountry,
                                          'typeLable': typeLabel,
                                          'title': genderValue
                                        };

                                        Get.back();
                                        Get.back(result: data);
                                        print("addnewadult$data");
                                        print("jgvgfcf${widget.resultindex}");
                                        print("jgvgfcf${widget.traceid}");
                                        print(widget.selectedpassenger);
                                        if (widget.selectedpassenger != null) {
                                          print("yesss");
                                          print(widget.segmentsJson);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TravelerDetailsPage(
                                                flight: {},
                                                city: widget.city,
                                                destination: widget.destination,
                                                airlineName: widget.airlineName,
                                                airlineCode: widget.airlineCode,
                                                flightNumber:
                                                    widget.flightNumber,
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
                                                desairportName:
                                                    widget.desairportName,
                                                basefare: widget.basefare,
                                                tax: widget.tax,
                                                segmentsJson:
                                                    widget.segmentsJson,
                                                segments: widget.segments,
                                                adultCount: widget.adultCount,
                                                childCount: widget.childCount,
                                                infantCount: widget.infantCount,
                                                selectedpassenger:
                                                    widget.selectedpassenger,
                                                outBoundData: {},
                                                inBoundData: {},
                                                traceid: widget.traceid,
                                                resultindex: widget.resultindex,
                                                coupouncode: widget.coupouncode,
                                                isLLC: widget.isLLC,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Color(0xFFF37023),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Continue",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40.h),
                  backgroundColor: Color(0xFFF37023),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  "CONFIRM",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    bool readOnly = false,
    Function()? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          suffixIcon: (label == "Date of Birth *" || label == "Expiry Date*")
              ? InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.date_range, color: Colors.grey.shade800),
                  ),
                )
              : null,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700)),
          filled: true,
          fillColor: Colors.white,
          label: Text(label),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
        ),
        style: TextStyle(fontSize: 16.sp, color: Colors.black),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class GenderStatus extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderStatus({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 18.w),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFF37023) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? Color(0xFFF37023) : Color(0xFFE6E6E6),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Color(0xFF1C1E1D),
            ),
          ),
        ),
      ),
    );
  }
}

bool isInternationalFromFareQuote(farequote.FareQuotesData fareQuote) {
  final segments = fareQuote.response.results.segments;

  for (var trip in segments) {
    for (var segment in trip) {
      final originCountry = segment.origin.airport.countryCode;
      print("originCountryoriginCountry$originCountry");
      final destinationCountry = segment.destination.airport.countryCode;
      print("destinationCountrydestinationCountry$destinationCountry");

      if (originCountry != 'IN' || destinationCountry != 'IN') {
        return true;
      }
    }
  }
  return false;
}
