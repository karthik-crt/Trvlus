import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FareBreakupSheet extends StatefulWidget {
  final double? basefare;
  final double? tax;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final double? adultfare;
  final double? childfare;
  final double? infantfare;
  final double? adultTax;
  final double? childTax;
  final double? infantTax;
  final double? total;

  FareBreakupSheet(
      {this.basefare,
      this.tax,
      this.adultCount,
      this.childCount,
      this.infantCount,
      this.adultfare,
      this.childfare,
      this.infantfare,
      this.adultTax,
      this.childTax,
      this.infantTax,
      this.total});

  @override
  _FareBreakupSheetState createState() => _FareBreakupSheetState();
}

class _FareBreakupSheetState extends State<FareBreakupSheet> {
  @override
  Widget build(BuildContext context) {
    print("VIEW FARE FULL DETAIL");
    // final adultFare = (widget.adultCount ?? 0) * (widget.basefare ?? 0);
    // final childFare = (widget.childCount ?? 0) * (widget.basefare ?? 0);
    // final infantFare = (widget.infantCount ?? 0) * (widget.basefare ?? 0);
    final tax = widget.tax ?? 0;
    // print("totaltotal$total");

    final adultFare = widget.adultfare;
    final childFare = widget.childfare;
    final infantFare = widget.infantfare;
    final adulttax = widget.adultTax;
    final childtax = widget.childTax;
    final infanttax = widget.infantTax;
    final taxtotal = tax;
    final overalltotal = widget.total;
    print("overalltotal$overalltotal");
    final total =
        adultFare! + childFare! + infantFare! + taxtotal; // ✅ now this works
    print("totall$total");
    print("taxtotal$taxtotal");
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              //SizedBox(height: 8.h),
              Divider(),
              //SizedBox(height: 8.h),
              SizedBox(height: 8.h),
              //SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fare Summary",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Inter",
                        color: Colors.black),
                  ),
                  Text(
                    "View less",
                    style: TextStyle(color: Color(0xFF909090)),
                  )
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE7DA),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Base fare",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(widget.basefare.toString(),
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF37023))),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Adults (${widget.adultCount} X ₹${widget.adultfare})",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                )),
                            Text("₹$adultFare",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Child (${widget.childCount} X ₹${widget.childfare})",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                )),
                            Text("₹$childFare",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Infant (${widget.infantCount} X ₹${widget.infantfare})",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                )),
                            Text("₹$infantFare",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tax",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text("₹$tax",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF37023))),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text("₹$overalltotal",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF37023))),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Container(
              //   padding: EdgeInsets.all(12.w),
              //   decoration: BoxDecoration(
              //     color: Color(0xFFF5F5F5),
              //     borderRadius: BorderRadius.circular(8.r),
              //   ),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text("Taxes & Surcharges",
              //               style: TextStyle(
              //                   fontSize: 14.sp,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.black)),
              //           Text("₹5,000",
              //               style: TextStyle(
              //                   fontSize: 14.sp,
              //                   fontWeight: FontWeight.bold,
              //                   color: Color(0xFFF37023))),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text("Airline taxes and surcharges",
              //               style: TextStyle(
              //                 fontSize: 12.sp,
              //                 color: Colors.grey,
              //               )),
              //           Text("₹5,000",
              //               style:
              //                   TextStyle(fontSize: 12.sp, color: Colors.grey)),
              //         ],
              //       ),
              //     ],q
              //   ),
              // ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF37023),
                  minimumSize: Size(double.infinity, 35.h),
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
              Navigator.pop(context);
            },
            child: Container(
              height: 28.h,
              width: 80.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/images/TraingleButton2.png",
                height: 24.h,
                width: 24.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
