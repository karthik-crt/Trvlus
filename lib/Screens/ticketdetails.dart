import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../models/getbookingdetailsid.dart';
import '../utils/api_service.dart';
import '../utils/constant.dart';
import 'DotDivider.dart';

class Ticketdetails extends StatefulWidget {
  final int? id; // declare variable here

  const Ticketdetails({Key? key, this.id}) : super(key: key);

  @override
  State<Ticketdetails> createState() => _TicketdetailsState();
}

class _TicketdetailsState extends State<Ticketdetails> {
  bool isShowCal = false;
  bool isfare = false;
  bool iscontact = false;
  bool istravel = false;
  bool isLoading = false;
  late Getbookingdetailsid bookingdetailsid;
  int adultCount = 0;
  int childCount = 0;
  int infantCount = 0;

  double adultFare = 0;
  double childFare = 0;
  double infantFare = 0;

  @override
  void initState() {
    super.initState();
    print("API CALLING GET BOOKING DETAILS");
    print("Ticket Details screen loaded");
    print("GETBOOKINGID${widget.id}");
    getBookingDataID();
  }

  getBookingDataID() async {
    setState(() {
      isLoading = true;
    });
    bookingdetailsid = await ApiService().getbookingdetailHistory(widget.id);
    // final adultCount =
    //     int.parse(bookingdetailsid.data.first.totalpassengers.toString());
    final fare = double.parse(bookingdetailsid
        .data.first.passengerDetails.first.fare.BaseFare
        .toString());
    print('fare$fare');
    adultFare = adultCount * fare;
    print("TOTAL COUNT $adultFare");
    setState(() {
      isLoading = false;
    });
    passengerCount();
  }

  passengerCount() {
    for (var booking in bookingdetailsid.data) {
      for (var passenger in booking.passengerDetails) {
        final baseFare = double.parse(passenger.fare.BaseFare.toString());

        if (passenger.PaxType == 1) {
          adultCount++;
          print("ADULTCOUNT$adultCount");
          adultFare += baseFare;
          print("ADULTCOUNT$adultFare");
        } else if (passenger.PaxType == 2) {
          childCount++;
          childFare += baseFare;
          print("ADULTCOUNT$childFare");
        } else if (passenger.PaxType == 3) {
          infantCount++;
          infantFare += baseFare;
          print("ADULTCOUNT$infantFare");
        }
      }
    }
  }

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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    height: 143,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Booking Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Airline PNR",
                              style: TextStyle(
                                  fontSize: 12.sp, fontFamily: 'Inter'),
                            ),
                            Text(
                              bookingdetailsid.data.first.pnr,
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
                              style: TextStyle(
                                  fontSize: 12.sp, fontFamily: 'Inter'),
                            ),
                            Text(
                              bookingdetailsid.data.first.appReference,
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
                              style: TextStyle(
                                  fontSize: 12.sp, fontFamily: 'Inter'),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDEF6DB),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Text(
                                bookingdetailsid.data.first.status,
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
                                    Image.asset(
                                        'assets/${bookingdetailsid.data.first.journeyList.first.OperatorCode}.gif'),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookingdetailsid.data.first
                                              .journeyList.first.OperatorName,
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: bookingdetailsid.data.first
                                                .journeyList.first.OperatorCode,
                                            // first text
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            // base style
                                            children: [
                                              TextSpan(text: " "),
                                              TextSpan(
                                                text: bookingdetailsid
                                                    .data
                                                    .first
                                                    .journeyList
                                                    .first
                                                    .FlightNumber,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: Colors
                                                            .grey.shade700),
                                              ),
                                              TextSpan(text: " "),
                                              TextSpan(
                                                text: " ${""}",
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
                                    SizedBox(width: 43.w),
                                    Image.asset(
                                      "assets/images/Line.png",
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
                                                  color: Colors.black),
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
                                              bookingdetailsid
                                                  .data
                                                  .first
                                                  .journeyList
                                                  .first
                                                  .DepatureTime,
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
                                          bookingdetailsid.data.first
                                              .journeyList.first.Depature,
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
                                            bookingdetailsid.data.first
                                                .journeyList.first.duration,
                                            style: TextStyle(fontSize: 12.sp)),
                                        Image.asset(
                                            'assets/images/flightColor.png'),
                                        // Text(
                                        //   "1 hr 14m",
                                        //   style: TextStyle(
                                        //       fontFamily: 'Inter', fontSize: 12.sp),
                                        // ),
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
                                              bookingdetailsid
                                                  .data
                                                  .first
                                                  .journeyList
                                                  .first
                                                  .ArrivalTime,
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
                                          bookingdetailsid.data.first
                                              .journeyList.first.Arrival,
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
                                              bookingdetailsid
                                                  .data
                                                  .first
                                                  .journeyList
                                                  .first
                                                  .FromCityName,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              bookingdetailsid
                                                  .data
                                                  .first
                                                  .journeyList
                                                  .first
                                                  .FromAirportCode,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              bookingdetailsid.data.first
                                                  .journeyList.first.ToCityName,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              bookingdetailsid
                                                  .data
                                                  .first
                                                  .journeyList
                                                  .first
                                                  .ToAirportCode,
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
                        // Container(
                        //   height: 40.h,
                        //   width: double.infinity,
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: 10.w, vertical: 8.h),
                        //   decoration: BoxDecoration(
                        //     color: Color(0xFFFFE7E5),
                        //     border: Border.all(color: Color(0xFFFFD7D7)),
                        //     borderRadius:
                        //         BorderRadius.circular(8.r), // Rounded corners
                        //   ),
                        //   child: Center(
                        //     child: Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Icon(
                        //           Icons.sync_alt,
                        //           color: Color(0xFFFF4D4F),
                        //           size: 16.sp,
                        //         ),
                        //         SizedBox(width: 8.w),
                        //         Text(
                        //           // "10H 35m Layover at ${city}",
                        //           "10H 35m Layover at city",
                        //           style: TextStyle(
                        //             color: Color(0xFFFF4D4F),
                        //             fontSize: 14, // Font size
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 10.h),
                        // Card(
                        //   color: Colors.white,
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8.r)),
                        //   elevation: 2,
                        //   child: Padding(
                        //     padding: EdgeInsets.all(12.w),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Row(
                        //           children: [
                        //             // Image.asset(flight['logo'], height: 40, width: 40),
                        //             SizedBox(width: 12),
                        //             Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 // Text(
                        //                 //   flight['airline'],
                        //                 //   style: TextStyle(
                        //                 //       fontFamily: 'Inter',
                        //                 //       fontWeight: FontWeight.bold,
                        //                 //       fontSize: 14.sp,
                        //                 //       color: Colors.black),
                        //                 // ),
                        //                 RichText(
                        //                     text: TextSpan(
                        //                         text: 'XL2724',
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .bodySmall
                        //                             ?.copyWith(
                        //                                 color: Colors
                        //                                     .grey.shade700),
                        //                         children: [
                        //                       TextSpan(
                        //                           text: " NR",
                        //                           style: Theme.of(context)
                        //                               .textTheme
                        //                               .headlineSmall
                        //                               ?.copyWith(
                        //                                   fontSize: 12.sp,
                        //                                   color: primaryColor))
                        //                     ]))
                        //               ],
                        //             ),
                        //             SizedBox(width: 43.w),
                        //             Image.asset(
                        //               "assets/images/Line.png",
                        //             ),
                        //             const Spacer(),
                        //             Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.end,
                        //               children: [
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       "Economy Class",
                        //                       style: TextStyle(
                        //                           fontFamily: 'Inter',
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 12.sp,
                        //                           color: Colors.black),
                        //                     ),
                        //                     SizedBox(
                        //                       width: 6.w,
                        //                     ),
                        //                     SizedBox(
                        //                       height: 4.h,
                        //                     ),
                        //                     Image.asset(
                        //                         "assets/images/star.png")
                        //                   ],
                        //                 ),
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //         SizedBox(height: 8.h),
                        //         SingleChildScrollView(
                        //           scrollDirection: Axis.horizontal,
                        //           child: DotDivider(
                        //             dotSize: 1.h, // Adjust size
                        //             spacing: 2.r, // Adjust spacing
                        //             dotCount: 97, // Adjust number of dots
                        //             color: Colors.grey, // Adjust color
                        //           ),
                        //         ),
                        //         SizedBox(height: 8.h),
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       "05:30",
                        //                       style: TextStyle(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.bold,
                        //                         color: Colors.black,
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 4.w),
                        //                   ],
                        //                 ),
                        //                 //SizedBox(height: 4.h),
                        //                 Text(
                        //                   "Sat,30 Nov 24",
                        //                   style: TextStyle(
                        //                     fontSize: 12.sp,
                        //                     color: Colors.grey,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             Column(
                        //               children: [
                        //                 Text("1 hr 14m",
                        //                     style: TextStyle(fontSize: 12.sp)),
                        //                 Image.asset(
                        //                     'assets/images/flightColor.png'),
                        //                 // Text(
                        //                 //   "1 hr 14m",
                        //                 //   style: TextStyle(
                        //                 //       fontFamily: 'Inter', fontSize: 12.sp),
                        //                 // ),
                        //               ],
                        //             ),
                        //             Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.end,
                        //               children: [
                        //                 Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                       "05:30",
                        //                       style: TextStyle(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.bold,
                        //                         color: Colors.black,
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 4.w),
                        //                   ],
                        //                 ),
                        //                 Text(
                        //                   "Sat,30 Nov 24",
                        //                   style: TextStyle(fontSize: 12.sp),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 5.h),
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       "city",
                        //                       style: TextStyle(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.bold,
                        //                         color: Colors.black,
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 4.w),
                        //                     Text(
                        //                       "DEL",
                        //                       style: TextStyle(
                        //                         fontSize: 12.sp,
                        //                         color: Colors.grey,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 //SizedBox(height: 4.h),
                        //                 // Text(
                        //                 //   flight["departure"],
                        //                 //   style: TextStyle(
                        //                 //     fontSize: 12.sp,
                        //                 //     color: Colors.grey,
                        //                 //   ),
                        //                 // ),
                        //               ],
                        //             ),
                        //             Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.end,
                        //               children: [
                        //                 Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                       "destination",
                        //                       style: TextStyle(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.bold,
                        //                         color: Colors.black,
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 4.w),
                        //                     Text(
                        //                       "BLR",
                        //                       style: TextStyle(
                        //                         fontSize: 12.sp,
                        //                         color: Colors.grey,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 // Text(
                        //                 //   flight["arrival"],
                        //                 //   style: TextStyle(fontSize: 12.sp),
                        //                 // ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
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
                                    SizedBox(
                                        width: 20.w), // Space between headers
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
                                    // Baggage Details
                                    Padding(
                                      padding: EdgeInsets.only(right: 0.w),
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            bookingdetailsid.data.first
                                                .journeyList.first.CabinBaggage,
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
                                            bookingdetailsid.data.first
                                                .journeyList.first.Baggage,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 60.h),
                                          Text(
                                            '${bookingdetailsid.data.first.journeyList.first.FromAirportCode} - ${bookingdetailsid.data.first.journeyList.first.ToAirportCode}',
                                            style: TextStyle(
                                                fontSize: 12.sp,
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
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
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
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
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
                                        "4hrs - 4 days to departure:",
                                        "₹4,555"),
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

                  // Traveler Details
                  Container(
                    margin: EdgeInsets.all(13),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 17.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
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
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(
                                istravel ? "View Less" : "View More",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
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
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: bookingdetailsid
                                          .data.first.passengerDetails.length,
                                      itemBuilder: (context, index) {
                                        final passenger = bookingdetailsid
                                            .data.first.passengerDetails[index];
                                        if (bookingdetailsid
                                                .data
                                                .first
                                                .passengerDetails[index]
                                                .PaxType ==
                                            1)
                                          return Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color(0xFFE6E6E6),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icon/adult.svg",
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      '${passenger.FirstName} ${passenger.LastName}',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          );
                                      },
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
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: bookingdetailsid
                                          .data.first.passengerDetails
                                          .where((p) => p.PaxType == 2)
                                          .length,
                                      itemBuilder: (context, index) {
                                        final passengerList = bookingdetailsid
                                            .data.first.passengerDetails;
                                        final childPassengers = passengerList
                                            .where((p) => p.PaxType == 2)
                                            .toList();

                                        final passenger = childPassengers[
                                            index]; // 👈 Access each child passenger

                                        print(
                                            'childPassengers: ${jsonEncode(childPassengers)}');

                                        return Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(0xFFE6E6E6),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icon/child.svg",
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    '${passenger.FirstName} ${passenger.LastName}',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "INFANT",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: bookingdetailsid
                                          .data.first.passengerDetails
                                          .where((p) => p.PaxType == 3)
                                          .length,
                                      itemBuilder: (context, index) {
                                        final passengerList = bookingdetailsid
                                            .data.first.passengerDetails;
                                        final infantPassengers = passengerList
                                            .where((p) => p.PaxType == 3)
                                            .toList();

                                        final passenger = infantPassengers[
                                            index]; // 👈 Access each child passenger

                                        print(
                                            'infantPassengers: ${jsonEncode(infantPassengers)}');

                                        return Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(0xFFE6E6E6),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icon/child.svg",
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    '${passenger.FirstName} ${passenger.LastName}',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        );
                                      },
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 17.5),
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
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(
                                isfare ? "View Less" : "View More",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
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
                                            Text("Base Fare",
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                '₹${bookingdetailsid.data.first.passengerDetails.first.fare.BaseFare.toString()}',
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
                                            Text(
                                                "Adults($adultCount X ₹$adultFare)",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey,
                                                )),
                                            Text("₹$adultFare",
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
                                            Text(
                                                "Child ($childCount X ₹$childFare))",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey,
                                                )),
                                            Text("₹$childFare",
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
                                            Text(
                                                "Infant ($infantCount X ₹$infantFare))",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey,
                                                )),
                                            Text("₹$infantFare",
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xFFF5F5F5)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Tax and Surcharges",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    '₹${bookingdetailsid.data.first.passengerDetails.first.fare.Tax.toString()}',
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFF37023))),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "Airline taxes and sur charges",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color:
                                                            Color(0xFF909090),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text("",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFF37023))),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Total",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color:
                                                            Color(0xFF606060),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    "₹${bookingdetailsid.data.first.totalFare}",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFF37023))),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Amount",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color:
                                                            Color(0xFF606060),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text("Including GST+ taxes",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF909090))),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 17.5),
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
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(
                                iscontact ? "View Less" : "View More",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Mobile"),
                                      Text(
                                        bookingdetailsid.data.first
                                            .passengerDetails.first.ContactNo,
                                        style: TextStyle(
                                            color: Color(0xFF303030),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Email"),
                                      Text(
                                        bookingdetailsid.data.first
                                            .passengerDetails.first.Email,
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
