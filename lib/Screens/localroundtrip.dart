import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:trvlus/Screens/Home_Page.dart';

import '../models/commissionpercentage.dart';
import '../models/customercommision.dart';
import '../models/search_data.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';
import 'FlightDetailsPage.dart';

// Global variables (consider moving to state management if the app grows)
String departureTime = "";
String arrivalTime = "";
String indepartureTime = "";
String inarrivalTime = "";
int selectedBaggage = 0;
String finalrounddepDateformat = "";
String finalroundarrDateformat = "";
late ComissionPercentage commission;
Customercommission? customer;

double onwardNetFare = 0.0;
double returnNetFare = 0.0;
double totalNetFare = 0.0;

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

  Localroundtrip({
    super.key,
    required this.airportCode,
    required this.fromAirport,
    required this.toairportCode,
    required this.toAirport,
    required this.selectedDepDate,
    required this.selectedReturnDate,
    required this.selectedTripType,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });

  @override
  State<Localroundtrip> createState() => _LocalroundtripState();
}

class _LocalroundtripState extends State<Localroundtrip> {
  int selectedindex = 0;
  int selectedbuild = 0;
  bool _isButtonVisible = false;
  late SearchData searchData;
  int passengerCount = 0;

  bool isLoading = true;

  // Separate scroll controllers for outbound and inbound
  ScrollController _outboundScrollController = ScrollController();
  ScrollController _inboundScrollController = ScrollController();

  List<Result> outbound = [];
  List<Result> inbound = [];
  Result? selectedOutbound;
  Result? selectedInbound;

  int adultCount = adults;
  int childCount = children;
  int infantCount = infants;

  // Pagination variables - separate for outbound and inbound
  static const int _pageSize = 10;
  int _outboundCurrentPage = 0;
  int _inboundCurrentPage = 0;
  bool _isLoadingMoreOutbound = false;
  bool _isLoadingMoreInbound = false;

  // FILTER - Separate filters for outbound and inbound
  late List<Map<String, dynamic>> uniqueAirlines;

  // Outbound filters
  Set<String> _outboundSelectedAirlineCodes = <String>{};
  int? _outboundSelectedStops;
  bool _outboundHideNonRefundable = false;
  String? _outboundSelectedDepartureTimeRange;
  String? _outboundSelectedArrivalTimeRange;

  // Inbound filters
  Set<String> _inboundSelectedAirlineCodes = <String>{};
  int? _inboundSelectedStops;
  bool _inboundHideNonRefundable = false;
  String? _inboundSelectedDepartureTimeRange;
  String? _inboundSelectedArrivalTimeRange;

  String? filterorigin;
  String? filterdestination;

  double outboundFlatOffer = 0.0;
  double inboundFlatOffer = 0.0;

  @override
  void initState() {
    print("LOCAL ROUNDRIP");
    print(widget.selectedDepDate);
    print(widget.selectedReturnDate);
    super.initState();
    filterorigin = widget.fromAirport;
    filterdestination = widget.toAirport;
    print("wighet${widget.adultCount}");

    // Setup scroll listeners for pagination
    _outboundScrollController.addListener(_onOutboundScroll);
    _inboundScrollController.addListener(_onInboundScroll);

    getSearchData(
      widget.airportCode,
      widget.fromAirport,
      widget.toairportCode,
      widget.toAirport,
      widget.selectedDepDate,
      widget.selectedReturnDate,
      widget.selectedTripType,
    );
    // getCustomerCommission();
  }

  @override
  void dispose() {
    _outboundScrollController.dispose();
    _inboundScrollController.dispose();
    super.dispose();
  }

  void _onOutboundScroll() {
    if (_outboundScrollController.position.pixels >=
        _outboundScrollController.position.maxScrollExtent * 0.8) {
      _loadMoreOutbound();
    }
  }

  void _onInboundScroll() {
    if (_inboundScrollController.position.pixels >=
        _inboundScrollController.position.maxScrollExtent * 0.8) {
      _loadMoreInbound();
    }
  }

  void _loadMoreOutbound() {
    if (_isLoadingMoreOutbound) return;

    final filteredOutbound = getFilteredOutbound();
    final groupedFlights = groupFlightsByAirlineAndNumber(filteredOutbound);
    final totalPages = (groupedFlights.length / _pageSize).ceil();

    if (_outboundCurrentPage < totalPages - 1) {
      setState(() {
        _isLoadingMoreOutbound = true;
        _outboundCurrentPage++;
        _isLoadingMoreOutbound = false;
      });
    }
  }

  void _loadMoreInbound() {
    if (_isLoadingMoreInbound) return;

    final filteredInbound = getFilteredInbound();
    final groupedFlights = groupFlightsByAirlineAndNumber(filteredInbound);
    final totalPages = (groupedFlights.length / _pageSize).ceil();

    if (_inboundCurrentPage < totalPages - 1) {
      setState(() {
        _isLoadingMoreInbound = true;
        _inboundCurrentPage++;
        _isLoadingMoreInbound = false;
      });
    }
  }

  getCommissionData() async {
    try {
      commission = await ApiService().commissionPercentage();
      print("COMMISION$commission");
    } catch (e) {
      print("Error loading commission: $e");
    }
  }

  getSearchData(
    String airportCode,
    String fromAirport,
    String toairportCode,
    String toAirport,
    String selectedDepDate,
    String selectedReturnDate,
    String selectedTripType,
  ) async {
    setState(() {
      isLoading = true;
    });

    try {
      customer = await ApiService().getcustomercommission();
      print("customer$customer");
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
        infantCount,
      );

      outbound = searchData.response.results.first;
      inbound = searchData.response.results.last;
      print("Passenger Count");

      final adult = widget.adultCount;
      print("adultCount$adult");
      final child = widget.childCount;
      print("childCount$child");
      final infant = widget.infantCount;
      print("infantCount$infant");
      passengerCount = (int.tryParse(adult.toString()) ?? 0) +
          (int.tryParse(child.toString()) ?? 0) +
          (int.tryParse(infant.toString()) ?? 0);
      print("passengerCount$passengerCount");

      // Compute unique airlines(FILTER AIRLINES)
      Set<String> codes = <String>{};
      uniqueAirlines = [
        {"name": "All Airlines", "code": null, "logo": "", "price": ""}
      ];
      for (var group in [outbound, inbound]) {
        for (int j = 0; j < group.length; j++) {
          String code = group[j].segments.first.first.airline.airlineCode;
          if (!codes.contains(code)) {
            codes.add(code);
            String name = group[j].segments.first.first.airline.airlineName;
            uniqueAirlines.add({
              "name": name,
              "code": code,
              "logo": "assets/$code.gif",
              "price": ""
            });
          }
        }
      }

      // Set default selected flights
      if (outbound.isNotEmpty) {
        // Find cheapest net fare flight
        var sortedOutbound = List<Result>.from(outbound);
        sortedOutbound.sort(
            (a, b) => _calculateNetFare(a).compareTo(_calculateNetFare(b)));
        selectedOutbound = sortedOutbound.first;

        departureTime = selectedOutbound!.segments.first.first.origin.depTime
            .toString()
            .substring(11, 16);
        arrivalTime = selectedOutbound!.segments.last.last.destination.arrTime
            .toString()
            .substring(11, 16);

        DateTime depDateTime = DateTime.parse(
            selectedOutbound!.segments.first.first.origin.depTime.toString());
        finalrounddepDateformat = DateFormat("dd MMM yy").format(depDateTime);

        DateTime arrDateTime = DateTime.parse(selectedOutbound!
            .segments.last.last.destination.arrTime
            .toString());
        finalroundarrDateformat = DateFormat("dd MMM yy").format(arrDateTime);

        onwardNetFare = _calculateNetFare(selectedOutbound!);
        outboundFlatOffer = _calculateFlatOffer(selectedOutbound!); // ← NEW
      }

      if (inbound.isNotEmpty) {
        var sortedInbound = List<Result>.from(inbound);
        sortedInbound.sort(
            (a, b) => _calculateNetFare(a).compareTo(_calculateNetFare(b)));
        selectedInbound = sortedInbound.first;

        indepartureTime = selectedInbound!.segments.first.first.origin.depTime
            .toString()
            .substring(11, 16);
        inarrivalTime = selectedInbound!.segments.last.last.destination.arrTime
            .toString()
            .substring(11, 16);

        returnNetFare = _calculateNetFare(selectedInbound!);
        inboundFlatOffer = _calculateFlatOffer(selectedInbound!); // ← NEW
      }

      totalNetFare = onwardNetFare + returnNetFare;
    } catch (e) {
      print("Error loading search data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<int> get outboundCurrentSelectedIndices {
    if (_outboundSelectedAirlineCodes.isEmpty) return [];
    List<int> indices = [];
    for (String code in _outboundSelectedAirlineCodes) {
      for (int i = 1; i < uniqueAirlines.length; i++) {
        if (uniqueAirlines[i]["code"] == code) {
          indices.add(i);
          break;
        }
      }
    }
    return indices;
  }

  List<int> get inboundCurrentSelectedIndices {
    if (_inboundSelectedAirlineCodes.isEmpty) return [];
    List<int> indices = [];
    for (String code in _inboundSelectedAirlineCodes) {
      for (int i = 1; i < uniqueAirlines.length; i++) {
        if (uniqueAirlines[i]["code"] == code) {
          indices.add(i);
          break;
        }
      }
    }
    return indices;
  }

  List<Result> getFilteredOutbound() {
    var filtered = outbound.where((flight) {
      if (_outboundSelectedAirlineCodes.isNotEmpty) {
        if (!_outboundSelectedAirlineCodes.contains(
            flight.segments.first.first.airline.airlineCode)) return false;
      }
      if (_outboundSelectedStops != null) {
        int stops = flight.segments.first.length - 1;
        if (_outboundSelectedStops! >= 2) return stops >= 2;
        return stops == _outboundSelectedStops!;
      }
      if (_outboundHideNonRefundable) {
        return flight.isRefundable == true;
      }
      if (_outboundSelectedDepartureTimeRange != null &&
          _outboundSelectedDepartureTimeRange!.isNotEmpty) {
        DateTime depTime = flight.segments.first.first.origin.depTime.toLocal();
        int hour = depTime.hour;
        bool matches = false;
        switch (_outboundSelectedDepartureTimeRange) {
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
        if (!matches) return false;
      }
      if (_outboundSelectedArrivalTimeRange != null &&
          _outboundSelectedArrivalTimeRange!.isNotEmpty) {
        DateTime arrTime =
            flight.segments.first.last.destination.arrTime.toLocal();
        int hour = arrTime.hour;
        bool matches = false;
        switch (_outboundSelectedArrivalTimeRange) {
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
        if (!matches) return false;
      }
      return true;
    }).toList();

    if (filtered.isNotEmpty) {
      filterorigin =
          filtered.first.segments.first.first.origin.airport.cityName;
      filterdestination =
          filtered.last.segments.last.last.destination.airport.cityName;
    }
    return filtered;
  }

  List<Result> getFilteredInbound() {
    var filtered = inbound.where((flight) {
      if (_inboundSelectedAirlineCodes.isNotEmpty) {
        if (!_inboundSelectedAirlineCodes
            .contains(flight.segments.first.first.airline.airlineCode)) {
          return false;
        }
      }
      if (_inboundSelectedStops != null) {
        int stops = flight.segments.first.length - 1;
        if (_inboundSelectedStops! >= 2) return stops >= 2;
        return stops == _inboundSelectedStops!;
      }
      if (_inboundHideNonRefundable) {
        return flight.isRefundable == true;
      }
      if (_inboundSelectedDepartureTimeRange != null &&
          _inboundSelectedDepartureTimeRange!.isNotEmpty) {
        DateTime depTime = flight.segments.first.first.origin.depTime.toLocal();
        int hour = depTime.hour;
        bool matches = false;
        switch (_inboundSelectedDepartureTimeRange) {
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
        if (!matches) return false;
      }
      if (_inboundSelectedArrivalTimeRange != null &&
          _inboundSelectedArrivalTimeRange!.isNotEmpty) {
        DateTime arrTime =
            flight.segments.first.last.destination.arrTime.toLocal();
        int hour = arrTime.hour;
        bool matches = false;
        switch (_inboundSelectedArrivalTimeRange) {
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
        if (!matches) return false;
      }
      return true;
    }).toList();
    return filtered;
  }

  // ✅ NEW: Group flights by airline, flight number, route, and schedule
  Map<String, List<Result>> groupFlightsByAirlineAndNumber(
      List<Result> results) {
    Map<String, List<Result>> groupedFlights = {};

    for (var flight in results) {
      // Get airline code and flight number
      String airlineCode = flight.segments.first.first.airline.airlineCode;
      String flightNumber = flight.segments.first.first.airline.flightNumber;

      // Get departure time (HH:MM format)
      String depTime = flight.segments.first.first.origin.depTime
          .toLocal()
          .toString()
          .substring(11, 16);

      // Get arrival time (HH:MM format)
      String arrTime = flight.segments.first.last.destination.arrTime
          .toLocal()
          .toString()
          .substring(11, 16);

      // Get origin and destination codes
      String originCode = flight.segments.first.first.origin.airport.cityCode;
      String destCode = flight.segments.first.last.destination.airport.cityCode;

      // Create unique key including route and times
      String key =
          "$airlineCode-$flightNumber-$originCode-$destCode-$depTime-$arrTime";

      if (!groupedFlights.containsKey(key)) {
        groupedFlights[key] = [];
      }
      groupedFlights[key]!.add(flight);
    }

    // Sort each group by price (lowest first)
    groupedFlights.forEach((key, flights) {
      flights.sort((a, b) {
        int priceA = (double.parse(a.fare.offeredFare.toString()) +
                double.parse(a.fare.tdsOnCommission.toString()))
            .round();
        int priceB = (double.parse(b.fare.offeredFare.toString()) +
                double.parse(b.fare.tdsOnCommission.toString()))
            .round();
        return priceA.compareTo(priceB);
      });
    });

    return groupedFlights;
  }

  // Get paginated results for grouped flights
  Map<String, List<Result>> getPaginatedOutbound() {
    final filtered = getFilteredOutbound();
    final grouped = groupFlightsByAirlineAndNumber(filtered);
    final keys = grouped.keys.toList();
    final endIndex = (_outboundCurrentPage + 1) * _pageSize;
    final paginatedKeys = keys.take(endIndex.clamp(0, keys.length)).toList();

    Map<String, List<Result>> paginatedGrouped = {};
    for (var key in paginatedKeys) {
      paginatedGrouped[key] = grouped[key]!;
    }
    return paginatedGrouped;
  }

  Map<String, List<Result>> getPaginatedInbound() {
    final filtered = getFilteredInbound();
    final grouped = groupFlightsByAirlineAndNumber(filtered);
    final keys = grouped.keys.toList();
    final endIndex = (_inboundCurrentPage + 1) * _pageSize;
    final paginatedKeys = keys.take(endIndex.clamp(0, keys.length)).toList();

    Map<String, List<Result>> paginatedGrouped = {};
    for (var key in paginatedKeys) {
      paginatedGrouped[key] = grouped[key]!;
    }
    return paginatedGrouped;
  }

  double _calculateNetFare(Result flight) {
    double publishFare = flight.fare.publishedFare.toDouble();

    double tboTDS = flight.fare.tdsOnCommission.toDouble();
    double commissionEarned = flight.fare.commissionEarned.toDouble();
    double otherCharges = flight.fare.otherCharges ?? 0.0;

    double customerComm = 0.0;
    if (customer != null && customer!.data.isNotEmpty && commissionEarned > 0) {
      var commData = customer!.data[0];
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

    double tdsOnPlb = flight.fare.tdsOnPlb.toDouble();
    double plbEarned = flight.fare.plbEarned.toDouble();

    double finalPlb = commissionEarned + plbEarned;
    double detection = finalPlb - customerComm - tboTDS - tdsOnPlb;
    double percentage = detection * 0.02;
    double flatOffer = detection - percentage;

    double netFare = publishFare + otherCharges - flatOffer;
    return netFare;
  }

  double _calculateFlatOffer(Result flight) {
    double commissionEarned = flight.fare.commissionEarned.toDouble();
    double tboTDS = flight.fare.tdsOnCommission.toDouble();
    double tdsOnPlb = flight.fare.tdsOnPlb.toDouble();
    double plbEarned = flight.fare.plbEarned.toDouble();

    double customerComm = 0.0;
    if (customer != null && customer!.data.isNotEmpty && commissionEarned > 0) {
      var commData = customer!.data[0];
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
        customerComm = commData.commission_250_300?.toDouble() ?? 0.0;
      } else if (earned <= 300) {
        customerComm = commData.commission_250_300?.toDouble() ?? 0.0;
      } else {
        customerComm = commData.commission_above_300?.toDouble() ?? 0.0;
      }
    }

    double finalPlb = commissionEarned + plbEarned;
    double detection = finalPlb - customerComm - tboTDS - tdsOnPlb;
    double percentage = detection * 0.02;
    double flatOffer = detection - percentage;

    return flatOffer;
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
  Widget build(BuildContext context) {
    // Get both filtered and paginated lists
    final filteredOutbound = getFilteredOutbound();
    final filteredInbound = getFilteredInbound();
    final groupedOutbound = groupFlightsByAirlineAndNumber(filteredOutbound);
    final groupedInbound = groupFlightsByAirlineAndNumber(filteredInbound);
    final paginatedOutbound = getPaginatedOutbound();
    final paginatedInbound = getPaginatedInbound();

    // Select current lists based on selected tab
    final currentGrouped =
        selectedBaggage == 0 ? groupedOutbound : groupedInbound;
    final currentPaginated =
        selectedBaggage == 0 ? paginatedOutbound : paginatedInbound;
    final currentScrollController = selectedBaggage == 0
        ? _outboundScrollController
        : _inboundScrollController;

    // Get the correct flight count for current direction
    final currentFlightCount =
        selectedBaggage == 0 ? groupedOutbound.length : groupedInbound.length;

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
                    "Loading flights...",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            bottomNavigationBar: _buildBottomNavigationBar(),
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              backgroundColor: Colors.grey.shade200,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(115),
                child: _buildAppBarBottom(),
              ),
              automaticallyImplyLeading: false,
            ),
            body: currentGrouped.isEmpty
                ? _buildNoFlightsWidget()
                : ListView(
                    controller: currentScrollController,
                    children: [
                      _buildFilterHeader(currentFlightCount),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: currentPaginated.length,
                        itemBuilder: (context, index) {
                          final flightKey =
                              currentPaginated.keys.toList()[index];
                          final flightVariants = currentPaginated[flightKey]!;
                          final lowestPriceFlight = flightVariants.first;

                          int outBoundDuration =
                              lowestPriceFlight.segments.first.first.duration;
                          int hours = outBoundDuration ~/ 60;
                          int minutes = outBoundDuration % 60;

                          return FlightCard(
                            key: ValueKey('${selectedBaggage}_$flightKey'),
                            flight: lowestPriceFlight,
                            flightVariants: flightVariants,
                            hours: hours,
                            minutes: minutes,
                            onFlightSelected: (selectedFlight) {
                              _handleFlightSelection(selectedFlight);
                            },
                          );
                        },
                      ),
                      // Loading indicator for pagination
                      if (currentPaginated.length < currentGrouped.length)
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFF37023),
                            ),
                          ),
                        ),
                      // End of results indicator
                      if (currentPaginated.length == currentGrouped.length &&
                          currentGrouped.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "Showing all ${currentGrouped.length} flights",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          );
  }

  void _handleFlightSelection(Result selectedFlight) {
    setState(() {
      double netFare = _calculateNetFare(selectedFlight);
      double flatOffer = _calculateFlatOffer(selectedFlight);

      if (selectedBaggage == 0) {
        selectedOutbound = selectedFlight;
        departureTime = selectedFlight.segments.first.first.origin.depTime
            .toString()
            .substring(11, 16);
        arrivalTime = selectedFlight.segments.last.last.destination.arrTime
            .toString()
            .substring(11, 16);

        DateTime depDateTime = DateTime.parse(
            selectedFlight.segments.first.first.origin.depTime.toString());
        finalrounddepDateformat = DateFormat("dd MMM yy").format(depDateTime);

        DateTime arrDateTime = DateTime.parse(
            selectedFlight.segments.last.last.destination.arrTime.toString());
        finalroundarrDateformat = DateFormat("dd MMM yy").format(arrDateTime);

        onwardNetFare = netFare;
        outboundFlatOffer = flatOffer; // ← NEW
      } else {
        selectedInbound = selectedFlight;
        indepartureTime = selectedFlight.segments.first.first.origin.depTime
            .toString()
            .substring(11, 16);
        inarrivalTime = selectedFlight.segments.last.last.destination.arrTime
            .toString()
            .substring(11, 16);

        returnNetFare = netFare;
        inboundFlatOffer = flatOffer; // ← NEW
      }

      totalNetFare = onwardNetFare + returnNetFare;
    });
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
                  const Text(
                    "ONWARDS",
                    style: TextStyle(
                        color: Color(0xFF0F9374),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$departureTime - $arrivalTime",
                    style: const TextStyle(color: Color(0xFF909090)),
                  ),
                  Text(
                    "₹ ${(onwardNetFare.round())}",
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
                    "$indepartureTime - $inarrivalTime",
                    style: TextStyle(color: Color(0xFF909090)),
                  ),
                  Text(
                    "₹ ${(returnNetFare.round())}",
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
                    "₹ ${(totalNetFare.round())}",
                    style: TextStyle(color: Color(0xFF606060), fontSize: 20),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: _handleViewFareTap,
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
    );
  }

  void _handleViewFareTap() {
    if (selectedOutbound != null && selectedInbound != null) {
      String formatDate(String? dateStr) {
        if (dateStr == null || dateStr.isEmpty) return '';
        try {
          final date = DateTime.parse(dateStr);
          return DateFormat('E, dd MMM yy').format(date);
        } catch (e) {
          return '';
        }
      }

      final outdepDate = selectedOutbound!.segments.first.first.origin.depTime
          .toString()
          .substring(0, 10);
      final outdepdate = formatDate(outdepDate);
      final outdepTime = selectedOutbound!.segments.first.first.origin.depTime
          .toString()
          .substring(11, 16);
      final arrDate = selectedOutbound!.segments.last.last.destination.arrTime
          .toString()
          .substring(0, 10);
      final outarrdate = formatDate(arrDate);
      final outarrTime = selectedOutbound!
          .segments.last.last.destination.arrTime
          .toString()
          .substring(11, 16);
      final refundable = selectedOutbound!.isRefundable == true ? "R" : "NR";

      Map<String, dynamic> outBoundData = {
        "flight": {},
        "destination":
            selectedOutbound!.segments.last.last.destination.airport.cityName,
        "airlineName":
            selectedOutbound!.segments.first.first.airline.airlineName,
        "airlineCode":
            selectedOutbound!.segments.first.first.airline.airlineCode,
        "cityName":
            selectedOutbound!.segments.first.first.origin.airport.cityName,
        "cityCode":
            selectedOutbound!.segments.first.first.origin.airport.cityCode,
        "flightNumber":
            selectedOutbound!.segments.first.first.airline.flightNumber,
        "descityName":
            selectedOutbound!.segments.first.first.destination.airport.cityName,
        "descityCode":
            selectedOutbound!.segments.first.first.destination.airport.cityCode,
        "outdepDate": outdepdate,
        "outdepTime": outdepTime,
        "outarrDate": outarrdate,
        "outarrTime": outarrTime,
        "duration": selectedOutbound!.segments.first.first.duration.toString(),
        "refundable": refundable,
        "stop": '',
        "airportName":
            selectedOutbound!.segments.first.first.origin.airport.airportName,
        "desairportName": selectedOutbound!
            .segments.last.last.destination.airport.airportName,
        "basefare": selectedOutbound!.fare.baseFare,
        "tax": selectedOutbound!.fare.tax,
        "segments": null,
        "adultCount": adultCount,
        "childCount": childCount,
        "infantCount": infantCount,
        "outresultindex": selectedOutbound?.resultIndex,
        "traceid": searchData.response.traceId,
        "total": totalNetFare.toString(),
        "IsLCC": selectedOutbound?.isLcc,
      };

      // INBOUND
      final indepDate = selectedInbound!.segments.first.first.origin.depTime
          .toString()
          .substring(0, 10);
      final inDepDate = formatDate(indepDate);
      final indepTime = selectedInbound!.segments.first.first.origin.depTime
          .toString()
          .substring(11, 16);
      final inarrDate = selectedInbound!.segments.last.last.destination.arrTime
          .toString()
          .substring(0, 10);
      final inarrdate = formatDate(inarrDate);
      final inarrTime = selectedInbound!.segments.last.last.destination.arrTime
          .toString()
          .substring(11, 16);
      final inrefundable = selectedInbound!.isRefundable == true ? "R" : "NR";

      Map<String, dynamic> inBoundData = {
        "flight": {},
        "destination":
            selectedInbound!.segments.last.last.destination.airport.cityName,
        "airlineName":
            selectedInbound!.segments.first.first.airline.airlineName,
        "cityName":
            selectedInbound!.segments.first.first.origin.airport.cityName,
        "airlineCode":
            selectedInbound!.segments.first.first.airline.airlineCode,
        "cityCode":
            selectedInbound!.segments.first.first.origin.airport.cityCode,
        "flightNumber":
            selectedInbound!.segments.first.first.airline.flightNumber,
        "descityName":
            selectedInbound!.segments.first.first.destination.airport.cityName,
        "descityCode":
            selectedInbound!.segments.first.first.destination.airport.cityCode,
        "indepDate": inDepDate,
        "indepTime": indepTime,
        "inarrDate": inarrdate,
        "inarrTime": inarrTime,
        "duration": selectedInbound!.segments.first.first.duration.toString(),
        "refundable": inrefundable,
        "stop": '',
        "airportName":
            selectedInbound!.segments.first.first.origin.airport.airportName,
        "desairportName":
            selectedInbound!.segments.last.last.destination.airport.airportName,
        "basefare": selectedInbound!.fare.baseFare,
        "tax": selectedInbound!.fare.tax,
        "segments": null,
        "adultCount": adultCount,
        "childCount": childCount,
        "infantCount": infantCount,
        "inresultindex": selectedInbound?.resultIndex,
        "traceid": searchData.response.traceId,
        "total": totalNetFare.toString(),
        "IsLCC": selectedInbound?.isLcc,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlightDetailsPage(
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
            outdepDate: outdepDate,
            outdepTime: outdepTime,
            outarrDate: arrDate,
            outarrTime: outarrTime,
            indepDate: indepDate,
            indepTime: indepTime,
            inarrDate: inarrDate,
            inarrTime: inarrTime,
            duration: '',
            refundable: '',
            stop: '',
            airportName: '',
            desairportName: '',
            segments: null,
            adultCount: adultCount,
            childCount: childCount,
            infantCount: infantCount,
            outresultindex: selectedOutbound?.resultIndex,
            inresultindex: selectedInbound?.resultIndex,
            traceid: searchData.response.traceId,
            total: totalNetFare.toString(),
            basefare: null,
            coupouncode: (outboundFlatOffer + inboundFlatOffer).round(),
            coup: outboundFlatOffer,
            coupo: inboundFlatOffer,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select both outbound and inbound flights"),
        ),
      );
    }
  }

  Widget _buildAppBarBottom() {
    return Column(
      children: [
        Container(
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
                            height: 13, width: 20, color: Colors.black),
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
                      style: const TextStyle(fontSize: 12, color: Colors.black),
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
                    // Reset inbound scroll to top when switching to outbound
                    if (_inboundScrollController.hasClients) {
                      _inboundScrollController.jumpTo(0);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color:
                        selectedBaggage == 0 ? Colors.white : Color(0xFFF37023),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Text(
                    "${widget.airportCode} - ${widget.toairportCode}",
                    style: TextStyle(
                        color:
                            selectedBaggage == 0 ? Colors.black : Colors.white,
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
                    // Reset outbound scroll to top when switching to inbound
                    if (_outboundScrollController.hasClients) {
                      _outboundScrollController.jumpTo(0);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color:
                        selectedBaggage == 1 ? Colors.white : Color(0xFFF37023),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Text(
                    "${widget.toairportCode} - ${widget.airportCode}",
                    style: TextStyle(
                        color:
                            selectedBaggage == 1 ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoFlightsWidget() {
    return Center(
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
    );
  }

  Widget _buildFilterHeader(int flightCount) {
    // Get current direction label
    final currentDirection = selectedBaggage == 0
        ? "${widget.airportCode} - ${widget.toairportCode}"
        : "${widget.toairportCode} - ${widget.airportCode}";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: flightCount.toString(),
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
                    SizedBox(height: 2.h),
                    Text(
                      currentDirection,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        color: Color(0xFFF37023),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 25.h,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Use separate filter state based on selected tab
                    final isOutbound = selectedBaggage == 0;
                    var filterData =
                        await showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) {
                        return Container(
                          height: 620.h,
                          child: FilterBottomSheet(
                            airlines: uniqueAirlines,
                            currentSelectedIndices: isOutbound
                                ? outboundCurrentSelectedIndices
                                : inboundCurrentSelectedIndices,
                            initialHideNonRefundable: isOutbound
                                ? _outboundHideNonRefundable
                                : _inboundHideNonRefundable,
                            filterorigin: filterorigin,
                            filterdestination: filterdestination,
                            initialStops: isOutbound
                                ? _outboundSelectedStops
                                : _inboundSelectedStops,
                            initialDepartureTime: isOutbound
                                ? (_outboundSelectedDepartureTimeRange ?? "")
                                : (_inboundSelectedDepartureTimeRange ?? ""),
                            initialArrivalTime: isOutbound
                                ? (_outboundSelectedArrivalTimeRange ?? "")
                                : (_inboundSelectedArrivalTimeRange ?? ""),
                          ),
                        );
                      },
                    );

                    if (filterData != null) {
                      setState(() {
                        List<int> indices = filterData['airlineIndices'] ?? [];
                        Set<String> airlineCodes = <String>{};
                        for (int i in indices) {
                          airlineCodes.add(uniqueAirlines[i]['code'] as String);
                        }

                        if (isOutbound) {
                          _outboundSelectedAirlineCodes = airlineCodes;
                          _outboundSelectedStops = filterData['stops'];
                          _outboundHideNonRefundable =
                              filterData['hideNonRefundable'] ?? false;
                          _outboundSelectedDepartureTimeRange =
                              filterData['departureTime'];
                          _outboundSelectedArrivalTimeRange =
                              filterData['arrivalTime'];
                          // Reset pagination when filter changes
                          _outboundCurrentPage = 0;
                        } else {
                          _inboundSelectedAirlineCodes = airlineCodes;
                          _inboundSelectedStops = filterData['stops'];
                          _inboundHideNonRefundable =
                              filterData['hideNonRefundable'] ?? false;
                          _inboundSelectedDepartureTimeRange =
                              filterData['departureTime'];
                          _inboundSelectedArrivalTimeRange =
                              filterData['arrivalTime'];
                          // Reset pagination when filter changes
                          _inboundCurrentPage = 0;
                        }
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
                    padding:
                        EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ✅ UPDATED FlightCard with Multiple Fare Options
class FlightCard extends StatefulWidget {
  final Result flight;
  final List<Result> flightVariants; // ✅ NEW: All fare variants
  final int hours;
  final int minutes;
  final Function(Result) onFlightSelected;

  const FlightCard({
    super.key,
    required this.flight,
    required this.flightVariants, // ✅ NEW
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
    // Use the lowest price flight (first in sorted list)
    final displayFlight = widget.flight;

    // LAYOVER CALCULATION
    int totalFlightMinutes = 0;
    for (var segmentGroup in displayFlight.segments.first) {
      totalFlightMinutes += segmentGroup.duration;
    }
    int totalHours = totalFlightMinutes ~/ 60;
    int totalMinutesRem = totalFlightMinutes % 60;
    String formattedTotalDuration = "${totalHours}h ${totalMinutesRem}m";

    String layoverText = "";
    int numStops = displayFlight.segments.first.length - 1;
    if (numStops > 0) {
      int layoverMinutes = displayFlight.segments.first[1].groundTime;
      int layoverHours = layoverMinutes ~/ 60;
      int layoverMins = layoverMinutes % 60;
      String layoverCity =
          displayFlight.segments.first[1].origin.airport.cityName;
      layoverText = "${layoverHours}h ${layoverMins}m layover at $layoverCity";
      print("layoverText$layoverText");
    }

    // TOTAL DURATION CALCULATION
    var segments = displayFlight.segments.first;
    String displayTotalDuration = formattedTotalDuration;

    if (numStops > 0) {
      DateTime firstDepTime = segments.first.origin.depTime;
      DateTime lastArrTime = segments.last.destination.arrTime;
      int totalTripMinutes = lastArrTime.difference(firstDepTime).inMinutes;
      int totalTripHours = totalTripMinutes ~/ 60;
      int totalTripMins = totalTripMinutes % 60;
      displayTotalDuration = "${totalTripHours}h ${totalTripMins}m";
    }

    // FARE CALCULATION FOR LOWEST PRICE
    double publishFare = displayFlight.fare.publishedFare.toDouble();
    print("publishFare$publishFare");
    String offeredFare = displayFlight.fare.offeredFare.toString();
    print("offeredFare$offeredFare");
    double tboTDS = displayFlight.fare.tdsOnCommission.toDouble();
    print("tboTDS$tboTDS");
    final commissionEarned = displayFlight.fare.commissionEarned.toDouble();
    print("commissionEarned$commissionEarned");
    double customerComm = 0.0;
    if (customer!.data.isNotEmpty && commissionEarned > 0) {
      var commData = customer!.data[0];
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

    double customertdsplb = displayFlight.fare.tdsOnPlb.toDouble();
    print("customertdsplb$customertdsplb");
    double customerplbearned = displayFlight.fare.plbEarned.toDouble();
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
    double othercharges = displayFlight.fare.otherCharges;
    print("othercharges$othercharges");
    int finaloffFare = (publishFare + othercharges - finalflatoffer).round();
    print("intfinaloffFare$finaloffFare");
    double finaloffferFare = double.parse(
      (publishFare + othercharges - finalflatoffer).toStringAsFixed(2),
    );
    print("finaloffferFare$finaloffferFare");

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
                // MAIN CARD CONTENT (showing lowest price)
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
                                "assets/${displayFlight.airlineCode}.gif",
                                height: 35,
                                width: 35,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      displayFlight.segments.first.first.airline
                                          .airlineName,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp)),
                                  RichText(
                                    text: TextSpan(
                                      text: displayFlight.segments.first.first
                                          .airline.airlineCode,
                                      style: Theme.of(context)
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
                                            text: displayFlight.segments.first
                                                .first.airline.flightNumber,
                                            style: Theme.of(context)
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
                                          text: displayFlight.isRefundable
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
                          if (finaloffFare < publishFare)
                            Text(
                              "₹${displayFlight.fare.publishedFare.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          Text(
                            "₹$finaloffFare",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            layoverText,
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

                // Time and location details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              displayFlight.segments.first.first.origin.depTime
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
                            DateTime.parse(displayFlight
                                .segments.first.first.origin.depTime
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
                          (displayFlight.segments.first.length - 1 == 0)
                              ? "Non Stop"
                              : "${displayFlight.segments.first.length - 1} Stop",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        Image.asset('assets/images/flightStop.png'),
                        Text(
                          displayTotalDuration,
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
                              displayFlight
                                  .segments.last.last.destination.arrTime
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
                            DateTime.parse(displayFlight
                                .segments.last.last.destination.arrTime
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
                              displayFlight
                                  .segments.first.first.origin.airport.cityName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              displayFlight
                                  .segments.first.first.origin.airport.cityCode,
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
                              displayFlight.segments.last.last.destination
                                  .airport.cityName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              displayFlight.segments.last.last.destination
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

                // ✅ EXPANDED SECTION - Show ALL fare variants with OLD DESIGN
                if (isExpanded && widget.flightVariants.length > 1)
                  Column(
                    children:
                        widget.flightVariants.asMap().entries.map((entry) {
                      final index = entry.key;
                      final variantFlight = entry.value;

                      print("INbaseee${variantFlight.fare.baseFare}");
                      print("INTaxx${variantFlight.fare.tax}");
                      // Calculate price for this variant
                      double varPublishFare =
                          variantFlight.fare.publishedFare.toDouble();
                      String varOfferedFare =
                          variantFlight.fare.offeredFare.toString();
                      double varTboTDS =
                          variantFlight.fare.tdsOnCommission.toDouble();
                      final varCommissionEarned =
                          variantFlight.fare.commissionEarned.toDouble();

                      double varCustomerComm = 0.0;
                      if (customer!.data.isNotEmpty &&
                          varCommissionEarned > 0) {
                        var commData = customer!.data[0];
                        double earned = varCommissionEarned;
                        if (earned >= 0 && earned <= 50) {
                          varCustomerComm =
                              commData.commission_0_50?.toDouble() ?? 0.0;
                        } else if (earned <= 100) {
                          varCustomerComm =
                              commData.commission_50_100?.toDouble() ?? 0.0;
                        } else if (earned <= 150) {
                          varCustomerComm =
                              commData.commission_100_150?.toDouble() ?? 0.0;
                        } else if (earned <= 200) {
                          varCustomerComm =
                              commData.commission_150_200?.toDouble() ?? 0.0;
                        } else if (earned <= 250) {
                          varCustomerComm =
                              commData.commission_200_250?.toDouble() ?? 0.0;
                        } else if (earned <= 300) {
                          varCustomerComm =
                              commData.commission_250_300?.toDouble() ?? 0.0;
                        } else {
                          varCustomerComm =
                              commData.commission_above_300?.toDouble() ?? 0.0;
                        }
                      }
                      print("varCustomerComm$varCustomerComm");

                      double varCustomertdsplb =
                          variantFlight.fare.tdsOnPlb.toDouble();
                      double varCustomerplbearned =
                          variantFlight.fare.plbEarned.toDouble();
                      double varfinalcommissionplb =
                          varCommissionEarned + varCustomerplbearned;
                      double varCustomercommissiondetection =
                          varfinalcommissionplb -
                              varCustomerComm -
                              varTboTDS -
                              varCustomertdsplb;
                      int varFinalcustomercommission =
                          varCustomercommissiondetection.round();
                      double varFinalcommissionpercentage =
                          varFinalcustomercommission * 0.02;
                      double varFinalflatoffer =
                          varCustomercommissiondetection -
                              varFinalcommissionpercentage;
                      print("varFinalflatoffer$varFinalflatoffer");
                      double varothercharges = variantFlight.fare.otherCharges;
                      int varFinaloffFare =
                          (varPublishFare + varothercharges - varFinalflatoffer)
                              .round();

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFFFF4EF)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ OLD DESIGN: Radio button at the top
                            Transform.scale(
                              scale: 1.2,
                              child: Radio(
                                  activeColor: Color(0xFFF37023),
                                  visualDensity: VisualDensity(
                                      horizontal: -1, vertical: -3),
                                  value: index,
                                  groupValue: selectedFare,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFare = value!;
                                      widget.onFlightSelected(variantFlight);
                                    });
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFFFE7DA),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    variantFlight.segments.first.first
                                            .supplierFareClass
                                            .toString()
                                            .isEmpty
                                        ? "Publish Fare"
                                        : variantFlight.segments.first.first
                                            .supplierFareClass
                                            .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1C1E1D),
                                    ),
                                  ),
                                  Text(
                                    "₹$varFinaloffFare",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFFF37023),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  _buildAmenityRow(
                                    'assets/ssr/bag.png',
                                    "Cabin Bag",
                                    variantFlight
                                        .segments.first.first.cabinBaggage
                                        .toString(),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildAmenityRow(
                                    'assets/ssr/checkin.png',
                                    "Check In",
                                    variantFlight.segments.first.first.baggage
                                            .isEmpty
                                        ? '0'
                                        : variantFlight
                                            .segments.first.first.baggage,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildAmenityRow(
                                    'assets/ssr/seat.png',
                                    "Seats",
                                    "Included",
                                  ),
                                  const SizedBox(height: 10),
                                  _buildAmenityRow(
                                    'assets/ssr/meals.png',
                                    "Meals",
                                    variantFlight.isFreeMealAvailable == 'true'
                                        ? "Included"
                                        : "Not Included",
                                  ),
                                  const SizedBox(height: 10),
                                  _buildAmenityRow(
                                    'assets/ssr/cancel.png',
                                    "Cancellation",
                                    variantFlight.miniFareRules.isEmpty
                                        ? "Contact Cust.support"
                                        : "Not Chargable",
                                  ),
                                  const SizedBox(height: 10),
                                  _buildAmenityRow(
                                    'assets/ssr/date.png',
                                    "Date Change",
                                    variantFlight.miniFareRules.isEmpty
                                        ? "Contact Cust.support"
                                        : variantFlight.miniFareRules[0]
                                                .firstWhere((rule) =>
                                                    rule.type == 'Reissue')
                                                .details
                                                .isNotEmpty
                                            ? "Chargable"
                                            : "",
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 10),

                // Promotional discount
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityRow(String iconPath, String label, String value) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          height: 16,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 10),
        )
      ],
    );
  }
}

// ✅ UPDATED FilterBottomSheet to support multi-select
class FilterBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> airlines;
  final List<int>? currentSelectedIndices; // ✅ Changed to List
  final bool initialHideNonRefundable;
  final String? filterorigin;
  final String? filterdestination;
  final int? initialStops;
  final String initialDepartureTime;
  final String initialArrivalTime;

  const FilterBottomSheet({
    Key? key,
    required this.airlines,
    this.currentSelectedIndices, // ✅ Changed
    this.initialHideNonRefundable = false,
    this.filterorigin,
    this.filterdestination,
    this.initialStops,
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
  Set<int> selectedAirlineIndices = <int>{}; // ✅ Changed to Set

  @override
  void initState() {
    super.initState();
    selectedAirlineIndices = Set<int>.from(
      widget.currentSelectedIndices ?? <int>[],
    );
    hideNonRefundable = widget.initialHideNonRefundable;
    selectedStops = widget.initialStops;
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h,
                        spacing: 2.r,
                        dotCount: 103,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8.h),
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
                    SizedBox(height: 8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h,
                        spacing: 2.r,
                        dotCount: 103,
                        color: Colors.grey,
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
                    SizedBox(height: 15.h),
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
                        dotSize: 1.h,
                        spacing: 2.r,
                        dotCount: 103,
                        color: Colors.grey,
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
                                vertical: 8.w,
                                horizontal: 5,
                              ),
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
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Regular airline row - multi-select with circular checkbox
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
                                vertical: 8.w,
                                horizontal: 5,
                              ),
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
              // ✅ Return list
              'stops': selectedStops,
              'hideNonRefundable': hideNonRefundable,
              'departureTime': departureTime,
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
