import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/search_data.dart';
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
  final double? basefare;
  final Result? outboundFlight;
  final Result? inboundFlight;
  final String? outresultindex;
  final String? inresultindex;
  final double? tax;
  final bool? isLLC;

  final List<Map<String, dynamic>>? passenger;
  final List<Map<String, dynamic>>? childpassenger;
  final List<Map<String, dynamic>>? infantpassenger;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;
  final Map<String, dynamic>? meal;

  final String? outdepDate;
  final String? outdepTime;
  final String? outarrDate;
  final String? outarrTime;
  final String? indepDate;
  final String? indepTime;
  final String? inarrDate;
  final String? inarrTime;

  const Afterpayment(
      {Key? key,
      this.flightNumber,
      required this.airlineName,
      required this.outBoundData,
      required this.inBoundData,
      required this.meal,
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
      this.outboundFlight,
      this.inboundFlight,
      this.outresultindex,
      this.inresultindex,
      this.basefare,
      this.tax,
      this.passenger,
      this.childpassenger,
      this.infantpassenger,
      this.isLLC,
      this.outdepDate,
      this.outdepTime,
      this.outarrDate,
      this.outarrTime,
      this.indepDate,
      this.indepTime,
      this.inarrDate,
      this.inarrTime})
      : super(key: key);

  @override
  State<Afterpayment> createState() => _AfterpaymentState();
}

class _AfterpaymentState extends State<Afterpayment> {
  bool isLoading = false;
  Map<String, dynamic>? searchData; // instead of String?

  // TICKET API CALLING
  getSearchData() async {
    print("TICKET API CALLING");
    print(widget.isLLC);

    print(widget.inBoundData['flightNumber']);
    print(widget.inBoundData['inarrDate']);
    print(widget.inBoundData['desairportName']);
    print(widget.inBoundData['duration']);
    print(widget.inBoundData['airlineCode']);
    print(widget.inBoundData['cityCode']);
    print(widget.inBoundData['descityCode']);
    print(widget.inBoundData['cityName']);
    print(widget.inBoundData['descityName']);
    print(widget.inBoundData['basefare']);
    print(widget.inBoundData['tax']);
    print(widget.inBoundData['traceid']);
    print(widget.inBoundData['inresultindex']);

    final prefs = await SharedPreferences.getInstance();
    final resultIndex = prefs.getString("ResultIndex");
    final traceid = prefs.getString("TraceId");

    final flightNumber = widget.flightNumber ?? "";
    final airlineName = widget.airlineName;

    final desairportName = widget.desairportName;
    final duration = widget.duration;
    final airlineCode = widget.airlineCode;
    final cityCode = widget.cityCode;
    final descityCode = widget.descityCode;
    final cityName = widget.cityName;
    final descityName = widget.descityName;
    final baseFare = widget.basefare;
    final tax = widget.tax;
    final airportName = widget.airportName;
    final passenger = widget.passenger ?? [];
    final childpassenger = widget.childpassenger ?? [];
    final infantpassenger = widget.infantpassenger ?? [];
    final Map<String, dynamic> meal = widget.meal ?? {};

    setState(() {
      isLoading = true;
      print("beforeOutput");
    });

    if (widget.outboundFlight != null && widget.inboundFlight != null) {
      String formatDate(String? dateStr) {
        if (dateStr == null || dateStr.isEmpty) return '';
        try {
          final date = DateTime.parse(dateStr);
          return DateFormat('E, dd MMM yy').format(date);
        } catch (e) {
          return '';
        }
      }

      print("ROUNDTRIP");
      if (widget.outBoundData['IsLCC'] == true) {
        searchData = await ApiService().ticket(
          widget.outBoundData['outresultindex'],
          widget.outBoundData['traceid'],
          widget.outBoundData['flightNumber'],
          widget.outBoundData['airlineName'],
          widget.outBoundData['outdepTime'],
          widget.outBoundData['outdepDate'],
          widget.outBoundData['airportName'],
          widget.outBoundData['outarrTime'],
          widget.outBoundData['outarrDate'],
          widget.outBoundData['desairportName'],
          widget.outBoundData['duration'],
          widget.outBoundData['airlineCode'],
          widget.outBoundData['cityCode'],
          widget.outBoundData['descityCode'],
          widget.outBoundData['cityName'],
          widget.outBoundData['descityName'],
          widget.outBoundData['basefare'],
          widget.outBoundData['tax'],
          passenger,
          childpassenger,
          infantpassenger,
          meal,
        );
      } else {
        searchData = await ApiService().holdTicket(
          widget.outBoundData['outresultindex'],
          widget.outBoundData['traceid'],
          widget.outBoundData['flightNumber'],
          widget.outBoundData['airlineName'],
          widget.outBoundData['outdepTime'],
          widget.outBoundData['outdepDate'],
          widget.outBoundData['airportName'],
          widget.outBoundData['outarrTime'],
          widget.outBoundData['outarrDate'],
          widget.outBoundData['desairportName'],
          widget.outBoundData['duration'],
          widget.outBoundData['airlineCode'],
          widget.outBoundData['cityCode'],
          widget.outBoundData['descityCode'],
          widget.outBoundData['cityName'],
          widget.outBoundData['descityName'],
          widget.outBoundData['basefare'],
          widget.outBoundData['tax'],
          passenger,
          childpassenger,
          infantpassenger,
          meal,
        );

        final pnr =
            (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
        final bookingId =
            (searchData?["data"]?["Response"]?["Response"]?["BookingId"]) ?? 0;
        final statusCode = (searchData?["statusCode"]) ?? 0;
        final api = searchData;
        print("API CALLING API$api");

        print("BookingId from hold pnr: $pnr");
        print("bookingIdbookingId: $bookingId");
        print("statusCodestatusCode: $statusCode");

        print("HOLD-->TICKET API CALLING");
        print("INSIDE API CALLING");
        await ApiService().ticketInvoice(pnr, bookingId.toString(), traceid);
      }

      print("searchDataROUNDTRIP$searchData");
      if (widget.inBoundData['IsLCC'] == true) {
        searchData = await ApiService().ticket(
            widget.inBoundData['inresultindex'],
            widget.inBoundData['traceid'],
            widget.inBoundData['flightNumber'],
            widget.inBoundData['airlineName'],
            widget.inBoundData['indepTime'],
            widget.inBoundData['indepDate'],
            widget.inBoundData['airportName'],
            widget.inBoundData['inarrTime'],
            widget.inBoundData['inarrDate'],
            widget.inBoundData['desairportName'],
            widget.inBoundData['duration'],
            widget.inBoundData['airlineCode'],
            widget.inBoundData['cityCode'],
            widget.inBoundData['descityCode'],
            widget.inBoundData['cityName'],
            widget.inBoundData['descityName'],
            widget.inBoundData['basefare'],
            widget.inBoundData['tax'],
            passenger,
            childpassenger,
            infantpassenger,
            meal);
        print("searchDataINBOUNDROUNDTRIP$searchData");
      } else {
        searchData = await ApiService().holdTicket(
          widget.inBoundData['inresultindex'],
          widget.inBoundData['traceid'],
          widget.inBoundData['flightNumber'],
          widget.inBoundData['airlineName'],
          widget.inBoundData['indepTime'],
          widget.inBoundData['indepDate'],
          widget.inBoundData['airportName'],
          widget.inBoundData['inarrTime'],
          widget.inBoundData['inarrDate'],
          widget.inBoundData['desairportName'],
          widget.inBoundData['duration'],
          widget.inBoundData['airlineCode'],
          widget.inBoundData['cityCode'],
          widget.inBoundData['descityCode'],
          widget.inBoundData['cityName'],
          widget.inBoundData['descityName'],
          widget.inBoundData['basefare'],
          widget.inBoundData['tax'],
          passenger,
          childpassenger,
          infantpassenger,
          meal,
        );

        final pnr =
            (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
        final bookingId =
            (searchData?["data"]?["Response"]?["Response"]?["BookingId"]) ?? 0;
        final statusCode = (searchData?["statusCode"]) ?? 0;
        final api = searchData;
        print("API CALLING API$api");

        print("BookingId from hold pnr: $pnr");
        print("bookingIdbookingId: $bookingId");
        print("statusCodestatusCode: $statusCode");

        print("HOLD-->TICKET API CALLING");
        print("INSIDE API CALLING");
        await ApiService().ticketInvoice(pnr, bookingId.toString(), traceid);
      }
    } else {
      if (widget.isLLC == true) {
        final depTime = widget.depTime;
        final depDate = DateFormat("dd MMM yy").format(
          DateTime.parse(widget.depDate.toString()),
        );

        final arrTime = widget.arrTime;
        final arrDate = DateFormat("dd MMM yy").format(
          DateTime.parse(widget.arrDate.toString()),
        );
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
          baseFare,
          tax,
          passenger,
          childpassenger,
          infantpassenger,
          meal,
        );
      } else {
        final depTime = widget.depTime;
        final depDate = DateFormat("dd MMM yy").format(
          DateTime.parse(widget.depDate.toString()),
        );

        final arrTime = widget.arrTime;
        final arrDate = DateFormat("dd MMM yy").format(
          DateTime.parse(widget.arrDate.toString()),
        );
        print("HOLD TICKET BOOKING");
        searchData = await ApiService().holdTicket(
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
            baseFare,
            tax,
            passenger,
            childpassenger,
            infantpassenger,
            meal);

        final pnr =
            (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
        final bookingId =
            (searchData?["data"]?["Response"]?["Response"]?["BookingId"]) ?? 0;
        final statusCode = (searchData?["statusCode"]) ?? 0;
        final api = searchData;
        print("API CALLING API$api");

        print("BookingId from hold pnr: $pnr");
        print("bookingIdbookingId: $bookingId");
        print("traceid: $traceid");
        print("statusCodestatusCode: $statusCode");

        print("HOLD-->TICKET API CALLING");
        print("INSIDE API CALLING");
        await ApiService().ticketInvoice(pnr, bookingId.toString(), traceid);
      }
    }
    setState(() {
      isLoading = false;
      print("AfterOutput");
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
