import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'DotDivider.dart';
import 'Payment.dart';
import 'ShowModelSheet.dart';
import 'ViewFullDetails.dart';

class ConfirmTravelerDetails extends StatefulWidget {
  final Map<String, dynamic> flight;
  final String city;
  final String destination;

  ConfirmTravelerDetails({
    required this.flight,
    required this.city,
    required this.destination,
  });

  @override
  State<ConfirmTravelerDetails> createState() => _ConfirmTravelerDetailsState();
}

class _ConfirmTravelerDetailsState extends State<ConfirmTravelerDetails> {
  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final city = widget.city;
    final destination = widget.destination;
    final List<Map<String, String>> travelers = [
      {"type": "ADULT 1", "name": "John"},
      {"type": "ADULT 2", "name": "ABC"},
    ];
    final List<Map<String, String>> travelers1 = [
      {"type": "CHILD 1", "name": "XYZ"},
      {"type": "CHILD 2", "name": "Smith"},
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Traveler Details ',
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
                    // Flight header
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
                            //     fontFamily: 'Inter',
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 14.sp,
                            //     color: Colors.black,
                            //   ),
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
                                            color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 45.w),
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
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Image.asset("assets/images/star.png"),
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
                    // Flight timing and city details
                    Row(
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
                            Text("1 hr 14m", style: TextStyle(fontSize: 12.sp)),
                            Image.asset('assets/images/flightColor.png'),
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
                            child: Image.asset("assets/images/Traingle.png"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                    Text(
                      "Edit Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          color: Colors.black),
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
            ...travelers.map((traveler) {
              final isAdult = traveler['type']!.startsWith('ADULT');
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.h),
                child: TravelerCard(
                  name: traveler['name']!,
                  type: traveler['type']!,
                  isAdult: isAdult,
                ),
              );
            }).toList(),
            SizedBox(height: 5.h),
            Text(
              "Child",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  fontSize: 12.sp),
            ),
            SizedBox(height: 2.h),
            ...travelers1.map((traveler) {
              final isAdult = traveler['type']!.startsWith('ADULT');
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.h),
                child: TravelerCard(
                  name: traveler['name']!,
                  type: traveler['type']!,
                  isAdult: isAdult,
                ),
              );
            }).toList(),
            Text(
              'Add Additional',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                fontFamily: 'Inter',
              ),
            ),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
                      () => MakePaymentScreen(
                        flight: flight,
                        city: widget.city,
                        destination: widget.destination,
                      ),
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

class TravelerCard extends StatelessWidget {
  final String name;
  final String type;
  final bool isAdult;

  const TravelerCard({
    Key? key,
    required this.name,
    required this.type,
    required this.isAdult,
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
