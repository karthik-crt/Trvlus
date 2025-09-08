import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/constant.dart';
import 'DotDivider.dart';

class Ticketdetails extends StatefulWidget {
  const Ticketdetails({super.key});

  @override
  State<Ticketdetails> createState() => _TicketdetailsState();
}

class _TicketdetailsState extends State<Ticketdetails> {
  bool isShowCal = false;
  bool isfare = false;
  bool iscontact = false;
  bool istravel = false;

  Widget _buildSectionCard(String title, List<Widget> content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  Image.asset("assets/images/cancellation.png"),
                  SizedBox(width: 8.w),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ...content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancellationPolicy() {
    return _buildSectionCard(
      "Cancellation Charges",
      [
        Row(
          children: [
            Text(
              "Cancellation between (IST)",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Text(
              isShowCal ? "View Less" : "View More",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Icon(
              isShowCal ? Icons.arrow_drop_up : Icons.arrow_drop_down_outlined,
              color: Colors.grey.shade700,
              size: 20,
            )
          ],
        ),
        SizedBox(height: 8.h),
        isShowCal
            ? Column(
                children: [
                  const Divider(),
                  //SizedBox(height: 8.h),
                  SizedBox(height: 8.h),
                  _buildPolicyRow(
                    "0-4 hrs to departure:",
                    "Non Refundable",
                    valueColor: Color(0xFFF32323),
                  ),
                  SizedBox(height: 12.h),
                  _buildPolicyRow("4hrs - 4 days to departure:", "₹4,555"),
                  SizedBox(height: 12.h),
                  _buildPolicyRow("4 - 999 days to departure:", "₹4,555"),
                ],
              )
            : Container()
      ],
    );
  }

  Widget _buildPolicyRow(String label, String value,
      {Color valueColor = Colors.black}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5), // Light gray background for each row
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 12.sp, fontFamily: 'Inter', color: Color(0xFF909090)),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6E6),
      appBar: AppBar(
        title: Text("Ticket Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              height: 138,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Booking Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Airline PNR",
                        style: TextStyle(fontSize: 12.sp, fontFamily: 'Inter'),
                      ),
                      Text(
                        "98498yeey",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reference Number",
                        style: TextStyle(fontSize: 12.sp, fontFamily: 'Inter'),
                      ),
                      Text(
                        "ATA2463545T",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Booking Status",
                        style: TextStyle(fontSize: 12.sp, fontFamily: 'Inter'),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDEF6DB),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Text(
                          "CONFIRMED",
                          style: TextStyle(
                            color: const Color(0xFF138808),
                            // Green text color
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(7),
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
                              SizedBox(width: 12),
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
                                              ?.copyWith(
                                                  color: Colors.grey.shade700),
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
                                  Text("1 hr 14m",
                                      style: TextStyle(fontSize: 12.sp)),
                                  Image.asset('assets/images/flightColor.png'),
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
                                        "city",
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
                                        "destination",
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 40.h,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE7E5),
                      border: Border.all(color: Color(0xFFFFD7D7)),
                      borderRadius:
                          BorderRadius.circular(8.r), // Rounded corners
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
                          Text(
                            // "10H 35m Layover at ${city}",
                            "10H 35m Layover at city",
                            style: TextStyle(
                              color: Color(0xFFFF4D4F),
                              fontSize: 14, // Font size
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
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
                              SizedBox(width: 12),
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
                                              ?.copyWith(
                                                  color: Colors.grey.shade700),
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
                                  Text("1 hr 14m",
                                      style: TextStyle(fontSize: 12.sp)),
                                  Image.asset('assets/images/flightColor.png'),
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
                                        "city",
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
                                        "destination",
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(7),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/Bagging.png"),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "Baggage",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 130.w),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // Action for the button
                          //     // ScaffoldMessenger.of(context).showSnackBar(
                          //     //   SnackBar(content: Text("Button Pressed")),
                          //     // );
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Color(0xFFF37023),
                          //     // Button color
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 15, vertical: 8),
                          //   ),
                          //   child: GestureDetector(
                          //     onTap: () {},
                          //     child: Text(
                          //       "ADD MORE",
                          //       style: TextStyle(
                          //         fontSize: 10.sp,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Text(
                        "Add additional checking package at low price",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.normal),
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
                      //SizedBox(height: 8.h),
                      SizedBox(height: 12.h),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(), // Empty space for alignment
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Cabin Bag",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF909090),
                                ),
                              ),
                              SizedBox(width: 20.w), // Space between headers
                              Text(
                                "Check-in Bag",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF909090),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Baggage List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        // Adjust based on your data
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Icon and Route
                              // Row(
                              //   children: [
                              //     Container(
                              //       height: 24.w,
                              //       width: 24.w,
                              //       decoration: BoxDecoration(
                              //         color: Color(0xFFF37023),
                              //         borderRadius: BorderRadius.circular(4.r),
                              //       ),
                              //     ),
                              //     SizedBox(width: 12.w),
                              //     Text(
                              //       "DEL-MAA (Adult)", // Update with flight data
                              //       style: TextStyle(
                              //         fontFamily: 'Inter',
                              //         fontSize: 14.sp,
                              //         fontWeight: FontWeight.bold,
                              //         color: Color(0xFF909090),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              // Baggage Details
                              Padding(
                                padding: EdgeInsets.only(right: 0.w),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "7kg",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    //Spacer(),
                                    SizedBox(width: 50.w),
                                    Text(
                                      "15kg",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 60.h),
                                    Text(
                                      "DEL-MAA(Adult)",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'Inter',
                                          color: Color(0xFF909090)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         isShowCal = !isShowCal;
            //       });
            //     },
            //     child: _buildCancellationPolicy()),
            SizedBox(
              height: 5,
            ),

            // Cancellation charges
            Container(
              margin: EdgeInsets.all(13),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: GestureDetector(
                onTap: () {
                  print("isshowcal");
                  setState(() {
                    isShowCal = !isShowCal;
                  });
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/cancellation.png'),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cancellation Charges",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "cancellation between (IST)",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          isShowCal ? "View Less" : "View More",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Icon(
                          isShowCal
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down_outlined,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                      ],
                    ),
                    isShowCal
                        ? Column(
                            children: [
                              const Divider(),
                              //SizedBox(height: 8.h),
                              SizedBox(height: 8.h),
                              _buildPolicyRow(
                                "0-4 hrs to departure:",
                                "Non Refundable",
                                valueColor: Color(0xFFF32323),
                              ),
                              SizedBox(height: 12.h),
                              _buildPolicyRow(
                                  "4hrs - 4 days to departure:", "₹4,555"),
                              SizedBox(height: 12.h),
                              _buildPolicyRow(
                                  "4 - 999 days to departure:", "₹4,555"),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),

            // Travle
            Container(
              margin: EdgeInsets.all(13),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    istravel = !istravel;
                  });
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.deepOrange,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Traveler Details",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          istravel ? "View Less" : "View More",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Icon(
                          istravel
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down_outlined,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                      ],
                    ),
                    istravel
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "ADULTS",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                // width: 300,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFE6E6E6)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icon/adult.svg",
                                      height: 15,
                                      width: 15,
                                    ),
                                    Text(
                                      "UserName here",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                // width: 300,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFE6E6E6)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icon/adult.svg",
                                      height: 15,
                                      width: 15,
                                    ),
                                    Text(
                                      "UserName here",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "CHILD",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                // width: 300,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFE6E6E6)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icon/child.svg",
                                      height: 15,
                                      width: 15,
                                    ),
                                    Text(
                                      "UserName here",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                // width: 300,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFE6E6E6)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icon/child.svg",
                                      height: 15,
                                      width: 15,
                                    ),
                                    Text(
                                      "UserName here",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),

            // FARE
            Container(
              margin: EdgeInsets.all(13),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("fr");
                      setState(() {
                        isfare = !isfare;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icon/fare.svg'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Fare BreakUp",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          isfare ? "View Less" : "View More",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Icon(
                          isfare
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down_outlined,
                          color: Colors.grey.shade700,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  isfare == true
                      ? Column(
                          children: [
                            Divider(),
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFFE7DA)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Base fare",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Text("₹5,000",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFF37023))),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Adults (1 X ₹5,000)",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                          )),
                                      Text("₹5,000",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("child (1 X ₹5,000)",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                          )),
                                      Text("₹5,000",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Infant (1 X ₹5,000)",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                          )),
                                      Text("₹5,000",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFF5F5F5)),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Tax and Surcharges",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Text("₹5,000",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFF37023))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Airline taxes and sur charges",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Color(0xFF909090),
                                                  fontWeight: FontWeight.bold)),
                                          Text("₹5,000",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFF37023))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Total",
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: Color(0xFF606060),
                                                  fontWeight: FontWeight.bold)),
                                          Text("₹5,000",
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFF37023))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Amount",
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: Color(0xFF606060),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Including GST+ taxes",
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF909090))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Align(
                                //   alignment: Alignment.bottomRight,
                                //   child: Text("Including GST+ taxes"),
                                // )
                              ],
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            ),

            // Support
            Container(
              margin: EdgeInsets.all(13),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("fr");
                      setState(() {
                        iscontact = !iscontact;
                      });
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/support.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Contact Support",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          iscontact ? "View Less" : "View More",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Icon(
                          iscontact
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down_outlined,
                          color: Colors.grey.shade700,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  iscontact == true
                      ? Column(
                          children: [
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Mobile"),
                                Text(
                                  "54632 78945",
                                  style: TextStyle(
                                      color: Color(0xFF303030),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Email"),
                                Text(
                                  "trvlus@gmail.com",
                                  style: TextStyle(
                                      color: Color(0xFF303030),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
