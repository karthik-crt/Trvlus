import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';

import '../models/search_data.dart';
import '../utils/api_service.dart';
import 'BookingHistory.dart';
import 'Home_Page.dart';

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
  final String? stop;
  final double? tax;
  final double? convenienceFee;
  final bool? isLLC;
  final num? coupouncode;
  final String? commonPublishedFare;
  final String? tboOfferedFare;
  final double? tboCommission;
  final double? tboTds;
  final double? trvlusCommission;
  final double? trvlusTds;
  final int? trvlusNetFare;
  final double? othercharges;

  final List<Map<String, dynamic>>? passenger;
  final List<Map<String, dynamic>>? childpassenger;
  final List<Map<String, dynamic>>? infantpassenger;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;
  final Map<String, dynamic>? meal;
  final Map<String, dynamic>? baggage;
  final List<Map<String, dynamic>>? seat;
  final String? resultindex;
  final String? traceid;

  final String? outdepDate;
  final String? outdepTime;
  final String? outarrDate;
  final String? outarrTime;
  final String? indepDate;
  final String? indepTime;
  final String? inarrDate;
  final String? inarrTime;

  final List<Map<String, dynamic>>? segmentsJson; // 4th page uses this

  const Afterpayment(
      {Key? key,
      this.flightNumber,
      required this.airlineName,
      required this.outBoundData,
      required this.inBoundData,
      required this.meal,
      required this.baggage,
      required this.seat,
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
      this.stop,
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
      this.segmentsJson,
      this.outdepDate,
      this.outdepTime,
      this.outarrDate,
      this.outarrTime,
      this.indepDate,
      this.indepTime,
      this.inarrDate,
      this.inarrTime,
      this.resultindex,
      this.traceid,
      this.convenienceFee,
      this.commonPublishedFare,
      this.tboOfferedFare,
      this.tboCommission,
      this.tboTds,
      this.trvlusCommission,
      this.trvlusTds,
      this.trvlusNetFare,
      this.othercharges,
      this.coupouncode})
      : super(key: key);

  @override
  State<Afterpayment> createState() => _AfterpaymentState();
}

class _AfterpaymentState extends State<Afterpayment> {
  bool isLoading = false;
  Map<String, dynamic>? searchData; // instead of String?
  String pnr = '';
  String bookingId = '';
  String statusMessage = '';
  double totalAmount = 0;
  String appReference = '';

// ✅ CORRECT
  double seatTotal = 0.0;
  double mealTotal = 0.0;
  double baggageTotal = 0.0;

  // TICKET API CALLING
  getSearchData() async {
    // final prefs = await SharedPreferences.getInstance();
    // final resultIndex = prefs.getString("ResultIndex");
    // final traceid = prefs.getString("TraceId");
    final resultIndex = widget.resultindex;
    final traceid = widget.traceid;

    final flightNumber = widget.flightNumber ?? "";
    final airlineName = widget.airlineName;
    final stop = widget.stop;

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
    final Map<String, dynamic> baggage = widget.baggage ?? {};
    List<Map<String, dynamic>> seat = widget.seat ?? [];
    final journeyList = widget.segmentsJson ?? "";
    final conveniencefee = widget.convenienceFee;
    final coupouncode = widget.coupouncode;
    final commonPublishedFare = widget.commonPublishedFare;
    final tboOfferedFare = widget.tboOfferedFare;
    final tboCommission = widget.tboCommission;
    final tboTds = widget.tboTds;
    final trvlusCommission = widget.trvlusCommission;
    final trvlusTds = widget.tboTds == 0.0 ? 0.0 : widget.trvlusTds;
    // final trvlusTds = widget.trvlusTds;
    final trvlusNetFare = widget.trvlusNetFare;
    final othercharges = widget.othercharges;
    final isLcc = widget.isLLC;

    setState(() {
      isLoading = true;
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
          baggage,
          seat,
          "",
          widget.outBoundData['segments'],
          conveniencefee,
          widget.outBoundData['trvlusCoupounCode'],
          widget.outBoundData['publishFare'],
          widget.outBoundData['offeredFare'],
          widget.outBoundData['tboCommission'],
          widget.outBoundData['tboTds'],
          widget.outBoundData['trvlusCommission'],
          widget.outBoundData['trvlusTds'],
          widget.outBoundData['trvlusNetFare'],
          othercharges,
        );
        setState(() {
          pnr = (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
          bookingId = (searchData?["data"]?["Response"]?["Response"]
                      ?["BookingId"])
                  ?.toString() ??
              "0";
          statusMessage = (searchData?["statusMessage"]);
        });
        // await ApiService().ticketInvoice(
        //     pnr, bookingId.toString(), widget.outBoundData['traceid'], "", "");
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
            baggage,
            seat,
            "",
            widget.outBoundData['segments'],
            conveniencefee,
            widget.outBoundData['trvlusCoupounCode'],
            widget.outBoundData['publishFare'],
            widget.outBoundData['offeredFare'],
            widget.outBoundData['tboCommission'],
            widget.outBoundData['tboTds'],
            widget.outBoundData['trvlusCommission'],
            widget.outBoundData['trvlusTds'],
            widget.outBoundData['trvlusNetFare'],
            "");

        // final pnr =
        //     (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
        // final bookingId =
        //     (searchData?["data"]?["Response"]?["Response"]?["BookingId"]) ?? 0;
        // final statusCode = (searchData?["statusCode"]) ?? 0;
        // final api = searchData;
        // print("API CALLING API$api");
        //
        // print("BookingId from hold pnr: $pnr");
        // print("bookingIdbookingId: $bookingId");
        // print("statusCodestatusCode: $statusCode");

        setState(() {
          pnr = (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
          bookingId = (searchData?["data"]?["Response"]?["Response"]
                      ?["BookingId"])
                  ?.toString() ??
              "0";
          statusMessage = (searchData?["statusMessage"]);
          appReference = (searchData?["data"]?["app_reference"]) ??
              (searchData?["app_reference"]) ??
              "";
        });

        print("HOLD-->TICKET API CALLING");
        print("INSIDE API CALLING outBoundData");
        await ApiService().ticketInvoice(
          pnr,
          bookingId.toString(),
          traceid,
          widget.outBoundData['trvlusNetFare'],
          conveniencefee,
          mealTotal,
          baggageTotal,
          seatTotal, // ✅
        );
      }

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
          meal,
          baggage,
          seat,
          "",
          widget.inBoundData['segments'],
          0,
          widget.inBoundData['trvlusCoupounCode'],
          widget.inBoundData['publishFare'],
          widget.inBoundData['offeredFare'],
          widget.inBoundData['tboCommission'],
          widget.inBoundData['tboTds'],
          widget.inBoundData['trvlusCommission'],
          widget.inBoundData['trvlusTds'],
          widget.inBoundData['trvlusNetFare'],
          othercharges,
        );
        setState(() {
          pnr =
              "$pnr${(searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? ""}";
          bookingId =
              "$bookingId ${(searchData?["data"]?["Response"]?["Response"]?["BookingId"])?.toString() ?? "0"}";
          statusMessage = (searchData?["statusMessage"]);
        });

        // await ApiService().ticketInvoice(
        //     (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "",
        //     (searchData?["data"]?["Response"]?["Response"]?["BookingId"])
        //             ?.toString() ??
        //         "0",
        //     widget.inBoundData['traceid'],
        //     "",
        //     "");
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
            baggage,
            seat,
            "",
            widget.inBoundData['segments'],
            0,
            widget.inBoundData['trvlusCoupounCode'],
            widget.inBoundData['publishFare'],
            widget.inBoundData['offeredFare'],
            widget.inBoundData['tboCommission'],
            widget.inBoundData['tboTds'],
            widget.inBoundData['trvlusCommission'],
            widget.inBoundData['trvlusTds'],
            widget.inBoundData['trvlusNetFare'],
            "");

        // print(
        //     "BookingId from hold pnr: ${(searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? ""}");
        // final pnr =
        //     (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
        // final bookingId =
        //     (searchData?["data"]?["Response"]?["Response"]?["BookingId"]) ?? 0;
        // final statusCode = (searchData?["statusCode"]) ?? 0;
        // final api = searchData;
        setState(() {
          pnr = (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
          bookingId = (searchData?["data"]?["Response"]?["Response"]
                  ?["BookingId"]) ??
              0;
          final statusCode = (searchData?["statusCode"]) ?? 0;
          final api = searchData;
        });

        print("HOLD-->TICKET API CALLING");
        print("INSIDE API CALLING inBoundData");

        await ApiService().ticketInvoice(
          pnr,
          bookingId.toString(),
          traceid,
          widget.inBoundData['trvlusNetFare'],
          conveniencefee,
          mealTotal,
          baggageTotal,
          seatTotal,
        );
      }
    } else {
      // ONEWAY
      if (widget.isLLC == true) {
        final depTime = widget.depTime;
        final depDate = DateFormat(
          "dd MMM yy",
        ).format(DateTime.parse(widget.depDate.toString()));

        final arrTime = widget.arrTime;
        final arrDate = DateFormat(
          "dd MMM yy",
        ).format(DateTime.parse(widget.arrDate.toString()));
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
            baggage,
            seat,
            stop,
            journeyList,
            conveniencefee,
            coupouncode,
            commonPublishedFare,
            tboOfferedFare,
            tboCommission,
            tboTds,
            trvlusCommission,
            trvlusTds,
            trvlusNetFare,
            othercharges);
        setState(() {
          pnr = (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
          bookingId = (searchData?["data"]?["Response"]?["Response"]
                      ?["BookingId"])
                  ?.toString() ??
              "0";
          statusMessage = (searchData?["statusMessage"]);
        });
      } else {
        // HOLD-->Ticket
        final depTime = widget.depTime;
        final depDate = DateFormat(
          "dd MMM yy",
        ).format(DateTime.parse(widget.depDate.toString()));

        final arrTime = widget.arrTime;
        final arrDate = DateFormat(
          "dd MMM yy",
        ).format(DateTime.parse(widget.arrDate.toString()));
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
          meal,
          baggage,
          seat,
          stop,
          journeyList,
          conveniencefee,
          coupouncode,
          commonPublishedFare,
          tboOfferedFare,
          tboCommission,
          tboTds,
          trvlusCommission,
          trvlusTds,
          trvlusNetFare,
          othercharges,
        );

        setState(() {
          pnr = (searchData?["data"]?["Response"]?["Response"]?["PNR"]) ?? "";
          bookingId = (searchData?["data"]?["Response"]?["Response"]
                      ?["BookingId"])
                  ?.toString() ??
              "0";

          statusMessage = (searchData?["statusMessage"]);
        });

        final api = searchData;

        await ApiService().ticketInvoice(
          pnr,
          bookingId.toString(),
          traceid,
          trvlusNetFare,
          conveniencefee,
          mealTotal,
          baggageTotal,
          seatTotal,
        );
      }
    }
    setState(() {
      isLoading = false;
    });

    // ✅ Check for booking failure
    final statusCode = searchData?["statusCode"]?.toString() ?? "";
    final msg = statusMessage ?? "";

    if (statusCode == "0" || msg.toLowerCase().contains("booking failed")) {
      Future.delayed(Duration.zero, () {
        _showBookingFailedDialog(msg);
      });
      return; // ← stop further execution
    }
    if (statusMessage != null && statusMessage.contains("Invalid Baggage")) {
      // Delay to ensure the widget is fully rendered before showing dialog
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Baggage Option Unavailable",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text(
                  "The baggage option you selected is no longer available from the airline. Please go back, remove the extra baggage, and try booking again."),
              actions: [
                TextButton(
                  child: Text("Go Back",
                      style: TextStyle(color: Color(0xFFF37023))),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to Payment
                    Navigator.of(context).pop(); // Go back to Additions
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  // SELECT TRAVELER
  selecttravelerData() async {
    print("TICKET API CALLING");
    final passenger = widget.passenger ?? [];
    final childpassenger = widget.childpassenger ?? [];
    final infantpassenger = widget.infantpassenger ?? [];

    setState(() {
      isLoading = true;
    });
    var traveler = await ApiService()
        .selectTraveler(passenger, childpassenger, infantpassenger);
    await getSearchData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _runBookingFlow() async {
    setState(() => isLoading = true);

    try {
      // selecttravelerData() internally calls getSearchData(), so don't call it again
      await selecttravelerData();
    } catch (e) {
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showBookingFailedDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Auto-close after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(); // Close dialog
          }
          Get.offAll(() => SearchFlightPage());
        });

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text(
                "Booking Failed",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   "App Reference Number",
              //   style: TextStyle(fontSize: 13, color: Colors.grey),
              // ),
              // const SizedBox(height: 4),
              // Text(
              //   appReference.isNotEmpty ? appReference : "N/A",
              //   // ✅ shows CR42-701668-925699
              //   style: const TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
              // Countdown indicator
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 0.0),
                duration: const Duration(seconds: 5),
                builder: (context, value, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey[300],
                        color: Color(0xFFF37023),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Redirecting to home in ${(value * 5).ceil()} sec...",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // selecttravelerData();
    // 1. Calculate seat total
    seatTotal = 0.0;
    if (widget.seat != null) {
      for (var s in widget.seat!) {
        seatTotal +=
            (s['Price'] ?? s['price'] ?? s['Amount'] ?? s['amount'] ?? 0)
                .toDouble();
      }
    }

    // 2. Calculate meal total
    mealTotal = 0.0;

    if (widget.meal != null && widget.meal!.isNotEmpty) {
      widget.meal!.forEach((routeKey, passengerData) {
        passengerData.forEach((passenger, meals) {
          for (var m in meals) {
            mealTotal += (m['Price'] ?? 0).toDouble();
          }
        });
      });
    }

    // 3. Calculate baggage total
    baggageTotal = 0.0;
    if (widget.baggage != null && widget.baggage!.isNotEmpty) {
      widget.baggage!.forEach((routeKey, baggageList) {
        for (var b in baggageList) {
          baggageTotal += (b['Price'] ?? 0).toDouble();
        }
      });
    }

    totalAmount = (widget.trvlusNetFare?.toDouble() ?? 0.0) +
        (widget.convenienceFee ?? 0.0) +
        seatTotal +
        mealTotal +
        baggageTotal;
    _runBookingFlow();

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
                  CircularProgressIndicator(color: Color(0xFFF37023)),
                  SizedBox(height: 10),
                  Text(
                    "Checking Payment",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  Text(
                    "Status...",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: GestureDetector(
              onTap: () {
                Get.offAll(() => BookingHistoryPage(source: 'payment'));
              },
              child: Container(
                height: 50,
                width: MediaQuery.sizeOf(context).width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xFFF37023),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Go To My Booking",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon(Icons.construction, size: 50),
                      Image.asset(
                        "assets/icon/left.png",
                        height: 100,
                        width: 60,
                      ),
                      Image.asset(
                        "assets/icon/successpayment.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        "assets/icon/right.png",
                        height: 100,
                        width: 60,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  // Text(
                  //   "This is a test payment.\nPayment integration will be live soon.",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // Text("PNR : $pnr"),
                  // Text("BOOKINGID : $bookingId"),
                  // Text("statusMessage :$statusMessage"),

                  Text(
                    "Payment Successfull",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "₹${totalAmount.toStringAsFixed(0)}",
                    style: TextStyle(
                        color: Color(0xFFF37023),
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Text("PNR : $pnr"),
                  Text("BOOKINGID : $bookingId"),
                ],
              ),
            ),
          );
  }
}
