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
  final List<Map<String, dynamic>> seatPayload;
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
      required this.seatPayload,
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
  List<Map<String, dynamic>> selectedSeatPayload = [];
  bool isOutbound = true;

  // Add this at the top of your _AdditionsState class
  Map<String, Map<int, int>> selectedBaggageCount =
      {}; // {route: {baggageIndex: count}}

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

          // Add each baggage item 'count' times
          for (int i = 0; i < count; i++) {
            formattedBaggage[route]!.add({
              "AirlineCode": baggageItem.airlineCode ?? "SG",
              "FlightNumber": baggageItem.flightNumber ?? "",
              "WayType": baggageItem.wayType ?? 2,
              "Code": baggageItem.code ?? "Baggage",
              "Description": baggageItem.weight ?? 0,
              "Weight": baggageItem.weight ?? 0,
              "Currency": baggageItem.currency ?? "INR",
              "Price": baggageItem.price ?? 0,
              "Origin": baggageItem.origin ?? "",
              "Destination": baggageItem.destination ?? "",
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

    setState(() {});
    print("Selected Meals: ${jsonEncode(selectedMealData)}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getssrdata();
    print("seatdf${widget.seatPayload}");
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
                              "meal": selectedMealData,
                              "seat": selectedSeatPayload,
                              "baggage": getFormattedBaggageData()
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
    // Calculate total passenger count
    final int totalPassengers = (widget.adultCount ?? 0) +
        (widget.childCount ?? 0) +
        (widget.infantCount ?? 0);

    // Get current route
    String currentRoute = '';
    if (ssrData.response != null &&
        ssrData.response.baggage != null &&
        ssrData.response.baggage.isNotEmpty &&
        ssrData.response.baggage[selectedBaggage].isNotEmpty) {
      currentRoute =
          '${ssrData.response.baggage[selectedBaggage][0].origin}-${ssrData.response.baggage[selectedBaggage][0].destination}';
    }

    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: 15,
            ),

            // 🔶 Small Origin → Destination pill OUTSIDE (MakeMyTrip style)
            // 🔶 Route pills - show all available routes (scrollable)
            if (ssrData.response != null &&
                ssrData.response.baggage != null &&
                ssrData.response.baggage.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      ssrData.response.baggage.length,
                      (index) {
                        if (ssrData.response.baggage[index].isEmpty) {
                          return SizedBox.shrink();
                        }

                        final route = ssrData.response.baggage[index][0];
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
                      },
                    ),
                  ),
                ),
              ),

            // 🔶 Baggage Card (below the route pill)
            Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                    SizedBox(height: 5),

                    // 🔶 Passenger count info
                    Text(
                      "You can select up to $totalPassengers baggage(s)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFF37023),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Divider(color: Colors.grey),
                    Row(
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

                    // Display baggage for SELECTED route only
                    if (ssrData.response.baggage.length > selectedBaggage)
                      Container(
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              ssrData.response.baggage[selectedBaggage].length,
                              (innerindex) {
                                // Initialize route map if not exists
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
                                          '${ssrData.response.baggage[selectedBaggage][innerindex].weight} kg',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '₹${ssrData.response.baggage[selectedBaggage][innerindex].price}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),

                                      // Counter buttons (icons only, no boxes)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Minus icon
                                          GestureDetector(
                                            onTap: canRemove
                                                ? () {
                                                    setState(() {
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
                                                    });
                                                  }
                                                : null,
                                            child: Icon(
                                              Icons.remove_circle,
                                              size: 24,
                                              color: canRemove
                                                  ? Color(0xFFF37023)
                                                  : Colors.grey.shade400,
                                            ),
                                          ),

                                          SizedBox(width: 8),

                                          // Count display
                                          Container(
                                            width: 20,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '$currentCount',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 8),

                                          // Plus icon
                                          GestureDetector(
                                            onTap: canAdd
                                                ? () {
                                                    setState(() {
                                                      selectedBaggageCount[
                                                                  currentRoute]![
                                                              innerindex] =
                                                          currentCount + 1;
                                                    });
                                                  }
                                                : () {
                                                    // Show message when limit reached
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Maximum $totalPassengers baggage(s) allowed',
                                                        ),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                            Color(0xFFF37023),
                                                      ),
                                                    );
                                                  },
                                            child: Icon(
                                              Icons.add_circle,
                                              size: 24,
                                              color: canAdd
                                                  ? Color(0xFFF37023)
                                                  : Colors.grey.shade400,
                                            ),
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
            infantCount: widget.infantCount,
            onPayloadUpdated: (payload) {
              setState(() {
                selectedSeatPayload = payload;
              });
            }));
  }
}
