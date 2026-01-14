import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/models/search_data.dart';
import 'package:trvlus/utils/api_service.dart';
import 'package:trvlus/utils/constant.dart';

import '../models/commissionpercentage.dart';
import '../models/customercommision.dart';
import '../models/farequote.dart' as farequote;
import '../models/farerule.dart';
import '../models/ssr.dart';
import 'DotDivider.dart';
import 'FlightDetailsPage.dart';
import 'Home_Page.dart';

class FlightResultsPage extends StatefulWidget {
  String airportCode;
  String fromAirport;
  SearchData? searchData;

  String toairportCode;
  String toAirport;
  String selectedDepDate;
  String selectedReturnDate;
  String selectedTripType;
  int adultCount;
  int? childCount;
  int? infantCount;

  FlightResultsPage(
      {Key? key,
      required this.airportCode,
      required this.fromAirport,
      required this.toairportCode,
      required this.toAirport,
      required this.selectedDepDate,
      required this.selectedReturnDate,
      required this.selectedTripType,
      required this.adultCount,
      this.childCount,
      this.infantCount,
      this.searchData})
      : super(key: key);

  // get resultindex => null;

  // get traceid => null;
  List<Map<String, dynamic>> dates =
      []; // This will be shared with DateScroller

  @override
  _FlightResultsPageState createState() => _FlightResultsPageState();
}

class _FlightResultsPageState extends State<FlightResultsPage> {
  ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = false;
  double _previousScrollPosition = 0.0;
  late SearchData searchData;
  String currentDepDate =
      ''; // NEW: Track current departure date for display and fetching

  // FILTER
  late List<Map<String, dynamic>> uniqueAirlines;
  Set<String> _selectedAirlineCodes = <String>{};
  int? _selectedStops; // null = no stops filter
  bool _hideNonRefundable =
      false; // false = show all (including non-refundable)
  String?
      _selectedDepartureTimeRange; // e.g., "Before 6 AM", "6 AM-12 Noon", etc.
  String? _selectedArrivalTimeRange;
  List<Map<String, dynamic>> dates = [];
  String? filterorigin;
  String? filterdestination;

  late ComissionPercentage commission;
  late Customercommission customer;
  bool isLoading = true;
  List inbound = [];
  List outbound = [];

  // String formatted = selectedDepDate.toString().substring(33, 44);
  int selectedindex = -1;
  int passengerCount = 0;
  late String currencycode;
  dynamic journeyList;

  String? resultIndex;
  String? traceId;
  String? flightnumber;
  String? origin;
  String? basefare;
  String? fareTax;
  String? destination;
  String? departureDate;
  late FareRuleData fare;
  late farequote.FareQuotesData fareQuote;
  late farequote.FareQuotesData infareQuote;
  late SsrData ssrdata;

  getCommissionData() async {
    setState(() {
      isLoading = true;
    });
    commission = await ApiService().commissionPercentage();
    print("getCommissionData${jsonEncode(commission)}");
    setState(() {
      isLoading = false;
    });
  }

  getCustomerCommission() async {
    setState(() {
      isLoading = true;
    });
    customer = await ApiService().getcustomercommission();
    print("COMMISIONcustomer${jsonEncode(customer)}");
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchFlightsForDate(String depDate) async {
    setState(() {
      isLoading = true;
    });
    searchData = await ApiService().getSearchResult(
        widget.airportCode,
        widget.fromAirport,
        widget.toairportCode,
        widget.toAirport,
        depDate,
        widget.selectedReturnDate,
        widget.selectedTripType,
        widget.adultCount,
        widget.childCount,
        widget.infantCount);
    print("searchDatasearchData$depDate");

    // Recompute unique airlines after fetching new data
    Set<String> codes = <String>{};
    uniqueAirlines = [
      {"name": "All Airlines", "code": null, "logo": "", "price": ""}
    ];
    for (int i = 0; i < searchData.response.results.length; i++) {
      for (int j = 0; j < searchData.response.results[i].length; j++) {
        String code = searchData
            .response.results[i][j].segments.first.first.airline.airlineCode;
        if (!codes.contains(code)) {
          codes.add(code);
          String name = searchData
              .response.results[i][j].segments.first.first.airline.airlineName;
          uniqueAirlines.add({
            "name": name,
            "code": code,
            "logo": "assets/${code}.gif",
            "price": ""
          });
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  getSearchData(
    String airportCode,
    String fromAirport,
    String toairportCode,
    String toAirport,
    String selectedDepDate,
    String selectedReturnDate,
    String selectedTripType,
    int adultCount,
    int? childCount,
    int? infantCount,
  ) async {
    await _fetchFlightsForDate(selectedDepDate); // Reuse the new method
  }

  void _onDateSelected(String newDate) {
    // Update currentDepDate for display
    setState(() {
      currentDepDate = newDate;
    });

    // Update selection in dates list
    for (var d in dates) {
      d['isSelected'] = d['date'] == newDate;
    }

    // Fetch new results
    _fetchFlightsForDate(newDate);
  }

  @override
  void initState() {
    getCommissionData();
    getCustomerCommission();
    currentDepDate = widget.selectedDepDate; // Initialize current date
    loadCalendarPrices();
    final adult = widget.adultCount;
    final child = widget.childCount;
    final infant = widget.infantCount;
    passengerCount = adult + child! + infant!;
    print("passengerCount$passengerCount");
    if (widget.searchData != null) {
      searchData = widget.searchData!;
    }

    // Compute unique airlines(FILTER AIRLINES)
    Set<String> codes = <String>{};
    uniqueAirlines = [
      {"name": "All Airlines", "code": null, "logo": "", "price": ""}
    ];
    for (int i = 0; i < searchData.response.results.length; i++) {
      for (int j = 0; j < searchData.response.results[i].length; j++) {
        String code = searchData
            .response.results[i][j].segments.first.first.airline.airlineCode;
        if (!codes.contains(code)) {
          codes.add(code);
          String name = searchData
              .response.results[i][j].segments.first.first.airline.airlineName;
          uniqueAirlines.add({
            "name": name,
            "code": code,
            "logo": "assets/${code}.gif",
            "price": ""
          });
        }
      }
    }
    final count = widget.adultCount.toString();
    print("adultCount$count");
    final countt = widget.childCount.toString();
    print("childCount$countt");
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
    // getSearchData(
    //     widget.airportCode,
    //     widget.fromAirport,
    //     widget.toairportCode,
    //     widget.toairportCode,
    //     widget.selectedDepDate,
    //     widget.selectedReturnDate,
    //     widget.selectedTripType,
    //     widget.adultCount,
    //     widget.childCount,
    //     widget.infantCount);
  }

  int get currentSelectedIndex {
    if (_selectedAirlineCodes.isEmpty) return 0;
    for (int i = 1; i < uniqueAirlines.length; i++) {
      if (uniqueAirlines[i]["code"] == _selectedAirlineCodes.first) return i;
    }
    return 0;
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> flights = [
    {
      "airline": "Emirates",
      "price": "4,566",
      "logo": "assets/images/Emirates1.png",
      "duration": "Available Seat 30",
      "departure": "Delhi Airport",
      "arrival": "Hyderabad Airport",
      "stops": "1 STOP",
    },
    {
      "airline": "Indigo",
      "price": "4,566",
      "logo": "assets/images/Indigo.png",
      "duration": "Available Seat 0",
      "departure": "Delhi Airport",
      "arrival": "Bengaluru Airport",
      "stops": "1 STOP",
    },
    {
      "airline": "Air India",
      "price": "4,566",
      "logo": "assets/images/AirIndia.png",
      "duration": "Available Seat 15",
      "departure": "Delhi Airport",
      "arrival": "Bengaluru Airport",
      "stops": "1 STOP",
    },
  ];

  // String? resultIndex;
  // String? traceId;
  // String? flightnumber;
  // String? origin;
  // String? basefare;
  // String? fareTax;
  // String? destination;
  // String? departureDate;

  List<List<dynamic>> getFilteredResults() {
    var results = searchData.response.results;
    filterorigin =
        results.first.first.segments.first.first.origin.airport.cityName;
    filterdestination =
        results.last.last.segments.last.last.destination.airport.cityName;
    if (_selectedAirlineCodes.isNotEmpty) {
      results = results
          .map((group) => group
              .where((flight) => _selectedAirlineCodes
                  .contains(flight.segments.first.first.airline.airlineCode))
              .toList())
          .where((g) => g.isNotEmpty)
          .toList();
    }
    if (_selectedStops != null) {
      results = results
          .map((group) => group.where((flight) {
                int stops = flight.segments.first.length - 1;
                if (_selectedStops! >= 2) return stops >= 2;
                return stops == _selectedStops!;
              }).toList())
          .where((g) => g.isNotEmpty)
          .toList();
    }
    if (_hideNonRefundable) {
      // <-- ADD THIS BLOCK
      results = results
          .map((group) => group
              .where((flight) =>
                  flight.isRefundable == true) // Exclude non-refundable
              .toList())
          .where((g) => g.isNotEmpty)
          .toList();
    }
    // ADD THIS BLOCK AFTER THE OTHER FILTERS
    if (_selectedDepartureTimeRange != null &&
        _selectedDepartureTimeRange!.isNotEmpty) {
      results = results
          .map((group) => group.where((flight) {
                DateTime depTime =
                    flight.segments.first.first.origin.depTime.toLocal();
                int hour = depTime.hour;

                bool matches = false;
                switch (_selectedDepartureTimeRange) {
                  case "Before 6 AM":
                    matches = hour < 6;
                    break;
                  case "6 AM-12 Noon":
                    matches = hour >= 6 && hour < 12;
                    break;
                  case "12 Noon-6 PM":
                    matches = hour >= 12 && hour < 18;
                    break;
                  case "6 PM-12 Midnight":
                    matches = hour >= 18;
                    break;
                }
                return matches;
              }).toList())
          .where((g) => g.isNotEmpty)
          .toList();
    }

    if (_selectedArrivalTimeRange != null &&
        _selectedArrivalTimeRange!.isNotEmpty) {
      results = results
          .map((group) => group.where((flight) {
                DateTime arrTime =
                    flight.segments.first.last.destination.arrTime.toLocal();
                int hour = arrTime.hour;

                bool matches = false;
                switch (_selectedArrivalTimeRange) {
                  case "Before 6 AM":
                    matches = hour < 6;
                    break;
                  case "6 AM-12 Noon":
                    matches = hour >= 6 && hour < 12;
                    break;
                  case "12 Noon-6 PM":
                    matches = hour >= 12 && hour < 18;
                    break;
                  case "6 PM-12 Midnight":
                    matches = hour >= 18;
                    break;
                }
                return matches;
              }).toList())
          .where((g) => g.isNotEmpty)
          .toList();
    }
    return results;
  }

  int get totalFlights =>
      getFilteredResults().fold<int>(0, (sum, g) => sum + g.length);

  Future<void> loadCalendarPrices() async {
    try {
      final response = await ApiService().getCalendarFare(
          widget.airportCode, // origin  → e.g., "DEL"
          widget.toairportCode, // destination → e.g., "BOM"
          selectedDepatureDate);

      if (response['Response']['ResponseStatus'] != 1) {
        return; // silent fail
      }

      final List<dynamic> searchResults = response['Response']['SearchResults'];

      // Group by date and find lowest fare per day
      Map<String, double> lowestFareByDate = {};

      for (var item in searchResults) {
        String dateStr = item['DepartureDate']; // "2025-12-12T22:30:00"
        String dateOnly = dateStr.substring(0, 10); // "2025-12-12"
        double fare = item['Fare'].toDouble();

        if (!lowestFareByDate.containsKey(dateOnly) ||
            fare < lowestFareByDate[dateOnly]!) {
          lowestFareByDate[dateOnly] = fare;
        }
      }

      // Now update your existing DateScroller dates list
      final now = DateTime.now();
      final updatedDates = <Map<String, dynamic>>[];

      for (int i = 0; i < 16; i++) {
        DateTime date = now.add(Duration(days: i));
        String dateKey = DateFormat('yyyy-MM-dd').format(date);

        String dayName =
            ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1];
        String monthName = [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ][date.month - 1];

        double? price = lowestFareByDate[dateKey];
        String priceText = price != null ? "₹${price.round()}" : "";

        updatedDates.add({
          "month": "$dayName, ${date.day} $monthName",
          "price": priceText,
          "isSelected": i == 0,
          "date": dateKey, // NEW: Store the actual date key for callback
        });
      }

      // Update the DateScroller from outside (using a callback)
      if (mounted) {
        setState(() {
          dates = updatedDates; // This will update your DateScroller
        });
      }
    } catch (e) {
      print("Calendar API Error: $e");
      // Keep dummy data if API fails
    }
  }

  @override
  Widget build(BuildContext context) {
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
        : getFilteredResults().isNotEmpty &&
                getFilteredResults()
                        .fold(0, (sum, group) => sum + group.length) >
                    0
            ? Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(100),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF37023),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3, color: Colors.grey.shade500)
                            ]),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Color(0xFFF37023),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  currentDepDate.contains("startDate")
                                      ? currentDepDate.substring(33, 43)
                                      : currentDepDate, // UPDATED: Use currentDepDate
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  'assets/icon/edit.svg',
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Edit details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            maxLines: 3,
                                            widget.fromAirport,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.airportCode,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      // "Chennai Airport",
                                      "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/flightStop.png',
                                  color: Colors.white,
                                ),
                                const Spacer(),
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
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          widget.toairportCode,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      // "Hyderbad Airport",
                                      "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            DotDivider(
                              dotSize: 1.h,
                              spacing: 2.r,
                              dotCount: 100,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "${passengerCount.toString()} Traveller",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text(
                                  "Economy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.stars,
                                  color: Colors.white,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                backgroundColor: Colors.grey.shade200,
                body: SingleChildScrollView(
                  //  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateScroller(
                          dates: dates,
                          onDateSelected: _onDateSelected, // NEW: Pass callback
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: searchData
                                            .response.results[0].length
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
                              SizedBox(width: 80.w),
                              Container(
                                height: 25.h,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    List<int> currentIndices = [];
                                    for (String code in _selectedAirlineCodes) {
                                      for (int i = 1;
                                          i < uniqueAirlines.length;
                                          i++) {
                                        // Skip index 0
                                        if (uniqueAirlines[i]['code'] == code) {
                                          currentIndices.add(i);
                                          break;
                                        }
                                      }
                                    }

                                    var filterData = await showModalBottomSheet<
                                        Map<String, dynamic>>(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16)),
                                      ),
                                      builder: (context) {
                                        return Container(
                                          height: 620.h,
                                          child: FilterBottomSheet(
                                            airlines: uniqueAirlines,
                                            currentSelectedIndices:
                                                currentIndices,
                                            filterorigin: filterorigin,
                                            filterdestination:
                                                filterdestination,
                                            initialStops: _selectedStops,
                                            initialHideNonRefundable:
                                                _hideNonRefundable,
                                            initialDepartureTime:
                                                _selectedDepartureTimeRange ??
                                                    "",
                                            initialArrivalTime:
                                                _selectedArrivalTimeRange ?? "",
                                          ),
                                        );
                                      },
                                    );
                                    if (filterData != null) {
                                      setState(() {
                                        List<int> indices =
                                            filterData['airlineIndices'] ?? [];
                                        _selectedAirlineCodes.clear();
                                        for (int i in indices) {
                                          _selectedAirlineCodes.add(
                                              uniqueAirlines[i]['code']
                                                  as String);
                                        }
                                        _selectedStops =
                                            filterData['stops']; // <-- ADD THIS
                                        _hideNonRefundable =
                                            filterData['hideNonRefundable'] ??
                                                false;
                                        _selectedDepartureTimeRange =
                                            filterData['departureTime'];
                                        _selectedArrivalTimeRange =
                                            filterData['arrivalTime'];
                                      });
                                    }
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
                                      fontSize: 10.sp, // Reduced text size
                                      color: Color(0xFF606060),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade100,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.r), // Rounded corners
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: getFilteredResults().length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ...List.generate(
                                      getFilteredResults()[index].length,
                                      (innerIndex) {
                                    int totalMinutes =
                                        getFilteredResults()[index][innerIndex]
                                            .segments
                                            .first
                                            .first
                                            .duration
                                            .toInt(); // <-- ADD .toInt() HERE
                                    String hello = getFilteredResults()[index]
                                        .length
                                        .toString(); // <-- Also fix this debug print to filtered (if not already)
                                    print("helloworld$hello");
                                    int hours =
                                        totalMinutes ~/ 60; // integer division
                                    int minutes =
                                        totalMinutes % 60; // remainder

                                    String formattedDuration =
                                        "${hours}h ${minutes}m";

// LAYOVER CALCULATION
                                    // LAYOVER CALCULATION
                                    double totalFlightMinutes =
                                        0.0; // <-- CHANGE TO DOUBLE FOR SAFE ADDITION
                                    for (var segmentGroup
                                        in getFilteredResults()[index]
                                                [innerIndex]
                                            .segments
                                            .first) {
                                      totalFlightMinutes += segmentGroup
                                          .duration
                                          .toDouble(); // <-- USE .toDouble() FOR PRECISION
                                    }
                                    int totalHours = totalFlightMinutes
                                            .floor() ~/
                                        60; // <-- floor() ENSURES INT BEFORE ~/
                                    int totalMinutesRem =
                                        totalFlightMinutes.floor() % 60;
                                    String formattedTotalDuration =
                                        "${totalHours}h ${totalMinutesRem}m";
                                    String layoverText = "";
                                    int numStops = getFilteredResults()[index]
                                                [innerIndex]
                                            .segments
                                            .first
                                            .length -
                                        1;
                                    if (numStops > 0) {
                                      int layoverMinutes =
                                          getFilteredResults()[index]
                                                  [innerIndex]
                                              .segments
                                              .first[1]
                                              .groundTime
                                              .toInt(); // Already fixed
                                      int layoverHours = layoverMinutes ~/ 60;
                                      int layoverMins = layoverMinutes % 60;

                                      String layoverCity =
                                          getFilteredResults()[index]
                                                  [innerIndex]
                                              .segments
                                              .first[1]
                                              .origin
                                              .airport
                                              .cityName;

                                      layoverText =
                                          "${layoverHours}h ${layoverMins}m layover at $layoverCity";
                                    } else {
                                      layoverText = "";
                                    }

                                    // TOTAL DURATION CALCULATION
                                    var segments = getFilteredResults()[index]
                                            [innerIndex]
                                        .segments
                                        .first;
                                    String displayTotalDuration =
                                        formattedTotalDuration; // Default to flight-only

                                    if (numStops > 0) {
                                      DateTime firstDepTime =
                                          segments.first.origin.depTime;
                                      DateTime lastArrTime =
                                          segments.last.destination.arrTime;
                                      int totalTripMinutes = lastArrTime
                                          .difference(firstDepTime)
                                          .inMinutes;
                                      int totalTripHours =
                                          totalTripMinutes ~/ 60;
                                      int totalTripMins = totalTripMinutes % 60;
                                      displayTotalDuration =
                                          "${totalTripHours}h ${totalTripMins}m"; // e.g., "9h 0m"
                                      print(
                                          "displayTotalDuration$displayTotalDuration");
                                      print(
                                          "displayTotalDuration (Total Trip)$displayTotalDuration");
                                    } else {
                                      print(
                                          "displayTotalDuration (Non-Stop)$displayTotalDuration");
                                    }
                                    // FARE CALCULATION
                                    String publishFare =
                                        getFilteredResults()[index][innerIndex]
                                            .fare
                                            .publishedFare
                                            .toString();
                                    print("publishFare$publishFare");
                                    String offeredFare =
                                        getFilteredResults()[index][innerIndex]
                                            .fare
                                            .offeredFare
                                            .toString();
                                    print("offeredFare$offeredFare");
                                    // -----------------------CUSTOMER COMMISSION CALCULATION--------------------- //
                                    double tboTDS = getFilteredResults()[index]
                                            [innerIndex]
                                        .fare
                                        .tdsOnCommission
                                        .toDouble();
                                    print("tboTDS$tboTDS");
                                    final commissionEarned =
                                        getFilteredResults()[index][innerIndex]
                                            .fare
                                            .commissionEarned
                                            .toDouble();
                                    print("commissionEarned$commissionEarned");

                                    // final commissionEarned =
                                    //     getFilteredResults()[index][innerIndex]
                                    //             .fare
                                    //             .commissionEarned
                                    //             .toDouble() -
                                    //         tboTDS;
                                    // print("commissionEarned_one$commissionEarned)
                                    // NEW: Calculate customer commission based on tiers
                                    double customerComm = 0.0;
                                    if (customer.data.isNotEmpty) {
                                      var commData = customer.data[0];
                                      double earned =
                                          commissionEarned; // For readability
                                      if (earned >= 0 && earned <= 50) {
                                        customerComm = commData.commission_0_50
                                                ?.toDouble() ??
                                            0.0;
                                      } else if (earned <= 100) {
                                        customerComm = commData
                                                .commission_50_100
                                                ?.toDouble() ??
                                            0.0;
                                      } else if (earned <= 150) {
                                        customerComm = commData
                                                .commission_100_150
                                                ?.toDouble() ??
                                            0.0;
                                      } else if (earned <= 200) {
                                        customerComm = commData
                                                .commission_150_200
                                                ?.toDouble() ??
                                            0.0;
                                      } else if (earned <= 250) {
                                        customerComm = commData
                                                .commission_200_250
                                                ?.toDouble() ??
                                            0.0;
                                      } else if (earned <= 300) {
                                        customerComm = commData
                                                .commission_250_300
                                                ?.toDouble() ??
                                            0.0;
                                      } else {
                                        customerComm = commData
                                                .commission_above_300
                                                ?.toDouble() ??
                                            0.0;
                                      }
                                    }
                                    print(
                                        "customerComm: $customerComm"); // Optional: For debugging
                                    double customercommissiondetection =
                                        commissionEarned - customerComm;
                                    double finalcustomercommission =
                                        customercommissiondetection *
                                            passengerCount;
                                    print(
                                        "customercommissiondetection$customercommissiondetection");
                                    print(
                                        "finalcustomercommission$finalcustomercommission");
                                    // ----------------------------------------------------------------------------//
                                    double publishFareVal =
                                        double.tryParse(publishFare) ?? 0;
                                    double offeredFareVal =
                                        double.tryParse(offeredFare) ?? 0;
                                    // COMMISIONPERCENTAGE
                                    double commissionpercentage = commission
                                            .data.first.commissionforgds
                                            .toDouble() *
                                        passengerCount;
                                    print(
                                        "commissionpercentage$commissionpercentage");
                                    int passengercount = passengerCount;
                                    print("passengercount$passengercount");

                                    // COMMISSION
                                    double commissionraw =
                                        publishFareVal - offeredFareVal;
                                    double owncommision = double.parse(
                                        (commissionEarned * 0.02)
                                            .toStringAsFixed(2));
                                    // print("owncommision$owncommision");

                                    // calculation
                                    double tbooverallCommision =
                                        commissionEarned - tboTDS;
                                    print(
                                        "tbooverallCommision$tbooverallCommision");
                                    //  ---------------------------------------------//
                                    double toubikcommisionearned =
                                        tbooverallCommision -
                                            commissionpercentage;
                                    print(
                                        "toubikcommisionearned$toubikcommisionearned");
                                    // -------------------------------------------------//
                                    double toubiktdsoncommision = double.parse(
                                        (toubikcommisionearned * 0.02)
                                            .toStringAsFixed(2));
                                    print(
                                        "toubiktdsoncommision$toubiktdsoncommision");
                                    double tdsplb = getFilteredResults()[index]
                                            [innerIndex]
                                        .fare
                                        .tdsOnPlb
                                        .toDouble();
                                    print("tdsplb$tdsplb");

                                    // NETFARE
                                    int offFare = (double.parse(
                                                offeredFare.toString()) +
                                            double.parse(tboTDS.toString()) +
                                            double.parse(toubiktdsoncommision
                                                .toString()) +
                                            double.parse(tdsplb.toString()) +
                                            double.parse(commissionpercentage
                                                .toString()))
                                        .round();
                                    print("offFare$offFare");

                                    // COUPOUN
                                    int coupon = (double.parse(
                                                publishFare.toString()) -
                                            double.parse(offFare.toString()))
                                        .round();
                                    print("coupon$coupon");

                                    int baseFare =
                                        (double.parse(publishFare.toString()) -
                                                double.parse(coupon.toString()))
                                            .round();
                                    print("baseFare$baseFare");

                                    return GestureDetector(
                                      onTap: () {
                                        print(
                                            "hello${searchData.response.results[index][innerIndex].isExpanded}");
                                        setState(() {
                                          getFilteredResults()[index]
                                                      [innerIndex]
                                                  .isExpanded =
                                              !getFilteredResults()[index]
                                                      [innerIndex]
                                                  .isExpanded;
                                          selectedindex = innerIndex;
                                        });
                                      },
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 16.w,
                                            right: 16.w,
                                            bottom: 8.h,
                                            top: 0.h,
                                          ),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r)),
                                            elevation: 2,
                                            color: Colors.white,
                                            // color: selectedindex == innerIndex
                                            //     ? Colors.orange.shade50
                                            //     : const Color(0xFFFFFFFF),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.r),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      /*  Image.asset(
                                                flight["logo"], // Airline logo
                                                height: 40.h,
                                                width: 40.w,
                                              ),*/
                                                      SizedBox(width: 12.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                // adjust radius
                                                                child:
                                                                    Image.asset(
                                                                  "assets/${getFilteredResults()[index][innerIndex].segments.first.first.airline.airlineCode}.gif",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  height: 35,
                                                                  width: 35,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                width: 120,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        getFilteredResults()[index][innerIndex]
                                                                            .segments
                                                                            .first
                                                                            .first
                                                                            .airline
                                                                            .airlineName,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 14.sp)),
                                                                    RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        text: getFilteredResults()[index][innerIndex]
                                                                            .airlineCode,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall
                                                                            ?.copyWith(color: Colors.grey.shade700),
                                                                        children: [
                                                                          WidgetSpan(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
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
                                                                              text: getFilteredResults()[index][innerIndex].segments.first.first.airline.flightNumber,
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12.sp, color: Colors.grey),
                                                                              children: [
                                                                                WidgetSpan(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
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
                                                                              ]),
                                                                          TextSpan(
                                                                            text: getFilteredResults()[index][innerIndex].isRefundable
                                                                                ? "R"
                                                                                : "NR",
                                                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                                                          SizedBox(
                                                            // height: 2.h,
                                                            width: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "${""} ${getFilteredResults()[index][innerIndex].fare.publishedFare}",
                                                              style: const TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "${""} $offFare",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color:
                                                                      primaryColor,
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              layoverText,
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 2.h,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: DotDivider(
                                                      dotSize: 1.h,
                                                      spacing: 2.r,
                                                      dotCount: 97,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                getFilteredResults()[
                                                                            index]
                                                                        [
                                                                        innerIndex]
                                                                    .segments
                                                                    .first
                                                                    .first
                                                                    .origin
                                                                    .depTime
                                                                    .toLocal()
                                                                    .toString()
                                                                    .substring(
                                                                        11, 16),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 4.w),
                                                            ],
                                                          ),
                                                          Text(
                                                            getFilteredResults()[
                                                                        index]
                                                                    [innerIndex]
                                                                .segments
                                                                .first
                                                                .first
                                                                .origin
                                                                .depTime
                                                                .toLocal()
                                                                .toString()
                                                                .substring(
                                                                    0, 10),
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            (getFilteredResults()[index][innerIndex]
                                                                            .segments
                                                                            .first
                                                                            .length -
                                                                        1) ==
                                                                    0
                                                                ? "Non-Stop"
                                                                : "${getFilteredResults()[index][innerIndex].segments.first.length - 1} stop",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                          Image.asset(
                                                              'assets/images/flightStop.png'),
                                                          Text(
                                                            displayTotalDuration,
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                getFilteredResults()[
                                                                            index]
                                                                        [
                                                                        innerIndex]
                                                                    .segments
                                                                    .last
                                                                    .last
                                                                    .destination
                                                                    .arrTime
                                                                    .toLocal()
                                                                    .toString()
                                                                    .substring(
                                                                        11, 16),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 4.w),
                                                            ],
                                                          ),
                                                          Text(
                                                            getFilteredResults()[
                                                                        index]
                                                                    [innerIndex]
                                                                .segments
                                                                .last
                                                                .last
                                                                .destination
                                                                .arrTime
                                                                .toLocal()
                                                                .toString()
                                                                .substring(
                                                                    0, 10),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                getFilteredResults()[
                                                                            index]
                                                                        [
                                                                        innerIndex]
                                                                    .segments
                                                                    .first
                                                                    .first
                                                                    .origin
                                                                    .airport
                                                                    .cityName,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 4.w),
                                                              Text(
                                                                getFilteredResults()[
                                                                            index]
                                                                        [
                                                                        innerIndex]
                                                                    .segments
                                                                    .first
                                                                    .first
                                                                    .origin
                                                                    .airport
                                                                    .cityCode,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 100,
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                getFilteredResults()[
                                                                            index]
                                                                        [
                                                                        innerIndex]
                                                                    .segments
                                                                    .first
                                                                    .last
                                                                    .destination
                                                                    .airport
                                                                    .cityName,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 4.w),
                                                              Text(
                                                                getFilteredResults()[
                                                                            index]
                                                                        [
                                                                        innerIndex]
                                                                    .segments
                                                                    .first
                                                                    .last
                                                                    .destination
                                                                    .airport
                                                                    .cityCode,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ...List.generate(
                                                      getFilteredResults()[
                                                              index][innerIndex]
                                                          .segments
                                                          .length,
                                                      (segmentsindex) {
                                                    return getFilteredResults()[
                                                                        index]
                                                                    [innerIndex]
                                                                .isExpanded &&
                                                            selectedindex ==
                                                                innerIndex
                                                        ? Column(
                                                            children: [
                                                              ...List.generate(
                                                                  getFilteredResults()[
                                                                              index]
                                                                          [
                                                                          innerIndex]
                                                                      .segments[
                                                                          segmentsindex]
                                                                      .length,
                                                                  (segmentsindex) {
                                                                return Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5),
                                                                  height: 290,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: const Color(
                                                                          0xFFFFF4EF)),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: const Color(0xFFFFE7DA)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              getFilteredResults()[index][innerIndex].segments.first.first.supplierFareClass.toString().isEmpty ? "Publish Fare" : getFilteredResults()[index][innerIndex].segments.first.first.supplierFareClass.toString(),
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1C1E1D)),
                                                                            ),
                                                                            Text(
                                                                              "${""} ${getFilteredResults()[index][innerIndex].fare.baseFare.toString().isEmpty ? " " : getFilteredResults()[index][innerIndex].fare.baseFare}",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFF37023)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Image.asset(
                                                                                  'assets/ssr/bag.png',
                                                                                  height: 16,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    "Cabin Bag",
                                                                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  getFilteredResults()[index][innerIndex].segments.first.first.cabinBaggage.toString(),
                                                                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Image.asset(
                                                                                  'assets/ssr/checkin.png',
                                                                                  height: 16,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    "Check In",
                                                                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  getFilteredResults()[index][innerIndex].segments.first.first.baggage.toString(),
                                                                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Image.asset(
                                                                                  'assets/ssr/seat.png',
                                                                                  height: 16,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    "Seats",
                                                                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                  ),
                                                                                ),
                                                                                const Text(
                                                                                  "Included",
                                                                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Image.asset(
                                                                                  'assets/ssr/meals.png',
                                                                                  height: 16,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    "Meals",
                                                                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  getFilteredResults()[index][innerIndex].isFreeMealAvailable == 'true' ? "Included" : "Not Included",
                                                                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Image.asset(
                                                                                  'assets/ssr/cancel.png',
                                                                                  height: 16,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    "Cancellation",
                                                                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  getFilteredResults()[index][innerIndex].miniFareRules.isEmpty
                                                                                      ? "Contact Cust.support"
                                                                                      // : searchData.response.results[index][innerIndex].miniFareRules[0].firstWhere((rule) => rule.type == 'Cancellation').details.isNotEmpty
                                                                                      //     ? "Chargable"
                                                                                      : "Not Chargable",
                                                                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Image.asset(
                                                                                  'assets/ssr/date.png',
                                                                                  height: 16,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    "Date Change",
                                                                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  getFilteredResults()[index][innerIndex].miniFareRules.isEmpty
                                                                                      ? "Contact Cust.support"
                                                                                      : getFilteredResults()[index][innerIndex].miniFareRules[0].firstWhere((rule) => rule.type == 'Reissue').details.isNotEmpty
                                                                                          ? "Chargable"
                                                                                          : "",
                                                                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                var currentFlight = getFilteredResults()[index][innerIndex]; // <-- ADD THIS HELPER VAR FOR CLEANLINESS
                                                                                resultIndex = currentFlight.resultIndex;
                                                                                print("resultIndexresultIndex$resultIndex");
                                                                                final prefs = await SharedPreferences.getInstance();
                                                                                final resultindex = await prefs.setString('ResultIndex', resultIndex!);
                                                                                print("resultindex$resultindex");

                                                                                traceId = searchData.response.traceId; // This is global, fine
                                                                                final prefstraceid = await SharedPreferences.getInstance();
                                                                                final traceid = await prefstraceid.setString('TraceId', traceId!);
                                                                                print("traceid$traceid");

                                                                                flightnumber = currentFlight.segments.first.first.airline.flightNumber;
                                                                                final prefsflight = await SharedPreferences.getInstance();
                                                                                final flightNumber = await prefsflight.setString('FlightNumber', flightnumber!);
                                                                                print("flightNumber$flightNumber");

                                                                                basefare = currentFlight.fare.baseFare.toString();
                                                                                print("basefarebasefare$basefare");
                                                                                final fare = await SharedPreferences.getInstance();
                                                                                final baseFare = await fare.setString('BaseFare', basefare!);
                                                                                fareTax = currentFlight.fare.tax.toString();
                                                                                print("fareTax$fareTax");
                                                                                final tax = await fare.setString('Tax', fareTax!);

                                                                                origin = searchData.response.results[index][innerIndex].fare.baseFare.toString(); // Global, fine
                                                                                final fromorigin = await fare.setString('Origin', origin!);
                                                                                print("origin$origin");
                                                                                origin = searchData.response.origin; // Global, fine

                                                                                destination = searchData.response.destination; // Global, fine
                                                                                final todestination = await fare.setString('Destination', destination!);
                                                                                print("destination$destination");
                                                                                departureDate = currentFlight.segments.first.first.origin.depTime.toLocal().toString().substring(0, 10);
                                                                                final depDate = await fare.setString('depTime', departureDate!);

                                                                                // JOURNEYLIST (segmentListJson loop) - Replace inner accesses too
                                                                                List<Map<String, dynamic>> segmentListJson = [];

                                                                                for (var segmentGroup in currentFlight.segments) {
                                                                                  // Calculate total journey duration (first dep → last arrival)
                                                                                  final firstSegment = segmentGroup.first;
                                                                                  final lastSegment = segmentGroup.last;
                                                                                  final totalDurationMinutes = lastSegment.destination.arrTime.difference(firstSegment.origin.depTime).inMinutes;
                                                                                  final totalHours = totalDurationMinutes ~/ 60;
                                                                                  final totalMinutes = totalDurationMinutes % 60;
                                                                                  final totalDurationText = "${totalHours}h ${totalMinutes}m";

                                                                                  for (var segment in segmentGroup) {
                                                                                    String layoverText = "";
                                                                                    int currentIndex = segmentGroup.indexOf(segment);
                                                                                    if (currentIndex > 0) {
                                                                                      final prevSegment = segmentGroup[currentIndex - 1];
                                                                                      DateTime prevArrival = prevSegment.destination.arrTime;
                                                                                      DateTime nextDeparture = segment.origin.depTime;
                                                                                      final layoverMinutes = nextDeparture.difference(prevArrival).inMinutes;
                                                                                      final hours = layoverMinutes ~/ 60;
                                                                                      final mins = layoverMinutes % 60;
                                                                                      layoverText = "${hours}h ${mins}m layover at ${prevSegment.destination.airport.cityName}";
                                                                                      print("layoverTextlayoverText$layoverText");
                                                                                    }

                                                                                    final DateTime depTime = segment.origin.depTime;
                                                                                    final String formatteddepDate = DateFormat("dd MMM yy").format(depTime);
                                                                                    final DateTime arrTime = segment.destination.arrTime;
                                                                                    final String formattedarrDate = DateFormat("dd MMM yy").format(arrTime);

                                                                                    final stop = (currentFlight.segments.first.length - 1) == 0 ? "Non-Stop" : "${currentFlight.segments.first.length - 1} stop";
                                                                                    final duration = segment.duration.toString();

                                                                                    segmentListJson.add({
                                                                                      "airlineName": segment.airline.airlineName,
                                                                                      "airlineCode": segment.airline.airlineCode,
                                                                                      "flightNumber": segment.airline.flightNumber,
                                                                                      "fromCity": segment.origin.airport.cityName,
                                                                                      "fromCode": segment.origin.airport.cityCode,
                                                                                      "toCity": segment.destination.airport.cityName,
                                                                                      "toCode": segment.destination.airport.cityCode,
                                                                                      "departure": formatteddepDate,
                                                                                      "depTime": segment.origin.depTime.toString().substring(11, 16),
                                                                                      "arrival": formattedarrDate,
                                                                                      "arrTime": segment.destination.arrTime.toString().substring(11, 16),
                                                                                      "duration": segment.duration.toString(),
                                                                                      "durationTime": totalDurationText,
                                                                                      // <-- Overall journey duration
                                                                                      "fromAirport": segment.origin.airport.airportName,
                                                                                      "fromAirportCode": segment.origin.airport.airportCode,
                                                                                      "toAirport": segment.destination.airport.airportName,
                                                                                      "toAirportCode": segment.destination.airport.airportCode,
                                                                                      "layover": layoverText,
                                                                                      "noofstop": stop,
                                                                                    });
                                                                                  }
                                                                                }

                                                                                print("segmentListJsonsegmentListJson${jsonEncode(segmentListJson)}");

                                                                                // FARE BREAKDOWN
                                                                                final fareBreakdown = currentFlight.fareBreakdown; // <-- Changed
                                                                                print("fareBreakdownfareBreakdown ${jsonEncode(fareBreakdown)}");

                                                                                // Default values
                                                                                double adultBase = 0, adultTax = 0;
                                                                                double childBase = 0, childTax = 0;
                                                                                double infantBase = 0, infantTax = 0;

                                                                                for (var item in fareBreakdown) {
                                                                                  if (item.passengerType == 1) {
                                                                                    adultBase = item.baseFare.toDouble();
                                                                                    adultTax = item.tax.toDouble();
                                                                                  } else if (item.passengerType == 2) {
                                                                                    childBase = item.baseFare.toDouble();
                                                                                    childTax = item.tax.toDouble();
                                                                                  } else if (item.passengerType == 3) {
                                                                                    infantBase = item.baseFare.toDouble();
                                                                                    print("infantBaseinfantBase$infantBase");
                                                                                    infantTax = item.tax.toDouble();
                                                                                  }
                                                                                }

                                                                                final fareee = currentFlight.fare.baseFare.toString();
                                                                                print("adultBase$adultBase");
                                                                                print("childBase$childBase");
                                                                                print("infantBase$infantBase");
                                                                                print("basefareeeee$fareee");
                                                                                print("efwefwe${searchData.response.traceId}");
                                                                                print("efwefwe${currentFlight.resultIndex}");

                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => FlightDetailsPage(
                                                                                              flight: const {},
                                                                                              city: 'mdu',
                                                                                              destination: 'chennai',
                                                                                              airlineName: currentFlight.segments.first.first.airline.airlineName,
                                                                                              // <-- All changed to currentFlight
                                                                                              airlineCode: currentFlight.segments.first.first.airline.airlineCode,
                                                                                              airportName: currentFlight.segments.first.first.origin.airport.airportName,
                                                                                              desairportName: currentFlight.segments.first.last.destination.airport.airportName,
                                                                                              cityName: currentFlight.segments.first.first.origin.airport.cityName,
                                                                                              cityCode: currentFlight.segments.first.first.origin.airport.cityCode,
                                                                                              descityName: currentFlight.segments.first.last.destination.airport.cityName,
                                                                                              descityCode: currentFlight.segments.first.last.destination.airport.cityCode,
                                                                                              flightNumber: currentFlight.segments.first.first.airline.flightNumber,
                                                                                              depDate: currentFlight.segments.first.first.origin.depTime.toLocal().toString().substring(0, 10),
                                                                                              depTime: currentFlight.segments.first.first.origin.depTime.toLocal().toString().substring(11, 16),
                                                                                              refundable: currentFlight.isRefundable ? "R" : "NR",
                                                                                              // <-- Fixed to current
                                                                                              arrDate: currentFlight.segments.last.last.destination.arrTime.toLocal().toString().substring(0, 10),
                                                                                              arrTime: currentFlight.segments.last.last.destination.arrTime.toLocal().toString().substring(11, 16),
                                                                                              stop: (currentFlight.segments.first.length - 1) == 0 ? "Non-Stop" : "${currentFlight.segments.first.length - 1} stop",
                                                                                              duration: "${hours}h ${minutes}m",
                                                                                              isLLC: currentFlight.isLcc,
                                                                                              cabinBaggage: currentFlight.segments.first.first.cabinBaggage,
                                                                                              baggage: currentFlight.segments.first.first.baggage,
                                                                                              basefare: currentFlight.fare.baseFare,
                                                                                              tax: currentFlight.fare.tax,
                                                                                              adultCount: widget.adultCount,
                                                                                              childCount: widget.childCount,
                                                                                              infantCount: widget.infantCount,
                                                                                              adultBaseFare: adultBase,
                                                                                              adultTax: adultTax,
                                                                                              childBaseFare: childBase,
                                                                                              childTax: childTax,
                                                                                              infantBaseFare: infantBase,
                                                                                              infantTax: infantTax,
                                                                                              segments: currentFlight.segments,
                                                                                              // <-- Changed
                                                                                              segmentsJson: segmentListJson,
                                                                                              resultindex: currentFlight.resultIndex,
                                                                                              traceid: searchData.response.traceId,
                                                                                              coupouncode: coupon,
                                                                                              // Global, fine
                                                                                              reissue: (() {
                                                                                                try {
                                                                                                  if (currentFlight.miniFareRules.isNotEmpty) {
                                                                                                    // <-- Changed
                                                                                                    return currentFlight.miniFareRules[0].firstWhere((rule) => rule.type == 'Reissue').details ?? "No data";
                                                                                                  } else {
                                                                                                    return "No data";
                                                                                                  }
                                                                                                } catch (e) {
                                                                                                  return "No data";
                                                                                                }
                                                                                              })(),
                                                                                              journeypoint: (() {
                                                                                                try {
                                                                                                  if (currentFlight.miniFareRules.isNotEmpty) {
                                                                                                    // <-- Changed
                                                                                                    return currentFlight.miniFareRules[0].first.journeyPoints ?? "No data";
                                                                                                  } else {
                                                                                                    return "No data";
                                                                                                  }
                                                                                                } catch (e) {
                                                                                                  return "No data";
                                                                                                }
                                                                                              })(),
                                                                                              cancellation: (() {
                                                                                                try {
                                                                                                  if (currentFlight.miniFareRules.isNotEmpty) {
                                                                                                    // <-- Changed
                                                                                                    return currentFlight.miniFareRules[0].firstWhere((rule) => rule.type == 'Cancellation').details ?? "No data";
                                                                                                  } else {
                                                                                                    return "No data";
                                                                                                  }
                                                                                                } catch (e) {
                                                                                                  return "No data";
                                                                                                }
                                                                                              })(),
                                                                                              outBoundData: {},
                                                                                              inBoundData: {},
                                                                                              //
                                                                                              commonPublishedFare: publishFare,
                                                                                              tboOfferedFare: offeredFare,
                                                                                              tboCommission: commissionpercentage,
                                                                                              tboTds: tboTDS,
                                                                                              trvlusCommission: toubikcommisionearned,
                                                                                              trvlusTds: toubiktdsoncommision,
                                                                                              trvlusNetFare: offFare,
                                                                                            )));
                                                                              },
                                                                              child: Container(
                                                                                height: 40,
                                                                                width: MediaQuery.sizeOf(context).width,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  color: const Color(0xFFF37023),
                                                                                ),
                                                                                alignment: Alignment.center,
                                                                                child: const Text(
                                                                                  "Book Now",
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              })
                                                            ],
                                                          )
                                                        : const SizedBox
                                                            .shrink();
                                                  }),
                                                  Container(
                                                    height: 25,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Color(0xFFDAE5FF),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        SvgPicture.asset(
                                                          "assets/icon/promocode.svg",
                                                          color:
                                                              Color(0xFF5D89F0),
                                                          height: 15,
                                                          width: 20,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          // "Flat 10% Off upto Rs.${coupon}with trvlus coupon",
                                                          "Flat ₹$coupon OFF—only on Trvuls.",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: AnimatedOpacity(
                  opacity: _isButtonVisible ? 1.0 : 0.0,
                  // opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    height: 45.h, // Reduced height
                    width: 50.w, // Reduced width
                    child: FloatingActionButton(
                      onPressed: () {
                        _scrollController.animateTo(
                          0.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: 30
                            .r, // Adjust the icon size to match the button size
                        color: Colors.white,
                      ),
                      backgroundColor: const Color(0xFFF37023),
                      shape: const CircleBorder(),
                      elevation: 6,
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icon/noFlight.png",
                        height: 70,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          "No flights are available for the selected date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      )
                      // ElevatedButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       // Reset all filters
                      //       _selectedAirlineCode = null;
                      //       _selectedStops = null;
                      //       _hideNonRefundable = false;
                      //       _selectedDepartureTimeRange = null;
                      //       _selectedArrivalTimeRange = null;
                      //     });
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Color(0xFFF37023),
                      //   ),
                      //   child: Text(
                      //     "Clear Filters",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> airlines;
  final List<int>? currentSelectedIndices;
  final int? initialStops;
  final bool initialHideNonRefundable;
  final String initialDepartureTime;
  final String initialArrivalTime;
  final String? filterorigin;
  final String? filterdestination;

  const FilterBottomSheet({
    Key? key,
    required this.airlines,
    this.currentSelectedIndices,
    this.filterorigin,
    this.filterdestination,
    this.initialStops, // optional
    this.initialHideNonRefundable = false,
    this.initialDepartureTime = "",
    this.initialArrivalTime = "",
  }) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool hideNonRefundable = false;
  int? selectedStops;
  String departureTime = "";
  String arrivalTime = "";
  Set<int> selectedAirlineIndices = <int>{};

  // final List<Map<String, String>> airlines = List.generate(
  //   10,
  //   (index) => {
  //     "name": "Emirates",
  //     "price": "₹500",
  //     "logo": "assets/images/Emirates.png",
  //   },
  // );
  int? selectedAirlineIndex;

  int? get selectedStopsValue => selectedStops; // Expose for return
  bool get hideNonRefundableValue => hideNonRefundable; // Expose for return

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedAirlineIndices =
        Set<int>.from(widget.currentSelectedIndices ?? <int>[]);
    selectedStops = widget.initialStops;
    hideNonRefundable = widget.initialHideNonRefundable;
    departureTime = widget.initialDepartureTime;
    arrivalTime = widget.initialArrivalTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Filters",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: const Color(0xFF0A0A0A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    //SizedBox(height: 8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h, // Adjust size
                        spacing: 2.r, // Adjust spacing
                        dotCount: 103, // Adjust number of dots
                        color: Colors.grey, // Adjust color
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // "Hide non-refundable flights" switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hide non-refundable flights",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp,
                            color: const Color(0xFF606060),
                          ),
                        ),
                        Switch(
                          value: hideNonRefundable,
                          onChanged: (value) {
                            setState(() {
                              hideNonRefundable = value;
                            });
                          },
                          activeColor: const Color(0xFFF37023),
                        ),
                      ],
                    ),
                    // SizedBox(height: 8.h),
                    SizedBox(height: 8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h, // Adjust size
                        spacing: 2.r, // Adjust spacing
                        dotCount: 103, // Adjust number of dots
                        color: Colors.grey, // Adjust color
                      ),
                    ),
                    SizedBox(height: 8.h),

                    Text(
                      "Stops",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: const Color(0xFF909090),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _buildChip("Non Stop", 0),
                        _buildChip("1 Stop", 1),
                        _buildChip("2+ Stops", 2),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h,
                        spacing: 2.r,
                        dotCount: 103,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "DEPARTURE FROM ${widget.filterorigin}",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: const Color(0xFF909090),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _timeButton("Before 6 AM", "Before 6 AM"),
                        _timeButton("6 AM-12 Noon", "6 AM-12 Noon"),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _timeButton("12 Noon-6 PM", "12 Noon-6 PM"),
                        _timeButton("6 PM-12 Midnight", "6 PM-12 Midnight"),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "ARRIVAL AT ${widget.filterdestination}",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: const Color(0xFF909090),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _timeButton("Before 6 AM", "Before 6 AM",
                            isArrival: true),
                        _timeButton("6 AM-12 Noon", "6 AM-12 Noon",
                            isArrival: true),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _timeButton("12 Noon-6 PM", "12 Noon-6 PM",
                            isArrival: true),
                        _timeButton("6 PM-12 Midnight", "6 PM-12 Midnight",
                            isArrival: true),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h, // Adjust size
                        spacing: 2.r, // Adjust spacing
                        dotCount: 103, // Adjust number of dots
                        color: Colors.grey, // Adjust color
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "AIRLINES",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF909090),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.airlines.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // "All Airlines" - Special tappable row to clear selections
                          bool isAllSelected = selectedAirlineIndices.isEmpty;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAirlineIndices.clear();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.w, horizontal: 5),
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Icon(
                                      isAllSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      size: 20.r,
                                      color: isAllSelected
                                          ? const Color(0xFFF37023)
                                          : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      widget.airlines[0]["name"]!,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  // No price for "All"
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Regular airline row - Now with circular checkbox for multi-select
                          bool isSelected =
                              selectedAirlineIndices.contains(index);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedAirlineIndices.remove(index);
                                } else {
                                  selectedAirlineIndices.add(index);
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.w, horizontal: 5),
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      size: 20.r,
                                      color: isSelected
                                          ? const Color(0xFFF37023)
                                          : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if (widget.airlines[index]["logo"] !=
                                                null &&
                                            widget.airlines[index]["logo"]!
                                                .isNotEmpty)
                                          Image.asset(
                                            widget.airlines[index]["logo"]!,
                                            height: 24.h,
                                            width: 24.w,
                                            fit: BoxFit.contain,
                                          ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          widget.airlines[index]["name"]!,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    widget.airlines[index]["price"] ?? "",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 65.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'airlineIndices': selectedAirlineIndices.toList(),
              // NEW key for multi
              'stops': selectedStops,
              'hideNonRefundable': hideNonRefundable,
              // <-- ADD THIS
              'departureTime': departureTime,
              // ADD
              'arrivalTime': arrivalTime,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF37023),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Text(
            "Apply Filter",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, int value) {
    bool isSelected = selectedStops == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedStops == value) {
            selectedStops = null;
          } else {
            selectedStops = value;
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Container(
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFFFFE7DA) : const Color(0xFFFFFFFF),
            border: Border.all(
                color: isSelected
                    ? const Color(0xFFF37023)
                    : const Color(0xFFE6E6E6)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'Inter',
              color: isSelected ? const Color(0xFFF37023) : Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeButton(String label, String value, {bool isArrival = false}) {
    bool isSelected = isArrival ? arrivalTime == value : departureTime == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isArrival) {
            arrivalTime = (arrivalTime == value) ? "" : value;
          } else {
            departureTime = (departureTime == value) ? "" : value;
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Container(
          width: 140.w,
          height: 35.h,
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFFFFE7DA) : const Color(0xFFFFFFFF),
            border: Border.all(
                color: isSelected
                    ? const Color(0xFFF37023)
                    : const Color(0xFFE6E6E6)),
            borderRadius: BorderRadius.circular(3.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'Inter',
              color: isSelected ? const Color(0xFFF37023) : Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class DateScroller extends StatefulWidget {
  final List<Map<String, dynamic>> dates;
  final Function(String)? onDateSelected; // NEW: Callback for date selection

  const DateScroller({
    Key? key,
    required this.dates,
    this.onDateSelected, // NEW
  }) : super(key: key);

  @override
  _DateScrollerState createState() => _DateScrollerState();
}

class _DateScrollerState extends State<DateScroller> {
  final ScrollController _scrollController = ScrollController();

  String _getMonth(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[date.month - 1];
  }

  String _getWeekday(DateTime date) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Colors.white,
        child: Row(
          children: widget.dates.asMap().entries.map((entry) {
            final int index = entry.key; // ✅ get index here
            final date = entry.value; // ✅ get the date map

            return GestureDetector(
              onTap: () {
                setState(() {
                  for (var d in widget.dates) {
                    d['isSelected'] = false;
                  }
                  date['isSelected'] = true;
                });

                // ✅ AUTO SCROLL
                _scrollController.animateTo(
                  index * 100.w, // item width
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );

                // Trigger callback to parent
                if (widget.onDateSelected != null && date['date'] != null) {
                  widget.onDateSelected!(date['date'] as String);
                }
              },
              child: Container(
                height: 40.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: date['isSelected']
                      ? const Color(0xFFFFE7DA)
                      : Colors.white,
                  border:
                      Border.all(color: const Color(0xFFE6E6E6), width: 1.w),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        date['month'] as String? ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              date['isSelected'] ? Colors.black : Colors.black,
                        ),
                      ),
                      Text(
                        (date['price'] as String? ?? ''),
                        style: TextStyle(
                          color: date['isSelected']
                              ? const Color(0xFFF37023)
                              : const Color(0xFF909090),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
