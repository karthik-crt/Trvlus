import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constant.dart';
import 'DotDivider.dart';

class Viewfulldetails extends StatefulWidget {
  final Map<String, dynamic> flight;
  final String city;
  final String destination;

  Viewfulldetails(
      {required this.flight, required this.city, required this.destination});

  @override
  State<Viewfulldetails> createState() => _ViewfulldetailsState();
}

class _ViewfulldetailsState extends State<Viewfulldetails> {
  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final city = widget.city;
    final destination = widget.destination;
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 40.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Color(0xFFFFE7E5),
                border: Border.all(color: Color(0xFFFFD7D7)),
                borderRadius: BorderRadius.circular(8.r), // Rounded corners
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
                      "10H 35m Layover at ${city}",
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
