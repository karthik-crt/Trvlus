import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../models/search_data.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';
import 'FlightDetailsPage.dart';
import 'Search_Result_Page.dart';

String departureTime = "";
String arrivalTime = "";
String fare = "";
String indepartureTime = "";
String inarrivalTime = "";
int selectedBaggage = 0;
String infare = "";
double total = 0.0;
String finaldepDateformat = "";
String finalarrDateformat = "";

class Localroundtrip extends StatefulWidget {
  String airportCode;
  String fromAirport;

  String toairportCode;
  String toAirport;
  String selectedDepDate;
  String selectedReturnDate;
  String selectedTripType;

  Localroundtrip({
    super.key,
    required this.airportCode,
    required this.fromAirport,
    required this.toairportCode,
    required this.toAirport,
    required this.selectedDepDate,
    required this.selectedReturnDate,
    required this.selectedTripType,
  });

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
    searchData = await ApiService().getSearchResult(
      airportCode,
      fromAirport,
      toairportCode,
      toAirport,
      selectedDepDate,
      selectedReturnDate,
      selectedTripType,
    );
    outbound = searchData.response.results.first;
    print("outbound${searchData.response.results.first.length}");
    inbound = searchData.response.results.last;
    print("inbound${searchData.response.results.last.length}");
    print(widget.selectedDepDate);

    departureTime = outbound.first.segments.first.first.origin.depTime
        .toString()
        .substring(11, 16);

    DateTime depDateTime = DateTime.parse(
        outbound.first.segments.first.first.origin.depTime.toString());
    print(depDateTime);
    finaldepDateformat = DateFormat("dd MMM yy").format(depDateTime);
    print("finaldepDateformat$finaldepDateformat");

    arrivalTime = outbound.first.segments.last.last.destination.arrTime
        .toString()
        .substring(11, 16);
    DateTime arrDateTime = DateTime.parse(
        inbound.first.segments.last.last.destination.arrTime.toString());
    finalarrDateformat = DateFormat("dd MMM yy").format(arrDateTime);
    print("finalarrDateformat$finalarrDateformat");

    fare = outbound.first.fare.baseFare.toString();

    indepartureTime = inbound.first.segments.first.first.origin.depTime
        .toString()
        .substring(11, 16);
    inarrivalTime = inbound.first.segments.last.last.destination.arrTime
        .toString()
        .substring(11, 16);
    infare = inbound.first.fare.baseFare.toString();

    total = double.parse(fare)! + double.parse(infare)!;

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
    return Scaffold(
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
          mainAxisSize: MainAxisSize.min, // 👈 prevents full screen expansion
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
                      style: TextStyle(color: Color(0xFF606060), fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlightDetailsPage(
                              flight: const {},
                              city: 'mdu',
                              destination: 'maa',
                              airlineName: 'airindia',
                              cityName: 'madurai',
                              cityCode: 'maa',
                            )));
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
                // height: 170,
                // width: 340,
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
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFFF37023),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${finaldepDateformat.toString()} - ${finalarrDateformat.toString()}",
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
                              fontWeight: FontWeight.bold, color: Colors.white),
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
                                    fontWeight: FontWeight.bold, fontSize: 10)),
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
                        // Text("dfbdgb"),
                        // Image.asset('assets/images/flightStop.png'),
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
                                    fontWeight: FontWeight.bold, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Text(
                    //               widget.toAirport,
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.black,
                    //                   fontSize: 15),
                    //             ),
                    //             SizedBox(width: 5),
                    //             Text(
                    //               widget.toairportCode,
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 10),
                    //             ),
                    //           ],
                    //         ),
                    //         Text("",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold, fontSize: 10)),
                    //       ],
                    //     ),
                    //     Image.asset('assets/images/flightStop.png'),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.end,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Text(
                    //               widget.fromAirport,
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.black,
                    //                   fontSize: 15),
                    //             ),
                    //             SizedBox(width: 5),
                    //             Text(
                    //               widget.airportCode,
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 10),
                    //             ),
                    //           ],
                    //         ),
                    //         Text("",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold, fontSize: 10)),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 5),
                    // DotDivider(
                    //   dotSize: 1.h,
                    //   spacing: 2.r,
                    //   dotCount: 100,
                    //   color: Colors.grey,
                    // ),
                    // SizedBox(height: 10),
                    // const Row(
                    //   children: [
                    //     Text(
                    //       "5 Traveller",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.black,
                    //           fontSize: 15),
                    //     ),
                    //     Spacer(),
                    //     Text(
                    //       "Economy",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.black,
                    //           fontSize: 15),
                    //     ),
                    //     SizedBox(width: 10),
                    //     Icon(
                    //       Icons.stars,
                    //       color: Colors.orange,
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),

              // Second Orange Container (moved outside)
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selectedBaggage == 0
                              ? Colors.white
                              : Color(0xFFF37023),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selectedBaggage == 1
                              ? Colors.white
                              : Color(0xFFF37023),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
          ? Center(child: CircularProgressIndicator())
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
                                text: outbound.length.toString(),
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
                      // SizedBox(width: 60.w),
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
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      selectedBaggage == 0 ? outbound.length : inbound.length,
                  itemBuilder: (context, index) {
                    final flight =
                        selectedBaggage == 0 ? outbound[index] : inbound[index];

                    int outBoundDuration = searchData.response.results.first
                        .first.segments.first.first.duration;
                    int hours = outBoundDuration ~/ 60; // integer division
                    int minutes = outBoundDuration % 60;
                    return FlightCard(
                      flight: flight,
                      hours: hours,
                      minutes: minutes,
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
  final int hours; // Add hours parameter
  final int minutes;

  const FlightCard({
    super.key,
    required this.flight,
    required this.hours,
    required this.minutes,
  });

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  bool isExpanded = false;
  int selectedFare = -1;

  // int deration = widget.flight.segments.first.first.duration;

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
            // Check if the flight is from outbound (BLR to DEL) or inbound (DEL to BLR)
            if (selectedBaggage == 0) {
              // Outbound flight (BLR to DEL)
              departureTime = widget.flight.segments.first.first.origin.depTime
                  .toString()
                  .substring(11, 16);
              print("departureTime$departureTime");
              print("selectedBaggage$selectedBaggage");
              arrivalTime = widget
                  .flight.segments.first.last.destination.arrTime
                  .toString()
                  .substring(11, 16);
              fare = widget.flight.fare.baseFare.toString();
              print("fare$fare");
              // selectedBaggage = 1;
            } else {
              print("selectedBaggage$selectedBaggage");

              // Inbound flight (DEL to BLR)
              indepartureTime = widget
                  .flight.segments.first.first.origin.depTime
                  .toString()
                  .substring(11, 16);
              inarrivalTime = widget
                  .flight.segments.last.last.destination.arrTime
                  .toString()
                  .substring(11, 16);
              infare = widget.flight.fare.baseFare.toString();
              print("infare$infare");
            }

            total = double.parse(fare)! + double.parse(infare)!;
            print("total$total");
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
                            const SizedBox(
                              width: 10,
                            ),
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
                                            text: widget.flight.segments.first
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
                                          text: widget.flight.isRefundable
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
                        SizedBox(
                          // height: 2.h,
                          width: 5,
                        ),
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
                              // highlight layover
                              fontWeight: FontWeight.w500,
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
                              : "${widget.flight.segments.first.length - 1} Stop",
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
                            // Text(searchData.response.results[index][innerIndex].airlineCode,
                            Text(
                              widget.flight.segments.first.first.origin.airport
                                  .cityCode,
                              style: TextStyle(
                                fontSize: 12.sp,
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
                SizedBox(
                  height: 5,
                ),
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
                              margin: EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              padding: EdgeInsets.all(5),
                              // height: 320,
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
                                            selectedBaggage = 1;
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
                                            const SizedBox(
                                              width: 10,
                                            ),
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
                                                        return "Contact Cust.support"; // or "No Cancellation Policy"
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                        return "Contact Cust.support"; // or "No Cancellation Policy"
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
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              padding: EdgeInsets.all(5),
                              // height: 320,
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
                                    // height: 40,
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
                                            const SizedBox(
                                              width: 10,
                                            ),
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                        const SizedBox(
                                          height: 15,
                                        ),
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
                const SizedBox(
                  height: 10,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
