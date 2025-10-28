import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/Screens/ProfilePage.dart';

import '../utils/api_service.dart';
import 'NotificationScreen.dart';
import 'Search_Result_Page.dart';
import 'flightname.dart';
import 'localroundtrip.dart';

String selectedDepDate = "";
String selectedRetDate = "";
DateTime? departureDate;
DateTime? returnDate;
DateTime? _selectedDates;
int adults = 1;
int children = 0;
int infants = 0;

String _selectedDepDate = '';
String _dateCount = '';
String _range = '';
String _rangeCount = '';

List<DateTime?> _selectedDepDates = [];

DateTime? selectedDepatureDate;
DateTime? selectedReturnDate;

String? authenticateToken;

class SearchFlightPage extends StatefulWidget {
  @override
  _SearchFlightPageState createState() => _SearchFlightPageState();
}

class _SearchFlightPageState extends State<SearchFlightPage> {
  String selectedTripType = "One way";
  String specialFare = "";

  String travelClass = "Economy";
  int selectedIndex = -1;
  int departureIndex = -1;

  // State variables for From and To fields
  String fromAirport = "Delhi";
  String airportCode = "DEL";
  String fromCode = "DEL, Delhi Airport India";
  String toAirport = "Bengaluru";
  String toairportCode = "BLR";

  // Function to swap From and To fields
  void _swapFields() {
    setState(() {
      final tempAirport = fromAirport;
      final tempCode = airportCode;

      fromAirport = toAirport;
      airportCode = toairportCode;

      toAirport = tempAirport;
      toairportCode = tempCode;
    });
  }

  // Future<void> auth() async {
  //   final api = ApiService();
  //   print("Authenticateapicalling");
  //   final token = await api.authenticate(); // returns token
  //   setState(() {
  //     authenticateToken = token;
  //     print("authenticateToken$authenticateToken");
  //   });
  // }

  Map<DateTime, double> fareMap = {};

  Future<void> date() async {
    final api = ApiService();
    print("Authenticateapicalling");

    final response = await api.getCalendarFare(
      airportCode,
      toairportCode,
    );

    print("token$response");

    final searchResults = response['Response']['SearchResults'] as List;

    // convert to map
    fareMap.clear();
    for (var result in searchResults) {
      final date = DateTime.parse(result['DepartureDate']);
      print("date$date");
      final key = DateTime(date.year, date.month, date.day); // remove time
      fareMap[key] = result['Fare'].toDouble(); // use normalized key
      // print('Mapped fare $key -> ${result['Fare']}');
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // date();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Format only the date part

    print(selectedDepDate);

    selectedDepatureDate = DateTime(now.year, now.month, now.day);
    print("dad$selectedDepatureDate");

    returnDate = DateTime.now().add(const Duration(days: 1));
    print('selectedReturnDate$selectedReturnDate');
    setPaxValue();
    // _selectedDepDate = today.toString();
  }

  setPaxValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("adults");
    await prefs.remove('children');
    await prefs.remove('infants');
    prefs.setInt('adults', 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String leftDescription = "${adults + children + infants} travelers";

    return Scaffold(
      bottomNavigationBar: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
          child: ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final storedadult = prefs.getInt("adults");
              print("storedadult$storedadult");
              // format departure date once
              String formattedDate = DateFormat(
                "yyyy-MM-dd",
              ).format(selectedDepatureDate!);

              String? formattedReturnDate;
              if (selectedReturnDate != null) {
                formattedReturnDate = DateFormat(
                  "yyyy-MM-dd",
                ).format(selectedReturnDate!);
              }

              if (selectedTripType == "One way") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightResultsPage(
                      airportCode: airportCode,
                      fromAirport: fromAirport,
                      toairportCode: toairportCode,
                      toAirport: toAirport,
                      selectedDepDate: formattedDate,
                      selectedReturnDate: formattedDate,
                      selectedTripType: selectedTripType,
                      adultCount: adults,
                      childCount: children,
                      infantCount: infants,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Localroundtrip(
                      airportCode: airportCode,
                      fromAirport: fromAirport,
                      toairportCode: toairportCode,
                      toAirport: toAirport,
                      selectedDepDate: formattedDate,
                      selectedReturnDate: formattedReturnDate ?? "",
                      selectedTripType: selectedTripType,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF37023),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 0.02.sh),
            ),
            child: Center(
              child: Text(
                "Search Flights",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        titleSpacing: 0,
        leadingWidth: 80.w,
        leading: GestureDetector(
          onTap: () {
            Get.to(ProfilePage());
          },
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: CircleAvatar(
                  radius: 20.r,
                  child: Icon(Icons.person, color: Colors.grey),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              // Menu Icon on Avatar
              Positioned(
                left: 44.w,
                top: 20.h,
                child: Container(
                  height: 15.h,
                  width: 15.w,
                  child: Image.asset(
                    "assets/images/Menu_1.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 8.h),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/images/Trvlus_Logo.png',
                  height: 28.h,
                ),
              ),
            ),
          ),
        ),
        actions: [
          // Price Tag
          // GestureDetector(
          //   onTap: () {
          //     Get.to(
          //       const Wallet(),
          //       duration: const Duration(milliseconds: 600),
          //     );
          //   },
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       Image.asset("assets/images/Group_1.png"),
          //       Padding(
          //         padding: EdgeInsets.only(right: 40.w, bottom: 15.h),
          //         child: Container(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: 6.w,
          //             vertical: 2.h,
          //           ),
          //           decoration: BoxDecoration(
          //             color: const Color(0xFFF37003),
          //             borderRadius: BorderRadius.circular(12.r),
          //           ),
          //           child: Text(
          //             '₹0',
          //             style: TextStyle(color: Colors.white, fontSize: 9.sp),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Notification Icon
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                Get.to(NotificationScreen());
                // Get.to(const Network());
              },
              child: Image.asset("assets/images/Bell_1.png"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TripTypeButton(
                      label: "One way",
                      isSelected: selectedTripType == "One way",
                      onTap: () {
                        setState(() {
                          selectedTripType = "One way";
                          selectedReturnDate = null;
                          _selectedDepDates = selectedDepatureDate != null
                              ? [selectedDepatureDate!]
                              : [];
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 0.02.sw),
                  // Expanded(
                  //     child: TripTypeButton(
                  //       label: "Round trip",
                  //       isSelected: selectedTripType == "Round trip",
                  //       onTap: () {
                  //         setState(() {
                  //           selectedTripType = "Round trip";
                  //           if (selectedDepatureDate != null) {
                  //             returnDate = selectedDepatureDate!.add(
                  //               const Duration(days: 1),
                  //             );
                  //           }
                  //         });
                  //       },
                  //     ),
                  //     ),
                  SizedBox(width: 0.02.sw),
                ],
              ),
              SizedBox(height: 0.02.sh),
              Stack(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Flightname(from: "From"),
                            ),
                          );
                          var finalValue = jsonDecode(value);
                          setState(() {
                            print("airportCode$airportCode");
                            print("fromAirport$fromAirport");
                            airportCode = finalValue['airport_code'];
                            fromAirport = finalValue['airport_city'];
                          });
                        },
                        child: FlightField(
                          label: "FROM",
                          airport: fromAirport,
                          code: airportCode,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Flightname(from: "To"),
                            ),
                          );
                          var finalValue = jsonDecode(value);

                          setState(() {
                            toairportCode = finalValue['airport_code'];

                            toAirport = finalValue['airport_city'];
                          });
                        },
                        child: FlightField(
                          label: "TO",
                          airport: toAirport,
                          code: toairportCode,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 15.w,
                    top: 65.h,
                    child: GestureDetector(
                      onTap: _swapFields, // Call swap function on tap
                      child: Container(
                        height: 50.h, // Size of the circular button
                        width: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // Background color for the circle
                          shape: BoxShape.circle,
                          // Circular shape
                          border: Border.all(
                            color: const Color(0xFFF7F7F7),
                            width: 5.w,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/swap.png",
                            height: 30.h, // Adjust image size
                            width: 30.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: DatePickerField(
                      label: "Departure on",
                      selectedDate: selectedDepatureDate,
                      onDateChanged: (date) {
                        setState(() {
                          _selectedDates = date;
                          print("departureDate$_selectedDates");
                          print("returnDate$returnDate");
                          // Automatically update return date
                        });
                      },

                      firstDate: DateTime.now(),
                      selectedTripType: 'One Way',
                      // Start from today
                      fareMap: fareMap, // ✅ pass the preprocessed map
                    ),
                  ),
                  // Text("Return on$returnDate"),
                  SizedBox(width: 0.02.sw),
                  // Expanded(
                  //   child: selectedTripType == "Round trip"
                  //       ? DatePickerField(
                  //           label: "Return on",
                  //           selectedDate: returnDate,
                  //           // selectedDepatureDate
                  //           //     ?.add(const Duration(days: 1)),
                  //           onDateChanged: (date) {
                  //             setState(() {
                  //               returnDate = date;
                  //               // returnDate = date;
                  //               print("returnDateDate$returnDate");
                  //             });
                  //           },
                  //           firstDate: selectedDepatureDate != null
                  //               ? selectedDepatureDate!.add(
                  //                   const Duration(days: 1),
                  //                 )
                  //               : DateTime.now().add(const Duration(days: 1)),
                  //           selectedTripType: selectedTripType,
                  //         )
                  //       : GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedTripType = "Round trip";
                  //               print("selectedTripTypeR$selectedTripType");
                  //               print(
                  //                   "selete departure date $selectedDepatureDate");
                  //
                  //               if (selectedDepatureDate != null) {
                  //                 returnDate = selectedDepatureDate!.add(
                  //                   const Duration(days: 1),
                  //                 );
                  //                 print("returnDatehelo$returnDate");
                  //               }
                  //             });
                  //           },
                  //           child: Container(
                  //             margin: const EdgeInsets.only(top: 8),
                  //             height: 63,
                  //             width: 156,
                  //             child: DottedBorder(
                  //               color: Colors.orange,
                  //               strokeWidth: 1.5,
                  //               dashPattern: [4, 4],
                  //               borderType: BorderType.RRect,
                  //               radius: const Radius.circular(8),
                  //               child: const Align(
                  //                 alignment: Alignment.center,
                  //                 child: Text(
                  //                   "+ Add Round Trip",
                  //                   style: TextStyle(
                  //                     color: Colors.orange,
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  // ),
                ],
              ),
              SizedBox(height: 16.h),
              CombinedSelectionField(),
              SizedBox(height: 0.02.sh),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey[300]!, width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Special fare (optional)",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: const Color(0xFF7F8387),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10.w,
                        children: [
                          SpecialFareButton(
                            label: "Student",
                            isSelected: specialFare == "Student",
                            onTap: () {
                              setState(() {
                                if (specialFare == "Student") {
                                  specialFare = "";
                                } else {
                                  specialFare = "Student";
                                }
                              });
                            },
                          ),
                          SpecialFareButton(
                            label: "Senior citizen",
                            isSelected: specialFare == "Senior citizen",
                            onTap: () {
                              setState(() {
                                if (specialFare == "Senior citizen") {
                                  specialFare = "";
                                } else {
                                  specialFare = "Senior citizen";
                                }
                              });
                            },
                          ),
                          SpecialFareButton(
                            label: "Defence",
                            isSelected: specialFare == "Defence",
                            onTap: () {
                              setState(() {
                                if (specialFare == "Defence") {
                                  specialFare = "";
                                } else {
                                  specialFare = "Defence";
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Trip type button widget
class TripTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  TripTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE7DA) : Colors.white,
          borderRadius: BorderRadius.circular(5.r),
          border: isSelected
              ? Border.all(color: Colors.orange, width: 1)
              : Border.all(color: const Color(0xFFE6E6E6), width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFFF37023)
                  : const Color(0xFF1C1E1D),
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// FlightField widget
class FlightField extends StatelessWidget {
  final String label;
  final String airport;
  final String code;

  FlightField({required this.label, required this.airport, required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF7F8387),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    airport,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1C1E1D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    code,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      color: const Color(0xFF7F8387),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DatePickerField extends StatefulWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateChanged;
  final DateTime firstDate;
  final String selectedTripType;
  final Map<DateTime, double>? fareMap; // 👈 add this

  const DatePickerField({
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
    required this.firstDate,
    required this.selectedTripType,
    this.fareMap,
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? departureDate;

  DateTime? returnDateround;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () async {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                DateTime? tempSelectedDate = widget.firstDate;
                print("tempSelectedDate$tempSelectedDate");
                DateTime? tempReturnDate = returnDate;
                print("tempReturnDate$tempReturnDate");
                print("hello${widget.onDateChanged}");
                return StatefulBuilder(
                  builder: (context, localSetState) {
                    print("Trip type is: ${widget.selectedTripType}");
                    return Container(
                      height: 550,
                      child: Scaffold(
                        floatingActionButton: Container(
                          color: const Color(0xFFF5F5F5),
                          margin: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          width: 300,
                          height: 40.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF37023),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            onPressed: () {
                              if (selectedDepatureDate != null) {
                                widget.onDateChanged(selectedDepatureDate!);
                                print("departureDate${widget.onDateChanged}");
                              }
                              if (selectedReturnDate != null) {
                                widget.onDateChanged(selectedReturnDate!);
                                print("departureDate${widget.onDateChanged}");
                              }
                              Navigator.pop(context);
                            },
                            child: const Text("Done"),
                          ),
                        ),
                        body: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 9.w),
                                        child: Text(
                                          widget.label == "Departure on"
                                              ? "Select Departure Date"
                                              : "Select Return Date",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter',
                                            fontSize: 20.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  color: Colors.white,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          localSetState(() {});
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 20.0.w,
                                          ),
                                          child: Container(
                                            width: 160.w,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 5.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  widget.label == "Departure on"
                                                      ? const Color(0xFFFFE7DA)
                                                      : Colors.white,
                                              border: Border.all(
                                                color: widget.label ==
                                                        "Departure on"
                                                    ? const Color(0xFFE6E6E6)
                                                    : Colors.grey.shade300,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/takeoff2.png",
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    Text(
                                                      "Departure",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium
                                                          ?.copyWith(
                                                            color: const Color(
                                                              0xFFF37023,
                                                            ),
                                                            fontSize: 15.sp,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4.h),
                                                RichText(
                                                  text: TextSpan(
                                                    text: selectedDepatureDate ==
                                                            null
                                                        ? "Select date"
                                                        : selectedDepatureDate
                                                            .toString()
                                                            .substring(0, 11),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                          fontSize: 12.sp,
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          localSetState(() {});
                                        },
                                        child: Container(
                                          width: 160.w,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: widget.label == "Return on"
                                                ? const Color(0xFFFFE7DA)
                                                : Colors.white,
                                            border: Border.all(
                                              color: widget.label == "Return on"
                                                  ? const Color(0xFFE6E6E6)
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/takeoff1.png",
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  Text(
                                                    "Return",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                          color: const Color(
                                                            0xFFF37023,
                                                          ),
                                                          fontSize: 15.sp,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4.h),
                                              RichText(
                                                text: TextSpan(
                                                  text:
                                                      selectedReturnDate == null
                                                          ? "Select date"
                                                          : selectedReturnDate
                                                              .toString()
                                                              .substring(0, 11),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall
                                                      ?.copyWith(
                                                        fontSize: 12.sp,
                                                        color: Colors.black,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  height: MediaQuery.sizeOf(context).height * 1,
                                  child: CalendarDatePicker2(
                                    config: CalendarDatePicker2Config(
                                      // todayHighlightColor: Colors.transparent,
                                      firstDate: widget.firstDate,
                                      lastDate: DateTime(2100),
                                      calendarType:
                                          widget.selectedTripType == 'One Way'
                                              ? CalendarDatePicker2Type.single
                                              : CalendarDatePicker2Type.range,
                                      calendarViewMode:
                                          CalendarDatePicker2Mode.scroll,
                                      hideScrollViewMonthWeekHeader: true,
                                      selectedDayHighlightColor: Colors.orange,
                                      weekdayLabelTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      controlsTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      dayTextStyle: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                      disabledDayTextStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      dayBuilder: ({
                                        required DateTime date,
                                        BoxDecoration? decoration,
                                        bool? isDisabled,
                                        bool? isSelected,
                                        bool? isToday,
                                        TextStyle? textStyle,
                                      }) {
                                        final now = DateTime.now();
                                        final isPastOrToday = date.isBefore(
                                            DateTime(now.year, now.month,
                                                now.day + 1));
                                        final dateOnly = DateTime(
                                            date.year, date.month, date.day);
                                        final fare = widget.fareMap?[dateOnly];
                                        // ✅ Check if this date is departure or return
                                        bool isDeparture = _selectedDepDates
                                                .isNotEmpty &&
                                            dateOnly == _selectedDepDates.first;

                                        bool isReturn =
                                            _selectedDepDates.length > 1 &&
                                                dateOnly ==
                                                    _selectedDepDates.last;
                                        double circleSize =
                                            38; // adjust as needed

                                        return Container(
                                          width: circleSize,
                                          height: circleSize,
                                          decoration: (isDeparture || isReturn)
                                              ? BoxDecoration(
                                                  color: isDeparture
                                                      ? Colors.orange
                                                      : Colors.orange,
                                                  // different color for return
                                                  shape: BoxShape.circle,
                                                )
                                              : decoration,
                                          // no decoration for today
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${date.day}",
                                                style: (textStyle ??
                                                        const TextStyle())
                                                    .copyWith(
                                                  // color: (isDisabled ?? false)
                                                  //     ? Colors.grey
                                                  //         .withOpacity(0.5)
                                                  //     : Colors.white,
                                                  fontWeight:
                                                      (isDeparture || isReturn)
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                              ),
                                              if (!isDisabled! &&
                                                  fare != null) ...[
                                                SizedBox(height: 2),
                                                Text(
                                                  '₹${fare.toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        );
                                      },
                                    ),

                                    // ✅ Value handling based on trip type
                                    value: widget.selectedTripType == 'One Way'
                                        ? (selectedDepatureDate != null
                                            ? [selectedDepatureDate!]
                                            : [])
                                        : _selectedDepDates,

                                    onValueChanged: (List<DateTime> dates) {
                                      localSetState(() {
                                        if (widget.selectedTripType ==
                                            'One Way') {
                                          if (dates.isNotEmpty) {
                                            selectedDepatureDate = dates.first;
                                            print(
                                              "One Way -> Departure: $selectedDepatureDate",
                                            );
                                          }
                                          selectedReturnDate = null;
                                        } else {
                                          _selectedDepDates = dates;
                                          if (dates.isNotEmpty) {
                                            selectedDepatureDate = dates.first;
                                            print(
                                              "Round Trip -> Departure: $selectedDepatureDate",
                                            );
                                          }
                                          if (dates.length > 1) {
                                            selectedReturnDate = dates.last;
                                            print(
                                              "Round Trip -> Return: $selectedReturnDate",
                                            );
                                          }
                                        }
                                      });

                                      // Debug logs
                                      if (dates.isNotEmpty) {
                                        print(
                                          "Selected Departure Date: ${DateFormat("yyyy-MM-dd").format(dates.first)}",
                                        );
                                      }
                                      if (dates.length > 1) {
                                        print(
                                          "Selected Return Date: ${DateFormat("yyyy-MM-dd").format(dates.last)}",
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 10.h),
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
          child: Container(
            padding: EdgeInsets.all(14.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    color: const Color(0xFF7F8387),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      widget.selectedDate != null
                          ? widget.selectedDate.toString().substring(0, 10)
                          : "Select date",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1C1E1D),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SvgPicture.asset("assets/icon/Calender.svg"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// SpecialFareButton widget
class SpecialFareButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecialFareButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE7DA) : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected ? Colors.orange : const Color(0xFFE6E6E6),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFFF37023)
                  : const Color(0xFF1C1E1D),
            ),
          ),
        ),
      ),
    );
  }
}

class CombinedSelectionField extends StatefulWidget {
  @override
  _CombinedSelectionFieldState createState() => _CombinedSelectionFieldState();
}

class _CombinedSelectionFieldState extends State<CombinedSelectionField> {
  String travelClass = "Economy";

  @override
  Widget build(BuildContext context) {
    String leftDescription = "${adults + children + infants} Travelers";

    return GestureDetector(
      onTap: () => _showTravelerAndClassDialog(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Traveler & class",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF7F8387),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Right Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftDescription,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: const Color(0xFF1C1E1D),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      travelClass, // Dynamically update travel class
                      style: TextStyle(
                        fontFamily: 'BricolageGrotesque',
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: const Color(0xFF1C1E1D),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Image.asset('assets/images/star1.png'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTravelerAndClassDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Removes the rounded corners
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext modalContext, StateSetter modalSetState) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SizedBox(
                height: 450.h,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select Traveler & Class",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      const Divider(),
                      SizedBox(height: 5.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          spacing: 5.w,
                          runSpacing: 5.h,
                          children: [
                            "Economy",
                            "Premium Economy",
                            "Business",
                            "First Class",
                          ].map((classType) {
                            return ChoiceChip(
                              label: Text(
                                classType,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: travelClass == classType
                                      ? Colors.orange
                                      : Colors.black,
                                ),
                              ),
                              selected: travelClass == classType,
                              selectedColor: const Color(0xFFFFE7DA),
                              backgroundColor: travelClass == classType
                                  ? const Color(0xFFFFE7DA)
                                  : Colors.white,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: travelClass == classType
                                      ? Colors.orange
                                      : const Color(0xFFE6E6E6),
                                  width: 1.5
                                      .w, // Border width scaled with ScreenUtil
                                ),
                              ),
                              onSelected: (bool selected) {
                                if (selected) {
                                  modalSetState(() {
                                    travelClass =
                                        classType; // Update local state
                                  });
                                  setState(() {
                                    travelClass = classType;
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      const Divider(),
                      SizedBox(height: 5.h),

                      _buildCounterRow(
                        "Adults",
                        "12 years and above",
                        adults,
                        (value) async {
                          final totalCount = value + children + infants;
                          if (totalCount <= 9) {
                            modalSetState(() => adults = value);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('adults', adults);
                            setState(() => adults = value);
                          } else {
                            ScaffoldMessenger.of(modalContext).showSnackBar(
                              SnackBar(
                                content: Text('Maximum 9 passengers allowed'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                      ),
                      _buildCounterRow(
                        "Children",
                        "Between 2 and 12 years",
                        children,
                        (value) async {
                          final totalCount = adults + value + infants;

                          if (totalCount <= 9) {
                            modalSetState(() => children = value);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('children', children);
                            print("childrenchildren$children");
                            setState(
                                () => children = value); // Update parent state
                          } else {
                            ScaffoldMessenger.of(modalContext).showSnackBar(
                              SnackBar(
                                content: Text('Maximum 9 passengers allowed'),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(16),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),

                      _buildCounterRow(
                        "Infants",
                        "Below 2 years",
                        infants,
                        (value) async {
                          final totalCount = adults + children + value;

                          if (totalCount <= 9) {
                            modalSetState(() => infants = value);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('infants', infants);
                            print("infantsinfants$infants");
                            setState(
                                () => infants = value); // Update parent state
                          } else {
                            // ✅ Show SnackBar INSIDE the modal bottom sheet
                            ScaffoldMessenger.of(modalContext).showSnackBar(
                              SnackBar(
                                content: Text('Maximum 9 passengers allowed'),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(16),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),

                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(right: 10.w, left: 10.w),
                        child: ElevatedButton(
                          onPressed: () {
                            final totalCount = adults + children + infants;
                            if (totalCount > 9) {
                              ScaffoldMessenger.of(modalContext).showSnackBar(
                                SnackBar(
                                  content: Text('Maximum 9 passengers allowed'),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(16),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF37023),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Center(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterRow(
    String label,
    String subtitle,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: const Color(0xFFE6E6E6)),
                borderRadius: BorderRadius.circular(5.r),
                //borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (value > 0) onChanged(value - 1);
                      print("value$value");
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Icon(
                        Icons.remove,
                        color: const Color(0xFF909090), // Icon color
                        size: 15.h, // Icon size
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 13.w,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      //borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "$value",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onChanged(value + 1),
                    child: Container(
                      padding: EdgeInsets.only(left: 5.w),
                      // Padding for the icon
                      child: Icon(
                        Icons.add,
                        color: const Color(0xFF909090), // Icon color
                        size: 15.h, // Icon size
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
