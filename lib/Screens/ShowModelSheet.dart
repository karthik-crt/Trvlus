import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FareBreakupSheet extends StatefulWidget {
  final double? basefare;
  final double? tax;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final num? coupouncode;
  final double? othercharges;
  final double? adultfare;
  final double? childfare;
  final double? infantfare;
  double? adultTax;
  final double? childTax;
  final double? infantTax;
  final bool showConvenienceFee;
  final bool ssrData;
  double convenienceFee = 0;
  final double? total;
  final Map<String, dynamic> meal;
  final double baggage;
  final List<Map<String, dynamic>> seat;

  FareBreakupSheet(
      {this.basefare,
      this.tax,
      this.adultCount,
      this.childCount,
      this.infantCount,
      this.coupouncode,
      this.othercharges,
      this.adultfare,
      this.childfare,
      this.infantfare,
      this.adultTax,
      this.childTax,
      this.infantTax,
      this.showConvenienceFee = false,
      this.ssrData = false,
      required this.convenienceFee,
      required this.meal,
      required this.seat,
      required this.baggage,
      this.total});

  @override
  _FareBreakupSheetState createState() => _FareBreakupSheetState();
}

class _FareBreakupSheetState extends State<FareBreakupSheet> {
  @override
  Widget build(BuildContext context) {
    print("VIEW FARE FULL DETAIL");
    double mealTotal = 0.0;
    double seatTotal = 0.0;
    double baggageTotal = 0.0;
    int total = 0;

    final tax = widget.tax?.round();
    print("totaltotal$tax");
    final othertaxcharges =
        ((widget.tax ?? 0) + (widget.othercharges ?? 0)).round();
    print("othertaxcharges$othertaxcharges");
    print("coupoun${widget.coupouncode}");
    print("meal${widget.meal}");
    print("meal${widget.meal['Price']}");
    print("seat${widget.seat}");
    print("dgtgsgre${widget.adultfare}");
    print("dgtgsgre${widget.tax}");
    print("dgtgsgre${widget.othercharges}");

    final adultFare = widget.adultfare?.round();
    final childFare = widget.childfare?.round();
    final infantFare = widget.infantfare?.round();
    final conveniencefee = widget.convenienceFee.toInt();
    final adulttax = widget.adultTax;
    final childtax = widget.childTax;
    final infanttax = widget.infantTax;
    final taxtotal = tax;
    print("taxtotal$taxtotal");
    final othercharges = widget.othercharges?.round();
    print("othercharges$othercharges");
    final othertaxtotal = tax! + othercharges!;
    print("othertaxtotal$othertaxtotal");
    final overalltotal = widget.total;
    print("overalltotal$overalltotal");
    print("taxtotal$taxtotal");
    final coupoun = widget.coupouncode;
    final adultCount = widget.adultCount;
    final childCount = widget.childCount;
    final infantCount = widget.infantCount;

    final totalAdultFare = adultFare! / adultCount!;
    final totalChildFare = childFare! / childCount!;
    final totalInfantFare = infantFare! / infantCount!;
    print("totalAdultFare$totalAdultFare");
    print("grgrg${widget.convenienceFee}");

    print("taxtotal$taxtotal");
    final totalDiscount = coupoun?.toDouble();
    print("totalDiscount$totalDiscount");

    final basefare = widget.basefare?.round();
    final totalBaseFare =
        (double.parse(basefare.toString()) - double.parse(coupoun.toString()))
            .round();

    final double convenienceFee =
        widget.showConvenienceFee ? (widget.convenienceFee ?? 0) : 0;
    print("convenienceFee$convenienceFee");

    // MEAL SEAT BAGGAGE CALCULATION
    final mealData = widget.meal;
    final seatData = widget.seat;
    final baggageData = widget.baggage;

// Meal
    if (mealData != null) {
      mealData.forEach((route, passengers) {
        passengers.forEach((pax, meals) {
          for (var meal in meals) {
            mealTotal += (meal['Price'] ?? 0).toDouble();
            print("mealTotalmealTotal$mealTotal");
          }
        });
      });
    }

// Seat
    if (seatData != null) {
      for (var seat in seatData) {
        seatTotal += (seat['Price'] ?? 0).toDouble();
      }
    }

    print("Meal: $mealTotal");
    print("Seat: $seatTotal");
    print("baggage: $baggageData");
    print("Grand Total: ${mealTotal + seatTotal + baggageData}");

    final ssrTotal = mealTotal + seatTotal + baggageData;
    print("ssrTotal$ssrTotal");

    if (widget.coupouncode! > 0) {
      print("helloooo");
      print(adultFare);
      print(conveniencefee);
      print(taxtotal);
      print(totalDiscount);
      total = (adultFare! +
              childFare! +
              infantFare! +
              conveniencefee +
              taxtotal! -
              totalDiscount!)
          .round();
      print("overallFare1$total");
    } else {
      print("helloooohelo");
      total = adultFare! +
          childFare! +
          infantFare! +
          conveniencefee +
          othertaxtotal;
      print("no commission");
      print("overallFare$total");
      print("overallFare$adultFare");
      print("overallFare$othertaxtotal");
    }

    // final total = adultFare! +
    //     childFare! +
    //     infantFare! +
    //     conveniencefee +
    //     taxtotal! -
    //     totalDiscount!;
    // print("totaltotaltotal$total");

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
                        Text("Base Fare",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text("₹${widget.basefare!.toStringAsFixed(0)}",
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
                                "Adults (${widget.adultCount} X ₹${totalAdultFare.toInt()})",
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
                        if (widget.childCount! > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Child (${widget.childCount} X ₹${totalChildFare.toInt()})",
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
                        if (widget.infantCount! > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Infant (${widget.infantCount} X ₹${totalInfantFare.toInt()})",
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
                            Text("₹$othertaxcharges",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF37023))),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        if (ssrTotal > 0)
                          if (widget.ssrData) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("SSR",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text("₹$ssrTotal",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF37023))),
                              ],
                            ),
                            if (widget.seat.isNotEmpty)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Seat",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey)),
                                  Text("₹$seatTotal",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey)),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Baggage",
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.grey)),
                                Text("${widget.baggage}",
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.grey)),
                              ],
                            ),
                            if (widget.meal != {} && mealTotal > 0)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Meals",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey)),
                                  Text("₹$mealTotal",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey)),
                                ],
                              ),
                          ],
                        if (widget.showConvenienceFee)
                          if (widget.convenienceFee > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Convenience Fee",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text("₹${widget.convenienceFee.toInt()}",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF37023))),
                              ],
                            ),
                        if (widget.coupouncode != null &&
                            widget.coupouncode! > 0) ...[
                          SizedBox(height: 7.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Discount",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text("-${totalDiscount?.round()}",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF37023))),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Promo Discount",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  )),
                              Text("₹${coupoun!.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ],
                        SizedBox(height: 7.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text("₹${total.toInt()}",
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
