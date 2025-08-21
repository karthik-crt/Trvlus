import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/constant.dart';
import 'ConfirmTraveler.dart';
import 'DotDivider.dart';
import 'FlightDetailsPage.dart';
import 'ShowModelSheet.dart';
import 'ViewFullDetails.dart';

class TravelerDetailsPage extends StatefulWidget {
  final Map<String, dynamic> flight;
  final String city;
  final String destination;

  TravelerDetailsPage(
      {required this.flight, required this.city, required this.destination});

  @override
  _TravelerDetailsPageState createState() => _TravelerDetailsPageState();
}

class _TravelerDetailsPageState extends State<TravelerDetailsPage> {
  int totalAmount = 8000;

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final city = widget.city;
    final destination = widget.destination;
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
                        // Image.asset(flight['logo'], height: 40, width: 40),
                        Image.asset(
                          "assets/images/flight.png",
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   // flight['airline']
                            //   style: TextStyle(
                            //       fontFamily: 'Inter',
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 14.sp,
                            //       color: Colors.black),
                            // ),
                            RichText(
                                text: TextSpan(
                                    text: 'XL2724',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey.shade700),
                                    children: [
                                  TextSpan(
                                      text: " NR",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                              fontSize: 12.sp,
                                              color: primaryColor))
                                ]))
                          ],
                        ),
                        SizedBox(width: 43.w),
                        Image.asset(
                          "assets/images/Line.png",
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
                            Text(
                              "Aircraft Boeing",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade700),
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
                                  "05:30",
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
                              "Sat,30 Nov 24",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("1 hr 14m", style: TextStyle(fontSize: 12.sp)),
                            // Image.asset('assets/images/flightColor.png'),
                            // Text(
                            //   "1 hr 14m",
                            //   style: TextStyle(
                            //       fontFamily: 'Inter', fontSize: 12.sp),
                            // ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "05:30",
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
                              "Sat,30 Nov 24",
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
                                  city,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "DEL",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            // Text(
                            //   // flight["departure"],
                            //   style: TextStyle(
                            //     fontSize: 12.sp,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  destination,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "BLR",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            // Text(
                            //   flight["arrival"],
                            //   style: TextStyle(fontSize: 12.sp),
                            // ),
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
                          () => FlightDetailsPage(
                            flight: flight,
                            city: widget.city,
                            destination: widget.destination,
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
                          const SizedBox(width: 5),
                          Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Image.asset("assets/images/Traingle.png"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            Column(
              children: [
                _buildTravelerCard('Adult', 'assets/adult.png', () {
                  Get.to(
                    () => AddTravelerPage(
                      flight: flight,
                      city: widget.city,
                      destination: widget.destination,
                    ),
                    //transition: Transition.rightToLeft,
                  );
                }),
                SizedBox(height: 8.h),
                _buildTravelerCard('Child', 'assets/child.png', () {}),
                SizedBox(height: 8.h),
                _buildTravelerCard('Infant', 'assets/infant.png', () {
                  // Handle Infant Add action
                }),
              ],
            ),
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
                          "₹8,000",
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
                    Get.to(
                      () => ConfirmTravelerDetails(
                        flight: flight,
                        city: widget.city,
                        destination: widget.destination,
                      ),
                      //transition: Transition.leftToRight
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

class AddTravelerPage extends StatefulWidget {
  final Map<String, dynamic> flight;
  final String city;
  final String destination;

  AddTravelerPage(
      {required this.flight, required this.city, required this.destination});

  @override
  _AddTravelerPageState createState() => _AddTravelerPageState();
}

class _AddTravelerPageState extends State<AddTravelerPage> {
  bool isWheelchairSelected = false;
  bool isFrequentFlyerSelected = false;
  String SelectButton = "Mr.";
  List<String> nationality = <String>['Indian', 'Saudi', 'Malayasian'];
  String selectedNationality = 'Indian';

  String selectedCountry = 'India';
  List<String> issusingcountry = <String>['India', 'Saudi', 'Malayasia', 'USA'];

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final city = widget.city;
    final destination = widget.destination;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Add new traveler',
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
            // Flight details card
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
                        // Image.asset(flight['logo'], height: 40.h, width: 40.w),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   flight['airline'],
                            //   style: TextStyle(
                            //       fontFamily: 'Inter',
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 14.sp,
                            //       color: Colors.black),
                            // ),
                            RichText(
                                text: TextSpan(
                                    text: 'XL2724',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey.shade700),
                                    children: [
                                  TextSpan(
                                      text: " NR",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                              fontSize: 12.sp,
                                              color: primaryColor))
                                ]))
                          ],
                        ),
                        SizedBox(width: 40.w),
                        Image.asset(
                          "assets/images/Line.png",
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
                            Text(
                              "Aircraft Boeing",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade700),
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
                                  "05:30",
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
                              "Sat,30 Nov 24",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("1 hr 14m", style: TextStyle(fontSize: 12.sp)),
                            // Image.asset('assets/images/flightColor.png'),
                            // Text(
                            //   "1 hr 14m",
                            //   style: TextStyle(
                            //       fontFamily: 'Inter', fontSize: 12.sp),
                            // ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "05:30",
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
                              "Sat,30 Nov 24",
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
                                  city,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "DEL",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            //SizedBox(height: 4.h),
                            // Text(
                            //   flight["departure"],
                            //   style: TextStyle(
                            //     fontSize: 12.sp,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  destination,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "BLR",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            // Text(
                            //   flight["arrival"],
                            //   style: TextStyle(fontSize: 12.sp),
                            // ),
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
                              child: Image.asset("assets/images/Traingle.png"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Traveler details form
            RichText(
              text: TextSpan(
                //style: TextStyle(fontSize: 14.sp, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Adult',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: '  (12 years & above)',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF909090)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                MaritalStatus(
                  label: "Mr.",
                  isSelected: SelectButton == "Mr.",
                  onTap: () {
                    setState(() {
                      SelectButton = "Mr.";
                    });
                  },
                ),
                SizedBox(width: 4.w),
                MaritalStatus(
                  label: "Mrs.",
                  isSelected: SelectButton == "Mrs.",
                  onTap: () {
                    setState(() {
                      SelectButton = "Mrs.";
                    });
                  },
                ),
                SizedBox(width: 4.w),
                MaritalStatus(
                  label: "Ms",
                  isSelected: SelectButton == "Ms",
                  onTap: () {
                    setState(() {
                      SelectButton = "Ms";
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),
            _buildTextField('First name *', 'Text here'),
            _buildTextField('Last name *', 'Text here'),
            _buildTextField('Date of birth *', 'Text here'),
            _buildDropdownField(
              'Nationality *',
              selectedNationality,
              nationality, // your list of countries
              (value) {
                setState(() {
                  selectedNationality = value!;
                });
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 98,
                    width: 150,
                    child: _buildTextField('PassportNo*', 'Text here')),
                Container(
                    height: 98,
                    width: 150,
                    child: _buildTextField('Expiry Date*', 'Text here')),
              ],
            ),
            _buildDropdownField(
              'Issusing Country *',
              selectedCountry,
              issusingcountry, // your list of countries
              (value) {
                setState(() {
                  selectedCountry = value!;
                });
              },
            ),

            // const Row(
            //   children: [
            //     Text(
            //       "PassportNo",
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.black,
            //       ),
            //     )
            //   ],
            // ),
            SizedBox(height: 16.h),
            Text(
              'Contact details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            _buildTextField('Country', 'India(+91)'),
            _buildTextField('ContactNo', 'Text here'),
            _buildTextField('Email', 'Text here'),
            //SizedBox(height: 16.h),
            _buildOptionToggle(
                'Wheel chair option', ['Yes', 'No'], isWheelchairSelected,
                (selected) {
              setState(() {
                isWheelchairSelected = selected;
              });
            }),
            _buildOptionToggle(
                'Frequent flyer', ['Yes', 'No'], isFrequentFlyerSelected,
                (selected) {
              setState(() {
                isFrequentFlyerSelected = selected;
              });
            }),
            _buildTextField('Frequent flyer number', 'Flight number'),
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
                          "₹8,000",
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
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return _buildTravelerAddedBottomSheet();
                      },
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
                    "Add Traveler",
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

  Widget _buildTextField(String label, String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        //height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade300), // Border color
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'BricolageGrotesque',
                color: Color(0xFF909090),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
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
            borderRadius: BorderRadius.circular(8),
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

  Widget _buildOptionToggle(
    String title,
    List<String> options,
    bool currentSelection,
    Function(bool) onSelectionChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: options.map((option) {
              bool isSelected =
                  (option == 'Yes') ? currentSelection : !currentSelection;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: Color(0xFFFFE7DA),
                  // Selected background color
                  backgroundColor: Colors.white,
                  // Unselected background color
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Color(0xFFF37023)
                        : Colors.black, // Text color based on selection
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r), // Round shape
                    side: BorderSide(
                      color: isSelected ? Color(0xFFF37023) : Colors.grey,
                      // Border color based on selection
                      width: 1.5, // Border width
                    ),
                  ),
                  onSelected: (bool selected) {
                    // Toggle selection for "Yes" or "No"
                    if (option == 'Yes') {
                      onSelectionChanged(true);
                    } else {
                      onSelectionChanged(false);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class MaritalStatus extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const MaritalStatus({
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
          color: isSelected ? Color(0xFFFFE7DA) : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected ? Colors.orange : Color(0xFFE6E6E6),
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
              color: isSelected ? Color(0xFFF37023) : Color(0xFF1C1E1D),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTravelerAddedBottomSheet() {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(0.r)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.close,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset("assets/images/RoseBorder.png"),
            Icon(
              Icons.check_circle,
              size: 60.sp,
              color: Color(0xFFF37023),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          "Traveler added!",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.h),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 40.h),
            backgroundColor: Color(0xFFF37023),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Text(
            "Done",
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

void showFareBreakupSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (context) {
      return FareBreakupSheet();
    },
  );
}
