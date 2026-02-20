import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trvlus/Screens/ticketdetails.dart';
import 'package:trvlus/models/bookinghistory.dart';
import 'package:trvlus/utils/api_service.dart';

import '../models/addstatus.dart';
import 'DotDivider.dart';
import 'ProfilePage.dart';
import 'notification_service.dart';

class BookingHistoryPage extends StatefulWidget {
  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  // Example: Dynamic booking status (could be toggled or updated via API)
  String bookingStatus = "CONFIRMED";

  // String hello = widget.bookings as String;
  // List<String> nationality = <String>[
  //   'Cancellation',
  //   'Flight rescheduling charges',
  //   'Flight Booking status',
  //   'Flight refund status',
  //   'Others'
  // ];
  // String selectedNationality = 'Cancellation';

  List<String> nationality = [];
  List<Map<String, dynamic>> statusList =
      []; // keeps id + name for sending back
  String? selectCancelReason = "Cancel";
  bool showError = false; // new variable for validation
  String? createdDate = '';
  final remarkController = TextEditingController();
  bool isLoading = false;
  late BookingHistory bookingHistory;
  late CancelReasonData cancelReasonData;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getBookingData();
  }

  getBookingData() async {
    setState(() {
      isLoading = true;
    });
    bookingHistory = await ApiService().bookingHistory();
    cancelReasonData = await ApiService().addStatus();
    print("dsfsg${jsonEncode(cancelReasonData)}");
    selectCancelReason = cancelReasonData.data.toString();
    print("selectCancelReason${jsonEncode(selectCancelReason)}");
    setState(() {
      isLoading = false;
    });
  } //h

  String getRequestTextFromId(int? id) {
    if (id == 1) return "cancellation";
    if (id == 2) return "refund";
    if (id == 3) return "date change";
    return "change request";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          title: Text(
            "Booking history",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                fontSize: 14.sp),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage())),
          )
          // elevation: 1,
          ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Text(
      //         "No Record Found!",
      //         style: TextStyle(
      //             color: Colors.black,
      //             fontWeight: FontWeight.w700,
      //             fontFamily: 'Inter',
      //             fontSize: 16.sp),
      //       )
      //     ],
      //   ),
      // ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Color(0xFFF37023)),
            )
          : (bookingHistory.data == null || bookingHistory.data!.isEmpty)
              ? Center(
                  child: Text(
                    "No Records Found!",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        fontSize: 16.sp),
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                  child: ListView.builder(
                    itemCount: bookingHistory.data.length,
                    itemBuilder: (context, index) {
                      final booking = bookingHistory.data[index];
                      print("BOOKING HISTORY");
                      print("HISTORY BOOKING HISTORY");
                      final journeys = booking.journeyList;

                      int totalMinutes = 0;

                      for (var j in journeys) {
                        totalMinutes +=
                            int.tryParse(j.duration.toString()) ?? 0;

                        if (j.layOverTime != null &&
                            j.layOverTime!.isNotEmpty) {
                          final regex = RegExp(r'(\d+)h\s*(\d+)m');
                          final match = regex.firstMatch(j.layOverTime!);
                          if (match != null) {
                            totalMinutes += (int.parse(match.group(1)!) * 60) +
                                int.parse(match.group(2)!);
                          }
                        }
                      }

                      final totalDurationText =
                          '${totalMinutes ~/ 60}h ${totalMinutes % 60}m';
                      print("totalDurationText$totalDurationText");
                      final create = booking.createdAt;
                      final date = DateTime.parse(create);
                      createdDate = DateFormat('dd MMM, yyyy').format(date);
                      // FOR PAST DATE REMOVE
                      String depatureStr =
                          booking.journeyList.first.depature; // "22 Oct 25"
                      DateTime bookingDate = parseBookingDate(depatureStr);
                      print("bookingDatebookingDate$bookingDate");
                      DateTime today = DateTime.now();
                      DateTime todayDateOnly =
                          DateTime(today.year, today.month, today.day);
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 16.h),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✈️ Flight Header
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/${booking.journeyList.first.operatorCode ?? ""}.gif",
                                    fit: BoxFit.cover,
                                    height: 35,
                                    width: 35,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          booking.journeyList.first
                                                  .operatorName ??
                                              "",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: booking
                                              .journeyList.first.operatorCode,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Colors.grey.shade700),
                                          children: [
                                            TextSpan(
                                              text: booking.journeyList.first
                                                  .flightNumber,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                      fontSize: 12.sp,
                                                      color: Colors.orange),
                                            ),
                                            TextSpan(
                                              text: " NR",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                      fontSize: 12.sp,
                                                      color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 45.w),
                                  // Image.asset("assets/images/Line.png"),
                                  // const Spacer(),
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
                                      Text(
                                        "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Colors.grey.shade700),
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

                              // 🏙️ Route Info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            booking
                                                .journeyList.first.fromCityName,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            booking.journeyList.first
                                                .fromAirportCode,
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
                                          booking.journeyList.first
                                              .fromAirportName,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      // Text(
                                      //   "Terminal 3",
                                      //   style: TextStyle(
                                      //       fontSize: 12.sp, color: Colors.grey),
                                      // ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            booking.journeyList.last.toCityName,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            booking
                                                .journeyList.last.toAirportCode,
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
                                          booking
                                              .journeyList.last.toAirportName,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                      // Text(
                                      //   "Terminal 1",
                                      //   style: TextStyle(fontSize: 12.sp),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),

                              // 🕓 Timing Row
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xFFFFF4EE),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking
                                              .journeyList.first.depatureTime,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          booking.journeyList.first.depature,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(totalDurationText,
                                            style: TextStyle(fontSize: 12.sp)),
                                        Image.asset(
                                            'assets/images/flightDetails.png'),
                                        Text(
                                            booking.journeyList.first.noofstop
                                                .toString(),
                                            style: TextStyle(fontSize: 12.sp)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          booking.journeyList.last.arrivalTime,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          booking.journeyList.last.arrival,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // 🧾 PNR, Reference & Booking Status
                              InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  print("Booking ID${booking.id}");
                                  var bookingID = booking.id;
                                  print("bookingID$bookingID");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Ticketdetails(id: bookingID),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Airline PNR",
                                            style: TextStyle(fontSize: 12.sp)),
                                        Text(
                                          booking.pnr ?? "",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Reference Number",
                                            style: TextStyle(fontSize: 12.sp)),
                                        Text(
                                          booking.appReference ?? "",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Booking Status",
                                            style: TextStyle(fontSize: 12.sp)),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDEF6DB),
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                          ),
                                          child: Text(
                                            (booking.customerStatus.isNotEmpty
                                                    ? booking.customerStatus
                                                    : booking.status)
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: [
                                                "FAILED",
                                                "CANCELLED"
                                              ].contains((booking.status ?? "")
                                                      .toUpperCase())
                                                  ? Colors.red
                                                  : const Color(0xFF138808),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text("Customer Status",
                                    //         style: TextStyle(fontSize: 12.sp)),
                                    //     Container(
                                    //       padding: EdgeInsets.symmetric(
                                    //           horizontal: 10.w, vertical: 5.h),
                                    //       decoration: BoxDecoration(
                                    //         color: const Color(0xFFDEF6DB),
                                    //         borderRadius:
                                    //             BorderRadius.circular(15.r),
                                    //       ),
                                    //       child: Text(
                                    //         (booking.customerStatus ?? "")
                                    //             .toUpperCase(),
                                    //         style: TextStyle(
                                    //           color: [
                                    //             "FAILED",
                                    //             "CANCELLED"
                                    //           ].contains(
                                    //                   (booking.customerStatus ??
                                    //                           "")
                                    //                       .toUpperCase())
                                    //               ? Colors.red
                                    //               : const Color(0xFF138808),
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 10.sp,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10.h),

                              // 🎟 Action Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    imagePath: "assets/icon/download.svg",
                                    label: "Download\nE-ticket",
                                    onTap: () async {
                                      var bookingID =
                                          booking.bookingId.toString();
                                      var pnr = booking.pnr.toString();
                                      print("DOWNLOAD API CALLING");

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Ticket is downloading…"),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );

                                      await ApiService()
                                          .downloadTicket(bookingID, pnr);

                                      NotificationService
                                          .showDownloadNotification(
                                              "ticket_$bookingID.pdf");
                                    },
                                  ),
                                  _buildActionButton(
                                    imagePath: "assets/icon/email.svg",
                                    label: "Email\nE-ticket",
                                    onTap: () {
                                      print("Email E-ticket tapped");
                                    },
                                  ),
                                  _buildActionButton(
                                    imagePath: "assets/icon/invoice.svg",
                                    label: "Download\nInvoice",
                                    onTap: () async {
                                      var bookingID =
                                          booking.bookingId.toString();
                                      var pnr = booking.pnr.toString();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Invoice is downloading…"),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                      await ApiService()
                                          .downloadInvoice(bookingID, pnr);
                                      print("Download Invoice tapped");

                                      NotificationService
                                          .showDownloadNotification(
                                              "invoice_$bookingID.pdf");
                                    },
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),
                              Column(
                                children: [
                                  // 🔔 Cancellation / Change Request Message
                                  if (booking.verifystatus.toString() == "0")
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFFFFE9DD),
                                      ),
                                      child: Text(
                                        "Requested for Cancelled on $createdDate.\n"
                                        "You will get a confirmation by our team shortly.",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),

                                  if (booking.verifystatus.toString() == "1")
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFFFFE9DD),
                                      ),
                                      child: Text(
                                        booking.cancel_description != null &&
                                                booking.cancel_description!
                                                    .trim()
                                                    .isNotEmpty
                                            ? booking.cancel_description!
                                            : "Your request has been approved by our team.",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              SizedBox(height: 10.h),

                              // 🔸 Change Request Row
                              if (!bookingDate.isBefore(todayDateOnly))
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Want to change request?",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF606060)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                          backgroundColor:
                                              const Color(0xFFF5F5F5),
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSetter setModalState) {
                                                return Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: SizedBox(
                                                      height: 400,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Change Request",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "PNR: ${booking.pnr}"),
                                                                  ],
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/icon/Close.png",
                                                                    height: 25,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            _buildDropdownField(
                                                              'Select',
                                                              selectCancelReason,
                                                              cancelReasonData,
                                                              (value) {
                                                                setModalState(
                                                                    () {
                                                                  selectCancelReason =
                                                                      value!;
                                                                  print(
                                                                      "selectCancelReason$selectCancelReason");
                                                                });
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            _buildTextField1(
                                                              label:
                                                                  'Remarks *',
                                                              hintText:
                                                                  'Text here',
                                                              controller:
                                                                  remarkController,
                                                            ),
                                                            const SizedBox(
                                                                height: 50),
                                                            Container(
                                                              height: 50,
                                                              width: MediaQuery
                                                                      .sizeOf(
                                                                          context)
                                                                  .width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: const Color(
                                                                    0xFFF37023),
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  String
                                                                      remark =
                                                                      remarkController
                                                                          .text
                                                                          .trim(); // get the text
                                                                  print(
                                                                      "User typed remark: $remark");
                                                                  // print("hellooo${booking.verifystatus});
                                                                  // Check if user selected a reason
                                                                  if (selectCancelReason ==
                                                                          null ||
                                                                      selectCancelReason!
                                                                          .isEmpty) {
                                                                    // Show error message
                                                                    setState(
                                                                        () {
                                                                      showError =
                                                                          true;
                                                                    });
                                                                    return; // Stop further execution
                                                                  }

                                                                  // Reset error if a reason is selected
                                                                  setState(() {
                                                                    showError =
                                                                        false;
                                                                  });

                                                                  // Call API
                                                                  await ApiService().cancelRequest(
                                                                      pnr: booking
                                                                          .pnr,
                                                                      appref: booking
                                                                          .appReference,
                                                                      bookingID:
                                                                          booking
                                                                              .bookingId,
                                                                      status: booking
                                                                          .status,
                                                                      remark:
                                                                          remark,
                                                                      selectCancelReason:
                                                                          selectCancelReason
                                                                      // reason: selectCancelReason, // pass selected reason
                                                                      );

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Send",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "Change Request",
                                        style: TextStyle(
                                          color: Color(0xFFF37023),
                                          fontSize: 17,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xFFF37023),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  DateTime parseBookingDate(String dateStr) {
    try {
      // Try format: 22 Oct 25
      return DateFormat('dd MMM yy').parse(dateStr);
    } catch (e1) {
      try {
        // Try format: 2025-10-16
        return DateFormat('yyyy-MM-dd').parse(dateStr);
      } catch (e2) {
        // If still fails, print and fallback to today (optional)
        print("Date parsing failed for: $dateStr");
        return DateTime.now();
      }
    }
  }
}

Widget _buildDropdownField(String label, String? selectedValue,
    CancelReasonData items, Function(String?) onChanged) {
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue != null &&
                    items.data.any((e) => e.name == selectedValue)
                ? selectedValue
                : null,
            hint: const Text("Select The Reason!"),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            onChanged: onChanged,
            items: items.data.map<DropdownMenuItem<String>>((e) {
              return DropdownMenuItem<String>(
                value: e.name,
                child: Text(e.name),
              );
            }).toList(),
          ),
        ),
      ),
    ],
  );
}

Widget _buildTextField1(
    {required String label,
    required String hintText,
    TextEditingController? controller}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: label == "Date of birth *"
                ? GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.date_range,
                      color: Colors.grey.shade800,
                    ),
                  )
                : label == "Expiry Date*"
                    ? GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.date_range,
                          color: Colors.grey.shade800,
                        ),
                      )
                    : const SizedBox.shrink(),
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

Future<bool> requestStoragePermission() async {
  var status = await Permission.storage.status;

  if (status.isGranted) return true;

  if (status.isPermanentlyDenied) {
    // User denied forever → open app settings
    await openAppSettings();
    return false;
  }

  status = await Permission.storage.request();
  return status.isGranted;
}

Widget _buildActionButton({
  required String imagePath,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 90.w,
      height: 70.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imagePath),
          SizedBox(height: 10.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
