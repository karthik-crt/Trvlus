import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/search_data.dart';
import '../models/ssr.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';
import 'Payment.dart';
import 'ShowModelSheet.dart';
import 'ViewFullDetails.dart';
import 'additions.dart';

String finaldepDateformat = '';
String finalarrDateformat = '';

class ConfirmTravelerDetails extends StatefulWidget {
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
  final List<Map<String, dynamic>>? initialData;
  final List<Map<String, dynamic>>? childData;
  final List<Map<String, dynamic>>? infantData;
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

  ConfirmTravelerDetails(
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
      this.initialData,
      this.childData,
      this.infantData,
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
      this.isLLC,
      this.outdepDate,
      this.outdepTime,
      this.outarrDate,
      this.outarrTime,
      this.indepDate,
      this.indepTime,
      this.inarrDate,
      this.inarrTime});

  @override
  State<ConfirmTravelerDetails> createState() => _ConfirmTravelerDetailsState();
}

class _ConfirmTravelerDetailsState extends State<ConfirmTravelerDetails> {
  Map<String, dynamic> passenger = {};
  Map<String, dynamic> childpassenger = {};
  Map<String, dynamic> infantpassenger = {};
  Map<String, dynamic> meal = {};

  late SsrData ssrData;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getssrdata();
  }

  getssrdata() async {
    setState(() {
      isLoading = true;
      print("beforeOutput");
    });
    print("CONFIRMTRAVELER");
    print(widget.outdepDate);
    print(widget.outdepTime);
    print(widget.outarrDate);
    print(widget.outarrTime);
    print(widget.indepDate);
    print(widget.indepTime);
    print(widget.inarrDate);
    print(widget.inarrTime);
    print(widget.traceid);
    print(widget.resultindex);
    ssrData =
        await ApiService().ssr(widget.resultindex ?? "", widget.traceid ?? "");
    debugPrint("ssrDATA: ${jsonEncode(ssrData)}", wrapWidth: 4500);
    final helo = ssrData.response;
    debugPrint("RESPONSESSRDTAA${jsonEncode(helo)}", wrapWidth: 1500);

    setState(() {
      isLoading = false;
      print("AferOutput");
    });
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final city = widget.city;
    final destination = widget.destination;
    final pax = widget.initialData;
    print("PAxdetails$pax");
    final child = widget.childData;
    print("childchild$child");
    final infant = widget.infantData;
    print("childchild$child");
    print("ISLLC${widget.isLLC}");

    int selectedindex = -1;
    if (widget.depDate != null) {
      final depDateformat = widget.depDate;
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(depDateformat!);
      final finaldepDateformat = DateFormat("EEE,dd MMM yy").format(parsedDate);

      final arrDateformat = widget.arrDate;
      DateTime arrparsedDate = DateTime.parse(arrDateformat!);
      final finalarrDateformat =
          DateFormat("EEE,dd MMM yy").format(arrparsedDate);
    }

    // Create travelers list from initialData
    final List<Map<String, String>> travelers =
        (pax ?? []).asMap().entries.map((entry) {
      int index = entry.key;
      passenger = entry.value;
      print("index$index");
      print("passengerAdult$passenger");
      return {
        "type": "ADULT ${index + 1}",
        "name": "${passenger['Firstname']} ${passenger['lastname']}",
      };
    }).toList();

    final List<Map<String, String>> travelersChild =
        (child ?? []).asMap().entries.map((entry) {
      int index = entry.key;
      childpassenger = entry.value;
      print("passengerchild$childpassenger");
      return {
        "type": "CHILD ${index + 1}",
        "name": "${childpassenger['Firstname']} ${childpassenger['lastname']}",
      };
    }).toList();

    final List<Map<String, String>> travelersInfant =
        (infant ?? []).asMap().entries.map((entry) {
      int index = entry.key;
      infantpassenger = entry.value;
      print("passengerinfant$infantpassenger");
      return {
        "type": "INFANT ${index + 1}",
        "name":
            "${infantpassenger['Firstname']} ${infantpassenger['lastname']}",
      };
    }).toList();

    return isLoading
        ? Scaffold(
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
        : Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            appBar: AppBar(
              title: Row(children: [
                Text(
                  'Traveler Details ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ]),
              foregroundColor: Colors.black,
              backgroundColor: Color(0xFFF5F5F5),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flight details card (unchanged)
                  if (widget.segments != null) ...[
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Flight header (unchanged)
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  // adjust radius
                                  child: Image.asset(
                                    "assets/${widget.airlineCode ?? ""}.gif",
                                    fit: BoxFit.cover,
                                    height: 35,
                                    width: 35,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.airlineName,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: widget.airlineCode ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
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
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Image.asset("assets/images/star.png"),
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
                                    Text(
                                      widget.depTime ?? "",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateFormat("dd MMM yy").format(
                                        DateTime.parse(
                                            widget.depDate.toString()),
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
                                    Image.asset(
                                        'assets/images/flightColor.png'),
                                    Text(widget.duration ?? "",
                                        style: TextStyle(fontSize: 12.sp)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.arrTime ?? "",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateFormat("dd MMM yy").format(
                                        DateTime.parse(
                                            widget.arrDate.toString()),
                                      ),
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                dotSize: 1.h,
                                spacing: 2.r,
                                dotCount: 97,
                                color: Colors.grey,
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
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: Image.asset(
                                        "assets/images/Traingle.png"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Card(
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
                                          widget
                                              .outboundFlight!
                                              .segments
                                              .first
                                              .last
                                              .destination
                                              .airport
                                              .cityName,
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
                                      child: Image.asset(
                                          "assets/images/Traingle.png"))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],

                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Travelers Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset("assets/images/Edit.png"),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Edit Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  fontFamily: 'Inter',
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Adults",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        fontSize: 12.sp),
                  ),
                  SizedBox(height: 2.h),
                  // Display travelers from initialData
                  ...travelers.map((traveler) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.h),
                      child: TravelerCard(
                        name: traveler['name']!,
                        type: traveler['type']!,
                        isAdult: true,
                        isChild: false,
                        isInfant:
                            false, // Assuming all passengers in initialData are adults
                      ),
                    );
                  }).toList(),
                  // Remove the "Child" section since you only want adults
                  if (widget.childCount! > 0) ...[
                    Text(
                      "Child",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 12.sp),
                    ),
                    SizedBox(height: 2.h),
                    // Display travelers from initialData
                    ...travelersChild.map((traveler) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.h),
                        child: TravelerCard(
                          name: traveler['name']!,
                          type: traveler['type']!,
                          isAdult: false,
                          isChild: true,
                          isInfant:
                              false, // Assuming all passengers in initialData are adults
                        ),
                      );
                    }).toList(),
                  ],

                  if (widget.infantCount! > 0) ...[
                    Text(
                      "Infant",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 12.sp),
                    ),
                    SizedBox(height: 2.h),
                    // Display travelers from initialData
                    ...travelersInfant.map((traveler) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.h),
                        child: TravelerCard(
                          name: traveler['name']!,
                          type: traveler['type']!,
                          isAdult: false,
                          isChild: false,
                          isInfant:
                              true, // Assuming all passengers in initialData are adults
                        ),
                      );
                    }).toList(),
                  ],
                  SizedBox(height: 20.h),
                  // Rest of the UI (Add Additional, GSTN Details, etc.) remains unchanged
                  Text(
                    'Add Additional',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 5),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 0.5,
                                  blurRadius: 0.3,
                                  offset: Offset(0, 0.5))
                            ]),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/seat.png',
                              height: 19,
                              width: 25,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Seats",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                print("TRACEID${widget.traceid}");
                                print("RESULTINDEX${widget.resultindex}");
                                print("adultCount${widget.adultCount}");
                                print("childCount${widget.childCount}");
                                print("infantCount${widget.infantCount}");

                                var value = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Additions(
                                              traceid: widget.traceid,
                                              resultindex: widget.resultindex,
                                              adultCount: widget.adultCount,
                                              childCount:
                                                  widget.childCount ?? 0,
                                              infantCount:
                                                  widget.infantCount ?? 0,
                                            )));
                                print("valuevaluevalue");
                                print(value);
                                meal = value["meal"];
                              },
                              child: Text(
                                "+ ADD",
                                style: TextStyle(
                                    color: Color(0xFFF37023),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      if (ssrData.response != null &&
                          ssrData.response!.baggage != null &&
                          ssrData.response!.baggage.isNotEmpty)
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0.5,
                                    blurRadius: 0.3,
                                    offset: Offset(0, 0.5))
                              ]),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/baggage.png',
                                height: 25,
                                width: 25,
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Baggage",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Additions(
                                                traceid: widget.traceid,
                                                resultindex: widget.resultindex,
                                                adultCount: widget.adultCount,
                                                childCount: widget.childCount,
                                                infantCount: widget.infantCount,
                                              )));
                                },
                                child: Text(
                                  "+ ADD",
                                  style: TextStyle(
                                      color: Color(0xFFF37023),
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      SizedBox(height: 15),
                      if (ssrData.response != null &&
                          ssrData.response!.mealDynamic != null &&
                          ssrData.response!.mealDynamic.isNotEmpty)
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0.5,
                                    blurRadius: 0.3,
                                    offset: Offset(0, 0.5))
                              ]),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/meals.png',
                                height: 25,
                                width: 25,
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Meals",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Additions(
                                                traceid: widget.traceid,
                                                resultindex: widget.resultindex,
                                                adultCount: widget.adultCount,
                                                childCount: widget.childCount,
                                                infantCount: widget.infantCount,
                                              )));
                                },
                                child: Text(
                                  "+ ADD",
                                  style: TextStyle(
                                      color: Color(0xFFF37023),
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "GSTN Details (Optional)",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add GSTIN for Booking",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Color(0xFFF5F5F5),
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(1.r),
                                ),
                              ),
                              builder: (context) => GSTBottomSheet(),
                            );
                          },
                          child: Text(
                            "+ ADD",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFFF37023),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // GestureDetector(
                  //   onTap: () {
                  //     showModalBottomSheet(
                  //         context: context,
                  //         backgroundColor: Color(0xFFF5F5F5),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(7)),
                  //         builder: (BuildContext context) {
                  //           selectedindex = -1;
                  //           return StatefulBuilder(
                  //             builder: (BuildContext context,
                  //                 void Function(void Function()) setState) {
                  //               return Padding(
                  //                 padding: MediaQuery.viewInsetsOf(context),
                  //                 child: Container(
                  //                   padding: EdgeInsets.all(10),
                  //                   child: SizedBox(
                  //                     height: 450,
                  //                     width: MediaQuery.sizeOf(context).width,
                  //                     child: Column(
                  //                       children: [
                  //                         GestureDetector(
                  //                           onTap: () {
                  //                             Navigator.pop(context);
                  //                           },
                  //                           child: Align(
                  //                               alignment: Alignment.topRight,
                  //                               child: Icon(Icons.cancel_outlined)),
                  //                         ),
                  //                         Image.asset(
                  //                           "assets/icon/priceAlert.png",
                  //                           height: 70,
                  //                           fit: BoxFit.fitHeight,
                  //                           width: MediaQuery.sizeOf(context).width,
                  //                         ),
                  //                         Text(
                  //                           "Price Alert!",
                  //                           style: TextStyle(
                  //                               color: Color(0xFF444444),
                  //                               fontWeight: FontWeight.bold,
                  //                               fontSize: 32),
                  //                         ),
                  //                         Align(
                  //                           alignment: Alignment.center,
                  //                           child: Text(
                  //                               "airline has increased the price by ₹500 \n please review the new price before \n booking"),
                  //                         ),
                  //                         SizedBox(height: 10),
                  //                         Container(
                  //                           height: 60,
                  //                           padding: EdgeInsets.all(10),
                  //                           margin: EdgeInsets.all(15),
                  //                           decoration: BoxDecoration(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10),
                  //                               color: Colors.white),
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.spaceBetween,
                  //                             children: [
                  //                               Column(
                  //                                 children: [
                  //                                   Text("Old Fare"),
                  //                                   Text(
                  //                                     "₹5000",
                  //                                     style: TextStyle(
                  //                                       color: Color(0xFFD10909),
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               Image.asset(
                  //                                   "assets/icon/pricechange.png"),
                  //                               Column(
                  //                                 children: [
                  //                                   Text("New Fare"),
                  //                                   Text(
                  //                                     "₹5000",
                  //                                     style: TextStyle(
                  //                                       color: Color(0xFF138808),
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.spaceBetween,
                  //                           children: [
                  //                             Expanded(
                  //                               child: GestureDetector(
                  //                                 onTap: () {
                  //                                   setState(() {
                  //                                     selectedindex = 0;
                  //                                   });
                  //                                   print(
                  //                                       "selectedIndex ${selectedindex}");
                  //                                 },
                  //                                 child: Container(
                  //                                   margin: EdgeInsets.all(10),
                  //                                   padding: EdgeInsets.all(5),
                  //                                   height: 45,
                  //                                   width: 100,
                  //                                   decoration: BoxDecoration(
                  //                                       borderRadius:
                  //                                           BorderRadius.circular(25),
                  //                                       border: Border.all(
                  //                                           color: Colors.orange),
                  //                                       color: selectedindex == 0
                  //                                           ? Colors.deepOrange
                  //                                           : Colors.white),
                  //                                   child: Align(
                  //                                       alignment: Alignment.center,
                  //                                       child: Text(
                  //                                         "Return",
                  //                                         style: TextStyle(
                  //                                             color:
                  //                                                 selectedindex == 0
                  //                                                     ? Colors.white
                  //                                                     : Colors.orange,
                  //                                             fontWeight:
                  //                                                 FontWeight.bold),
                  //                                       )),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Expanded(
                  //                               child: GestureDetector(
                  //                                 onTap: () {
                  //                                   setState(() {
                  //                                     selectedindex = 1;
                  //                                   });
                  //                                 },
                  //                                 child: Container(
                  //                                   margin: EdgeInsets.all(10),
                  //                                   padding: EdgeInsets.all(5),
                  //                                   height: 45,
                  //                                   width: 100,
                  //                                   decoration: BoxDecoration(
                  //                                       borderRadius:
                  //                                           BorderRadius.circular(25),
                  //                                       border: Border.all(
                  //                                         color: Colors.orange,
                  //                                       ),
                  //                                       color: selectedindex == 1
                  //                                           ? Colors.deepOrange
                  //                                           : Colors.white),
                  //                                   child: Align(
                  //                                       alignment: Alignment.center,
                  //                                       child: Text(
                  //                                         "Continue",
                  //                                         style: TextStyle(
                  //                                             fontWeight:
                  //                                                 FontWeight.bold,
                  //                                             color: selectedindex ==
                  //                                                     1
                  //                                                 ? Colors.white
                  //                                                 : Colors.orange),
                  //                                       )),
                  //                                 ),
                  //                               ),
                  //                             )
                  //                           ],
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           );
                  //         });
                  //   },
                  //   child: Text(
                  //     "Price Alert",
                  //     style: TextStyle(color: Colors.grey.shade900),
                  //   ),
                  // ),
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(0.r)),
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
                                  // Action for "View full details"
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
                                "₹${widget.basefare ?? widget.total}",
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
                        onPressed: () async {
                          // await ApiService().countryCode();
                          // await ApiService().commissionPercentage();
                          print("passengerdetailsAdults$pax");

                          for (var i in passenger.entries) {
                            print("loopPASSENGER${passenger[i]}");
                          }
                          print("passengerdetailschild$childpassenger");
                          print("passengerInfant$infantpassenger");

                          Get.to(
                            () => MakePaymentScreen(
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
                                initialData: widget.initialData,
                                resultindex: widget.resultindex,
                                traceid: widget.traceid,
                                outboundFlight: widget.outboundFlight,
                                inboundFlight: widget.inboundFlight,
                                outresultindex: widget.outresultindex,
                                inresultindex: widget.inresultindex,
                                total: widget.total,
                                tax: widget.tax,
                                adultCount: widget.adultCount,
                                childCount: widget.childCount,
                                infantCount: widget.infantCount,
                                passenger: pax,
                                childpassenger: child,
                                infantpassenger: infant,
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
                                meal: meal),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40.h),
                          backgroundColor: Color(0xFFF37023),
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
        return FareBreakupSheet(
          basefare: widget.basefare,
          tax: widget.tax,
          adultCount: widget.adultCount,
          childCount: widget.childCount,
          infantCount: widget.infantCount,
        );
      },
    );
  }
}

class TravelerCard extends StatelessWidget {
  final String name;
  final String type;
  final bool isAdult;
  final bool isChild;
  final bool isInfant;

  const TravelerCard({
    Key? key,
    required this.name,
    required this.type,
    required this.isAdult,
    required this.isChild,
    required this.isInfant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  isAdult ? Colors.orange.shade100 : Colors.blue.shade100,
              radius: 16.r,
              child: Icon(
                Icons.person,
                color: isAdult ? Colors.orange : Colors.blue,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
                Text(
                  type,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GSTBottomSheet extends StatefulWidget {
  @override
  _GSTBottomSheetState createState() => _GSTBottomSheetState();
}

class _GSTBottomSheetState extends State<GSTBottomSheet> {
  // Controllers for the TextFields
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController gstHolderNameController = TextEditingController();
  final TextEditingController gstPincodeController = TextEditingController();
  final TextEditingController gstAddressController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to free resources
    gstNumberController.dispose();
    gstHolderNameController.dispose();
    gstPincodeController.dispose();
    gstAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        //bottom: MediaQuery.of(context).viewInsets.bottom,
        bottom: 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add GST Details",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // TextFields with White Box
          _buildTextField("GST number", gstNumberController),
          SizedBox(height: 16.h),
          _buildTextField("GST holder name", gstHolderNameController),
          SizedBox(height: 16.h),
          _buildTextField("GST Pincode", gstPincodeController),
          SizedBox(height: 16.h),
          _buildTextField("GST Address", gstAddressController),
          SizedBox(height: 16.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF37023),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              minimumSize: Size(double.infinity, 38.h),
            ),
            onPressed: () {
              // Handle Apply filter logic
              print("GST Number: ${gstNumberController.text}");
              print("GST Holder Name: ${gstHolderNameController.text}");
              print("GST Pincode: ${gstPincodeController.text}");
              print("GST Address: ${gstAddressController.text}");
            },
            child: Text(
              "Apply filter",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Text here",
              labelStyle: TextStyle(color: Colors.black),
              border: InputBorder.none, // Removes the default border
            ),
          ),
        ],
      ),
    );
  }
}
