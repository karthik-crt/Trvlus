import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:trvlus/Screens/Home_Page.dart';

import '../models/search_data.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';
import 'FlightDetailsPage.dart';
import 'Search_Result_Page.dart';

// Global variables (consider moving to state management if the app grows)
String departureTime = "";
String arrivalTime = "";
String fare = "";
String indepartureTime = "";
String inarrivalTime = "";
int selectedBaggage = 0;
String infare = "";
double total = 0.0;
String finalrounddepDateformat = "";
String finalroundarrDateformat = "";

class Localroundtrip extends StatefulWidget {
  String airportCode;
  String fromAirport;
  String toairportCode;
  String toAirport;
  String selectedDepDate;
  String selectedReturnDate;
  String selectedTripType;
  String adultCount;
  String childCount;
  String infantCount;

  Localroundtrip({super.key,
    required this.airportCode,
    required this.fromAirport,
    required this.toairportCode,
    required this.toAirport,
    required this.selectedDepDate,
    required this.selectedReturnDate,
    required this.selectedTripType,
    required this.adultCount,
    required this.childCount,
    required this.infantCount});

  @override
  State<Localroundtrip> createState() => _LocalroundtripState();
}

class _LocalroundtripState extends State<Localroundtrip> {
  int selectedindex = 0;
  int selectedbuild = 0;
  bool _isButtonVisible = false;
  late SearchData searchData;
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();
  List<Result> outbound = [];
  List<Result> inbound = [];
  Result? selectedOutbound; // Track selected outbound flight
  Result? selectedInbound;

  int adultCount = adults;

  int childCount = children;

  int infantCount = infants; // Track selected inbound flight

  getSearchData(String airportCode,
      String fromAirport,
      String toairportCode,
      String toAirport,
      String selectedDepDate,
      String selectedReturnDate,
      String selectedTripType,) async {
    setState(() {
      isLoading = true;
    });
    searchData = await ApiService().getSearchResult(
        airportCode,
        fromAirport,
        toairportCode,
        toAirport,
        selectedDepDate,
        selectedReturnDate,
        selectedTripType,
        adultCount,
        childCount,
        infantCount);
    outbound = searchData.response.results.first;
    inbound = searchData.response.results.last;

// Set default selected flights
    if (outbound.isNotEmpty) {
      selectedOutbound = outbound.first;
      departureTime = selectedOutbound!.segments.first.first.origin.depTime
          .toString()
          .substring(11, 16);
      DateTime depDateTime = DateTime.parse(
          selectedOutbound!.segments.first.first.origin.depTime.toString());
      finalrounddepDateformat = DateFormat("dd MMM yy").format(depDateTime);
      print('finalrounddepDateformat$finalrounddepDateformat');
      arrivalTime = selectedOutbound!.segments.last.last.destination.arrTime
          .toString()
          .substring(11, 16);
      DateTime arrDateTime = DateTime.parse(
          selectedOutbound!.segments.first.first.origin.depTime.toString());
      finalroundarrDateformat = DateFormat("dd MMM yy").format(arrDateTime);
      print('finalroundarrDateformat$finalroundarrDateformat');
      fare = selectedOutbound!.fare.baseFare.toString();
    }
    if (inbound.isNotEmpty) {
      selectedInbound = inbound.first;
      indepartureTime = selectedInbound!.segments.first.first.origin.depTime
          .toString()
          .substring(11, 16);
      inarrivalTime = selectedInbound!.segments.last.last.destination.arrTime
          .toString()
          .substring(11, 16);
      print('inarrivalTime$inarrivalTime');
      infare = selectedInbound!.fare.baseFare.toString();
    }
    total = (fare.isNotEmpty && infare.isNotEmpty)
        ? double.parse(fare) + double.parse(infare)
        : 0.0;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward &&
          _isButtonVisible) {
        setState(() {
          _isButtonVisible = false;
        });
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse &&
          !_isButtonVisible) {
        setState(() {
          _isButtonVisible = true;
        });
      }
    });
    getSearchData(
        widget.airportCode,
        widget.fromAirport,
        widget.toairportCode,
        widget.toAirport,
        widget.selectedDepDate,
        widget.selectedReturnDate,
        widget.selectedTripType);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFF37023),
            ),
            SizedBox(height: 10),
            Text(
              "Loading...",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    )
        : Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
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
                      "ONWARDS",
                      style: TextStyle(
                          color: Color(0xFF0F9374),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${departureTime} - ${arrivalTime}",
                      style: TextStyle(color: Color(0xFF909090)),
                    ),
                    Text(
                      "₹${fare}",
                      style: TextStyle(color: Color(0xFF606060)),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RETURN",
                      style: TextStyle(
                          color: Color(0xFFD71A21),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${indepartureTime} - ${inarrivalTime}",
                      style: TextStyle(color: Color(0xFF909090)),
                    ),
                    Text(
                      "₹${infare}",
                      style: TextStyle(color: Color(0xFF606060)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "TOTAL PRICE",
                      style: TextStyle(
                          color: Color(0xFFD71A21),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹${total}",
                      style: TextStyle(
                          color: Color(0xFF606060), fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                print("Total Amount$total");
                if (selectedOutbound != null && selectedInbound != null) {
                  print('Navigating to FlightDetailsPage with:');
                  print(
                      'Outbound Flight: ${selectedOutbound!.segments.first.first
                          .airline.airlineName} (${selectedOutbound!.segments
                          .first.first.airline.flightNumber})');
                  print(
                      "selectedOutbound${selectedOutbound!.resultIndex}");
                  print("selectedInbound${selectedInbound!.resultIndex}");
                  print(
                      "selectedOUTboundTIME${selectedOutbound!.segments.first
                          .first.origin.depTime}");
                  print(
                      "selectedOUTboundTIME${selectedOutbound!.segments.last
                          .first.destination.arrTime}");

                  print(
                      'Inbound Flight: ${selectedInbound!.segments.first.first
                          .airline.airlineName} (${selectedInbound!.segments
                          .first.first.airline.flightNumber})');
                  String formatDate(String? dateStr) {
                    if (dateStr == null || dateStr.isEmpty) return '';
                    try {
                      final date = DateTime.parse(dateStr);
                      return DateFormat('E, dd MMM yy').format(date);
                    } catch (e) {
                      return '';
                    }
                  }

                  final outdepDate = selectedOutbound!
                      .segments.first.first.origin.depTime
                      .toString()
                      .substring(0, 10);
                  final outdepdate = formatDate(outdepDate);
                  print("depDate: ${(outdepdate)}");
                  final outdepTime = selectedOutbound!
                      .segments.first.first.origin.depTime
                      .toString()
                      .substring(11, 16);
                  final arrDate = selectedOutbound!
                      .segments.last.last.destination.arrTime
                      .toString()
                      .substring(0, 10);
                  final outarrdate = formatDate(arrDate);
                  print("outarrDate: ${(outarrdate)}");
                  final outarrTime = selectedOutbound!
                      .segments.last.last.destination.arrTime
                      .toString()
                      .substring(11, 16);
                  final refundable =
                  selectedOutbound!.isRefundable == true ? "R" : "NR";
                  print("refundable$refundable");

                  Map<String, dynamic> outBoundData = {
                    "flight": {},
                    "destination": selectedOutbound!
                        .segments.last.last.destination.airport.cityName,
                    "airlineName": selectedOutbound!
                        .segments.first.first.airline.airlineName,
                    "airlineCode": selectedOutbound!
                        .segments.first.first.airline.airlineCode,
                    "cityName": selectedOutbound!
                        .segments.first.first.origin.airport.cityName,
                    "cityCode": selectedOutbound!
                        .segments.first.first.origin.airport.cityCode,
                    "flightNumber": selectedOutbound!
                        .segments.first.first.airline.flightNumber,
                    "descityName": selectedOutbound!.segments.first.first
                        .destination.airport.cityName,
                    "descityCode": selectedOutbound!.segments.first.first
                        .destination.airport.cityCode,
                    "outdepDate": outdepdate,
                    "outdepTime": outdepTime,
                    "outarrDate": outarrdate,
                    "outarrTime": outarrTime,
                    "duration": selectedOutbound!
                        .segments.first.first.duration
                        .toString(),
                    "refundable": refundable,
                    "stop": '',
                    "airportName": selectedOutbound!
                        .segments.first.first.origin.airport.airportName,
                    "desairportName": selectedOutbound!.segments.last.last
                        .destination.airport.airportName,
                    "basefare": selectedOutbound!.fare.baseFare,
                    "tax": selectedOutbound!.fare.tax,
                    "segments": null,
                    "adultCount": adultCount,
                    "childCount": childCount,
                    "infantCount": infantCount,
                    "outresultindex": selectedOutbound?.resultIndex,
                    "traceid": searchData.response.traceId,
                    "total": total.toString(),
                    "IsLCC": selectedOutbound?.isLcc,
                  };
                  print("outBoundData$outBoundData");

                  // INBOUND
                  final indepDate = selectedInbound!
                      .segments.first.first.origin.depTime
                      .toString()
                      .substring(0, 10);
                  final inDepDate = formatDate(indepDate);
                  print("indepdate: ${(inDepDate)}");
                  final indepTime = selectedInbound!
                      .segments.first.first.origin.depTime
                      .toString()
                      .substring(11, 16);
                  final inarrDate = selectedInbound!
                      .segments.last.last.destination.arrTime
                      .toString()
                      .substring(0, 10);
                  final inarrdate = formatDate(inarrDate);
                  print("outarrDate: ${(inarrdate)}");
                  final inarrTime = selectedInbound!
                      .segments.last.last.destination.arrTime
                      .toString()
                      .substring(11, 16);
                  final inrefundable =
                  selectedInbound!.isRefundable == true ? "R" : "NR";
                  print("refundable$inrefundable");
                  print("INBOUND");
                  Map<String, dynamic> inBoundData = {
                    "flight": {},
                    "destination": selectedInbound!
                        .segments.last.last.destination.airport.cityName,
                    "airlineName": selectedInbound!
                        .segments.first.first.airline.airlineName,
                    "cityName": selectedInbound!
                        .segments.first.first.origin.airport.cityName,
                    "airlineCode": selectedInbound!
                        .segments.first.first.airline.airlineCode,
                    "cityCode": selectedInbound!
                        .segments.first.first.origin.airport.cityCode,
                    "flightNumber": selectedInbound!
                        .segments.first.first.airline.flightNumber,
                    "descityName": selectedInbound!.segments.first.first
                        .destination.airport.cityName,
                    "descityCode": selectedInbound!.segments.first.first
                        .destination.airport.cityCode,
                    "indepDate": inDepDate,
                    "indepTime": indepTime,
                    "inarrDate": inarrdate,
                    "inarrTime": inarrTime,
                    "duration": selectedInbound!
                        .segments.first.first.duration
                        .toString(),
                    "refundable": inrefundable,
                    "stop": '',
                    "airportName": selectedInbound!
                        .segments.first.first.origin.airport.airportName,
                    "desairportName": selectedInbound!.segments.last.last
                        .destination.airport.airportName,
                    "basefare": selectedInbound!.fare.baseFare,
                    "tax": selectedInbound!.fare.tax,
                    "segments": null,
                    "adultCount": adultCount,
                    "childCount": childCount,
                    "infantCount": infantCount,
                    "inresultindex": selectedInbound?.resultIndex,
                    "traceid": searchData.response.traceId,
                    "total": total.toString(),
                    "IsLCC": selectedInbound?.isLcc,
                  };
                  print(
                      "inBoundDatatraceid${searchData.response.traceId}");
                  print("inBoundData$inBoundData");
                  print("PASSENGERCOUNT");
                  print(adultCount);
                  print(childCount);
                  print(infantCount);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FlightDetailsPage(
                              outboundFlight: selectedOutbound,
                              inboundFlight: selectedInbound,
                              flight: {},
                              outBoundData: outBoundData,
                              inBoundData: inBoundData,
                              city: '',
                              destination: '',
                              airlineName: '',
                              cityName: '',
                              cityCode: '',
                              flightNumber: '',
                              descityName: '',
                              descityCode: '',
                              outdepDate: selectedOutbound!
                                  .segments.first.first.origin.depTime
                                  .toString()
                                  .substring(0, 10),
                              outdepTime: selectedOutbound!
                                  .segments.first.first.origin.depTime
                                  .toString()
                                  .substring(11, 16),
                              outarrDate: selectedOutbound!
                                  .segments.last.first.destination.arrTime
                                  .toString()
                                  .substring(0, 10),
                              outarrTime: selectedOutbound!
                                  .segments.last.last.destination.arrTime
                                  .toString()
                                  .substring(11, 16),
                              indepDate: selectedInbound!
                                  .segments.first.first.origin.depTime
                                  .toString()
                                  .substring(0, 10),
                              indepTime: selectedInbound!.segments.first.first
                                  .origin.depTime.toString().substring(11, 16),
                              inarrDate: selectedInbound!.segments.last.first
                                  .destination.arrTime.toString().substring(
                                  0, 10),
                              inarrTime: selectedInbound!.segments.last.last
                                  .destination.arrTime.toString().substring(
                                  11, 16),
                              duration: '',
                              refundable: '',
                              stop: '',
                              airportName: '',
                              desairportName: '',
                              basefare: null,
                              segments: null,
                              adultCount: adultCount,
                              childCount: childCount,
                              infantCount: infantCount,
                              outresultindex: selectedOutbound?.resultIndex,
                              inresultindex: selectedInbound?.resultIndex,
                              traceid: searchData.response.traceId,
                              total: total.toString()),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Please select both outbound and inbound flights"),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFF37023)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "View Fare",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xFFF37023),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Colors.grey.shade500,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFFF37023),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${finalrounddepDateformat
                              .toString()} - ${finalroundarrDateformat
                              .toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          'assets/icon/edit.svg',
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Edit details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.fromAirport,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  widget.airportCode,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Text("",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10)),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              "assets/icon/roundtripright.png",
                              width: 25,
                              height: 15,
                            ),
                            Image.asset(
                              "assets/icon/roundtripline.png",
                              width: 70,
                              height: 15,
                            ),
                            Image.asset(
                              "assets/icon/roundtripleft.png",
                              width: 25,
                              height: 15,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.toAirport,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  widget.toairportCode,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Text("",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(12),
                height: 60,
                decoration: BoxDecoration(
                    color: Color(0xFFF37023),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBaggage = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35, vertical: 10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selectedBaggage == 0
                              ? Colors.white
                              : Color(0xFFF37023),
                          borderRadius:
                          BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Text(
                          "${widget.airportCode} - ${widget.toairportCode}",
                          style: TextStyle(
                              color: selectedBaggage == 0
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 0.5,
                      color: Colors.grey.shade200,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBaggage = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35, vertical: 10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selectedBaggage == 1
                              ? Colors.white
                              : Color(0xFFF37023),
                          borderRadius:
                          BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Text(
                          "${widget.toairportCode} - ${widget.airportCode}",
                          style: TextStyle(
                              color: selectedBaggage == 1
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(
          child: CircularProgressIndicator(
            color: Color(0xFFF37023),
          ))
          : ListView(
        controller: _scrollController,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8.h,
            ),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (selectedBaggage == 0
                              ? outbound.length
                              : inbound.length)
                              .toString(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        TextSpan(text: " "),
                        TextSpan(
                          text: "AVAILABLE FLIGHTS",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 25.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16)),
                        ),
                        builder: (context) {
                          return Container(
                            height: 620.h,
                            child: FilterBottomSheet(),
                          );
                        },
                      );
                    },
                    icon: Image.asset(
                      'assets/images/Filter.png',
                      alignment: Alignment.center,
                      height: 12.h,
                      width: 12.w,
                    ),
                    label: Text(
                      "Filter",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        color: Color(0xFF606060),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 3.h, horizontal: 20.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: selectedBaggage == 0
                ? outbound.length
                : inbound.length,
            itemBuilder: (context, index) {
              final flight = selectedBaggage == 0
                  ? outbound[index]
                  : inbound[index];
              int outBoundDuration =
                  flight.segments.first.first.duration;
              int hours = outBoundDuration ~/ 60;
              int minutes = outBoundDuration % 60;
              return FlightCard(
                flight: flight,
                hours: hours,
                minutes: minutes,
                onFlightSelected: (selectedFlight) {
                  setState(() {
                    if (selectedBaggage == 0) {
                      selectedOutbound = selectedFlight;
                      departureTime = selectedFlight
                          .segments.first.first.origin.depTime
                          .toString()
                          .substring(11, 16);
                      arrivalTime = selectedFlight
                          .segments.last.last.destination.arrTime
                          .toString()
                          .substring(11, 16);
                      fare =
                          selectedFlight.fare.baseFare.toString();
                      print('Selected Outbound Flight:');
                      print(
                          'Airline: ${selectedFlight.segments.first.first
                              .airline.airlineName}');
                      print(
                          'Flight Number: ${selectedFlight.segments.first.first
                              .airline.flightNumber}');
                      print(
                          'Departure: ${selectedFlight.segments.first.first
                              .origin.airport.cityName} ($departureTime)');
                      print(
                          'Arrival: ${selectedFlight.segments.last.last
                              .destination.airport.cityName} ($arrivalTime)');
                      print(
                          'Fare: ₹${selectedFlight.fare.baseFare}');
                      print('Fare: ₹${selectedFlight.isLcc}');
                      print(
                          'Refundable: ${selectedFlight.isRefundable
                              ? "Yes"
                              : "No"}');
                      debugPrint(
                          "Full Outbound Flight JSON: ${jsonEncode(
                              selectedFlight.toJson())}",
                          wrapWidth: 1500);
                    } else {
                      selectedInbound = selectedFlight;
                      indepartureTime = selectedFlight
                          .segments.first.first.origin.depTime
                          .toString()
                          .substring(11, 16);
                      inarrivalTime = selectedFlight
                          .segments.last.last.destination.arrTime
                          .toString()
                          .substring(11, 16);
                      infare =
                          selectedFlight.fare.baseFare.toString();
                      print('Selected Inbound Flight:');
                      print(
                          'Airline: ${selectedFlight.segments.first.first
                              .airline.airlineName}');
                      print(
                          'Flight Number: ${selectedFlight.segments.first.first
                              .airline.flightNumber}');
                      print(
                          'Flight Number: ${selectedFlight.isLcc}');
                      print(
                          'Departure: ${selectedFlight.segments.first.first
                              .origin.airport.cityName} ($indepartureTime)');
                      print(
                          'Arrival: ${selectedFlight.segments.last.last
                              .destination.airport.cityName} ($inarrivalTime)');
                      print(
                          'Fare: ₹${selectedFlight.fare.baseFare}');
                      print(
                          'Refundable: ${selectedFlight.isRefundable
                              ? "Yes"
                              : "No"}');
                      debugPrint(
                          "Full Inbound Flight JSON: ${jsonEncode(
                              selectedFlight.toJson())}",
                          wrapWidth: 1500);
                    }
                    total = (fare.isNotEmpty && infare.isNotEmpty)
                        ? double.parse(fare) + double.parse(infare)
                        : 0.0;
                    print('Total Fare: ₹$total');
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FlightCard extends StatefulWidget {
  final Result flight;
  final int hours;
  final int minutes;
  final Function(Result) onFlightSelected;

  const FlightCard({
    super.key,
    required this.flight,
    required this.hours,
    required this.minutes,
    required this.onFlightSelected,
  });

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  bool isExpanded = false;
  int selectedFare = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 8.h,
        top: 0.h,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
            widget.onFlightSelected(widget.flight);
          });
        },
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          elevation: 2,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/${widget.flight.airlineCode}.gif",
                                height: 50,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      widget.flight.segments.first.first.airline
                                          .airlineName,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp)),
                                  RichText(
                                    text: TextSpan(
                                      text: widget.flight.segments.first.first
                                          .airline.airlineCode,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                          color: Colors.grey.shade700),
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w, vertical: 4.h),
                                            child: Container(
                                              width: 4.w,
                                              height: 3.h,
                                              decoration: const BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                            text: widget.flight.segments.first
                                                .first.airline.flightNumber,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.grey),
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2.w,
                                                      vertical: 4.h),
                                                  child: Container(
                                                    width: 4.w,
                                                    height: 3.h,
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: Colors.grey,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        TextSpan(
                                          text: widget.flight.isRefundable
                                              ? "R"
                                              : "NR",
                                          style: Theme
                                              .of(context)
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
                          ],
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${widget.flight.fare.publishedFare}",
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${widget.flight.fare.baseFare}",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "11hrs 15m layover at Mumbai",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.flight.segments.first.first.origin.depTime
                                  .toString()
                                  .substring(11, 16),
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
                          DateFormat("EEE, dd MMM yy").format(
                            DateTime.parse(widget
                                .flight.segments.first.first.origin.depTime
                                .toString()),
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
                        Text(
                          (widget.flight.segments.first.length - 1 == 0)
                              ? "Non Stop"
                              : "${widget.flight.segments.first.length -
                              1} Stop",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        Image.asset('assets/images/flightStop.png'),
                        Text(
                          "${widget.hours}h ${widget.minutes}m",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
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
                              widget
                                  .flight.segments.last.last.destination.arrTime
                                  .toString()
                                  .substring(11, 16),
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
                          DateFormat("EEE, dd MMM yy").format(
                            DateTime.parse(widget
                                .flight.segments.last.last.destination.arrTime
                                .toString()),
                          ),
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.flight.segments.first.first.origin.airport
                                  .cityName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              widget.flight.segments.first.first.origin.airport
                                  .cityCode,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 100),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.flight.segments.first.first.destination
                                  .airport.cityName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              widget.flight.segments.first.first.destination
                                  .airport.cityCode,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                isExpanded
                    ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFFFF4EF)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Radio(
                                  activeColor: Color(0xFFF37023),
                                  visualDensity: VisualDensity(
                                      horizontal: -1, vertical: -3),
                                  value: 1,
                                  groupValue: selectedFare,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFare = value!;
                                    });
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFFFE7DA)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.flight.segments.first.first
                                        .supplierFareClass
                                        .toString()
                                        .isEmpty
                                        ? "Publish Fare"
                                        : widget.flight.segments.first
                                        .first.supplierFareClass
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF1C1E1D)),
                                  ),
                                  Text(
                                    "₹ 5,600",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFFF37023)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/bag.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Cabin Bag",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        widget.flight.segments.first.first
                                            .cabinBaggage,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/checkin.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Check In",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        widget.flight.segments.first.first
                                            .baggage,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/seat.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Seats",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      const Text(
                                        "Free Seats availabel",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/meals.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Meals",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        widget.flight
                                            .isFreeMealAvailable ==
                                            'true'
                                            ? "Included"
                                            : "Not Included",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/cancel.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Cancellation",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        widget.flight.miniFareRules
                                            .isEmpty
                                            ? "Contact Cust.support"
                                            : (() {
                                          final rules = widget
                                              .flight
                                              .miniFareRules[0]
                                              .where((rule) =>
                                          rule.type ==
                                              'Cancellation')
                                              .toList();
                                          if (rules.isEmpty) {
                                            return "Contact Cust.support";
                                          } else if (rules.first
                                              .details.isNotEmpty) {
                                            return "Chargable";
                                          } else {
                                            return "";
                                          }
                                        })(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/ssr/date.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Date Change",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        widget.flight.miniFareRules
                                            .isEmpty
                                            ? "Contact Cust.support"
                                            : (() {
                                          final rules = widget
                                              .flight
                                              .miniFareRules[0]
                                              .where((rule) =>
                                          rule.type ==
                                              'Reissue')
                                              .toList();
                                          if (rules.isEmpty) {
                                            return "Contact Cust.support";
                                          } else if (rules.first
                                              .details.isNotEmpty) {
                                            return "Chargable";
                                          } else {
                                            return "";
                                          }
                                        })(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFFFF4EF)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Radio(
                                  activeColor: Color(0xFFF37023),
                                  visualDensity: VisualDensity(
                                      horizontal: -1, vertical: -3),
                                  value: 2,
                                  groupValue: selectedFare,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFare = value!;
                                    });
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFFFE7DA)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Publish Fare",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF1C1E1D)),
                                  ),
                                  Text(
                                    "₹ 5,600",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFFF37023)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/bag.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Cabin Bag",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        "25",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/checkin.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Check In",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        "25kg",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/seat.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Seats",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      const Text(
                                        "Free Seats availabel",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/meals.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Meals",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      const Text(
                                        "Get complimentary",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ssr/cancel.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Cancellation",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        "Refundable",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/ssr/date.png',
                                        height: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Date Change",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        "Refundable",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(),
                const SizedBox(height: 10),
                Container(
                  height: 25,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFDAE5FF),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5),
                      SvgPicture.asset(
                        "assets/icon/promocode.svg",
                        color: Color(0xFF5D89F0),
                        height: 15,
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Flat 10% Off upto Rs.with trvlus coupon",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
