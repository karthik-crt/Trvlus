import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trvlus/Screens/ticketdetails.dart';

import 'DotDivider.dart';
import 'Home_Page.dart';
import 'Ticket.dart';

class BookingHistoryPage extends StatefulWidget {
  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  // Example: Dynamic booking status (could be toggled or updated via API)
  String bookingStatus = "CONFIRMED";

  List<String> nationality = <String>[
    'Cancellation',
    'Flight rescheduling charges',
    'Flight Booking status',
    'Flight refund status',
    'Others'
  ];

  String selectedNationality = 'Cancellation';

  final remarkController = TextEditingController();

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
              MaterialPageRoute(builder: (context) => SearchFlightPage())),
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    // Flight header
                    Row(
                      children: [
                        Image.asset('assets/images/Emirates.png',
                            height: 40, width: 40),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emirates',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
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
                                            color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 45.w,
                        ),
                        Image.asset("assets/images/Line.png"),
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
                            Text(
                              "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade700),
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
                    SizedBox(
                      height: 10.h,
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
                                  "Delhi",
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
                            Text(
                              "Delhi Airport",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Terminal 3",
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
                                  "Bengaluru",
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
                            Text(
                              "Bengaluru Airport",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text(
                              "Terminal 1",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFFF4EE)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "05:30",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Sat, 30 Nov 24",
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
                              Image.asset('assets/images/flightDetails.png'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "06:44",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Sat, 30 Nov 24",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        print("hello");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Ticketdetails()));
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Airline PNR",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Inter'),
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
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Inter'),
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
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h, // Adjust size
                        spacing: 2.r, // Adjust spacing
                        dotCount: 97, // Adjust number of dots
                        color: Colors.grey, // Adjust color
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          imagePath: "assets/icon/download.svg",
                          label: "Download\nE-ticket",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Ticket()));
                            print("Download E-ticket tapped");
                          },
                        ),
                        _buildActionButton(
                          imagePath: "assets/icon/email.svg",
                          label: "Email\nE-ticket",
                          onTap: () {
                            // Action for Email E-ticket
                            print("Email E-ticket tapped");
                          },
                        ),
                        _buildActionButton(
                          imagePath: "assets/icon/invoice.svg",
                          label: "Download\nInvoice",
                          onTap: () {
                            // Action for Download Invoice
                            print("Download Invoice tapped");
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DotDivider(
                        dotSize: 1.h, // Adjust size
                        spacing: 2.r, // Adjust spacing
                        dotCount: 97, // Adjust number of dots
                        color: Colors.grey, // Adjust color
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(5),
                    //   height: 55,
                    //   width: 300,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: const Color(0xFFFFE9DD)),
                    //   alignment: Alignment.center,
                    //   child: const Text(
                    //     "",
                    //     // "Requested for cancellation on 12 Sep, 2025 .\n You will get a confirmation by our team shortly.",
                    //     style: TextStyle(fontSize: 12, color: Colors.black),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Want to change request?",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF606060)),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                                backgroundColor: Color(0xFFF5F5F5),
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                clipBehavior: Clip.antiAlias,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: SizedBox(
                                        height: 400,
                                        child: SingleChildScrollView(
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
                                                      Text(
                                                        "Change Request",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text("PNR: 98498YEEY"),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Image.asset(
                                                      "assets/icon/Close.png",
                                                      height: 25,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              _buildDropdownField(
                                                'Select',
                                                selectedNationality,
                                                nationality,
                                                // your list of countries
                                                (value) {
                                                  setState(() {
                                                    selectedNationality =
                                                        value!;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              _buildTextField1(
                                                  label: 'Remarks *',
                                                  hintText: 'Text here'),
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Container(
                                                height: 50,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color(0xFFF37023)),
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Send",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Text(
                            "Change Request",
                            style: TextStyle(
                                color: Color(0xFFF37023),
                                fontSize: 17,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFF37023)),
                          ),
                        )
                      ],
                    )
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
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
