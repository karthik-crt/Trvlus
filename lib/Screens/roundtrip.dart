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

  // EXPANDED CONCEPT
  int selectedindex = -1;

  // ✅ CHANGED: Pagination now works on grouped flight keys
  int _itemsPerPage = 10;
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  List<String> _displayedFlightKeys = [];
  Map<String, List<dynamic>> _groupedFlights = {};

  // FILTER
  late List<Map<String, dynamic>> uniqueAirlines;
  String? _selectedAirlineCode;
  int? _selectedStops;
  bool _hideNonRefundable = false;
  String? _selectedDepartureTimeRange;
  String? _selectedArrivalTimeRange;
  String? filterorigin;
  String? filterdestination;

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

  void _onDateSelected(String newDate) {
    setState(() {
      currentDepDate = newDate;
    });
    for (var d in dates) {
      d['isSelected'] = d['date'] == newDate;
    }
    _fetchFlightsForDate(newDate);
  }

  String _calculateTotalDuration(List currentSegment) {
    if (currentSegment.isEmpty) return '0h 0min';
    try {
      int totalMinutes;
      if (currentSegment.length == 1) {
        totalMinutes = currentSegment.first.duration.toInt();
      } else {
        totalMinutes = currentSegment.last.accumulatedDuration.toInt();
      }
      int hours = totalMinutes ~/ 60;
      int mins = totalMinutes % 60;
      return '${hours}h ${mins}min';
    } catch (e) {
      return 'N/A';
    }
  }

  Future<void> loadCalendarPrices() async {
    try {
      final response = await ApiService().getCalendarFare(
          widget.airportCode, widget.toairportCode, selectedDepatureDate);

      if (response['Response']['ResponseStatus'] != 1) return;

      final List<dynamic> searchResults = response['Response']['SearchResults'];
      Map<String, double> lowestFareByDate = {};

      for (var item in searchResults) {
        String dateStr = item['DepartureDate'];
        String dateOnly = dateStr.substring(0, 10);
        double fare = item['Fare'].toDouble();
        if (!lowestFareByDate.containsKey(dateOnly) ||
            fare < lowestFareByDate[dateOnly]!) {
          lowestFareByDate[dateOnly] = fare;
        }
      }

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
          "date": dateKey,
        });
      }

      if (mounted) {
        setState(() {
          dates = updatedDates;
        });
      }
    } catch (e) {
      print("Calendar API Error: $e");
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
    return DateFormat('dd MMM yy').format(parsedDate);
  }

  String returnDate() {
    DateTime parsedDate = DateTime.parse(widget.selectedReturnDate);
    return DateFormat('dd MMM yy').format(parsedDate);
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
    _initializePagination();
    _scrollController.addListener(_onScroll);
  }

  // ✅ NEW: Group flights with same airline + flight number + route + dep/arr time
  // This deduplicates cards — same flight with different fare classes
  // becomes one card with multiple variants in the expanded section.
  Map<String, List<dynamic>> groupFlightsByAirlineAndNumber(
      List<List<dynamic>> results) {
    Map<String, List<dynamic>> groupedFlights = {};

    for (var group in results) {
      for (var flight in group) {
        String airlineCode = flight.segments.first.first.airline.airlineCode;
        String flightNumber = flight.segments.first.first.airline.flightNumber;

        String depTime = flight.segments.first.first.origin.depTime
            .toLocal()
            .toString()
            .substring(11, 16);
        String arrTime = flight.segments.last.last.destination.arrTime
            .toLocal()
            .toString()
            .substring(11, 16);

        String originCode = flight.segments.first.first.origin.airport.cityCode;
        String destCode =
            flight.segments.last.last.destination.airport.cityCode;

        // Key: airline + flight number + route + dep/arr times
        String key =
            "$airlineCode-$flightNumber-$originCode-$destCode-$depTime-$arrTime";

        if (!groupedFlights.containsKey(key)) {
          groupedFlights[key] = [];
        }
        groupedFlights[key]!.add(flight);
      }
    }

    // Sort each group by lowest price first
    groupedFlights.forEach((key, flights) {
      flights.sort((a, b) {
        double fareA =
            a.fare.publishedFare.toDouble() + a.fare.otherCharges.toDouble();
        double fareB =
            b.fare.publishedFare.toDouble() + b.fare.otherCharges.toDouble();
        return fareA.compareTo(fareB);
      });
    });

    return groupedFlights;
  }

  void _initializePagination() {
    final filteredResults = getFilteredResults();
    // ✅ Group flights before paginating
    _groupedFlights = groupFlightsByAirlineAndNumber(filteredResults);
    _displayedFlightKeys = [];
    _currentPage = 0;
    _hasMoreData = true;
    _loadMoreFlights();
  }

  void _loadMoreFlights() {
    if (!_hasMoreData || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final allKeys = _groupedFlights.keys.toList();
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    if (startIndex >= allKeys.length) {
      setState(() {
        _hasMoreData = false;
        _isLoadingMore = false;
      });
      return;
    }

    final newKeys = allKeys.sublist(
      startIndex,
      endIndex > allKeys.length ? allKeys.length : endIndex,
    );

    setState(() {
      _displayedFlightKeys.addAll(newKeys);
      _currentPage++;
      _isLoadingMore = false;
      _hasMoreData = endIndex < allKeys.length;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      _loadMoreFlights();
    }
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
                    flight.segments.last.last.destination.arrTime.toLocal();
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

  // ✅ Now shows count of unique grouped flights, not raw duplicates
  int get totalFlights => _groupedFlights.length;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ HELPER: Reusable fare calculation for any flight variant
  Map<String, dynamic> _calculateFare(dynamic flight) {
    double publishFare = flight.fare.publishedFare.toDouble();
    double tboTDS = flight.fare.tdsOnCommission.toDouble();
    final commissionEarned = flight.fare.commissionEarned.toDouble();

    double customerComm = 0.0;
    if (customer.data.isNotEmpty && commissionEarned >= 0) {
      var commData = customer.data[0];
      double earned = commissionEarned;
      if (earned == 0) {
        customerComm = commData.commission_0?.toDouble() ?? 0.0;
      } else if (earned <= 10) {
        customerComm = commData.commission_0_10?.toDouble() ?? 0.0;
      } else if (earned <= 20) {
        customerComm = commData.commission_10_20?.toDouble() ?? 0.0;
      } else if (earned <= 30) {
        customerComm = commData.commission_20_30?.toDouble() ?? 0.0;
      } else if (earned <= 50) {
        customerComm = commData.commission_30_50?.toDouble() ?? 0.0;
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

    double customertdsplb = flight.fare.tdsOnPlb.toDouble();
    double customerplbearned = flight.fare.plbEarned.toDouble();
    double finalcommissionplb = commissionEarned + customerplbearned;
    double customercommissiondetection =
        finalcommissionplb - customerComm - tboTDS - customertdsplb;
    double finalcommissionpercentage =
        customercommissiondetection.round() * 0.02;
    double finalflatoffer =
        customercommissiondetection - finalcommissionpercentage;
    int finalcoupouncode = finalflatoffer.round();
    double othercharges = flight.fare.otherCharges;
    int finaloffFare = (publishFare - finalflatoffer).round();

    return {
      'publishFare': publishFare,
      'finaloffFare': finaloffFare,
      'finalcoupouncode': finalcoupouncode,
      'finalflatoffer': finalflatoffer,
    };
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFF37023)),
                  SizedBox(height: 10),
                  Text("Loading...", style: TextStyle(color: Colors.black))
                ],
              ),
            ),
          )
        : _displayedFlightKeys.isNotEmpty
            ? Scaffold(
                appBar: AppBar(
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
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back,
                                color: Color(0xFFF37023)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(widget.fromAirport,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                    Image.asset("assets/icon/swap.png",
                                        height: 13,
                                        width: 20,
                                        color: Colors.black),
                                    Text(widget.toAirport,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                  ],
                                ),
                                const SizedBox(height: 4),
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
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icon/edit.svg',
                                    color: Color(0xFFF37023), height: 16),
                                const SizedBox(width: 4),
                                const Text("Edit",
                                    style: TextStyle(color: Color(0xFFF37023))),
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
                                            color: Colors.orange),
                                      ),
                                      TextSpan(text: " "),
                                      TextSpan(
                                        text: "AVAILABLE FLIGHTS",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
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
                                    var filterData = await showModalBottomSheet<
                                        Map<String, dynamic>>(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16))),
                                      builder: (context) => Container(
                                        height: 620.h,
                                        child: FilterBottomSheet(
                                            airlines: uniqueAirlines,
                                            currentSelectedIndex:
                                                currentSelectedIndex,
                                            filterorigin: filterorigin,
                                            filterdestination:
                                                filterdestination),
                                      ),
                                    );
                                    if (filterData != null) {
                                      setState(() {
                                        int airlineIndex =
                                            filterData['airlineIndex'] ?? 0;
                                        _selectedAirlineCode = airlineIndex == 0
                                            ? null
                                            : uniqueAirlines[airlineIndex]
                                                ['code'];
                                        _selectedStops = filterData['stops'];
                                        _hideNonRefundable =
                                            filterData['hideNonRefundable'] ??
                                                false;
                                        _selectedDepartureTimeRange =
                                            filterData['departureTime'];
                                        _selectedArrivalTimeRange =
                                            filterData['arrivalTime'];
                                        selectedindex = -1;
                                        _initializePagination();
                                      });
                                    }
                                  },
                                  icon: Image.asset('assets/images/Filter.png',
                                      height: 12.h, width: 12.w),
                                  label: Text("Filter",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10.sp,
                                          color: Color(0xFF606060))),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade100,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.r)),
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
                          // ✅ itemCount uses grouped keys count
                          itemCount: _displayedFlightKeys.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _displayedFlightKeys.length) {
                              return _buildLoadingIndicator();
                            }
                            return _buildSingleFlightCard(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icon/noFlight.png", height: 70),
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

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      alignment: Alignment.center,
      child: _isLoadingMore
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                    color: Color(0xFFF37023), strokeWidth: 3),
                SizedBox(height: 12.h),
                Text("Loading more flights...",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF606060))),
                SizedBox(height: 4.h),
                Text("Please wait",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: Color(0xFF909090))),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildSingleFlightCard(int index) {
    // ✅ Pull the group of fare variants for this card
    final flightKey = _displayedFlightKeys[index];
    final flightVariants = _groupedFlights[flightKey]!;
    // ✅ The card always shows the lowest-priced variant
    final lowestPriceFlight = flightVariants.first;

    final depTimeStr =
        lowestPriceFlight.segments.first.first.origin.depTime.toString();
    final depTimeFormatted =
        DateFormat("HH:mm").format(DateTime.parse(depTimeStr));
    final arrTimeStr =
        lowestPriceFlight.segments.last.last.destination.arrTime.toString();
    final arrTimeFormatted =
        DateFormat("HH:mm").format(DateTime.parse(arrTimeStr));

    // Fare for the lowest-price variant (shown on the card header)
    final fareData = _calculateFare(lowestPriceFlight);
    double publishFare = fareData['publishFare'];
    int finaloffFare = fareData['finaloffFare'];
    int finalcoupouncode = fareData['finalcoupouncode'];

    // ✅ EXPANDED CONCEPT: toggle on tap
    return GestureDetector(
      onTap: () {
        setState(() {
          lowestPriceFlight.isExpanded = !lowestPriceFlight.isExpanded;
          selectedindex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                children: [
                  // Price header — always shows lowest fare
                  Container(
                    height: 60,
                    width: 400,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFFFE7DA)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Round Trip",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (finaloffFare.round() <
                                lowestPriceFlight.fare.publishedFare.round())
                              Text(
                                "₹${lowestPriceFlight.fare.publishedFare.toStringAsFixed(0)}",
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12),
                              ),
                            Text("₹${finaloffFare.toStringAsFixed(0)}",
                                style: TextStyle(
                                    color: const Color(0xFFF37023),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Segments loop — unchanged from original
                  ...List.generate(lowestPriceFlight.segments.length,
                      (segmentsindex) {
                    var currentSegment =
                        lowestPriceFlight.segments[segmentsindex];
                    if (currentSegment.isEmpty) return const SizedBox.shrink();

                    var firstLeg = currentSegment.first;
                    var lastLeg = currentSegment.last;

                    DateTime depDate = DateTime.parse(
                        currentSegment.first.origin.depTime.toString());
                    DateTime arrDate = DateTime.parse(
                        currentSegment.last.destination.arrTime.toString());

                    String finalDepDateFormat =
                        DateFormat("EEE, dd MMM yy").format(depDate);
                    String finalArrDateFormat =
                        DateFormat("EEE, dd MMM yy").format(arrDate);

                    int totalStops = currentSegment.length - 1;
                    String totalDuration =
                        _calculateTotalDuration(currentSegment);

                    List<String> layoverDetails = [];
                    for (int i = 0; i < currentSegment.length - 1; i++) {
                      DateTime arrTime = currentSegment[i].destination.arrTime;
                      DateTime depTime = currentSegment[i + 1].origin.depTime;
                      int layoverMinutes =
                          depTime.difference(arrTime).inMinutes;
                      if (layoverMinutes > 0) {
                        int h = layoverMinutes ~/ 60;
                        int m = layoverMinutes % 60;
                        String city =
                            currentSegment[i + 1].origin.airport.cityName;
                        layoverDetails.add("${h}h ${m}m layover at $city");
                      }
                    }

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
                                Row(children: [
                                  Text(layoverDetails.join(", "),
                                      style: TextStyle(
                                          color: Color(0xFFF37023),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold))
                                ]),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset("assets/$airlineCode.gif",
                                      fit: BoxFit.fill, height: 35, width: 35),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(airlineName,
                                          style: TextStyle(
                                              color: Color(0xFF1C1E1D),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                      RichText(
                                        text: TextSpan(
                                          text: airlineCode,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Colors.grey.shade700),
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
                                                            shape: BoxShape
                                                                .circle)),
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.w,
                                                              vertical: 4.h),
                                                      child: Container(
                                                          width: 4.w,
                                                          height: 3.h,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: BoxShape
                                                                      .circle)),
                                                    ),
                                                  ),
                                                ]),
                                            TextSpan(
                                              text: lowestPriceFlight
                                                          .isRefundable ==
                                                      true
                                                  ? "R"
                                                  : "NR",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                      fontSize: 12.sp,
                                                      color: primaryColor),
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
                                              fontWeight: FontWeight.bold)),
                                      Text(finalDepDateFormat,
                                          style: TextStyle(
                                              color: Color(0xFF909090),
                                              fontSize: 10)),
                                      Row(children: [
                                        Text(firstLeg.origin.airport.cityName,
                                            style: TextStyle(
                                                color: Color(0xFF1C1E1D),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(width: 5),
                                        Text(firstLeg.origin.airport.cityCode,
                                            style: TextStyle(
                                                color: Color(0xFF909090),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ])
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(stopsText,
                                          style: TextStyle(
                                              color: Color(0xFF909090),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                      Image.asset(
                                          'assets/images/flightStop.png'),
                                      Text(totalDuration,
                                          style: TextStyle(
                                              color: Color(0xFF909090),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          lastLeg.destination.arrTime
                                              .toString()
                                              .substring(11, 16),
                                          style: TextStyle(
                                              color: Color(0xFF1C1E1D),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(finalArrDateFormat,
                                          style: TextStyle(
                                              color: Color(0xFF909090),
                                              fontSize: 10)),
                                      Row(children: [
                                        Text(
                                            lastLeg
                                                .destination.airport.cityName,
                                            style: TextStyle(
                                                color: Color(0xFF1C1E1D),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(width: 5),
                                        Text(
                                            lastLeg
                                                .destination.airport.cityCode,
                                            style: TextStyle(
                                                color: Color(0xFF909090),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ])
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
                                      color: Colors.grey),
                                ),
                              ],
                              GestureDetector(onTap: () {}, child: Text(""))
                            ],
                          ),
                        ),
                      ],
                    );
                  }),

                  // ✅ EXPANDED SECTION: shows all fare variants for this flight
                  if (lowestPriceFlight.isExpanded && selectedindex == index)
                    Column(
                      children: flightVariants.asMap().entries.map((entry) {
                        final variantFlight = entry.value;

                        // Per-variant fare calculation
                        final varFareData = _calculateFare(variantFlight);
                        int varFinaloffFare = varFareData['finaloffFare'];
                        int varFinalcoupouncode =
                            varFareData['finalcoupouncode'];
                        double varPublishFare = varFareData['publishFare'];

                        final varDepTimeFormatted = DateFormat("HH:mm").format(
                            DateTime.parse(variantFlight
                                .segments.first.first.origin.depTime
                                .toString()));
                        final varArrTimeFormatted = DateFormat("HH:mm").format(
                            DateTime.parse(variantFlight
                                .segments.last.last.destination.arrTime
                                .toString()));

                        int varNumStops =
                            variantFlight.segments.first.length - 1;

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFFFF4EF)),
                          child: Column(
                            children: [
                              // Fare class name + price
                              Container(
                                height: 40,
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
                                      variantFlight.segments.first.first
                                              .supplierFareClass
                                              .toString()
                                              .isEmpty
                                          ? "Round Trip"
                                          : variantFlight.segments.first.first
                                              .supplierFareClass
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF1C1E1D)),
                                    ),
                                    Text("₹$varFinaloffFare",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFFF37023))),
                                  ],
                                ),
                              ),
                              // SSR details + Book Now button
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Image.asset('assets/ssr/bag.png',
                                          height: 16),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                          width: 100,
                                          child: Text("Cabin Bag",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10))),
                                      Text(
                                          variantFlight
                                              .segments.first.first.cabinBaggage
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10)),
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      Image.asset('assets/ssr/checkin.png',
                                          height: 16),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                          width: 100,
                                          child: Text("Check In",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10))),
                                      Text(
                                          variantFlight.segments.first.first
                                                  .baggage.isEmpty
                                              ? '0'
                                              : variantFlight
                                                  .segments.first.first.baggage,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10)),
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      Image.asset('assets/ssr/seat.png',
                                          height: 16),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                          width: 100,
                                          child: Text("Seats",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10))),
                                      const Text("Included",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10)),
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      Image.asset('assets/ssr/meals.png',
                                          height: 16),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                          width: 100,
                                          child: Text("Meals",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10))),
                                      Text(
                                          variantFlight.isFreeMealAvailable ==
                                                  'true'
                                              ? "Included"
                                              : "Not Included",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10)),
                                    ]),
                                    const SizedBox(height: 20),
                                    // Book Now — navigates with this variant's data
                                    GestureDetector(
                                      onTap: () {
                                        Map<String, dynamic> outBoundData = {
                                          "resultindex":
                                              variantFlight.resultIndex,
                                          "traceid":
                                              searchData.response.traceId,
                                        };
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FlightDetailsPage(
                                                      flight: {},
                                                      outBoundData:
                                                          outBoundData,
                                                      inBoundData: {},
                                                      city: '',
                                                      destination: '',
                                                      airlineName: variantFlight
                                                          .segments
                                                          .first
                                                          .first
                                                          .airline
                                                          .airlineName,
                                                      airlineCode: variantFlight
                                                          .segments
                                                          .first
                                                          .first
                                                          .airline
                                                          .airlineCode,
                                                      airportName: variantFlight
                                                          .segments
                                                          .first
                                                          .first
                                                          .origin
                                                          .airport
                                                          .airportName,
                                                      flightNumber:
                                                          variantFlight
                                                              .segments
                                                              .first
                                                              .first
                                                              .airline
                                                              .flightNumber,
                                                      cityName: variantFlight
                                                          .segments
                                                          .first
                                                          .first
                                                          .origin
                                                          .airport
                                                          .cityName,
                                                      cityCode: variantFlight
                                                          .segments
                                                          .first
                                                          .first
                                                          .origin
                                                          .airport
                                                          .cityCode,
                                                      depDate: variantFlight
                                                          .segments
                                                          .first
                                                          .first
                                                          .origin
                                                          .depTime
                                                          .toString(),
                                                      depTime:
                                                          varDepTimeFormatted,
                                                      desairportName:
                                                          variantFlight
                                                              .segments
                                                              .first
                                                              .first
                                                              .destination
                                                              .airport
                                                              .airportName,
                                                      descityName: variantFlight
                                                          .segments
                                                          .first
                                                          .first
                                                          .destination
                                                          .airport
                                                          .cityName,
                                                      descityCode: variantFlight
                                                          .segments
                                                          .first
                                                          .first
                                                          .destination
                                                          .airport
                                                          .cityCode,
                                                      segments: variantFlight
                                                          .segments,
                                                      arrDate: variantFlight
                                                          .segments
                                                          .last
                                                          .last
                                                          .destination
                                                          .arrTime
                                                          .toString(),
                                                      arrTime:
                                                          varArrTimeFormatted,
                                                      refundable: '',
                                                      resultindex: variantFlight
                                                          .resultIndex,
                                                      traceid: searchData
                                                          .response.traceId,
                                                      adultCount:
                                                          widget.adultCount,
                                                      childCount:
                                                          widget.childCount,
                                                      infantCount:
                                                          widget.infantCount,
                                                      coupouncode:
                                                          varFinalcoupouncode,
                                                      stop: varNumStops == 0
                                                          ? "Non-Stop"
                                                          : "$varNumStops Stops",
                                                      duration: '',
                                                      basefare: variantFlight
                                                          .fare.baseFare,
                                                      tax: variantFlight
                                                          .fare.tax,
                                                      commonPublishedFare:
                                                          varPublishFare
                                                              .toString(),
                                                      isLLC:
                                                          variantFlight.isLcc,
                                                      trvlusNetFare:
                                                          varFinaloffFare,
                                                    )));
                                      },
                                      child: Container(
                                        height: 40,
                                        width: MediaQuery.sizeOf(context).width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color(0xFFF37023)),
                                        alignment: Alignment.center,
                                        child: const Text("Book Now",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                  // Promo code banner
                  if (finaloffFare <= publishFare && finalcoupouncode != 0)
                    Container(
                      height: 25,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFFDAE5FF)),
                      child: Row(
                        children: [
                          const SizedBox(width: 5),
                          SvgPicture.asset("assets/icon/promocode.svg",
                              color: Color(0xFF5D89F0), height: 15, width: 20),
                          SizedBox(width: 10),
                          Text("Flat ₹$finalcoupouncode OFF—only on Trvuls.",
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> airlines;
  final int? currentSelectedIndex;
  final bool initialHideNonRefundable;
  final String? filterorigin;
  final String? filterdestination;

  const FilterBottomSheet({
    Key? key,
    required this.airlines,
    this.currentSelectedIndex,
    this.initialHideNonRefundable = false,
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
  int? selectedAirlineIndex;

  int? get selectedStopsValue => selectedStops;

  bool get hideNonRefundableValue => hideNonRefundable;

  @override
  void initState() {
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
                        Text("Filters",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                color: const Color(0xFF0A0A0A))),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                          dotSize: 1.h,
                          spacing: 2.r,
                          dotCount: 103,
                          color: Colors.grey),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hide non-refundable flights",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.sp,
                                color: const Color(0xFF606060))),
                        Switch(
                          value: hideNonRefundable,
                          onChanged: (value) =>
                              setState(() => hideNonRefundable = value),
                          activeColor: const Color(0xFFF37023),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                          dotSize: 1.h,
                          spacing: 2.r,
                          dotCount: 103,
                          color: Colors.grey),
                    ),
                    SizedBox(height: 8.h),
                    Text("Stops",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: const Color(0xFF909090))),
                    SizedBox(height: 10.h),
                    Row(children: [
                      _buildChip("Non Stop", 0),
                      _buildChip("1 Stop", 1),
                      _buildChip("2+ Stops", 2),
                    ]),
                    SizedBox(height: 15.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                          dotSize: 1.h,
                          spacing: 2.r,
                          dotCount: 103,
                          color: Colors.grey),
                    ),
                    SizedBox(height: 15.h),
                    Text("DEPARTURE FROM ${widget.filterorigin}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: const Color(0xFF909090))),
                    SizedBox(height: 10.h),
                    Row(children: [
                      _timeButton("Before 6 AM", "Before 6 AM"),
                      _timeButton("6 AM-12 Noon", "6 AM-12 Noon"),
                    ]),
                    SizedBox(height: 10.h),
                    Row(children: [
                      _timeButton("12 Noon-6 PM", "12 Noon-6 PM"),
                      _timeButton("6 PM-12 Midnight", "6 PM-12 Midnight"),
                    ]),
                    SizedBox(height: 20.h),
                    Text("ARRIVAL AT ${widget.filterdestination}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: const Color(0xFF909090))),
                    SizedBox(height: 10.h),
                    Row(children: [
                      _timeButton("Before 6 AM", "Before 6 AM",
                          isArrival: true),
                      _timeButton("6 AM-12 Noon", "6 AM-12 Noon",
                          isArrival: true),
                    ]),
                    SizedBox(height: 10.h),
                    Row(children: [
                      _timeButton("12 Noon-6 PM", "12 Noon-6 PM",
                          isArrival: true),
                      _timeButton("6 PM-12 Midnight", "6 PM-12 Midnight",
                          isArrival: true),
                    ]),
                    SizedBox(height: 15.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                          dotSize: 1.h,
                          spacing: 2.r,
                          dotCount: 103,
                          color: Colors.grey),
                    ),
                    SizedBox(height: 15.h),
                    Text("AIRLINES",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF909090))),
                    SizedBox(height: 8.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.airlines.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.w),
                            child: Row(children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<int>(
                                  value: 0,
                                  groupValue: selectedAirlineIndex,
                                  onChanged: (value) => setState(
                                      () => selectedAirlineIndex = value),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                  child: Text(widget.airlines[0]["name"]!,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black))),
                            ]),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.w),
                            child: Row(children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<int>(
                                  value: index,
                                  groupValue: selectedAirlineIndex,
                                  onChanged: (value) => setState(
                                      () => selectedAirlineIndex = value),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Row(children: [
                                  if (widget.airlines[index]["logo"] != null &&
                                      widget
                                          .airlines[index]["logo"]!.isNotEmpty)
                                    Image.asset(widget.airlines[index]["logo"]!,
                                        height: 24.h,
                                        width: 24.w,
                                        fit: BoxFit.contain),
                                  SizedBox(width: 8.w),
                                  Text(widget.airlines[index]["name"]!,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ]),
                              ),
                              Text(widget.airlines[index]["price"] ?? "",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ]),
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
              'hideNonRefundable': hideNonRefundable,
              'departureTime': departureTime,
              'arrivalTime': arrivalTime,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF37023),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r)),
          ),
          child: Text("Apply Filter",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildChip(String label, int value) {
    bool isSelected = selectedStops == value;
    return GestureDetector(
      onTap: () => setState(() => selectedStops = value),
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
          child: Text(label,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  color: isSelected ? const Color(0xFFF37023) : Colors.black,
                  fontWeight: FontWeight.normal)),
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
          child: Text(label,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  color: isSelected ? const Color(0xFFF37023) : Colors.black,
                  fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }
}

class DateScroller extends StatefulWidget {
  final List<Map<String, dynamic>> dates;
  final Function(String)? onDateSelected;

  const DateScroller({Key? key, required this.dates, this.onDateSelected})
      : super(key: key);

  @override
  _DateScrollerState createState() => _DateScrollerState();
}

class _DateScrollerState extends State<DateScroller> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Colors.white,
        child: Row(
          children: widget.dates.asMap().entries.map((entry) {
            final int index = entry.key;
            final date = entry.value;
            return GestureDetector(
              onTap: () {
                setState(() {
                  for (var d in widget.dates) d['isSelected'] = false;
                  date['isSelected'] = true;
                });
                _scrollController.animateTo(index * 100.w,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
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
                      Text(date['month'] as String? ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(date['price'] as String? ?? '',
                          style: TextStyle(
                              color: date['isSelected']
                                  ? const Color(0xFFF37023)
                                  : const Color(0xFF909090))),
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
