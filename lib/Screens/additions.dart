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

class Additions extends StatefulWidget {
  final String? traceid;
  final String? resultindex;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;
  final Result? outboundFlight;
  final Result? inboundFlight;
  final String? outresultindex;
  final String? inresultindex;

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
      this.inresultindex,
      this.outboundFlight,
      this.inboundFlight});

  @override
  State<Additions> createState() => _AdditionsState();
}

class _AdditionsState extends State<Additions> {
  int selectedindex = 0;
  int selectedBaggage = 0;
  int selectedbuild = 0;

  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final int seatsPerRow = 4;
  final Set<String> selectedSeats = {};

  late SsrData ssrData;
  late SsrData inssrData;
  late farequote.FareQuotesData fareQuote;
  late FareRuleData fare;
  bool isLoading = true;
  int selectedPassengerType = 0; // 0 - Adult, 1 - Child
  Map<String, Map<String, dynamic>> selectedMealData = {};
  bool isOutbound = true;

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

    setState(() {});
    print("Selected Meals: ${jsonEncode(selectedMealData)}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getssrdata();
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
      fareQuote = await ApiService().farequote(
          widget.inBoundData['inresultindex'] ?? "", widget.traceid ?? "");
      ssrData = await ApiService().ssr(
          widget.outBoundData['outresultindex'] ?? "", widget.traceid ?? "");
      print(ssrData.response.mealDynamic);
      inssrData = await ApiService()
          .ssr(widget.inBoundData['inresultindex'] ?? "", widget.traceid ?? "");
    } else {
      ssrData = await ApiService()
          .ssr(widget.resultindex ?? "", widget.traceid ?? "");
      debugPrint("ssrDATA: ${jsonEncode(ssrData)}", wrapWidth: 4500);
    }

    setState(() {
      isLoading = false;
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
                              "meal": selectedMealData
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
                // Container(
                //   padding: EdgeInsets.all(5),
                //   margin: EdgeInsets.all(12),
                //   height: 60,
                //   decoration: BoxDecoration(
                //       color: Color(0xFFF37023),
                //       borderRadius: BorderRadius.all(Radius.circular(20))),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             selectedBaggage = 0;
                //           });
                //         },
                //         child: Container(
                //           padding: EdgeInsets.symmetric(
                //               horizontal: 35, vertical: 10),
                //           margin: EdgeInsets.all(5),
                //           decoration: BoxDecoration(
                //               color: selectedBaggage == 0
                //                   ? Colors.white
                //                   : Color(0xFFFFF37023),
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(15))),
                //           child: Text(
                //             "MAA-BLR",
                //             style: TextStyle(
                //                 color: selectedBaggage == 0
                //                     ? Colors.black
                //                     : Colors.white,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 15),
                //           ),
                //         ),
                //       ),
                //       // Image.asset(
                //       //   "assets/images/Line.png",
                //       // ),
                //       Container(
                //         height: 50,
                //         width: 0.5,
                //         color: Colors.grey.shade200,
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             selectedBaggage = 1;
                //           });
                //         },
                //         child: Container(
                //           padding: EdgeInsets.symmetric(
                //               horizontal: 35, vertical: 10),
                //           margin: EdgeInsets.all(5),
                //           decoration: BoxDecoration(
                //               color: selectedBaggage == 1
                //                   ? Colors.white
                //                   : Color(0xFFFFF37023),
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(15))),
                //           child: Text(
                //             "BLR-MAA",
                //             style: TextStyle(
                //                 color: selectedBaggage == 1
                //                     ? Colors.black
                //                     : Colors.white,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 15),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                selectedindex == 0
                    ? buildBaggage()
                    : selectedindex == 1
                        ? Expanded(child: buildseat())
                        : (ssrData.response != null &&
                                ssrData.response!.mealDynamic != null &&
                                ssrData.response!.mealDynamic.isNotEmpty &&
                                selectedindex == 2)
                            ? Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isOutbound = true;
                                              });
                                            },
                                            child: Text("Outbound")),
                                        if (widget.inBoundData != null)
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isOutbound = false;
                                                });
                                              },
                                              child: Text("Inbound")),
                                      ],
                                    ),
                                    buildmeals(isOutbound ? ssrData : inssrData)
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
              ],
            ));
  }

  buildBaggage() {
    // if (ssrData.response != null ||
    //     ssrData.response.baggage != null ||
    //     ssrData.response.baggage.isEmpty) {
    //   return const SizedBox(); // 🔹 Don't display meals section
    // }
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: 15,
            ),
            // SizedBox(
            //   height: 50.h,
            //   child: Container(
            //     margin: EdgeInsets.all(10),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Expanded(
            //             child: GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     selectedindex = 0;
            //                   });
            //                 },
            //                 child: Container(
            //                   alignment: Alignment.center,
            //                   height: MediaQuery.sizeOf(context).height,
            //                   width: MediaQuery.sizeOf(context).width,
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(5),
            //                       border: Border.all(color: Colors.grey),
            //                       color: selectedindex == 0
            //                           ? Color(0xFFFFE7DA)
            //                           : Colors.white),
            //                   child: Text(
            //                     "Baggage",
            //                     style: TextStyle(
            //                         color: selectedindex == 0
            //                             ? Colors.orange
            //                             : Colors.black),
            //                   ),
            //                 ))),
            //         Expanded(
            //             child: GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     selectedindex = 1;
            //                   });
            //                 },
            //                 child: Container(
            //                   alignment: Alignment.center,
            //                   height: MediaQuery.sizeOf(context).height,
            //                   width: MediaQuery.sizeOf(context).width,
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(5),
            //                       color: selectedindex == 1
            //                           ? Color(0xFFFFE7DA)
            //                           : Colors.white,
            //                       border: Border.all(color: Colors.grey)),
            //                   child: Text(
            //                     "Seat",
            //                     style: TextStyle(
            //                         color: selectedindex == 1
            //                             ? Colors.orange
            //                             : Colors.black),
            //                   ),
            //                 ))),
            //         Expanded(
            //             child: GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     selectedindex = 2;
            //                   });
            //                 },
            //                 child: Container(
            //                   alignment: Alignment.center,
            //                   height: MediaQuery.sizeOf(context).height,
            //                   width: MediaQuery.sizeOf(context).width,
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(5),
            //                       color: selectedindex == 2
            //                           ? Color(0xFFFFE7DA)
            //                           : Colors.white,
            //                       border: Border.all(color: Colors.grey)),
            //                   child: Text(
            //                     "Meals",
            //                     style: TextStyle(
            //                         color: selectedindex == 2
            //                             ? Colors.orange
            //                             : Colors.black),
            //                   ),
            //                 )))
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   margin: EdgeInsets.all(12),
            //   height: 50,
            //   decoration: BoxDecoration(
            //       color: Color(0xFFF37023),
            //       borderRadius: BorderRadius.all(Radius.circular(15))),
            //   child: Row(
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             selectedBaggage = 0;
            //           });
            //         },
            //         child: Container(
            //           padding: EdgeInsets.symmetric(horizontal: 44),
            //           margin: EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //               color: selectedBaggage == 0
            //                   ? Colors.white
            //                   : Color(0xFFFFF37023),
            //               borderRadius: BorderRadius.all(Radius.circular(8))),
            //           child: Text(
            //             "MAA-BLR",
            //             style: TextStyle(
            //                 color: selectedBaggage == 0
            //                     ? Colors.black
            //                     : Colors.white,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             selectedBaggage = 1;
            //           });
            //         },
            //         child: Container(
            //           padding: EdgeInsets.symmetric(horizontal: 44),
            //           margin: EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //               color: selectedBaggage == 1
            //                   ? Colors.white
            //                   : Color(0xFFFFF37023),
            //               borderRadius: BorderRadius.all(Radius.circular(8))),
            //           child: Text(
            //             "BLR-MAA",
            //             style: TextStyle(
            //                 color: selectedBaggage == 1
            //                     ? Colors.black
            //                     : Colors.white,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: Container(
                // height: 170,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/baggage.svg'),
                        SizedBox(width: 5),
                        Text(
                          "Baggage",
                          style: TextStyle(
                            color: Color(0xFF1C1E1D),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Text("Add additional checkin baggage at low price"),
                    Divider(color: Colors.grey),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kilogram',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 80,
                        ),
                        Text('Price',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 5),
                    ...List.generate(ssrData.response.baggage.length, (index) {
                      return Container(
                        constraints: const BoxConstraints(
                          maxHeight:
                              300, // 👈 optional: scroll only if more items
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          // 👈 scroll only if overflow
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // 👈 adjusts height automatically
                            children: [
                              ...List.generate(
                                ssrData.response.baggage[index].length,
                                (innerindex) {
                                  bool isChecked = false;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${ssrData.response.baggage[index][innerindex].weight} kg',
                                        ),
                                        Text(
                                          ssrData.response
                                              .baggage[index][innerindex].price
                                              .toString(),
                                        ),
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return Transform.scale(
                                              scale: 0.9,
                                              child: Checkbox(
                                                value: isChecked,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isChecked = value!;
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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

  buildmeals(SsrData data) {
    // 🥗 Check if mealDynamic data is available
    if (data.response == null ||
        data.response.mealDynamic == null ||
        data.response.mealDynamic.isEmpty) {
      return const SizedBox(); // 🔹 Don't display meals section
    }

    // 🥗 Group meals by Origin-Destination
    final meals = data.response.mealDynamic.expand((x) => x).toList();

    // ✅ If still empty, skip rendering
    if (meals.isEmpty) {
      return const SizedBox();
    }

    final Map<String, List<dynamic>> groupedMeals = {};
    for (var meal in meals) {
      final route = '${meal.origin}-${meal.destination}';
      groupedMeals.putIfAbsent(route, () => []).add(meal);
    }

    final routes = groupedMeals.keys.toList();

    if (routes.isEmpty) {
      return const SizedBox();
    }

    if (selectedbuild >= routes.length) selectedbuild = 0;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔶 Scrollable route buttons section
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
                final isConnectingFlight = routes.length > 1;
                final route = routes[selectedbuild];

                // For connecting flights → scrollable route buttons
                if (isConnectingFlight) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(routes.length, (index) {
                        final route = routes[index];
                        String passengerType =
                            selectedPassengerType == 0 ? "Adult" : "Child";
                        String passengerKey = "$passengerType ${index + 1}";
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedbuild = index;
                              print("helloselectedbuild$selectedbuild");
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedbuild == index
                                  ? Colors.white
                                  : const Color(0xFFF37023),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Text(
                              route,
                              style: TextStyle(
                                color: selectedbuild == index
                                    ? Colors.black
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

                // For non-stop flight → show single centered text
                return Center(
                  child: Text(
                    route,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 🔘 Passenger type toggle buttons (ADDED)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ADULT
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPassengerType = 0;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: selectedPassengerType == 0
                        ? const Color(0xFFF37023)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Adult",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // CHILD
              if (widget.childCount! > 0)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPassengerType = 1;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: selectedPassengerType == 1
                          ? const Color(0xFFF37023)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Child",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // INFANT  ✅ ADD THIS BLOCK
              if (widget.infantCount! > 0)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPassengerType = 2;
                    });

                    // SHOW MESSAGE WHEN INFANT CLICKED
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Meals are not available for infants."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: selectedPassengerType == 2
                          ? const Color(0xFFF37023)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Infant",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔽 Scrollable meals list
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    selectedPassengerType == 0
                        ? widget.adultCount!
                        : selectedPassengerType == 1
                            ? widget.childCount!
                            : 0, // INFANT → 0 meals

                    (index) {
                  String passengerType =
                      selectedPassengerType == 0 ? "Adult" : "Child";
                  String passengerKey = "$passengerType ${index + 1}";

                  return Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🟧 Meals title inside each box
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 4),
                          child: Text(
                            selectedPassengerType == 0
                                ? "🍴 Selected meals for Adult ${index + 1}"
                                : "🍴 Selected meals for Child ${index + 1}",
                            style: const TextStyle(
                              color: Color(0xFFF37023),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        // 🔹 Dynamic scrollable meal list inside each box
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: selectedPassengerType == 2
                                  ? [
                                      /* infant message */
                                    ]
                                  : groupedMeals[routes[selectedbuild]]!
                                      .map((meal) {
                                      final isMandatory = meal.code == "NoMeal";
                                      final currentRoute =
                                          routes[selectedbuild];
                                      final passengerType =
                                          selectedPassengerType == 0
                                              ? "Adult"
                                              : "Child";
                                      final passengerKey =
                                          "$passengerType ${index + 1}";

                                      bool isChecked =
                                          selectedMealData[currentRoute]
                                                      ?[passengerKey]
                                                  ?.any((m) =>
                                                      m["Code"] == meal.code) ??
                                              false;

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                meal.description.isEmpty
                                                    ? "No Meal"
                                                    : meal.airlineDescription,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                isMandatory
                                                    ? "0.0"
                                                    : '₹${meal.price}',
                                                style: TextStyle(
                                                  color: isMandatory
                                                      ? Colors.orange
                                                      : Colors.black,
                                                  fontWeight: isMandatory
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Transform.scale(
                                              scale: 0.9,
                                              child: Checkbox(
                                                value: isMandatory
                                                    ? true
                                                    : isChecked,
                                                onChanged: isMandatory
                                                    ? null
                                                    : (value) {
                                                        final route =
                                                            '${meal.origin}-${meal.destination}';
                                                        final paxType =
                                                            selectedPassengerType;

                                                        if (value!) {
                                                          // 🔥 Allow only ONE meal per passenger
                                                          selectedMealData[
                                                                      route]?[
                                                                  passengerKey]
                                                              ?.clear();

                                                          storeSelectedMeal(
                                                              route,
                                                              paxType,
                                                              meal,
                                                              index);
                                                        } else {
                                                          selectedMealData[
                                                                      route]?[
                                                                  passengerKey]
                                                              ?.removeWhere((m) =>
                                                                  m["Code"] ==
                                                                  meal.code);
                                                          if (selectedMealData[
                                                                          route]
                                                                      ?[
                                                                      passengerKey]
                                                                  ?.isEmpty ==
                                                              true) {
                                                            selectedMealData[
                                                                    route]?[
                                                                passengerKey] = [];
                                                          }
                                                        }
                                                        setState(() {});
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
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildseat() {
    return SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: SeatSelectionScreen(
            traceid: widget.traceid,
            resultindex: widget.resultindex,
            adultCount: widget.adultCount,
            childCount: widget.childCount,
            infantCount: widget.infantCount));
  }
}
