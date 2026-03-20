import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../models/farequote.dart' as farequote;
import '../models/farerule.dart';
import '../models/search_data.dart';
import '../models/ssr.dart';
import '../utils/api_service.dart';
import 'Seat.dart';
import 'ShowModelSheet.dart';

class Additions extends StatefulWidget {
  final String? traceid;
  final String? resultindex;
  final int? finaloffFare;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;
  final Result? outboundFlight;
  final Result? inboundFlight;
  final String? outresultindex;
  final String? inresultindex;
  final List<Map<String, dynamic>> seatPayload;
  final Map<String, dynamic>? initialMealData;
  final Map<String, dynamic>? initialBaggageCount;
  final int? initialTabIndex; // 0=Baggage, 1=Seat, 2=Meals

  final double? baseFare;
  final double? tax;
  final num? coupouncode;
  final double? othercharges;

  const Additions(
      {super.key,
      this.traceid,
      this.resultindex,
      this.adultCount,
      this.childCount,
      this.infantCount,
      required this.outBoundData,
      required this.inBoundData,
      this.outresultindex,
      this.finaloffFare,
      required this.seatPayload,
      this.inresultindex,
      this.baseFare,
      this.tax,
      this.coupouncode,
      this.othercharges,
      this.outboundFlight,
      this.inboundFlight,
      this.initialMealData,
      this.initialBaggageCount,
      this.initialTabIndex});

  @override
  State<Additions> createState() => _AdditionsState();
}

class _AdditionsState extends State<Additions> {
  int totalPrice = 0;
  int selectedindex = 0;
  int selectedBaggage = 0;
  double mealsTotal = 0.0; // ← add this
  int selectedbuild = 0;

  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final int seatsPerRow = 4;
  final Set<String> selectedSeats = {};

  double totalBaseFare = 0;
  double totalTax = 0;
  double othercharges = 0;
  double overallFare = 0;
  double inbaseFare = 0;
  double intax = 0;
  int totaladultCount = 0;
  int totalchildCount = 0;
  int totalinfantCount = 0;
  double adultFare = 0;
  double childFare = 0;
  double infantFare = 0;
  num coupouncode = 0;

  late SsrData ssrData;
  late SsrData inssrData;
  late farequote.FareQuotesData fareQuote;
  late farequote.FareQuotesData infareQuote;
  late FareRuleData fare;

  bool hasMealData = false;
  bool hasInMealData = false;

  bool isLoading = true;
  int selectedPassengerType = 0; // 0 - Adult, 1 - Child
  Map<String, Map<String, dynamic>> selectedMealData = {};
  List<Map<String, dynamic>> selectedSeatPayload = [];
  bool isOutbound = true;
  String fareQuoteResultIndex = '';
  String craftType = ''; // ← add this

  // Add this at the top of your _AdditionsState class
  Map<String, Map<int, int>> selectedBaggageCount =
      {}; // {route: {baggageIndex: count}}
  List<List<dynamic>> get allBaggage {
    List<List<dynamic>> merged = [];
    if (ssrData.response?.baggage != null) {
      merged.addAll(ssrData.response.baggage);
    }
    if (widget.inBoundData['inresultindex'] != null &&
        !isLoading &&
        inssrData.response?.baggage != null) {
      merged.addAll(inssrData.response.baggage);
    }
    return merged;
  }

  // BAGGAGE
  double calculateBaggageTotal() {
    double total = 0.0;

    selectedBaggageCount.forEach((route, baggageMap) {
      baggageMap.forEach((baggageIndex, count) {
        for (final baggageGroup in allBaggage) {
          // ✅ use allBaggage
          if (baggageGroup.isNotEmpty) {
            final groupRoute =
                '${baggageGroup[0].origin}-${baggageGroup[0].destination}';
            if (groupRoute == route && baggageGroup.length > baggageIndex) {
              final price = baggageGroup[baggageIndex].price ?? 0;
              total += (price * count);
              break;
            }
          }
        }
      });
    });

    return total;
  }

  // MEALS
  double calculateMealsTotal() {
    double total = 0.0;

    selectedMealData.forEach((route, passengerMap) {
      passengerMap.forEach((passengerKey, meals) {
        if (meals is List<dynamic>) {
          for (var meal in meals) {
            final price = (meal['Price'] as num?)?.toDouble() ?? 0.0;
            total += price;
          }
        }
      });
    });

    return total;
  }

  void recalculateTotalPrice() {
    int base = widget.finaloffFare ?? 0;

    // ✅ Baggage - now searches both outbound and inbound
    double baggageSum = 0.0;

    selectedBaggageCount.forEach((route, baggageMap) {
      baggageMap.forEach((baggageIndex, count) {
        for (final baggageGroup in allBaggage) {
          // ✅ use allBaggage
          if (baggageGroup.isNotEmpty) {
            final groupRoute =
                '${baggageGroup[0].origin}-${baggageGroup[0].destination}';
            if (groupRoute == route && baggageIndex < baggageGroup.length) {
              final price = (baggageGroup[baggageIndex].price ?? 0).toDouble();
              baggageSum += price * count;
              break;
            }
          }
        }
      });
    });

    base += baggageSum.round();

    // seats and meals stay same...
    double seatSum = 0.0;
    for (final seat in selectedSeatPayload) {
      seatSum += (seat['Price'] as num?)?.toDouble() ?? 0.0;
    }
    base += seatSum.round();

    double mealSum = 0.0;
    selectedMealData.forEach((route, passengerMap) {
      passengerMap.forEach((passengerKey, value) {
        if (value is List) {
          for (final meal in value) {
            mealSum += (meal['Price'] as num?)?.toDouble() ?? 0.0;
          }
        }
      });
    });
    base += mealSum.round();

    setState(() {
      totalPrice = base;
    });
  }

  int getTotalSelectedBaggageForRoute(String route) {
    if (!selectedBaggageCount.containsKey(route)) return 0;
    return selectedBaggageCount[route]!
        .values
        .fold(0, (sum, count) => sum + count);
  }

  // Add this method in your _AdditionsState class
  Map<String, List<Map<String, dynamic>>> getFormattedBaggageData() {
    Map<String, List<Map<String, dynamic>>> formattedBaggage = {};

    selectedBaggageCount.forEach((route, baggageMap) {
      formattedBaggage[route] = [];

      baggageMap.forEach((baggageIndex, count) {
        // Find the correct route index for this baggage
        int routeIndex = 0;
        for (int i = 0; i < ssrData.response.baggage.length; i++) {
          if (ssrData.response.baggage[i].isNotEmpty) {
            String currentRoute =
                '${ssrData.response.baggage[i][0].origin}-${ssrData.response.baggage[i][0].destination}';
            if (currentRoute == route) {
              routeIndex = i;
              break;
            }
          }
        }

        if (ssrData.response.baggage.length > routeIndex &&
            ssrData.response.baggage[routeIndex].length > baggageIndex) {
          final baggageItem =
              ssrData.response.baggage[routeIndex][baggageIndex];
          print("description: ${baggageItem.description}");
          print("weight: ${baggageItem.weight}");

          // Add each baggage item 'count' times
          for (int i = 0; i < count; i++) {
            formattedBaggage[route]!.add({
              "AirlineCode": baggageItem.airlineCode,
              "FlightNumber":
                  int.tryParse(baggageItem.flightNumber.toString()) ?? 0,
              "WayType": baggageItem.wayType,
              "Code": baggageItem.code,
              "Description": baggageItem.description, // raw int from SSR
              "Weight": baggageItem.weight,
              "Currency": baggageItem.currency,
              "Price": baggageItem.price,
              "Origin": baggageItem.origin,
              "Destination": baggageItem.destination,
            });
          }
        }
      });
    });

    return formattedBaggage;
  }

  void storeSelectedMeal(
      String route, int paxType, dynamic meal, int passengerIndex) {
    String passengerType = paxType == 0
        ? "Adult"
        : paxType == 1
            ? "Child"
            : "Infant";

    if (passengerType == "Infant") return;

    // Unique key: "Adult 1", "Child 2", etc.
    String passengerKey = "$passengerType ${passengerIndex + 1}";

    // Initialize route if not exists
    selectedMealData.putIfAbsent(route, () => {});

    // Initialize passenger array if not exists
    selectedMealData[route]!.putIfAbsent(passengerKey, () => []);

    // Remove any existing meal for this passenger on this route
    selectedMealData[route]![passengerKey]
        ?.removeWhere((m) => m["Code"] == meal.code);

    // Add the new meal
    selectedMealData[route]![passengerKey].add({
      "AirlineCode": meal.airlineCode,
      "FlightNumber": meal.flightNumber,
      "WayType": meal.wayType,
      "Code": meal.code,
      "Description": meal.description,
      "AirlineDescription": meal.airlineDescription,
      "Quantity": 1,
      "Currency": meal.currency,
      "Price": meal.price,
      "Origin": meal.origin,
      "Destination": meal.destination,
    });

    recalculateTotalPrice();
    print("Selected Meals: ${jsonEncode(selectedMealData)}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSeatPayload = widget.seatPayload;
    // Set the initial tab if provided
    if (widget.initialTabIndex != null) {
      selectedindex = widget.initialTabIndex!;
    }
    if (widget.initialMealData != null) {
      // Create a deep copy or use as is, casting appropriately
      try {
        widget.initialMealData!.forEach((key, value) {
          if (value is Map) {
            selectedMealData[key] = Map<String, dynamic>.from(value);
          }
        });
      } catch (e) {
        print("Error initializing meal data: $e");
      }
    }
    if (widget.initialBaggageCount != null) {
      try {
        widget.initialBaggageCount!.forEach((key, value) {
          if (value is Map) {
            selectedBaggageCount[key] =
                Map<int, int>.from(value.cast<int, int>());
          }
        });
      } catch (e) {
        print("Error initializing baggage count: $e");
      }
    }
    getssrdata();
    print("seatdf${widget.seatPayload}");

    totalPrice = widget.finaloffFare ?? 0;
  }

  getssrdata() async {
    setState(() {
      isLoading = true;
      print("beforeOutput");
    });

    print(widget.traceid);
    print(widget.resultindex);
    print("ADULTCOUNTADULTCOUNT${widget.adultCount}");
    print(widget.outBoundData);
    print(widget.inresultindex);
    if (widget.outBoundData['outresultindex'] != null &&
        widget.inBoundData['inresultindex'] != null) {
      fare = (await ApiService().farerule(
          widget.outBoundData['outresultindex'] ?? "", widget.traceid ?? ""));
      fare = (await ApiService().farerule(
          widget.inBoundData['inresultindex'] ?? "", widget.traceid ?? ""));
      fareQuote = await ApiService().farequote(
          widget.outBoundData['outresultindex'] ?? "", widget.traceid ?? "");
      infareQuote = await ApiService().farequote(
          widget.inBoundData['inresultindex'] ?? "", widget.traceid ?? "");
      ssrData = await ApiService().ssr(
          widget.outBoundData['outresultindex'] ?? "", widget.traceid ?? "");
      print(ssrData.response.mealDynamic);
      inssrData = await ApiService()
          .ssr(widget.inBoundData['inresultindex'] ?? "", widget.traceid ?? "");
    } else {
      fareQuote = await ApiService()
          .farequote(widget.resultindex ?? "", widget.traceid ?? "");
      ssrData = await ApiService()
          .ssr(widget.resultindex ?? "", widget.traceid ?? "");
      debugPrint("ssrDATA: ${jsonEncode(ssrData)}", wrapWidth: 4500);
    }
    fareQuoteResultIndex = fareQuote.response.results.resultIndex;

    String craftType = '';
    try {
      craftType = fareQuote.response.results.segments.first.first.craft ?? '';
      print("CraftType from FareQuote: $craftType");
    } catch (e) {
      print("CraftType extraction failed: $e");
    }
    final fareBreakdown = fareQuote.response.results.fareBreakdown;
    print("fareBreakdownfareBreakdown${jsonEncode(fareBreakdown)}");
    final baseFare = fareQuote.response.results.fare.baseFare;
    final tax = fareQuote.response.results.fare.tax.toDouble();

    double adultBase = 0, adultTax = 0;
    double childBase = 0, childTax = 0;
    double infantBase = 0, infantTax = 0;
    int adultCount = 0, childCount = 0;
    int infantCount = 0;
    // INBOUNDFARE
    double inadultBase = 0, inadultTax = 0;
    double inchildBase = 0, inchildTax = 0;
    double ininfantBase = 0, ininfantTax = 0;
    int inadultCount = 0, inchildCount = 0;
    int ininfantCount = 0;

    for (var item in fareBreakdown) {
      if (item.passengerType == 1) {
        adultBase = item.baseFare.toDouble();
        adultTax = item.tax.toDouble();
        adultCount = item.passengerCount.toInt();
      } else if (item.passengerType == 2) {
        childBase = item.baseFare.toDouble();
        childTax = item.tax.toDouble();
        childCount = item.passengerCount.toInt();
      } else if (item.passengerType == 3) {
        infantBase = item.baseFare.toDouble();
        infantTax = item.tax.toDouble();
        infantCount = item.passengerCount.toInt();
      }
    }
    // INBOUNDFARE
    if (widget.inBoundData['inresultindex'] != null) {
      final infareBreakdown = infareQuote.response.results.fareBreakdown;
      print("infareBreakdownfareBreakdown${jsonEncode(infareBreakdown)}");
      inbaseFare = infareQuote.response.results.fare.baseFare;
      print("inbaseFare$inbaseFare");
      intax = infareQuote.response.results.fare.tax.toDouble();
      for (var item in infareBreakdown) {
        if (item.passengerType == 1) {
          inadultBase = item.baseFare.toDouble();
          inadultTax = item.tax.toDouble();
          inadultCount = item.passengerCount.toInt();
        } else if (item.passengerType == 2) {
          inchildBase = item.baseFare.toDouble();
          inchildTax = item.tax.toDouble();
          inchildCount = item.passengerCount.toInt();
        } else if (item.passengerType == 3) {
          ininfantBase = item.baseFare.toDouble();
          ininfantTax = item.tax.toDouble();
          ininfantCount = item.passengerCount.toInt();
        }
      }
    }

    setState(() {
      isLoading = false;
      coupouncode = widget.coupouncode!;
      othercharges = widget.othercharges ?? 0;

      totalBaseFare = baseFare + inbaseFare;
      print("totalFare$totalBaseFare");
      totalTax = tax + intax + othercharges;
      print("totalTax$totalTax");
      if (widget.coupouncode! > 0) {
        overallFare = totalBaseFare + totalTax - coupouncode;
        print("overallFare1$overallFare");
      } else {
        overallFare = totalBaseFare + totalTax + othercharges;
        print("overallFare$overallFare");
        print("overallFare$totalBaseFare");
        print("overallFare$totalTax");
        print("overallFare$othercharges");
      }
      totaladultCount = adultCount + inadultCount;
      totalchildCount = childCount + inchildCount;
      totalinfantCount = infantCount + ininfantCount;
      adultFare = adultBase + inadultBase;
      childFare = childBase + inchildBase;
      infantFare = infantBase + ininfantBase;

      // Default to Seat tab if baggage is not available
      if (ssrData.response == null ||
          ssrData.response!.baggage == null ||
          ssrData.response!.baggage.isEmpty) {
        selectedindex = 1;
      }

      print("AferOutput");
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFFF37023),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Loading...",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            bottomNavigationBar: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(0.r)),
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
                                  showFareBreakupSheet(context);
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
                                "₹${totalPrice.toStringAsFixed(0)}",
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
                          print("wigent${widget.resultindex}");
                          // ApiService().bookTicket(selectedSeatPayload,
                          //     widget.resultindex, widget.traceid);
                          // Same data bundle as back arrow
                          Map<String, dynamic> threeValue = {
                            "meal": selectedMealData,
                            "seat": selectedSeatPayload,
                            "baggage": getFormattedBaggageData(),
                            "baggageCount": selectedBaggageCount,
                          };
                          print("Next pressed → passing data: $threeValue");
                          Navigator.pop(context, threeValue);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40.h),
                          backgroundColor: Color(0xFFF37023),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          "Next",
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
            backgroundColor: Color(0xFFE8E8E8),
            appBar: AppBar(
              backgroundColor: Color(0xFFE8E8E8),
              automaticallyImplyLeading: false,
              title: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade200),
                      child: GestureDetector(
                          onTap: () {
                            Map<String, dynamic> threeValue = {
                              "meal": selectedMealData,
                              "seat": selectedSeatPayload,
                              "baggage": getFormattedBaggageData(),
                              "baggageCount": selectedBaggageCount
                              // Add this line for seats
                            };
                            print("threeValue$threeValue");
                            Navigator.pop(context, threeValue);
                          },
                          child: Icon(Icons.arrow_back)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Additions",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 50.h,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (ssrData.response != null &&
                            ssrData.response!.baggage != null &&
                            ssrData.response!.baggage.isNotEmpty)
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedindex = 0;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.sizeOf(context).height,
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: selectedindex == 0
                                                ? Color(0xFFF37023)
                                                : Colors.grey.shade300),
                                        color: selectedindex == 0
                                            ? Color(0xFFFFE7DA)
                                            : Colors.white),
                                    child: Text(
                                      "Baggage",
                                      style: TextStyle(
                                          color: selectedindex == 0
                                              ? Color(0xFFF37023)
                                              : Colors.black),
                                    ),
                                  ))),
                        SizedBox(
                          width: 2,
                        ),
                        if (ssrData.response.seatDynamic.isNotEmpty)
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedindex = 1;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.sizeOf(context).height,
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: selectedindex == 1
                                            ? Color(0xFFFFE7DA)
                                            : Colors.white,
                                        border: Border.all(
                                            color: selectedindex == 1
                                                ? Color(0xFFF37023)
                                                : Colors.grey.shade300)),
                                    child: Text(
                                      "Seat",
                                      style: TextStyle(
                                          color: selectedindex == 1
                                              ? Color(0xFFF37023)
                                              : Colors.black),
                                    ),
                                  ))),
                        SizedBox(
                          width: 2,
                        ),
                        if (ssrData.response != null &&
                            ssrData.response!.mealDynamic != null &&
                            ssrData.response!.mealDynamic.isNotEmpty)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedindex = 2;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: selectedindex == 2
                                      ? const Color(0xFFFFE7DA)
                                      : Colors.white,
                                  border: Border.all(
                                    color: selectedindex == 2
                                        ? const Color(0xFFF37023)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  "Meals",
                                  style: TextStyle(
                                      color: selectedindex == 2
                                          ? Color(0xFFF37023)
                                          : Colors.black),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                selectedindex == 0 &&
                        ssrData.response != null &&
                        ssrData.response!.baggage != null &&
                        ssrData.response!.baggage.isNotEmpty
                    ? buildBaggage()
                    : selectedindex == 1 &&
                            ssrData.response.seatDynamic.isNotEmpty
                        ? Expanded(child: buildseat())
                        : (ssrData.response != null &&
                                ssrData.response!.mealDynamic != null &&
                                ssrData.response!.mealDynamic.isNotEmpty &&
                                selectedindex == 2)
                            ? Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [buildmeals()],
                                ),
                              )
                            : const SizedBox.shrink(),
              ],
            ));
  }

  buildBaggage() {
    print("Total baggage groups: ${ssrData.response.baggage.length}");
    for (int i = 0; i < ssrData.response.baggage.length; i++) {
      print("Group $i length: ${ssrData.response.baggage[i].length}");
      if (ssrData.response.baggage[i].isNotEmpty) {
        print(
            "  Route: ${ssrData.response.baggage[i][0].origin}-${ssrData.response.baggage[i][0].destination}");
      }
    }
    final int totalPassengers = (widget.adultCount ?? 0) +
        (widget.childCount ?? 0) +
        (widget.infantCount ?? 0);

    // ✅ Merge outbound + inbound baggage
    List<List<dynamic>> allBaggage = [];

    if (ssrData.response != null && ssrData.response.baggage != null) {
      allBaggage.addAll(ssrData.response.baggage);
    }

    // Add inbound baggage if it's a round trip
    if (widget.inBoundData['inresultindex'] != null &&
        inssrData.response != null &&
        inssrData.response.baggage != null) {
      allBaggage.addAll(inssrData.response.baggage);
    }

    String currentRoute = '';
    if (allBaggage.isNotEmpty && allBaggage[selectedBaggage].isNotEmpty) {
      currentRoute =
          '${allBaggage[selectedBaggage][0].origin}-${allBaggage[selectedBaggage][0].destination}';
    }

    return Column(
      children: [
        Column(
          children: [
            SizedBox(height: 15),

            // Route pills
            if (allBaggage.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(allBaggage.length, (index) {
                      if (allBaggage[index].isEmpty) return SizedBox.shrink();

                      final route = allBaggage[index][0];
                      final routeText =
                          '${route.origin} - ${route.destination}';

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBaggage = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: selectedBaggage == index
                                  ? Color(0xFFF37023)
                                  : Color(0xFFFFF4ED),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: selectedBaggage == index
                                    ? Color(0xFFF37023)
                                    : Color(0xFFF37023).withOpacity(0.3),
                                width: selectedBaggage == index ? 1.5 : 0.5,
                              ),
                            ),
                            child: Text(
                              routeText,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selectedBaggage == index
                                    ? Colors.white
                                    : Color(0xFFF37023),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

            Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/baggage.svg'),
                        SizedBox(width: 5),
                        Text("Baggage",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 7),
                    Text("Add additional checkin baggage at low price"),
                    SizedBox(height: 5),
                    Text(
                      "You can select up to $totalPassengers baggage(s)",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFF37023),
                          fontWeight: FontWeight.w600),
                    ),
                    Divider(color: Colors.grey),
                    Row(
                      children: [
                        Text('Kilogram',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 80),
                        Text('Price',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 5),

                    // ✅ Use allBaggage instead of ssrData.response.baggage
                    if (allBaggage.length > selectedBaggage)
                      Container(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              allBaggage[selectedBaggage].length,
                              (innerindex) {
                                if (!selectedBaggageCount
                                    .containsKey(currentRoute)) {
                                  selectedBaggageCount[currentRoute] = {};
                                }

                                final currentCount = selectedBaggageCount[
                                        currentRoute]![innerindex] ??
                                    0;
                                final totalSelected =
                                    getTotalSelectedBaggageForRoute(
                                        currentRoute);
                                final canAdd = totalSelected < totalPassengers;
                                final canRemove = currentCount > 0;

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${allBaggage[selectedBaggage][innerindex].weight} kg',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '₹${allBaggage[selectedBaggage][innerindex].price}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: canRemove
                                                ? () {
                                                    selectedBaggageCount[
                                                                currentRoute]![
                                                            innerindex] =
                                                        currentCount - 1;
                                                    if (selectedBaggageCount[
                                                                currentRoute]![
                                                            innerindex] ==
                                                        0) {
                                                      selectedBaggageCount[
                                                              currentRoute]!
                                                          .remove(innerindex);
                                                    }
                                                    recalculateTotalPrice();
                                                  }
                                                : null,
                                            child: Icon(Icons.remove_circle,
                                                size: 24,
                                                color: canRemove
                                                    ? Color(0xFFF37023)
                                                    : Colors.grey.shade400),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            width: 20,
                                            alignment: Alignment.center,
                                            child: Text('$currentCount',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                          SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: canAdd
                                                ? () {
                                                    selectedBaggageCount[
                                                                currentRoute]![
                                                            innerindex] =
                                                        currentCount + 1;
                                                    recalculateTotalPrice();
                                                  }
                                                : () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Maximum $totalPassengers baggage(s) allowed'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                            Color(0xFFF37023),
                                                      ),
                                                    );
                                                  },
                                            child: Icon(Icons.add_circle,
                                                size: 24,
                                                color: canAdd
                                                    ? Color(0xFFF37023)
                                                    : Colors.grey.shade400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildmeals() {
    List<dynamic> allMeals = [];

    // Outbound meals
    if (ssrData.response?.mealDynamic != null &&
        ssrData.response!.mealDynamic.isNotEmpty) {
      allMeals.addAll(ssrData.response.mealDynamic.expand((x) => x));
    }

    // Inbound meals (only if round-trip exists)
    if (widget.inBoundData['inresultindex'] != null &&
        inssrData.response?.mealDynamic != null &&
        inssrData.response!.mealDynamic.isNotEmpty) {
      allMeals.addAll(inssrData.response.mealDynamic.expand((x) => x));
    }

    if (allMeals.isEmpty) {
      return const SizedBox(); // no meals at all → hide section
    }

    // ────────────────────────────────────────────────
    // 2. Group meals by route string (DEL-IXB, IXB-CCU, etc.)
    // ────────────────────────────────────────────────
    final Map<String, List<dynamic>> groupedMeals = {};

    for (var meal in allMeals) {
      final route = '${meal.origin}-${meal.destination}';
      groupedMeals.putIfAbsent(route, () => []).add(meal);
    }

    final List<String> routes = groupedMeals.keys.toList();

    if (routes.isEmpty) {
      return const SizedBox();
    }

    // Safety: if selected index is out of range → reset
    if (selectedbuild >= routes.length || selectedbuild < 0) {
      selectedbuild = 0;
    }

    // ────────────────────────────────────────────────
    // 3. UI starts here
    // ────────────────────────────────────────────────
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Orange scrollable route selector ─ always scrollable if >1 route
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(12),
            height: 60,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: const Color(0xFFF37023),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Builder(
              builder: (context) {
                // ────────────────────────────────────────────────
                // Case 1: Non-stop (1 segment) → centered
                // ────────────────────────────────────────────────
                if (routes.length == 1) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        routes[0],
                        style: const TextStyle(
                          color: Color(0xFFF37023),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  );
                }

                // ────────────────────────────────────────────────
                // Case 2: Exactly 1 stop (2 segments) → left + right corners
                // ────────────────────────────────────────────────
                if (routes.length == 2) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // ← pushes to corners
                      children: List.generate(2, (index) {
                        final route = routes[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedbuild = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedbuild == index
                                  ? Colors.white
                                  : const Color(0xFFF37023),
                              borderRadius: BorderRadius.circular(20),
                              border: selectedbuild == index
                                  ? Border.all(color: Colors.white, width: 1.5)
                                  : null,
                            ),
                            child: Text(
                              route,
                              style: TextStyle(
                                color: selectedbuild == index
                                    ? const Color(0xFFF37023)
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }

                // ────────────────────────────────────────────────
                // Case 3: 2+ stops (3+ segments) → even spacing + scroll
                // ────────────────────────────────────────────────
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(routes.length, (index) {
                      final route = routes[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedbuild = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: selectedbuild == index
                                ? Colors.white
                                : const Color(0xFFF37023),
                            borderRadius: BorderRadius.circular(20),
                            border: selectedbuild == index
                                ? Border.all(color: Colors.white, width: 1.5)
                                : null,
                          ),
                          child: Text(
                            route,
                            style: TextStyle(
                              color: selectedbuild == index
                                  ? const Color(0xFFF37023)
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Passenger type selector (Adult / Child / Infant)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Adult
              _buildPassengerTypeButton(0, "Adult"),
              // Child
              if (widget.childCount! > 0) _buildPassengerTypeButton(1, "Child"),
              // Infant (shows snackbar)
              if (widget.infantCount! > 0)
                _buildPassengerTypeButton(2, "Infant"),
            ],
          ),

          const SizedBox(height: 12),

          // ────────────────────────────────────────────────
          // Horizontal scroll of passenger cards
          // ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  _getPassengerCountForType(selectedPassengerType),
                  (index) {
                    final passengerType = selectedPassengerType == 0
                        ? "Adult"
                        : selectedPassengerType == 1
                            ? "Child"
                            : "Infant";

                    final passengerKey = "$passengerType ${index + 1}";

                    return Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 4),
                            child: Text(
                              selectedPassengerType == 2
                                  ? "🍴 No meals available for Infant ${index + 1}"
                                  : "🍴 Meals for $passengerType ${index + 1}",
                              style: const TextStyle(
                                color: Color(0xFFF37023),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (selectedPassengerType == 2)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              child: Text(
                                "Infants do not require meal selection.",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            )
                          else
                            Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: groupedMeals[routes[selectedbuild]]!
                                      .map((meal) {
                                    final isNoMeal = meal.code == "NoMeal";
                                    final currentRoute = routes[selectedbuild];

                                    bool isChecked =
                                        selectedMealData[currentRoute]
                                                    ?[passengerKey]
                                                ?.any((m) =>
                                                    m["Code"] == meal.code) ??
                                            false;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 4),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              isNoMeal
                                                  ? "No Meal"
                                                  : (meal.airlineDescription ??
                                                      meal.code ??
                                                      "Meal"),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              isNoMeal
                                                  ? "0"
                                                  : '₹${meal.price ?? 0}',
                                              style: TextStyle(
                                                color: isNoMeal
                                                    ? Colors.orange
                                                    : Colors.black87,
                                                fontWeight: isNoMeal
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Transform.scale(
                                            scale: 0.95,
                                            child: Checkbox(
                                              value:
                                                  isNoMeal ? true : isChecked,
                                              activeColor:
                                                  const Color(0xFFF37023),
                                              onChanged: isNoMeal
                                                  ? null
                                                  : (bool? value) {
                                                      final route =
                                                          currentRoute;
                                                      final paxType =
                                                          selectedPassengerType;

                                                      if (value == true) {
                                                        // Allow only ONE meal → clear previous
                                                        selectedMealData[route]
                                                                ?[passengerKey]
                                                            ?.clear();
                                                        storeSelectedMeal(
                                                          route,
                                                          paxType,
                                                          meal,
                                                          index,
                                                        );
                                                      } else {
                                                        selectedMealData[route]
                                                                ?[passengerKey]
                                                            ?.removeWhere((m) =>
                                                                m["Code"] ==
                                                                meal.code);
                                                        if (selectedMealData[
                                                                        route]?[
                                                                    passengerKey]
                                                                ?.isEmpty ??
                                                            true) {
                                                          selectedMealData[
                                                                  route]?[
                                                              passengerKey] = [];
                                                        }
                                                      }
                                                      recalculateTotalPrice();
                                                      setState(
                                                          () {}); // important!
                                                    },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerTypeButton(int type, String label) {
    final bool isSelected = selectedPassengerType == type;
    final bool isInfant = type == 2;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPassengerType = type;
        });
        if (isInfant) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Meals are not available for infants."),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF37023) : Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  int _getPassengerCountForType(int type) {
    if (type == 0) return widget.adultCount ?? 0;
    if (type == 1) return widget.childCount ?? 0;
    return 0; // infant → no meals
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
        final double realBaggageTotal = calculateBaggageTotal(); // ← here
        final double realMealsTotal = calculateMealsTotal(); // ← add this
        return FareBreakupSheet(
          basefare: totalBaseFare,
          tax: totalTax,
          adultCount: totaladultCount,
          childCount: totalchildCount,
          infantCount: totalinfantCount,
          adultfare: adultFare,
          childfare: childFare,
          infantfare: infantFare,
          total: overallFare,
          adultTax: 0,
          childTax: 0,
          infantTax: 0,
          convenienceFee: 0,
          coupouncode: coupouncode,
          ssrData: true,
          meal: selectedMealData,
          seat: selectedSeatPayload,
          baggage: selectedBaggageCount,
          othercharges: othercharges,
        );
      },
    );
  }

  Widget buildseat() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SeatSelectionScreen(
        traceid: widget.traceid,
        resultindex: widget.resultindex,
        adultCount: widget.adultCount,
        childCount: widget.childCount,
        infantCount: widget.infantCount,
        craftType: craftType,
        // ← pass it
        initialPayload: selectedSeatPayload,
        onPayloadUpdated: (newPayload) {
          setState(() {
            selectedSeatPayload = newPayload;
          });
          recalculateTotalPrice();
        },
        outBoundData: widget.outBoundData,
        inBoundData: widget.inBoundData,
      ),
    );
  }
}
