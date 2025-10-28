import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_service.dart';
import 'BookingHistory.dart';

class Afterpayment extends StatefulWidget {
  final String? flightNumber;
  final String airlineName;
  final String? depDate;
  final String? depTime;
  final String? arrDate;
  final String? arrTime;
  final String? duration;
  final String? airportName;
  final String? desairportName;
  final String? airlineCode;
  final String cityCode;
  final String? descityCode;
  final String cityName;
  final String? descityName;
  final List<Map<String, dynamic>>? passenger;
  final Map<String, dynamic>? childpassenger;
  final Map<String, dynamic>? infantpassenger;

  const Afterpayment(
      {Key? key,
      this.flightNumber,
      required this.airlineName,
      this.depDate,
      this.depTime,
      this.arrDate,
      this.arrTime,
      this.duration,
      this.airportName,
      this.desairportName,
      this.airlineCode,
      required this.cityCode,
      this.descityCode,
      required this.cityName,
      this.descityName,
      this.passenger,
      this.childpassenger,
      this.infantpassenger})
      : super(key: key);

  @override
  State<Afterpayment> createState() => _AfterpaymentState();
}

class _AfterpaymentState extends State<Afterpayment> {
  bool isLoading = true;
  Map<String, dynamic>? searchData; // instead of String?

  getSearchData() async {
    final prefs = await SharedPreferences.getInstance();
    final resultIndex = prefs.getString("ResultIndex");
    final traceid = prefs.getString("TraceId");
    final flightNumber = widget.flightNumber ?? "";
    final airlineName = widget.airlineName;
    final depTime = widget.depTime;
    final depDate = DateFormat("dd MMM yy").format(
      DateTime.parse(widget.depDate.toString()),
    );
    print(depDate);
    final airportName = widget.airportName;
    final arrTime = widget.arrTime;
    final arrDate = DateFormat("dd MMM yy").format(
      DateTime.parse(widget.arrDate.toString()),
    );
    print(arrDate);
    final desairportName = widget.desairportName;
    final duration = widget.duration;
    final airlineCode = widget.airlineCode;
    final cityCode = widget.cityCode;
    final descityCode = widget.descityCode;
    print(airportName);
    print(desairportName);
    final cityName = widget.cityName;
    final descityName = widget.descityName;
    final passenger = widget.passenger;
    print("passengerADULT$passenger");
    final childpassenger = widget.childpassenger;
    final infantpassenger = widget.infantpassenger;

    setState(() {
      isLoading = true;
      print("beforeOutput");
    });
    searchData = await ApiService().ticket(
      resultIndex!,
      traceid!,
      flightNumber,
      airlineName,
      depTime,
      depDate,
      airportName,
      arrTime,
      arrDate,
      desairportName,
      duration,
      airlineCode,
      cityCode,
      descityCode,
      cityName,
      descityName,
      widget.passenger ?? [],
      childpassenger as Map<String, dynamic>? ?? {},
      // infantpassenger as Map<String, dynamic>? ?? {},
    );
    // print(widget.passenger?['Firstname']);

    setState(() {
      isLoading = false;
      print("AferOutput");
    });
  }

  @override
  void initState() {
    getSearchData();
    print('passengerdetailsall${widget.passenger}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
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
                    "Checking Payment Status...",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingHistoryPage()));
              },
              child: Container(
                height: 50,
                width: MediaQuery.sizeOf(context).width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFF37023)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Go To My Booking",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            // appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.construction,
                        size: 50,
                      ),
                      // Image.asset(
                      //   "assets/icon/left.png",
                      //   height: 200,
                      //   width: 60,
                      // ),
                      // Image.asset(
                      //   "assets/icon/successpayment.png",
                      //   height: 200,
                      //   width: 80,
                      // ),
                      // Image.asset(
                      //   "assets/icon/right.png",
                      //   height: 200,
                      //   width: 60,
                      // )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "This is a test payment.\nPayment integration will be live soon.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  // Text(
                  //   "Payment Successfull",
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 22,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Text(
                  //   "₹8,000",
                  //   style: TextStyle(
                  //       color: Color(0xFFF37023),
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 24),
                  // ),
                  // Text(
                  //   "Transaction ID :985y348y385",
                  //   style: TextStyle(color: Color(0xFF909090)),
                  // ),
                ],
              ),
            ),
          );
  }
}
