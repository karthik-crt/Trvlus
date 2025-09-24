import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/search_data.dart';
import 'DotDivider.dart';
import 'localroundtrip.dart';

class Roundtrip extends StatefulWidget {
  final dynamic flight;
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

  const Roundtrip({
    super.key,
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
  });

  @override
  State<Roundtrip> createState() => _RoundtripState();
}

class _RoundtripState extends State<Roundtrip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Container(
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
                    SvgPicture.asset('assets/icon/edit.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Edit details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "MAA",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ],
                        ),
                        Text(
                          "Chennai Airport",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    // const Spacer(),
                    Image.asset('assets/images/flightStop.png'),
                    // const Spacer(),
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
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "MAA",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ],
                        ),
                        Text(
                          "Hyderbad Airport",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
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
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          DateScroller(),
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
                          text: "50",
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
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
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
                        borderRadius:
                            BorderRadius.circular(30.r), // Rounded corners
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            "₹ 4666",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12),
                          ),
                          Text(
                            "₹ 4,566",
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
                Row(
                  children: [
                    Text(
                      "11h 15 layover at Bangalore",
                      style: TextStyle(
                          color: Color(0xFFF37023),
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/flight.png",
                      height: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Indigo",
                          style: TextStyle(
                              color: Color(0xFF1C1E1D),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "XL-2724",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 4.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "NR",
                              style: TextStyle(
                                  color: Color(0xFFF37023),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "05:35",
                          style: TextStyle(
                              color: Color(0xFF1C1E1D),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Sat, 30 Nov 24",
                          style:
                              TextStyle(color: Color(0xFF909090), fontSize: 10),
                        ),
                        Row(
                          children: [
                            Text(
                              "Chennai",
                              style: TextStyle(
                                  color: Color(0xFF1C1E1D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "MAA",
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
                          "1 STOP",
                          style: TextStyle(
                              color: Color(0xFF909090),
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                        Image.asset('assets/images/flightStop.png'),
                        Text(
                          "1hr 14 min",
                          style: TextStyle(
                              color: Color(0xFF909090),
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "05:35",
                          style: TextStyle(
                              color: Color(0xFF1C1E1D),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Sat, 30 Nov 24",
                          style:
                              TextStyle(color: Color(0xFF909090), fontSize: 10),
                        ),
                        Row(
                          children: [
                            Text(
                              "Madurai",
                              style: TextStyle(
                                  color: Color(0xFF1C1E1D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "IXM",
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
                SizedBox(
                  height: 10,
                ),
                DotDivider(
                  dotSize: 1.h,
                  spacing: 2.r,
                  dotCount: 97,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "11h 15 layover at Bangalore",
                  style: TextStyle(
                      color: Color(0xFFF37023),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/flight.png",
                      height: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emriates",
                          style: TextStyle(
                              color: Color(0xFF1C1E1D),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "XL-2724",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 4.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "NR",
                              style: TextStyle(
                                  color: Color(0xFFF37023),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
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
                        Text(
                          "05:35",
                          style: TextStyle(
                              color: Color(0xFF1C1E1D),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Sat, 30 Nov 24",
                          style:
                              TextStyle(color: Color(0xFF909090), fontSize: 10),
                        ),
                        Row(
                          children: [
                            Text(
                              "Madurai",
                              style: TextStyle(
                                  color: Color(0xFF1C1E1D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "IXM",
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
                          "1 STOP",
                          style: TextStyle(
                              color: Color(0xFF909090),
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                        Image.asset('assets/images/flightStop.png'),
                        Text(
                          "1hr 14 min",
                          style: TextStyle(
                              color: Color(0xFF909090),
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "05:35",
                          style: TextStyle(
                              color: Color(0xFF1C1E1D),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Sat, 30 Nov 24",
                          style:
                              TextStyle(color: Color(0xFF909090), fontSize: 10),
                        ),
                        Row(
                          children: [
                            Text(
                              "Chennai",
                              style: TextStyle(
                                  color: Color(0xFF1C1E1D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "MAA",
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
                SizedBox(
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
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Localroundtrip(flight: null,, city: '',, destination: '',, airlineName: '',, cityName: '',, cityCode: '',)));
                    },
                    child: Text("Round Trip"))
              ],
            ),
          ),
        ],
      ),
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
