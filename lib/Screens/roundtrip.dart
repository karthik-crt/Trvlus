import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../models/commissionpercentage.dart';
import '../models/search_data.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';
import 'FlightDetailsPage.dart';

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
    setState(() {
      isLoading = true;
      print("international true");
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
    setState(() {
      isLoading = false;
      print("international false");
    });
  }

  String _calculateTotalDuration(List currentSegment) {
    if (currentSegment.isEmpty) return '0h 0min';
    try {
      DateTime dep =
          DateTime.parse(currentSegment.first.origin.depTime.toString());
      DateTime arr =
          DateTime.parse(currentSegment.last.destination.arrTime.toString());
      Duration diff = arr.difference(dep);
      int hours = diff.inHours;
      int mins = diff.inMinutes % 60;
      return '${hours}h ${mins}min';
    } catch (e) {
      return 'N/A'; // Fallback if parsing fails
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCommissionData();
    print("Hewlooooooo");
    super.initState();
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
        : widget.search.response.results.isNotEmpty
            ? (() {
                // ✅ LOGGING CODE INSERTED HERE (runs on every build when data exists)
                print(
                    'Total result groups: ${widget.search.response.results.length}');
                if (widget.search.response.results.isNotEmpty) {
                  var firstGroup = widget.search.response.results.first;
                  print('Flights in first group: ${firstGroup.length}');
                  if (firstGroup.isNotEmpty) {
                    var firstFlight = firstGroup.first;
                    print(
                        'Segments in first flight: ${firstFlight.segments.length}');
                    if (firstFlight.segments.isNotEmpty) {
                      print(
                          'Sub-segments in first segment: ${firstFlight.segments.first.length}');
                    }
                  }
                }
                return Scaffold(
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
                                    "",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              maxLines: 3,
                                              widget.fromAirport,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    ],
                                  ),
                                  const Spacer(),
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
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            maxLines: 3,
                                            widget.toAirport,
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
                                            widget.toairportCode,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ],
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
                                    " Traveller",
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
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DateScroller(),
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
                                          text: widget
                                              .search.response.results[0].length
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
                                // SizedBox(width: 80.w),
                                // Container(
                                //   height: 25.h,
                                //   child: ElevatedButton.icon(
                                //     onPressed: () {
                                //       showModalBottomSheet(
                                //         context: context,
                                //         isScrollControlled: true,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.vertical(
                                //               top: Radius.circular(16)),
                                //         ),
                                //         builder: (context) {
                                //           return Container(
                                //             height: 620.h, // Fixed height
                                //             child: FilterBottomSheet(),
                                //           );
                                //         },
                                //       );
                                //     },
                                //     icon: Image.asset(
                                //       'assets/images/Filter.png',
                                //       alignment: Alignment.center,
                                //       height: 12.h,
                                //       width: 12.w,
                                //     ),
                                //     label: Text(
                                //       "Filter",
                                //       style: TextStyle(
                                //         fontFamily: 'Inter',
                                //         fontSize: 10.sp, // Reduced text size
                                //         color: Color(0xFF606060),
                                //       ),
                                //     ),
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.grey.shade100,
                                //       elevation: 3,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(
                                //             30.r), // Rounded corners
                                //       ),
                                //       padding: EdgeInsets.symmetric(
                                //           vertical: 3.h, horizontal: 20.w),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          // Outer virtualization: Builds groups lazily
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.search.response.results.length,
                            itemBuilder: (context, index) {
                              return _buildFlightGroup(index);
                            },
                          ),
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
                );
              })()
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
                    ],
                  ),
                ),
              );
  }

  // New method to preserve inner logic (exact copy of your original inner List.generate for flights)
  Widget _buildFlightGroup(int index) {
    return Column(
      children: [
        ...List.generate(widget.search.response.results[index].length,
            (innerIndex) {
          String hello =
              widget.search.response.results[index].length.toString();
          final depTimeStr = widget.search.response.results[index][innerIndex]
              .segments.first.first.origin.depTime
              .toString();
          DateTime depDateTime = DateTime.parse(depTimeStr);

          final depTimeFormatted = DateFormat("HH:mm").format(depDateTime);
          final arrTimeStr = widget.search.response.results[index][innerIndex]
              .segments.last.last.destination.arrTime
              .toString();
          DateTime arrDateTime = DateTime.parse(arrTimeStr);

          final arrTimeFormatted = DateFormat("HH:mm").format(arrDateTime);

          // FARE CALCULATION
          String publishFare = widget
              .search.response.results[index][innerIndex].fare.publishedFare
              .toString();
          print("publishFare$publishFare");
          String offeredFare = widget
              .search.response.results[index][innerIndex].fare.offeredFare
              .toString();
          print("offeredFare$offeredFare");
          final commissionEarned = widget
              .search.response.results[index][innerIndex].fare.commissionEarned
              .toDouble();
          print("TBOcommision$commissionEarned");
          double tboTDS = widget
              .search.response.results[index][innerIndex].fare.tdsOnCommission
              .toDouble();
          print("tboTDS$tboTDS");
          double publishFareVal = double.tryParse(publishFare) ?? 0;
          double offeredFareVal = double.tryParse(offeredFare) ?? 0;
          // COMMISIONPERCENTAGE

          double commissionpercentage =
              commission.data.first.commissionforgds.toDouble();
          print("commissionpercentage$commissionpercentage");
          // COMMISSION
          double commissionraw = publishFareVal - offeredFareVal;
          double owncommision =
              double.parse((commissionEarned * 0.02).toStringAsFixed(2));
          // print("owncommision$owncommision");

          // calculation
          double tbooverallCommision = commissionEarned - tboTDS;
          print("tbooverallCommision$tbooverallCommision");
          double toubikcommisionearned =
              tbooverallCommision - commissionpercentage;
          print("toubikcommisionearned$toubikcommisionearned");
          double toubiktdsoncommision =
              double.parse((toubikcommisionearned * 0.02).toStringAsFixed(2));
          print("toubiktdsoncommision$toubiktdsoncommision");
          double tdsplb = widget
              .search.response.results[index][innerIndex].fare.tdsOnPlb
              .toDouble();
          print("tdsplb$tdsplb");

          // NETFARE
          int offFare = (double.parse(offeredFare.toString()) +
                  double.parse(tboTDS.toString()) +
                  double.parse(toubiktdsoncommision.toString()) +
                  double.parse(tdsplb.toString()) +
                  double.parse(commissionpercentage.toString()))
              .round();
          print("offFare$offFare");

          return GestureDetector(
            onTap: () {
              Map<String, dynamic> outBoundData = {
                "resultindex": widget
                    .search.response.results[index][innerIndex].resultIndex,
                "traceid": widget.search.response.traceId,
              };

              Navigator.push(
                  context,
                  (MaterialPageRoute(
                      builder: (context) => FlightDetailsPage(
                          flight: {},
                          outBoundData: outBoundData,
                          inBoundData: {},
                          city: '',
                          destination: '',
                          airlineName: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .airline
                              .airlineName,
                          airlineCode: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .airline
                              .airlineCode,
                          airportName: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .origin
                              .airport
                              .airportName,
                          flightNumber: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .airline
                              .flightNumber,
                          cityName: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .origin
                              .airport
                              .cityName,
                          cityCode: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .origin
                              .airport
                              .cityCode,
                          depDate: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .origin
                              .depTime
                              .toString(),
                          depTime: depTimeFormatted,
                          desairportName: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .destination
                              .airport
                              .airportName,
                          descityName: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .destination
                              .airport
                              .cityName,
                          descityCode: widget
                              .search
                              .response
                              .results[index][innerIndex]
                              .segments
                              .first
                              .first
                              .destination
                              .airport
                              .cityCode,
                          segments: widget.search.response.results[index][innerIndex].segments,
                          arrDate: widget.search.response.results[index][innerIndex].segments.last.last.destination.arrTime.toString(),
                          arrTime: arrTimeFormatted,
                          refundable: '',
                          resultindex: widget.search.response.results[index][innerIndex].resultIndex,
                          traceid: widget.search.response.traceId,
                          adultCount: widget.adultCount,
                          childCount: widget.childCount,
                          infantCount: widget.infantCount,
                          stop: (widget.search.response.results[index][innerIndex].segments!.first.length - 1) == 0 ? "Non-Stop" : "${widget.search.response.results[index][innerIndex].segments!.first.length - 1} Stops",
                          duration: '',
                          basefare: widget.search.response.results[index][innerIndex].fare.baseFare,
                          tax: widget.search.response.results[index][innerIndex].fare.tax,
                          isLLC: widget.search.response.results[index][innerIndex].isLcc))));
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₹${widget.search.response.results[index][innerIndex].fare.publishedFare.toInt()}",
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "₹$offFare",
                                      style: TextStyle(
                                          color: Color(0xFFF37023),
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ...List.generate(
                              widget.search.response.results[index][innerIndex]
                                  .segments.length, (segmentsindex) {
                            // Aggregate for this main segment (outbound or return)
                            var currentSegment = widget
                                .search
                                .response
                                .results[index][innerIndex]
                                .segments[segmentsindex];
                            if (currentSegment.isEmpty)
                              return const SizedBox.shrink(); // Skip empty
                            var firstLeg = currentSegment.first;
                            var lastLeg = currentSegment.last;
                            // DEP DATE
                            var depString =
                                currentSegment.first.origin.depTime.toString();
                            var arrString = currentSegment
                                .last.destination.arrTime
                                .toString();

                            // Convert to DateTime
                            DateTime depDate = DateTime.parse(depString);
                            DateTime arrDate = DateTime.parse(arrString);

                            // Format both
                            String finalDepDateFormat =
                                DateFormat("EEE, dd MMM yy").format(depDate);
                            String finalArrDateFormat =
                                DateFormat("EEE, dd MMM yy").format(arrDate);

                            int totalStops = currentSegment.length - 1;
                            String totalDuration = _calculateTotalDuration(
                                currentSegment); // Use helper below
                            String layoverText = totalStops > 0
                                ? '${totalStops}h layover at ${currentSegment[1].origin.airport.cityName}'
                                : ''; // Customize as needed, e.g., loop middle for multi-layovers
                            String stopsText = totalStops == 0
                                ? 'NON STOP'
                                : '$totalStops STOP';
                            String airlineName = firstLeg.airline
                                .airlineName; // Or aggregate if multi-airline
                            String airlineCode = firstLeg.airline.airlineCode;
                            String flightNumber = firstLeg.airline.flightNumber;

                            return Column(
                              children: [
                                Container(
                                  // margin: EdgeInsets.all(10),
                                  // padding: EdgeInsets.all(15),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (layoverText.isNotEmpty)
                                        Row(
                                          children: [
                                            Text(
                                              layoverText,
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
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                airlineName,
                                                style: TextStyle(
                                                    color: Color(0xFF1C1E1D),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: airlineCode,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color: Colors
                                                              .grey.shade700),
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
                                                    TextSpan(
                                                        text: flightNumber,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall
                                                            ?.copyWith(
                                                                fontSize: 12.sp,
                                                                color: Colors
                                                                    .grey),
                                                        children: [
                                                          WidgetSpan(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          2.w,
                                                                      vertical:
                                                                          4.h),
                                                              child: Container(
                                                                width: 4.w,
                                                                height: 3.h,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    TextSpan(
                                                      text: widget
                                                                  .search
                                                                  .response
                                                                  .results[
                                                                      index][
                                                                      innerIndex]
                                                                  .isRefundable ==
                                                              true
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
                                                    .substring(
                                                        11, 16), // Overall dep
                                                style: TextStyle(
                                                    color: Color(0xFF1C1E1D),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    firstLeg.origin.airport
                                                        .cityName,
                                                    // Overall origin city
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF1C1E1D),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    firstLeg.origin.airport
                                                        .cityCode,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF909090),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                    .substring(
                                                        11, 16), // Overall arr
                                                style: TextStyle(
                                                    color: Color(0xFF1C1E1D),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                finalArrDateFormat,
                                                // Pull from lastLeg.destination.arrTime date part
                                                style: TextStyle(
                                                    color: Color(0xFF909090),
                                                    fontSize: 10),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    lastLeg.destination.airport
                                                        .cityName,
                                                    // Overall dest city
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF1C1E1D),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    lastLeg.destination.airport
                                                        .cityCode,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF909090),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                            // Adjust for desired length
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                      GestureDetector(
                                          onTap: () {}, child: Text(""))
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 25,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFFDAE5FF),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset(
                                  "assets/icon/promocode.svg",
                                  color: Color(0xFF5D89F0),
                                  height: 15,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Flat 10% Off upto Rs.with trvlus coupon",
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
        })
      ],
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool hideNonRefundable = true;
  int? selectedStops;

  String departureTime = "";
  String arrivalTime = "";
  final List<Map<String, String>> airlines = List.generate(
    10,
    (index) => {
      "name": "Emirates",
      "price": "₹500",
      "logo": "assets/images/Emirates.png",
    },
  );
  int? selectedAirlineIndex;

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
                        dotCount: 50, // Adjust number of dots
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
                        dotCount: 50, // Adjust number of dots
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
                        dotCount: 50,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "DEPARTURE FROM DELHI",
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
                      "ARRIVAL AT BANGALURU",
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
                        dotCount: 50, // Adjust number of dots
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
                      itemCount: airlines.length,
                      itemBuilder: (context, index) {
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
                                    // Image.asset(
                                    //   airlines[index]["logo"]!,
                                    //   height: 24.h,
                                    //   width: 24.w,
                                    //   fit: BoxFit.contain,
                                    // ),
                                    SizedBox(width: 8.w),
                                    // Text(
                                    //   // airlines[index]["name"]!,
                                    //   // style: TextStyle(
                                    //   //   fontFamily: 'Inter',
                                    //   //   fontSize: 14.sp,
                                    //   //   fontWeight: FontWeight.w500,
                                    //   //   color: Colors.black,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              // Text(
                              //     // airlines[index]["price"]!,
                              //     // style: TextStyle(
                              //     //   fontSize: 16.sp,
                              //     //   fontWeight: FontWeight.w500,
                              //     //   color: Colors.black,
                              //     // ),
                              //     ),
                            ],
                          ),
                        );
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
            Navigator.pop(context);
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
  const DateScroller({super.key});

  @override
  _DateScrollerState createState() => _DateScrollerState();
}

class _DateScrollerState extends State<DateScroller> {
  List<Map<String, dynamic>> dates = [
    {"month": "Sep, 31", "price": "₹100", "isSelected": false},
    {"month": "Nov", "price": "", "isSelected": true, "color": "hi"},
    {"month": "Sun, 1 Dec", "price": "₹100", "isSelected": false},
    {"month": "Sun, 1 Dec", "price": "₹100", "isSelected": false},
    {"month": "Sun, 1 Dec", "price": "₹100", "isSelected": false},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Colors.white,
        child: Row(
          children: dates.map((date) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  date['isSelected'] = !date['isSelected'];
                  if (date['isSelected']) {
                    for (var otherDate in dates) {
                      if (otherDate != date) {
                        otherDate['isSelected'] = false;
                      }
                    }
                  }
                });
              },
              child: Container(
                height: 40.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: date['color'] == "hi"
                      ? const Color(0xFFF37023)
                      : date['isSelected']
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
                          color: date['month'] == "Nov"
                              ? Colors.white
                              : (date['isSelected']
                                  ? Colors.black
                                  : Colors.black),
                        ),
                      ),
                      if ((date['price'] as String? ?? '').isNotEmpty)
                        Text(
                          date['price'] as String? ?? '',
                          style: TextStyle(
                            color: date['isSelected']
                                ? const Color(
                                    0xFFF37023) // Change price color on selection
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
