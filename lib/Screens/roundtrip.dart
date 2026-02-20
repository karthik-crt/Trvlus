import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../models/commissionpercentage.dart';
import '../models/customercommision.dart';
import '../models/search_data.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';
import 'FlightDetailsPage.dart';
import 'Home_Page.dart';

class Roundtrip extends StatefulWidget {
  String airportCode;
  String fromAirport;
  String toairportCode;
  String toAirport;
  String selectedDepDate;
  String selectedReturnDate;
  String selectedTripType;
  SearchData search;
  int adultCount;
  int? childCount;
  int? infantCount;

  Roundtrip(
      {super.key,
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
      required this.search});

  @override
  State<Roundtrip> createState() => _RoundtripState();
}

class _RoundtripState extends State<Roundtrip> {
  late SearchData searchData;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = false;
  late ComissionPercentage commission;
  late Customercommission customer;
  String currentDepDate = '';
  List<Map<String, dynamic>> dates = [];
  int passengerCount = 0;

  // ✅ NEW: Pagination variables
  int _itemsPerPage = 10; // Load 10 items at a time
  int _currentPage = 0; // Current page index
  bool _isLoadingMore = false; // Loading more indicator
  bool _hasMoreData = true; // Check if more data exists
  List<dynamic> _displayedFlights = []; // Currently displayed flights
  List<List<dynamic>> _allFilteredFlights = []; // All filtered flights

  // FILTER
  late List<Map<String, dynamic>> uniqueAirlines;
  String? _selectedAirlineCode;
  int? _selectedStops;
  bool _hideNonRefundable = false;
  String? _selectedDepartureTimeRange;
  String? _selectedArrivalTimeRange;
  String? filterorigin;
  String? filterdestination;

  // ... (keep existing methods: getCommissionData, _fetchFlightsForDate, etc.)
  getCommissionData() async {
    setState(() {
      isLoading = true;
    });
    commission = await ApiService().commissionPercentage();
    print("COMMISION$commission");
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
    await getCommissionData();

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

  String _calculateTotalDuration(List currentSegment) {
    if (currentSegment.isEmpty) return '0h 0min';

    try {
      int totalMinutes;

      if (currentSegment.length == 1) {
        // Direct flight → use leg duration
        totalMinutes = currentSegment.first.duration.toInt();
      } else {
        // With stops → use accumulatedDuration on the LAST leg
        totalMinutes = currentSegment.last.accumulatedDuration.toInt();
      }

      int hours = totalMinutes ~/ 60;
      int mins = totalMinutes % 60;
      print("Hellloooo");
      print('${hours}h ${mins}min');
      return '${hours}h ${mins}min';
    } catch (e) {
      return 'N/A';
    }
  }

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

  int get currentSelectedIndex {
    if (_selectedAirlineCode == null) return 0;
    for (int i = 1; i < uniqueAirlines.length; i++) {
      if (uniqueAirlines[i]["code"] == _selectedAirlineCode) return i;
    }
    return 0;
  }

  String formatDate() {
    DateTime parsedDate = DateTime.parse(widget.selectedDepDate);
    String formattedDate = DateFormat('dd MMM yy').format(parsedDate);
    print("HElloooooo");
    return formattedDate;
  }

  String returnDate() {
    DateTime parsedDate = DateTime.parse(widget.selectedReturnDate);
    String formattedDate = DateFormat('dd MMM yy').format(parsedDate);
    print("HElloooooo");
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    getCustomerCommission();
    searchData = widget.search;
    currentDepDate = widget.selectedDepDate;

    final adult = widget.adultCount;
    final child = widget.childCount;
    final infant = widget.infantCount;
    passengerCount = adult + (child ?? 0) + (infant ?? 0);

    // Compute unique airlines
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

    loadCalendarPrices();

    // ✅ NEW: Initialize pagination
    _initializePagination();

    // ✅ NEW: Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  // ✅ NEW: Initialize pagination with first 10 items
  void _initializePagination() {
    _allFilteredFlights = getFilteredResults();
    _displayedFlights = [];
    _currentPage = 0;
    _hasMoreData = true;
    _loadMoreFlights();
  }

  // ✅ NEW: Load more flights (10 at a time)
// ✅ IMPROVED: Load more flights (faster, no delay)
  void _loadMoreFlights() {
    if (!_hasMoreData || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Flatten all flights from groups
    List<dynamic> allFlights = [];
    for (var group in _allFilteredFlights) {
      allFlights.addAll(group);
    }

    // Calculate start and end index
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    if (startIndex >= allFlights.length) {
      setState(() {
        _hasMoreData = false;
        _isLoadingMore = false;
      });
      return;
    }

    // ✅ REMOVED DELAY - Load immediately for smoother scrolling
    final newItems = allFlights.sublist(
      startIndex,
      endIndex > allFlights.length ? allFlights.length : endIndex,
    );

    setState(() {
      _displayedFlights.addAll(newItems);
      _currentPage++;
      _isLoadingMore = false;
      _hasMoreData = endIndex < allFlights.length;
    });
  }

  // ✅ NEW: Scroll listener
// ✅ IMPROVED: Scroll listener - triggers earlier for smoother experience
  void _onScroll() {
    // Load more when user is 400px from bottom (increased from 200px)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      _loadMoreFlights();
    }

    // Handle scroll to top button visibility (existing logic)
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
  }

  // ✅ MODIFIED: Reset pagination when filters change
  List<List<dynamic>> getFilteredResults() {
    var results = searchData.response.results;
    filterorigin =
        results.first.first.segments.first.first.origin.airport.cityName;
    filterdestination =
        results.last.last.segments.last.last.destination.airport.cityName;

    if (_selectedAirlineCode != null) {
      results = results
          .map((group) => group
              .where((flight) =>
                  flight.segments.first.first.airline.airlineCode ==
                  _selectedAirlineCode)
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
      results = results
          .map((group) =>
              group.where((flight) => flight.isRefundable == true).toList())
          .where((g) => g.isNotEmpty)
          .toList();
    }

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  SizedBox(height: 10),
                  Text(
                    "Loading...",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          )
        : _displayedFlights.isNotEmpty
            ? Scaffold(
                appBar: AppBar(
                  // ... (keep existing AppBar code)
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(30),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                        border: Border.all(color: Color(0xFFF37023)),
                      ),
                      child: Row(
                        children: [
                          /// Back Button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFFF37023),
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// 🔥 THIS IS IMPORTANT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// 🔥 Single Line Text (Like Makemytrip)
                                Row(
                                  children: [
                                    Text(
                                      widget.fromAirport,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                    Image.asset("assets/icon/swap.png",
                                        height: 13,
                                        width: 20,
                                        color: Colors.black),
                                    Text(
                                      widget.toAirport,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                /// Second Row
                                Text(
                                  "${formatDate()} - ${returnDate()} | $passengerCount Traveller | Economy",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// Edit
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/edit.svg',
                                  color: Color(0xFFF37023),
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "Edit",
                                  style: TextStyle(color: Color(0xFFF37023)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.grey.shade200,
                body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                        text: totalFlights.toString(),
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

                              // ✅✅✅ ADD FILTER BUTTON HERE ✅✅✅
                              Container(
                                height: 25.h,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
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
                                              currentSelectedIndex:
                                                  currentSelectedIndex,
                                              filterorigin: filterorigin,
                                              filterdestination:
                                                  filterdestination),
                                        );
                                      },
                                    );

                                    // Handle filter result
                                    if (filterData != null) {
                                      setState(() {
                                        int airlineIndex =
                                            filterData['airlineIndex'] ?? 0;
                                        if (airlineIndex == 0) {
                                          _selectedAirlineCode = null;
                                        } else {
                                          _selectedAirlineCode =
                                              uniqueAirlines[airlineIndex]
                                                  ['code'];
                                        }
                                        _selectedStops = filterData['stops'];
                                        _hideNonRefundable =
                                            filterData['hideNonRefundable'] ??
                                                false;
                                        _selectedDepartureTimeRange =
                                            filterData['departureTime'];
                                        _selectedArrivalTimeRange =
                                            filterData['arrivalTime'];

                                        // ✅ Reset pagination with filtered data
                                        _initializePagination();
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
                              // ✅✅✅ FILTER BUTTON ENDS HERE ✅✅✅
                            ],
                          ),
                        ),
                        // ✅ NEW: Display paginated flights
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _displayedFlights.length + 1,
                          // ✅ Always +1 for loading indicator
                          itemBuilder: (context, index) {
                            print(
                                "📋 Building item at index $index (total flights: ${_displayedFlights.length})");

                            // ✅ Show loading indicator at bottom
                            if (index == _displayedFlights.length) {
                              return _buildLoadingIndicator();
                            }

                            return _buildSingleFlightCard(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // floatingActionButtonLocation:
                //     FloatingActionButtonLocation.endFloat,
                // floatingActionButton: AnimatedOpacity(
                //   opacity: _isButtonVisible ? 1.0 : 0.0,
                //   duration: const Duration(milliseconds: 300),
                //   child: SizedBox(
                //     height: 45.h,
                //     width: 50.w,
                //     child: FloatingActionButton(
                //       onPressed: () {
                //         _scrollController.animateTo(
                //           0.0,
                //           duration: const Duration(milliseconds: 300),
                //           curve: Curves.easeOut,
                //         );
                //       },
                //       child: Icon(
                //         Icons.keyboard_arrow_up,
                //         size: 30.r,
                //         color: Colors.white,
                //       ),
                //       backgroundColor: const Color(0xFFF37023),
                //       shape: const CircleBorder(),
                //       elevation: 6,
                //     ),
                //   ),
                // ),
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
                      SizedBox(height: 10),
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
                    ],
                  ),
                ),
              );
  }

  // ✅ NEW: Loading indicator widget
// ✅ IMPROVED: Better loading indicator with text
  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      alignment: Alignment.center,
      child: _isLoadingMore
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFFF37023),
                  strokeWidth: 3,
                ),
                SizedBox(height: 12.h),
                Text(
                  "Loading more flights...",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF606060),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Please wait",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    color: Color(0xFF909090),
                  ),
                ),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  // ✅ NEW: Build single flight card (extracted from your original code)
  Widget _buildSingleFlightCard(int index) {
    final flight = _displayedFlights[index];

    // Your existing flight card code here
    final depTimeStr = flight.segments.first.first.origin.depTime.toString();
    DateTime depDateTime = DateTime.parse(depTimeStr);
    final depTimeFormatted = DateFormat("HH:mm").format(depDateTime);

    final arrTimeStr = flight.segments.last.last.destination.arrTime.toString();
    DateTime arrDateTime = DateTime.parse(arrTimeStr);
    final arrTimeFormatted = DateFormat("HH:mm").format(arrDateTime);

    // FARE CALCULATION
    double publishFare = flight.fare.publishedFare.toDouble();
    print("publishFare$publishFare");
    String offeredFare = flight.fare.offeredFare.toString();
    print("offeredFare$offeredFare");
    double tboTDS = flight.fare.tdsOnCommission.toDouble();
    print("tboTDS$tboTDS");

    // Calculate customer commission (same logic as before)
    final commissionEarned = flight.fare.commissionEarned.toDouble();
    print("commissionEarned$commissionEarned");
    double customerComm = 0.0;
    if (customer.data.isNotEmpty && commissionEarned > 0) {
      var commData = customer.data[0];
      double earned = commissionEarned;
      if (earned >= 0 && earned <= 50) {
        customerComm = commData.commission_0_50?.toDouble() ?? 0.0;
      } else if (earned <= 100) {
        customerComm = commData.commission_50_100?.toDouble() ?? 0.0;
      } else if (earned <= 150) {
        customerComm = commData.commission_100_150?.toDouble() ?? 0.0;
      } else if (earned <= 200) {
        customerComm = commData.commission_150_200?.toDouble() ?? 0.0;
      } else if (earned <= 250) {
        customerComm = commData.commission_200_250?.toDouble() ?? 0.0;
      } else if (earned <= 300) {
        customerComm = commData.commission_250_300?.toDouble() ?? 0.0;
      } else {
        customerComm = commData.commission_above_300?.toDouble() ?? 0.0;
      }
    }
    print("customerComm$customerComm");
    double customertdsplb = flight.fare.tdsOnPlb.toDouble();
    print("customertdsplb$customertdsplb");
    double customerplbearned = flight.fare.plbEarned.toDouble();
    print("customerplbearned$customerplbearned");
    double finalcommissionplb = commissionEarned + customerplbearned;
    print("finalcommissionplb$finalcommissionplb");
    double customercommissiondetection =
        finalcommissionplb - customerComm - tboTDS - customertdsplb;
    print("customercommissiondetection$customercommissiondetection");
    int finalcustomercommission = customercommissiondetection.round();
    print("finalcustomercommission$finalcustomercommission");
    double finalcommissionpercentage = finalcustomercommission * 0.02;
    print("finalcommissionpercentage$finalcommissionpercentage");
    int commissionpercentageround = finalcommissionpercentage.round();
    print("commissionpercentageround$commissionpercentageround");
    double finalflatoffer =
        customercommissiondetection - finalcommissionpercentage;
    print("finalflatoffer$finalflatoffer");
    int finalcoupouncode = finalflatoffer.round();
    print("finalcoupouncode$finalcoupouncode");
    // int finaloffFare = (double.parse(offeredFare) +
    //         double.parse(tboTDS.toString()) +
    //         double.parse(finalcommissionpercentage
    //             .toString()) +
    //         double.parse(customerComm.toString()))
    //     .round();
    double othercharges = flight.fare.otherCharges;
    print("othercharges$othercharges");
    int finaloffFare = (publishFare + othercharges - finalflatoffer).round();
    print("finaloffFare$finaloffFare");

    // DURATION AND LAYOVER CALCULATION
    int totalMinutes = flight.segments.first.first.duration.toInt();
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    String formattedDuration = "${hours}h ${minutes}m";
    print("formattedDuration$formattedDuration");

    final segments = flight.segments.first;
    int numStops = segments.length - 1;

    String displayTotalDuration = formattedDuration;
    print("displayTotalDuration$displayTotalDuration");
    if (numStops > 0) {
      int totalTripMinutes = segments.last.accumulatedDuration.toInt();
      int totalTripHours = totalTripMinutes ~/ 60;
      int totalTripMins = totalTripMinutes % 60;
      displayTotalDuration = "${totalTripHours}h ${totalTripMins}m";
      print("displayTotalDuration$displayTotalDuration");
    }

    return GestureDetector(
      onTap: () {
        Map<String, dynamic> outBoundData = {
          "resultindex": flight.resultIndex,
          "traceid": searchData.response.traceId,
        };

        print("International");
        print(flight.fare.publishedFare);
        Navigator.push(
            context,
            (MaterialPageRoute(
                builder: (context) => FlightDetailsPage(
                    flight: {},
                    outBoundData: outBoundData,
                    inBoundData: {},
                    city: '',
                    destination: '',
                    airlineName:
                        flight.segments.first.first.airline.airlineName,
                    airlineCode:
                        flight.segments.first.first.airline.airlineCode,
                    airportName:
                        flight.segments.first.first.origin.airport.airportName,
                    flightNumber:
                        flight.segments.first.first.airline.flightNumber,
                    cityName:
                        flight.segments.first.first.origin.airport.cityName,
                    cityCode:
                        flight.segments.first.first.origin.airport.cityCode,
                    depDate:
                        flight.segments.first.first.origin.depTime.toString(),
                    depTime: depTimeFormatted,
                    desairportName: flight
                        .segments.first.first.destination.airport.airportName,
                    descityName: flight
                        .segments.first.first.destination.airport.cityName,
                    descityCode: flight
                        .segments.first.first.destination.airport.cityCode,
                    segments: flight.segments,
                    arrDate: flight.segments.last.last.destination.arrTime
                        .toString(),
                    arrTime: arrTimeFormatted,
                    refundable: '',
                    resultindex: flight.resultIndex,
                    traceid: searchData.response.traceId,
                    adultCount: widget.adultCount,
                    childCount: widget.childCount,
                    infantCount: widget.infantCount,
                    coupouncode: finalcoupouncode,
                    stop: (flight.segments!.first.length - 1) == 0
                        ? "Non-Stop"
                        : "${flight.segments!.first.length - 1} Stops",
                    duration: '',
                    basefare: flight.fare.baseFare,
                    tax: flight.fare.tax,
                    commonPublishedFare: flight.fare.publishedFare.toString(),
                    isLLC: flight.isLcc))));
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 400,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFFFE7DA),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Round Trip",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ✅ ADD THIS
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (finaloffFare.round() <
                                  flight.fare.publishedFare.round())
                                Text(
                                  "₹${flight.fare.publishedFare.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12,
                                  ),
                                ),
                              Text(
                                "₹${finaloffFare.toStringAsFixed(0)}",
                                style: TextStyle(
                                  color: const Color(0xFFF37023),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    // ... (rest of your flight card UI - segments loop, etc.)
                    // Copy the entire segments List.generate from your original code here
                    ...List.generate(flight.segments.length, (segmentsindex) {
                      var currentSegment = flight.segments[segmentsindex];
                      if (currentSegment.isEmpty)
                        return const SizedBox.shrink();

                      var firstLeg = currentSegment.first;
                      var lastLeg = currentSegment.last;

                      var depString =
                          currentSegment.first.origin.depTime.toString();
                      var arrString =
                          currentSegment.last.destination.arrTime.toString();

                      DateTime depDate = DateTime.parse(depString);
                      DateTime arrDate = DateTime.parse(arrString);

                      String finalDepDateFormat =
                          DateFormat("EEE, dd MMM yy").format(depDate);
                      String finalArrDateFormat =
                          DateFormat("EEE, dd MMM yy").format(arrDate);

                      int totalStops = currentSegment.length - 1;
                      String totalDuration =
                          _calculateTotalDuration(currentSegment);

                      // Layover calculation
                      // ✅ CORRECT - uses the current trip's segments
                      List<String> layoverDetails = [];
                      for (int i = 0; i < currentSegment.length - 1; i++) {
                        // ← changed
                        DateTime arrTime =
                            currentSegment[i].destination.arrTime; // ← changed
                        DateTime depTime =
                            currentSegment[i + 1].origin.depTime; // ← changed
                        int layoverMinutes =
                            depTime.difference(arrTime).inMinutes;
                        if (layoverMinutes > 0) {
                          int h = layoverMinutes ~/ 60;
                          int m = layoverMinutes % 60;
                          String city = currentSegment[i + 1]
                              .origin
                              .airport
                              .cityName; // ← changed
                          layoverDetails.add("${h}h ${m}m layover at $city");
                        }
                      }
                      print("Final layoverDetails: $layoverDetails");

                      String stopsText =
                          totalStops == 0 ? 'NON STOP' : '$totalStops STOP';
                      String airlineName = firstLeg.airline.airlineName;
                      String airlineCode = firstLeg.airline.airlineCode;
                      String flightNumber = firstLeg.airline.flightNumber;

                      return Column(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (totalStops > 0 && layoverDetails.isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        layoverDetails.join(", "),
                                        style: TextStyle(
                                            color: Color(0xFFF37023),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Image.asset("assets/$airlineCode.gif",
                                        fit: BoxFit.fill,
                                        height: 35,
                                        width: 35),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          airlineName,
                                          style: TextStyle(
                                              color: Color(0xFF1C1E1D),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: airlineCode,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color:
                                                        Colors.grey.shade700),
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
                                              TextSpan(
                                                  text: flightNumber,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall
                                                      ?.copyWith(
                                                          fontSize: 12.sp,
                                                          color: Colors.grey),
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 2.w,
                                                                vertical: 4.h),
                                                        child: Container(
                                                          width: 4.w,
                                                          height: 3.h,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.grey,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                              TextSpan(
                                                text:
                                                    flight.isRefundable == true
                                                        ? "R"
                                                        : "NR",
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
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          firstLeg.origin.depTime
                                              .toString()
                                              .substring(11, 16),
                                          style: TextStyle(
                                              color: Color(0xFF1C1E1D),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          finalDepDateFormat,
                                          style: TextStyle(
                                              color: Color(0xFF909090),
                                              fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              firstLeg.origin.airport.cityName,
                                              style: TextStyle(
                                                  color: Color(0xFF1C1E1D),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              firstLeg.origin.airport.cityCode,
                                              style: TextStyle(
                                                  color: Color(0xFF909090),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          stopsText,
                                          style: TextStyle(
                                              color: Color(0xFF909090),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        Image.asset(
                                            'assets/images/flightStop.png'),
                                        Text(
                                          totalDuration,
                                          style: TextStyle(
                                              color: Color(0xFF909090),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          lastLeg.destination.arrTime
                                              .toString()
                                              .substring(11, 16),
                                          style: TextStyle(
                                              color: Color(0xFF1C1E1D),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          finalArrDateFormat,
                                          style: TextStyle(
                                              color: Color(0xFF909090),
                                              fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              lastLeg
                                                  .destination.airport.cityName,
                                              style: TextStyle(
                                                  color: Color(0xFF1C1E1D),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              lastLeg
                                                  .destination.airport.cityCode,
                                              style: TextStyle(
                                                  color: Color(0xFF909090),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                if (segmentsindex == 0) ...[
                                  SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DotDivider(
                                      dotSize: 1.h,
                                      spacing: 2.r,
                                      dotCount: 100,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                                GestureDetector(onTap: () {}, child: Text(""))
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    if (finaloffFare <= publishFare && finalcoupouncode != 0)
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
                              "Flat ₹$finalcoupouncode OFF—only on Trvuls.",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> airlines;
  final int? currentSelectedIndex;
  final bool initialHideNonRefundable; // <-- ADD
  final String? filterorigin;
  final String? filterdestination;

  const FilterBottomSheet({
    Key? key,
    required this.airlines,
    this.currentSelectedIndex,
    this.initialHideNonRefundable = false, // <-- ADD
    this.filterorigin,
    this.filterdestination,
  }) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool hideNonRefundable = false;
  int? selectedStops;
  String departureTime = "";
  String arrivalTime = "";

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
    selectedAirlineIndex = widget.currentSelectedIndex;
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
                          // All Airlines row
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.w),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 1.3,
                                  child: Radio<int>(
                                    value: 0,
                                    groupValue: selectedAirlineIndex,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAirlineIndex = value;
                                      });
                                    },
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
                          );
                        } else {
                          // Regular airline row
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.w),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 1.3,
                                  child: Radio<int>(
                                    value: index,
                                    groupValue: selectedAirlineIndex,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAirlineIndex = value;
                                      });
                                    },
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
              'airlineIndex': selectedAirlineIndex ?? 0,
              'stops': selectedStops,
              'hideNonRefundable': hideNonRefundable, // <-- ADD THIS
              'departureTime': departureTime, // ADD
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
          selectedStops = value;
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
            arrivalTime = value;
          } else {
            departureTime = value;
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
