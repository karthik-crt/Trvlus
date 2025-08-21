import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'ConfirmTraveler.dart';
import 'DotDivider.dart';
import 'ViewFullDetails.dart';

class MakePaymentScreen extends StatefulWidget {
  final Map<String, dynamic> flight;
  final String city;
  final String destination;

  MakePaymentScreen({
    required this.flight,
    required this.city,
    required this.destination,
  });

  @override
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  String selectedPaymentMethod = 'Google Pay';
  final TextEditingController _cardNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final city = widget.city;
    final destination = widget.destination;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Make Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontFamily: 'Inter',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFF5F5F5),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                          dotSize: 1.h,
                          spacing: 2.r,
                          dotCount: 97,
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
              SizedBox(
                height: 8.h,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PAY THROUGH UPI',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              fontFamily: 'Inter')),
                      SizedBox(height: 5.h),
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Image.asset("assets/images/Gpay.png"),
                        title: Text('Google Pay'),
                        subtitle: Text(
                          'save ₹49 by paying online',
                          style: TextStyle(
                            color: Color(0xFF138808),
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'Google Pay';
                            });
                          },
                          child: Icon(
                            selectedPaymentMethod == 'Google Pay'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedPaymentMethod == 'Google Pay'
                                ? Color(0xFFF37023)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Image.asset("assets/images/Pay_tm.png"),
                        title: Text('Paytm'),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'Paytm';
                            });
                          },
                          child: Icon(
                            selectedPaymentMethod == 'Paytm'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedPaymentMethod == 'Paytm'
                                ? Color(0xFFF37023)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Image.asset("assets/images/Phone_pay.png"),
                        title: Text('Paytm'),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'PhonePay';
                            });
                          },
                          child: Icon(
                            selectedPaymentMethod == 'PhonePay'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedPaymentMethod == 'PhonePay'
                                ? Color(0xFFF37023)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PAY THROUGH CARD',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            "+ADD NEW CARD",
                            style: TextStyle(color: Color(0xFFF37023)),
                          )
                        ],
                      ),
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Image.asset("assets/images/Card.png"),
                        title: Text('HDFC Credit Card'),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = 'HDFC Credit Card';
                            });
                          },
                          child: Icon(
                            selectedPaymentMethod == 'HDFC Credit Card'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedPaymentMethod == 'HDFC Credit Card'
                                ? Color(0xFFF37023)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      TextField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          CardNumberInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          filled: true,

                          fillColor: Color(0xFFF3F4F6),
                          // Background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NET BANKING",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'NET BANKING';
                          });
                        },
                        child: Icon(
                          selectedPaymentMethod == 'NET BANKING'
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selectedPaymentMethod == 'NET BANKING'
                              ? Color(0xFFF37023)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              // Card(
              //   color: Colors.white,
              //   child: Padding(
              //     padding:
              //         EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              //     // child: Row(
              //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     //   children: [
              //     //     Text(
              //     //       "",
              //     //       style: TextStyle(
              //     //           fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              //     //     ),
              //     //     GestureDetector(
              //     //       onTap: () {
              //     //         setState(() {
              //     //           selectedPaymentMethod = 'CASH ON DELIVERY';
              //     //         });
              //     //       },
              //     //       child: Icon(
              //     //         selectedPaymentMethod == 'CASH ON DELIVERY'
              //     //             ? Icons.check_circle
              //     //             : Icons.radio_button_unchecked,
              //     //         color: selectedPaymentMethod == 'CASH ON DELIVERY'
              //     //             ? Color(0xFFF37023)
              //     //             : Colors.grey,
              //     //       ),
              //     //     ),
              //     //   ],
              //     // ),
              //   ),
              // ),
              SizedBox(height: 16.h),
            ],
          ),
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
                    Get.to(MakePaymentScreen(
                      flight: flight,
                      city: widget.city,
                      destination: widget.destination,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40.h),
                    backgroundColor: Color(0xFFF37023),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Proceed to pay",
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

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', ''); // Remove existing spaces
    String formatted = '';

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' '; // Add space after every 4 digits
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
