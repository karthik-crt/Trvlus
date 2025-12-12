import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../models/search_data.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';

class Viewfulldetails extends StatefulWidget {
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
  final List<List<Segment>>? segments;
  final Result? outboundFlight;
  final Result? inboundFlight;

  Viewfulldetails(
      {required this.flight,
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
      this.segments,
      this.outboundFlight,
      this.inboundFlight});

  @override
  State<Viewfulldetails> createState() => _ViewfulldetailsState();
}

class _ViewfulldetailsState extends State<Viewfulldetails> {
  int selectedBaggage = 0;
  late final bool outboundFlight;
  late final bool inboundFlight;

  @override
  Widget build(BuildContext context) {
    // final flight =
    //     widget.outboundFlight!.segments.first.first.origin.airport.cityName;
    // final flight1 = widget
    //     .outboundFlight!.segments.first.first.destination.airport.cityCode;
    // print("flightflight$flight");
    // print("flight1flight1$flight1");
    final city = widget.city;
    final destination = widget.destination;
    final sights = widget.stop;
    print(sights);
    final segments = jsonEncode(widget.segments);
    print("fullsegments$segments");
    print("airlinecode${widget.airlineCode}");

    return Scaffold(
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
            if (widget.segments != null) ...[
              ...List.generate(widget.segments!.length, (index) {
                return Column(
                  children: [
                    ...List.generate(widget.segments![index].length,
                        (innerIndex) {
                      final depTimeStr = widget
                          .segments![index][innerIndex].origin.depTime
                          .toString();
                      DateTime depDateTime = DateTime.parse(depTimeStr);
                      final finaldepDateformat =
                          DateFormat("EEE,dd MMM yy").format(depDateTime);
                      final depTimeFormatted =
                          DateFormat("HH:mm").format(depDateTime);

                      final arrTimeStr = widget
                          .segments![index][innerIndex].destination.arrTime
                          .toString();
                      DateTime arrDateTime = DateTime.parse(arrTimeStr);
                      final finalarrDateformat =
                          DateFormat("EEE,dd MMM yy").format(arrDateTime);
                      final arrTimeFormatted =
                          DateFormat("HH:mm").format(arrDateTime);

                      return Column(
                        children: [
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                          "assets/${widget.airlineCode ?? ""}.gif"),
                                      SizedBox(width: 12),
                                      Container(
                                        width: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget
                                                  .segments![index][innerIndex]
                                                  .airline
                                                  .airlineName,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: widget
                                                    .segments![index]
                                                        [innerIndex]
                                                    .airline
                                                    .airlineCode,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                                children: [
                                                  TextSpan(text: " "),
                                                  TextSpan(
                                                    text: widget
                                                        .segments![index]
                                                            [innerIndex]
                                                        .airline
                                                        .flightNumber,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: Colors
                                                              .grey.shade700,
                                                        ),
                                                  ),
                                                  TextSpan(text: " "),
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
                                                  color: Colors.black,
                                                ),
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
                                                depTimeFormatted,
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
                                          Text(
                                            widget.stop == "Non-Stop"
                                                ? "Non Stop"
                                                : "",
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          Image.asset(
                                              'assets/images/flightColor.png'),
                                          Text(
                                            widget.duration ?? "",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12.sp,
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
                                                arrTimeFormatted,
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
                                                widget
                                                    .segments![index]
                                                        [innerIndex]
                                                    .origin
                                                    .airport
                                                    .cityName,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                widget
                                                    .segments![index]
                                                        [innerIndex]
                                                    .origin
                                                    .airport
                                                    .cityCode,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              widget
                                                  .segments![index][innerIndex]
                                                  .origin
                                                  .airport
                                                  .airportName,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey,
                                              ),
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
                                                widget
                                                    .segments![index]
                                                        [innerIndex]
                                                    .destination
                                                    .airport
                                                    .cityName,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                widget
                                                    .segments![index]
                                                        [innerIndex]
                                                    .destination
                                                    .airport
                                                    .cityCode,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              textAlign: TextAlign.end,
                                              widget
                                                  .segments![index][innerIndex]
                                                  .destination
                                                  .airport
                                                  .airportName,
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (innerIndex <
                              widget.segments![index].length - 1) ...[
                            SizedBox(height: 10.h),
                            Container(
                              height: 40.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFE7E5),
                                border: Border.all(color: Color(0xFFFFD7D7)),
                                borderRadius: BorderRadius.circular(
                                    8.r), // Rounded corners
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.sync_alt,
                                      color: Color(0xFFFF4D4F),
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Builder(
                                      builder: (context) {
                                        final nextDepTimeStr = widget
                                            .segments![index][innerIndex + 1]
                                            .origin
                                            .depTime
                                            .toString();
                                        final currentArrTimeStr = widget
                                            .segments![index][innerIndex]
                                            .destination
                                            .arrTime
                                            .toString();
                                        DateTime nextDep =
                                            DateTime.parse(nextDepTimeStr);
                                        DateTime currentArr =
                                            DateTime.parse(currentArrTimeStr);
                                        Duration layoverDuration =
                                            nextDep.difference(currentArr);
                                        String layoverTime =
                                            "${layoverDuration.inHours}H ${layoverDuration.inMinutes % 60}m";
                                        String layoverCity = widget
                                            .segments![index][innerIndex]
                                            .destination
                                            .airport
                                            .cityName;
                                        return Text(
                                          "$layoverTime Layover at $layoverCity",
                                          style: TextStyle(
                                            color: Color(0xFFFF4D4F),
                                            fontSize: 14, // Font size
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ],
                      );
                    })
                  ],
                );
              }),
            ]
            // RoundTrip
            else ...[
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
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
                          "${widget.outboundFlight!.segments.first.first.origin.airport.cityCode} - ${widget.outboundFlight!.segments.first.last.destination.airport.cityCode}",
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
                          "${widget.inboundFlight!.segments.first.first.origin.airport.cityCode} - ${widget.inboundFlight!.segments.first.last.destination.airport.cityCode}",
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
              // 🔹 Show flights depending on selected tab
              if (selectedBaggage == 0)
                buildFlightDetails(widget.outboundFlight!)
              else
                buildFlightDetails(widget.inboundFlight!),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildFlightDetails(Result result) {
    return Column(
      children: List.generate(result.segments.length, (index) {
        return Column(
          children: List.generate(result.segments[index].length, (innerIndex) {
            final segment = result.segments[index][innerIndex];
            final depTime = DateTime.parse(segment.origin.depTime.toString());
            print("depTime$depTime");
            final arrTime =
                DateTime.parse(segment.destination.arrTime.toString());
            print("arrTime$arrTime");

            final depDateFormatted =
                DateFormat("EEE,dd MMM yy").format(depTime);
            final arrDateFormatted =
                DateFormat("EEE,dd MMM yy").format(arrTime);
            final depTimeFormatted = DateFormat("HH:mm").format(depTime);
            final arrTimeFormatted = DateFormat("HH:mm").format(arrTime);

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                            "assets/${segment.airline.airlineCode}.gif"),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              segment.airline.airlineName,
                              style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 12.sp, color: Color(0xFF909090)),
                                children: [
                                  TextSpan(
                                      text: "${segment.airline.airlineCode} "),
                                  TextSpan(
                                      text: "${segment.airline.flightNumber} "),
                                  TextSpan(
                                    text: result.isRefundable == true
                                        ? "R"
                                        : "NR",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF37023)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          "Economy Class",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFF1C1E1D),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.stars,
                          color: Color(0xFFF37023),
                        )
                      ],
                    ),
                    SizedBox(height: 10.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h, // Adjust size
                        spacing: 2.r, // Adjust spacing
                        dotCount: 97, // Adjust number of dots
                        color: Colors.grey, // Adjust color
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(depTimeFormatted,
                                style: TextStyle(
                                    color: Color(0xFF1C1E1D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp)),
                            Text(depDateFormatted,
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  segment.origin.airport.cityName,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  segment.origin.airport.airportCode,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: Color(0xFF909090),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(segment.origin.airport.airportName,
                                  style: TextStyle(fontSize: 12.sp)),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(widget.outboundFlight!.segments.first.length -
                                        1 ==
                                    0
                                ? "Non Stop"
                                : ""),
                            Image.asset(
                              'assets/images/flightStop.png',
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(arrTimeFormatted,
                                style: TextStyle(
                                    color: Color(0xFF1C1E1D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp)),
                            Text(arrDateFormatted,
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  segment.destination.airport.cityName,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  segment.destination.airport.airportCode,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: Color(0xFF909090),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                  textAlign: TextAlign.end,
                                  segment.destination.airport.airportName,
                                  style: TextStyle(fontSize: 12.sp)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
