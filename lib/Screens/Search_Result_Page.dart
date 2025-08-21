import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trvlus/models/search_data.dart';
import 'package:trvlus/utils/api_service.dart';
import 'package:trvlus/utils/constant.dart';

import 'DotDivider.dart';
import 'FlightDetailsPage.dart';

class FlightResultsPage extends StatefulWidget {
  const FlightResultsPage({Key? key}) : super(key: key);

  @override
  _FlightResultsPageState createState() => _FlightResultsPageState();
}

class _FlightResultsPageState extends State<FlightResultsPage> {
  ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = false;
  double _previousScrollPosition = 0.0;
  late SearchData searchData;
  bool isLoading = true;

  int selectedindex = -1;

  getSearchData() async {
    setState(() {
      isLoading = true;
    });
    searchData = await ApiService().getSearchResult({});
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
    getSearchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: const Center(
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
            floatingActionButton: selectedindex != -1
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      // padding: ,
                      height: 50,
                      width: 325,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFF37023)),
                      child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FlightDetailsPage(
                                          flight: const {},
                                          city: 'mdu',
                                          destination: 'chennai',
                                        )));
                          },
                          child: Text(
                            "Book Now",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
            backgroundColor: const Color(0xFFF5F5F5),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 25.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   searchData.response.origin,
                    //   maxLines: 3,
                    // ),
                    // Text(searchData.response.origin),
                    // Text(searchData.response.destination),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      height: 150,
                      width: 340,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                // offset: Offset(0, 0.7),
                                blurRadius: 3,
                                color: Colors.grey.shade500)
                          ]),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back)),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "17 sep 2024",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15),
                              ),
                              Spacer(),
                              Icon(Icons.edit),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Edit details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Chennai",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "MAA",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Chennai Airport",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Image.asset('assets/images/flightStop.png'),
                              const Spacer(),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Hyderbad",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "MAA",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Hyderbad Airport",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DotDivider(
                            dotSize: 1.h,
                            spacing: 2.r,
                            dotCount: 100,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          const Row(
                            children: [
                              Text(
                                "5 Traveller",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15),
                              ),
                              Spacer(),
                              Text(
                                "Economy",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.stars,
                                color: Colors.orange,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    ...List.generate(searchData.response.results.length,
                        (index) {
                      return Column(
                        children: [
                          ...List.generate(
                              searchData.response.results[index].length,
                              (innerIndex) {
                            int totalMinutes = searchData
                                .response
                                .results[index][innerIndex]
                                .segments
                                .first
                                .first
                                .duration;

                            int hours = totalMinutes ~/ 60; // integer division
                            int minutes = totalMinutes % 60; // remainder

                            String formattedDuration = "${hours}h ${minutes}m";

                            // LAYOVER DURATION CALCULATION
                            // String segments = searchData
                            //     .response
                            //     .results[index][innerIndex]
                            //     .segments
                            //     .first
                            //     .first
                            //     .destination
                            //     .arrTime
                            //     .toString();
                            //
                            // List<Widget> segmentWidgets = [];
                            //
                            // for (int i = 0; i < segments.length - 1; i++) {
                            //   // Arrival of current segment
                            //   DateTime arrTime = DateTime.parse(
                            //       segments[i][0]["Destination"]["ArrTime"]);
                            //
                            //   // Departure of next segment
                            //   DateTime depTime = DateTime.parse(
                            //       segments[i + 1]["Origin"]["DepTime"]);
                            //
                            //   // Layover duration
                            //   Duration layover = depTime.difference(arrTime);
                            //
                            //   int hours = layover.inHours;
                            //   int minutes = layover.inMinutes % 60;
                            //
                            //   // City where layover happens
                            //   String layoverCity = searchData
                            //       .response
                            //       .results[index][innerIndex]
                            //       .segments
                            //       .first
                            //       .first
                            //       .destination
                            //       .airport
                            //       .airportName
                            //       .toString();
                            // }

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedindex = innerIndex;
                                });
                                /*  Get.to(() => FlightDetailsPage(
                                  flight: flight,
                                  city: widget.departureCity,
                                  destination: widget.destinationCity,
                                ));*/
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
                                    color: selectedindex == innerIndex
                                        ? Colors.orange.shade50
                                        : const Color(0xFFFFFFFF),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        // adjust radius
                                                        child: Image.asset(
                                                          "assets/${searchData.response.results[index][innerIndex].segments.first.first.airline.airlineCode}.gif",
                                                          fit: BoxFit.cover,
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                              searchData
                                                                  .response
                                                                  .results[
                                                                      index][
                                                                      innerIndex]
                                                                  .segments
                                                                  .first
                                                                  .first
                                                                  .airline
                                                                  .airlineName,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14.sp)),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: searchData
                                                                  .response
                                                                  .results[
                                                                      index][
                                                                      innerIndex]
                                                                  .airlineCode,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700),
                                                              children: [
                                                                WidgetSpan(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            2.w,
                                                                        vertical:
                                                                            4.h),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          4.w,
                                                                      height:
                                                                          3.h,
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
                                                                TextSpan(
                                                                  text: searchData
                                                                      .response
                                                                      .results[
                                                                          index]
                                                                          [
                                                                          innerIndex]
                                                                      .segments
                                                                      .first
                                                                      .first
                                                                      .airline
                                                                      .flightNumber,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineSmall
                                                                      ?.copyWith(
                                                                        fontSize:
                                                                            12.sp,
                                                                        color:
                                                                            primaryColor,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 38.w),
                                              Image.asset(
                                                "assets/images/Line.png",
                                              ),
                                              const Spacer(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "₹${searchData.response.results[index][innerIndex].fare.publishedFare}",
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "₹${searchData.response.results[index][innerIndex].fare.baseFare}",
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: primaryColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${hours}h ${minutes}m layover at Mumbai",
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: Colors.red,
                                                      // highlight layover
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
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
                                              color: Colors.grey,
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
                                                        searchData
                                                            .response
                                                            .results[index]
                                                                [innerIndex]
                                                            .segments
                                                            .first
                                                            .first
                                                            .origin
                                                            .depTime
                                                            .toLocal()
                                                            .toString()
                                                            .substring(11, 16),
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4.w),
                                                    ],
                                                  ),
                                                  Text(
                                                    searchData
                                                        .response
                                                        .results[index]
                                                            [innerIndex]
                                                        .segments
                                                        .first
                                                        .first
                                                        .origin
                                                        .depTime
                                                        .toLocal()
                                                        .toString()
                                                        .substring(0, 10),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  // Text(searchData.response.results[index][innerIndex].,
                                                  /*  Text(flight["stops"],
                                                      style: TextStyle(
                                                          fontSize: 12.sp)),*/
                                                  Image.asset(
                                                      'assets/images/flightStop.png'),
                                                  Text(
                                                    "${hours}h ${minutes}m",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey,
                                                    ),
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
                                                        searchData
                                                            .response
                                                            .results[index]
                                                                [innerIndex]
                                                            .segments
                                                            .first
                                                            .first
                                                            .destination
                                                            .arrTime
                                                            .toLocal()
                                                            .toString()
                                                            .substring(11, 16),
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4.w),
                                                    ],
                                                  ),
                                                  // Text(searchData.response.results[index][innerIndex].airlineCode,
                                                  Text(
                                                    searchData
                                                        .response
                                                        .results[index]
                                                            [innerIndex]
                                                        .segments
                                                        .first
                                                        .first
                                                        .destination
                                                        .arrTime
                                                        .toLocal()
                                                        .toString()
                                                        .substring(0, 10),
                                                    style: TextStyle(
                                                        fontSize: 12.sp),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        searchData
                                                            .response
                                                            .results[index]
                                                                [innerIndex]
                                                            .segments
                                                            .first
                                                            .last
                                                            .origin
                                                            .airport
                                                            .cityName,
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      // Text(searchData.response.results[index][innerIndex].airlineCode,
                                                      Text(
                                                        searchData
                                                            .response
                                                            .results[index]
                                                                [innerIndex]
                                                            .segments
                                                            .first
                                                            .last
                                                            .origin
                                                            .airport
                                                            .cityCode,
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //SizedBox(height: 4.h),
                                                  // Text(searchData.response.results[index][innerIndex].,
                                                  SizedBox(
                                                    width: 100,
                                                    // child: Text(
                                                    //   searchData
                                                    //       .response
                                                    //       .results[index]
                                                    //           [innerIndex]
                                                    //       .segments
                                                    //       .last
                                                    //       .last
                                                    //       .destination
                                                    //       .airport
                                                    //       .airportName,
                                                    //   style: TextStyle(
                                                    //     fontSize: 12.sp,
                                                    //     color: Colors.grey,
                                                    //   ),
                                                    // ),
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
                                                        searchData
                                                            .response
                                                            .results[index]
                                                                [innerIndex]
                                                            .segments
                                                            .first
                                                            .last
                                                            .destination
                                                            .airport
                                                            .cityName,
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Text(
                                                        searchData
                                                            .response
                                                            .results[index]
                                                                [innerIndex]
                                                            .segments
                                                            .first
                                                            .last
                                                            .destination
                                                            .airport
                                                            .cityCode,
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Text(searchData.response.results[index][innerIndex].airlineCode,
                                                  // Text(
                                                  //   searchData
                                                  //       .response
                                                  //       .results[index]
                                                  //           [innerIndex]
                                                  //       .segments
                                                  //       .first
                                                  //       .first
                                                  //       .origin
                                                  //       .airport
                                                  //       .airportName,
                                                  //   style: TextStyle(
                                                  //       fontSize: 12.sp),
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
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
                    //SizedBox(height: 20.h),
                    /*   Padding(
                      padding:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        elevation: 2,
                        color: Color(0xFFFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                        "assets/images/Navi_back.png"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 60.w),
                                    child: Text(
                                      "${(widget.departureDate ?? DateTime.now()).toLocal().toString().split(' ')[0]}",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset("assets/images/Edit.png"),
                                      SizedBox(width: 10.w),
                                      Text(
                                        "EDIT DETAILS",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    "${widget.departureCity}",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    " DEL",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Spacer(),
                                  Image.asset('assets/images/flightColor.png'),
                                  Spacer(),
                                  Text(
                                    "${widget.destinationCity}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    " BLR",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${widget.departureCity} Airport",
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                        fontSize: 12.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${widget.destinationCity} Airport",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              //Image.asset("assets/images/Divider.png"),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DotDivider(
                                  dotSize: 1.h,
                                  spacing: 2.r,
                                  dotCount: 97,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${widget.travelers} Travelers",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontFamily: 'BricolageGrotesque',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Travel Class: ${widget.travelClass}",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'BricolageGrotesque',
                                            color: Colors.black),
                                      ),
                                      SizedBox(width: 3.w),
                                      Image.asset("assets/images/star.png")
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    DateScroller(),
                    //SizedBox(height: 20.h),
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
                                    text: "  30 ",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
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
                          SizedBox(width: 70.w),
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
                                      height: 620.h, // Fixed height
                                      child: FilterBottomSheet(),
                                    );
                                  },
                                );
                              },
                              icon: Image.asset(
                                'assets/images/Filter.png',
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
                    ),*/
                    //SizedBox(height: 1.h),
                  ],
                ),
              ),
            ),
            //   floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            // floatingActionButton: AnimatedOpacity(
            //   opacity: _isButtonVisible ? 1.0 : 0.0,
            //   duration: const Duration(milliseconds: 300),
            //   child: SizedBox(
            //     height: 45.h, // Reduced height
            //     width: 50.w, // Reduced width
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
            //         size: 30.r, // Adjust the icon size to match the button size
            //         color: Colors.white,
            //       ),
            //       backgroundColor: const Color(0xFFF37023),
            //       shape: const CircleBorder(),
            //       elevation: 6,
            //     ),
            //   ),
            // ),
          );
  }
}

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool hideNonRefundable = true;
  int selectedStops = 1;
  String departureTime = "6 AM-12 Noon";
  String arrivalTime = "6 AM-12 Noon";
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
                                    Image.asset(
                                      airlines[index]["logo"]!,
                                      height: 24.h,
                                      width: 24.w,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      airlines[index]["name"]!,
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
                                airlines[index]["price"]!,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
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
