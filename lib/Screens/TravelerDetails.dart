import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/search_data.dart';
import '../utils/constant.dart';
import 'ConfirmTraveler.dart';
import 'DotDivider.dart';
import 'ShowModelSheet.dart';
import 'ViewFullDetails.dart';

String finaldepDateformat = '';
String finalarrDateformat = '';

class TravelerDetailsPage extends StatefulWidget {
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
  final String? resultindex;
  final String? traceid;
  final Result? outboundFlight;
  final Result? inboundFlight;
  final String? total;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;

  TravelerDetailsPage(
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
      this.basefare,
      this.segments,
      this.resultindex,
      this.traceid,
      this.outboundFlight,
      this.inboundFlight,
      this.total,
      this.tax,
      this.adultCount,
      this.childCount,
      this.infantCount});

  @override
  _TravelerDetailsPageState createState() => _TravelerDetailsPageState();
}

class _TravelerDetailsPageState extends State<TravelerDetailsPage> {
  int totalAmount = 8000;
  List<Map<String, dynamic>> adultTravelers = [];
  List<Map<String, dynamic>> childTravelers = [];
  List<Map<String, dynamic>> infantTravelers = [];
  bool hasGST = false;
  String selectedState = 'Tamil Nadu';
  List<String> states = ['Tamil Nadu']; // Add more states as needed
  List<Map<String, dynamic>> traveler = [];
  List<Map<String, dynamic>> childtraveler = [];
  List<Map<String, dynamic>> infanttraveler = [];

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final childCount = widget.childCount;
    final infantCount = widget.infantCount;
    print("childCount$childCount");
    print("infantCount$infantCount");
    if (widget.depTime == null) {
      final depDateformat = widget.depDate;
      print("sfrgfrg$depDateformat");
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(depDateformat!);
      final finaldepDateformat = DateFormat("EEE,dd MMM yy").format(parsedDate);
      final arrDateformat = widget.arrDate;
      DateTime arrparsedDate = DateFormat("yyyy-MM-dd").parse(arrDateformat!);
      final finalarrDateformat =
          DateFormat("EEE,dd MMM yy").format(arrparsedDate);
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Add Traveler Details',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.airlineName ?? "",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: Colors.black),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: widget.airlineCode ?? "",
                                    // first text
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    // base style
                                    children: [
                                      TextSpan(text: " "),
                                      TextSpan(
                                        text: widget.flightNumber ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Colors.grey.shade700),
                                      ),
                                      TextSpan(text: " "),
                                      TextSpan(
                                        text: " ${widget.refundable ?? ""}",
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
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Image.asset("assets/images/star.png")
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.depTime ?? "",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                ],
                              ),
                              //SizedBox(height: 4.h),
                              Text(
                                DateFormat("dd MMM yy").format(
                                  DateTime.parse(widget.depDate.toString()),
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
                              Image.asset('assets/images/flightColor.png'),
                              Text(
                                widget.duration ?? "",
                                style: TextStyle(
                                    fontFamily: 'Inter', fontSize: 12.sp),
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
                                    widget.arrTime ?? "",
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
                                DateFormat("dd MMM yy").format(
                                  DateTime.parse(widget.arrDate.toString()),
                                ),
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
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
                              SizedBox(height: 4.h),
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
                              segments: widget.segments,
                            ),
                          );
                        }, // Action to execute on tap
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
                            // const SizedBox(width: 5),
                            // Padding(
                            // padding: EdgeInsets.only(top: 2.h),
                            // child: Image.asset("assets/images/Traingle.png"))
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
                                    widget.outboundFlight!.segments.first.first
                                        .origin.airport.cityName,
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
                                    widget.outboundFlight!.segments.first.first
                                        .origin.airport.cityCode,
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
                                    widget.outboundFlight!.segments.first.last
                                        .destination.airport.cityName,
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
                                    widget.outboundFlight!.segments.first.first
                                        .origin.airport.cityCode,
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
                                child:
                                    Image.asset("assets/images/Traingle.png"))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
            SizedBox(height: 10.h),
            Text(
              'Traveler Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Image.asset("assets/images/Adult.png"),
                SizedBox(
                  width: 10,
                ),
                Text('ADULT (12yrs+)',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Spacer(),
                Text('${widget.adultCount} added',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ],
            ),

            SizedBox(height: 8.h),
            ...adultTravelers.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> traveler = entry.value;
              return Column(
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Text(
                            '${traveler['Firstname']} ${traveler['lastname']}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          if (traveler['wheelchair'])
                            Text(
                              'Wheelchair',
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.grey),
                            ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              var result = await Get.to(
                                () => AddTravelerPage(
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
                                  initialData: traveler,
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  adultTravelers[index] = result;
                                });
                              }
                            },
                            child: Icon(Icons.edit, color: Color(0xFFF37023)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              );
            }),
            GestureDetector(
              onTap: () async {
                print("adultTravelers$adultTravelers");
                // if (widget.adultCount == 1 && adultTravelers.length >= 1) {
                //   showDialog(
                //     context: context,
                //     builder: (context) => AlertDialog(
                //       title: const Text("Alert"),
                //       content:
                //           const Text("You have already selected an adult."),
                //       actions: [
                //         TextButton(
                //           onPressed: () => Navigator.pop(context),
                //           child: const Text("OK"),
                //         ),
                //       ],
                //     ),
                //   );
                //   return; // stop further navigation
                // }
                var result = await Get.to(
                  () => AddTravelerPage(
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
                  ),
                );
                if (result != null) {
                  setState(() {
                    adultTravelers.add(result);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFF37023))),
                child: Text(
                  '+ ADD NEW ADULT',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF37023),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // CheckboxListTile(
            //   value: hasGST,
            //   onChanged: (v) => setState(() => hasGST = v!),
            //   title: Text('I have a GST number (Optional)'),
            //   controlAffinity: ListTileControlAffinity.leading,
            //   activeColor: Color(0xFFF37023),
            // ),
            // SizedBox(height: 10.h),
            // Text(
            //   'Booking details will be sent to',
            //   style: TextStyle(
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black),
            // ),
            // SizedBox(height: 10.h),
            // _buildTextField(
            //     label: 'Email',
            //     hintText: 'Text here',
            //     controller: TextEditingController()),
            // SizedBox(height: 10.h),
            // GestureDetector(
            //   onTap: () {},
            //   child: Text(
            //     '+ Add Mobile',
            //     style: TextStyle(
            //       color: Color(0xFFF37023),
            //       fontWeight: FontWeight.bold,
            //       fontSize: 14.sp,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10.h),
            // Text(
            //   'Your State',
            //   style: TextStyle(
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black),
            // ),
            // SizedBox(height: 10.h),
            // _buildDropdownField(
            //   'State',
            //   selectedState,
            //   states,
            //   (value) {
            //     setState(() {
            //       selectedState = value!;
            //     });
            //   },
            // ),
            // SizedBox(height: 4.h),
            // Text(
            //   'Required for GST purpose on your tax invoice',
            //   style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            // ),
            // Child Travelers

            if (widget.childCount! > 0) ...[
              Row(
                children: [
                  Image.asset("assets/images/Child.png"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'CHILD(2 -12 Yrs)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text('${widget.childCount} added',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 10.h),
              ...childTravelers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> traveler = entry.value;
                print("childTravelerschildTravelers$childTravelers");
                return Column(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Text(
                              '${traveler['Firstname']} ${traveler['lastname']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (traveler['wheelchair'])
                              Text(
                                'Wheelchair',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey),
                              ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                var result = await Get.to(
                                  () => AddTravelerPage(
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
                                    initialData: traveler,
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    childTravelers[index] = result;
                                  });
                                }
                              },
                              child: Icon(Icons.edit, color: Color(0xFFF37023)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                );
              }),
              GestureDetector(
                onTap: () async {
                  var result = await Get.to(
                    () => AddTravelerPage(
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
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      childTravelers.add(result);
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFF37023))),
                  child: Text(
                    '+ ADD NEW CHILD',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF37023),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],

// Infant Travelers (same as child)
            if (widget.infantCount! > 0) ...[
              Row(
                children: [
                  Image.asset("assets/images/Infant.png"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'INFANT(<2 Yrs)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text('${widget.infantCount} added',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 10.h),
              ...infantTravelers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> traveler = entry.value;
                print("infantTravelersinfantTravelers$traveler");
                return Column(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Text(
                              '${traveler['Firstname']} ${traveler['lastname']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (traveler['wheelchair'])
                              Text(
                                'Wheelchair',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey),
                              ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                var result = await Get.to(
                                  () => AddTravelerPage(
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
                                    initialData: traveler,
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    infantTravelers[index] = result;
                                  });
                                }
                              },
                              child: Icon(Icons.edit, color: Color(0xFFF37023)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                );
              }),
              GestureDetector(
                onTap: () async {
                  var result = await Get.to(
                    () => AddTravelerPage(
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
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      infantTravelers.add(result);
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFF37023))),
                  child: Text(
                    '+ ADD NEW INFANT',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF37023),
                    ),
                  ),
                ),
              ),
            ]
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(0.r)),
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
                            showFareBreakupSheet(context);
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
                  onPressed: () {
                    print("adultTravelers$adultTravelers");
                    Get.to(
                      () => ConfirmTravelerDetails(
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
                        basefare: widget.basefare,
                        segments: widget.segments,
                        initialData: adultTravelers,
                        childData: childTravelers,
                        resultindex: widget.resultindex,
                        traceid: widget.traceid,
                        outboundFlight: widget.outboundFlight,
                        inboundFlight: widget.inboundFlight,
                        total: widget.total,
                        tax: widget.tax,
                        adultCount: widget.adultCount,
                        childCount: widget.childCount,
                        infantCount: widget.infantCount,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40.h),
                    backgroundColor: const Color(0xFFF37023),
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

  Widget _buildTravelerCard(
      String label, String imagePath, VoidCallback onAddTap) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(imagePath, height: 40.h, width: 40.w),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onAddTap,
              child: Text(
                '+ ADD',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF37023),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    String? prefixText,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixText: prefixText,
              prefixStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700)),
              fillColor: Colors.white,
              filled: true,
              label: Text(label),
              focusColor: Colors.orange,
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontSize: 14.sp,
              ),
            ),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class AddTravelerPage extends StatefulWidget {
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
  final List<List<Segment>>? segments;
  final Map<String, dynamic>? initialData;

  AddTravelerPage({
    required this.flight,
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
  });

  @override
  _AddTravelerPageState createState() => _AddTravelerPageState();
}

class _AddTravelerPageState extends State<AddTravelerPage> {
  String selectedGender = "Mr";
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final passportNoController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  final expiryController = TextEditingController();

  bool requireWheelchair = false;

  List<String> nationality = <String>['Indian', 'Saudi', 'Malayasian'];
  String selectedNationality = 'Indian';

  String selectedCountry = 'India';
  List<String> IssusingCountry = <String>['India', 'Saudi', 'Malaysian', 'USA'];
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    print("psicked date$picked");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat("dd-MM-yyyy").format(selectedDate!);
      });
    }
  }

  Future<void> _expiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    print("psicked date$picked");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        expiryController.text = DateFormat("dd-MM-yyyy").format(selectedDate!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      print(widget.initialData!['gender']);
      print(widget.initialData!['Firstname']);
      print(widget.initialData!['lastname']);
      print("pass${widget.initialData!['Passport No']}");
      print("mobile${widget.initialData!['mobile']}");
      print("email${widget.initialData!['email']}");
      print("birth${widget.initialData!['Date of Birth']}");
      print("expiry${widget.initialData!['Expiry']}");

      selectedGender = widget.initialData!['gender'];
      firstNameController.text = widget.initialData!['Firstname'];
      lastNameController.text = widget.initialData!['lastname'];
      passportNoController.text = widget.initialData!['Passport No'];
      mobileController.text = widget.initialData!['mobile'];
      emailController.text = widget.initialData!['email'];
      dateController.text = widget.initialData!['Date of Birth'] ?? '';
      expiryController.text = widget.initialData!['Expiry'] ?? '';
      requireWheelchair = widget.initialData!['wheelchair'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Add Traveler',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            SizedBox(height: 10.h),
            Row(
              children: [
                GenderStatus(
                  label: "Mr",
                  isSelected: selectedGender == "Mr",
                  onTap: () {
                    setState(() {
                      selectedGender = "Mr";
                    });
                  },
                ),
                SizedBox(width: 4.w),
                GenderStatus(
                  label: "Mrs",
                  isSelected: selectedGender == "Mrs",
                  onTap: () {
                    setState(() {
                      selectedGender = "Mrs";
                    });
                  },
                ),
                GenderStatus(
                  label: "Ms",
                  isSelected: selectedGender == "Ms",
                  onTap: () {
                    setState(() {
                      selectedGender = "Ms";
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 10.h),
            _buildTextField(
              label: 'First Name',
              hintText: 'Text here',
              controller: firstNameController,
            ),
            _buildTextField(
              label: 'Last Name',
              hintText: 'Text here',
              controller: lastNameController,
            ),
            _buildTextField(
              label: 'Date of Birth *',
              hintText: 'Select date',
              controller: dateController,
              readOnly: true,
              // important for date picker
              onTap: () => _selectDate(context),
            ),
            _buildTextField(
              label: 'Passport No',
              hintText: '',
              controller: passportNoController,
              // prefixText: '',
              // keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              label: 'Expiry Date*',
              hintText: 'Text here',
              controller: expiryController,
              readOnly: true,
              onTap: () => _expiryDate(
                  context), // This was missing! Now it triggers the picker.
            ),
            _buildDropdownField(
              'Nationality *',
              selectedNationality,
              nationality, // your list of countries
              (value) {
                setState(() {
                  selectedNationality = value!;
                  print("selectedNationality$selectedNationality");
                });
              },
            ),
            _buildDropdownField(
              'Issusing Country *',
              selectedCountry,
              IssusingCountry, // your list of countries
              (value) {
                setState(() {
                  selectedCountry = value!;
                });
              },
            ),
            Text(
              "Contact details",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            _buildTextField(
              label: 'Mobile Number',
              hintText: '',
              controller: mobileController,
              // prefixText: '+91 - ',
              // keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              label: 'Email',
              hintText: '',
              controller: emailController,
              // prefixText: '',
              // keyboardType: TextInputType.phone,
            ),
            CheckboxListTile(
              value: requireWheelchair,
              onChanged: (v) => setState(() => requireWheelchair = v!),
              title: Text('I require wheelchair (Optional)'),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Color(0xFFF37023),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> data = {
                  'gender': selectedGender,
                  'Firstname': firstNameController.text,
                  'lastname': lastNameController.text,
                  'mobile': mobileController.text,
                  'Passport No': passportNoController.text,
                  'email': emailController.text,
                  'Date of Birth': dateController.text,
                  'Expiry': expiryController.text,
                  'wheelchair': requireWheelchair,
                  'Nationality': selectedNationality,
                  'IssusingCountry': selectedCountry
                };
                print("data$data");
                Get.back(result: data);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.h),
                backgroundColor: Color(0xFFF37023),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                "CONFIRM",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    bool readOnly = false,
    Function()? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          suffixIcon: (label == "Date of Birth *" || label == "Expiry Date*")
              ? InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.date_range, color: Colors.grey.shade800),
                  ),
                )
              : null,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700)),
          filled: true,
          fillColor: Colors.white,
          label: Text(label),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
        ),
        style: TextStyle(fontSize: 16.sp, color: Colors.black),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class GenderStatus extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderStatus({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFF37023) : Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isSelected ? Color(0xFFF37023) : Color(0xFFE6E6E6),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Color(0xFF1C1E1D),
            ),
          ),
        ),
      ),
    );
  }
}
