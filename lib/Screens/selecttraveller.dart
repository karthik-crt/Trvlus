import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/search_data.dart';
import '../models/selecttraveler.dart';
import '../utils/api_service.dart';
import 'TravelerDetails.dart';
import 'multi_add_traveler.dart';

class SelectTraveller extends StatefulWidget {
  final dynamic flight;
  final String city;
  final String destination;
  final String airlineName;
  final String cityName;
  final String cityCode;
  final String? flightNumber;
  final String? depDate;
  final String? depTime;
  final String? refundable;
  final String? arrDate;
  final String? arrTime;
  final String? descityName;
  final String? descityCode;
  final String? airlineCode;
  final String? stop;
  final String? duration;
  final String? airportName;
  final String? desairportName;
  final double? basefare;
  final double? tax;
  final List<List<Segment>>? segments;
  final List<Map<String, dynamic>>? segmentsJson; // 4th page uses this
  final String? resultindex;
  final String? traceid;
  final Result? outboundFlight;
  final Result? inboundFlight;
  final String? outresultindex;
  final String? outdepDate;
  final String? outdepTime;
  final String? outarrDate;
  final String? outarrTime;
  final String? indepDate;
  final String? indepTime;
  final String? inarrDate;
  final String? inarrTime;
  final String? inresultindex;
  final String? total;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final num? coupouncode;
  final bool? isLLC;
  final bool? islogin;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;
  final String? commonPublishedFare;
  final String? tboOfferedFare;
  final double? tboCommission;
  final double? tboTds;
  final double? trvlusCommission;
  final double? trvlusTds;
  final double? othercharges;
  final int? trvlusNetFare;

  final bool isPassportRequiredAtTicket;
  final bool isPassportFullDetailRequiredAtBook;

  const SelectTraveller({
    super.key,
    required this.flight,
    required this.outBoundData,
    required this.inBoundData,
    required this.city,
    required this.destination,
    required this.airlineName,
    required this.cityName,
    required this.cityCode,
    this.airlineCode,
    this.airportName,
    this.desairportName,
    this.flightNumber,
    this.depDate,
    this.depTime,
    this.refundable,
    this.arrDate,
    this.arrTime,
    this.descityName,
    this.descityCode,
    this.duration,
    this.basefare,
    this.segments,
    this.segmentsJson,
    this.resultindex,
    this.traceid,
    this.outboundFlight,
    this.inboundFlight,
    this.total,
    this.tax,
    this.outresultindex,
    this.inresultindex,
    this.stop,
    this.adultCount,
    this.childCount,
    this.infantCount,
    this.coupouncode,
    this.isLLC,
    this.outdepDate,
    this.outdepTime,
    this.outarrDate,
    this.outarrTime,
    this.indepDate,
    this.indepTime,
    this.inarrDate,
    this.inarrTime,
    this.islogin,
    this.commonPublishedFare,
    this.tboOfferedFare,
    this.tboCommission,
    this.tboTds,
    this.trvlusCommission,
    this.trvlusTds,
    this.trvlusNetFare,
    this.othercharges,
    required this.isPassportRequiredAtTicket,
    required this.isPassportFullDetailRequiredAtBook,
  });

  @override
  State<SelectTraveller> createState() => _SelectTravellerState();
}

class _SelectTravellerState extends State<SelectTraveller> {
  bool isLoading = true;
  bool _isNavigating = false; // ADD THIS

  late Selecttraveler getTraveller;
  List<PassengerDetails> allPassengers = [];
  List<int> selectedPassengerIndices = [];

  @override
  void initState() {
    super.initState();
    print("SelectTraveller");
    getBookingData();
  }

  getBookingData() async {
    setState(() {
      isLoading = true;
      print("beforeOutput");
    });
    getTraveller = await ApiService().gettraveler();

    if (getTraveller.data.isNotEmpty) {
      allPassengers = getTraveller.data;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TravelerDetailsPage(
            flight: {},
            city: widget.city,
            destination: widget.destination,
            airlineName: widget.airlineName,
            airlineCode: widget.airlineCode,
            flightNumber: widget.flightNumber,
            cityName: widget.cityName,
            cityCode: widget.cityCode,
            descityName: widget.descityName,
            descityCode: widget.descityCode,
            depDate: widget.depDate,
            depTime: widget.depTime,
            arrDate: widget.arrDate,
            arrTime: widget.arrTime,
            duration: widget.duration,
            refundable: widget.refundable,
            stop: widget.stop,
            airportName: widget.airportName,
            desairportName: widget.desairportName,
            basefare: widget.basefare,
            segments: widget.segments,
            resultindex: widget.resultindex,
            traceid: widget.traceid,
            outboundFlight: widget.outboundFlight,
            inboundFlight: widget.inboundFlight,
            total: widget.total,
            tax: widget.tax,
            adultCount: widget.adultCount,
            childCount: widget.childCount,
            infantCount: widget.infantCount,
            isLLC: widget.isLLC,
            outdepDate: widget.outdepDate,
            outdepTime: widget.outdepTime,
            outarrDate: widget.outarrDate,
            outarrTime: widget.outarrTime,
            indepDate: widget.indepDate,
            indepTime: widget.indepTime,
            inarrDate: widget.inarrDate,
            inarrTime: widget.inarrTime,
            outBoundData: widget.outBoundData,
            inBoundData: widget.inBoundData,
            segmentsJson: widget.segmentsJson,
            coupouncode: widget.coupouncode,
            commonPublishedFare: widget.commonPublishedFare,
            tboOfferedFare: widget.tboOfferedFare,
            tboCommission: widget.tboCommission,
            tboTds: widget.tboTds,
            trvlusCommission: widget.trvlusCommission,
            trvlusTds: widget.trvlusTds,
            trvlusNetFare: widget.trvlusNetFare,
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 50, // better height for finger tap
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Build selected passengers list (same logic as Apply button)
                    List<Map<String, dynamic>> selectedPassengersList = [];

                    for (int index in selectedPassengerIndices) {
                      final passenger = allPassengers[index];
                      final date =
                          DateFormat('yyyy-MM-dd').parseStrict(passenger.dob);
                      final formattedDate =
                          DateFormat('dd-MM-yyyy').format(date);

                      String formattedExpiry = '';
                      final rawExpiry = passenger.passportExpiry ?? '';
                      if (rawExpiry.isNotEmpty) {
                        try {
                          final expiry =
                              DateFormat('yyyy-MM-dd').parseStrict(rawExpiry);
                          formattedExpiry =
                              DateFormat('dd-MM-yyyy').format(expiry);
                        } catch (e) {
                          formattedExpiry = '';
                        }
                      }

                      selectedPassengersList.add({
                        'id': passenger.id,
                        'gender': passenger.gender,
                        'Firstname': passenger.firstName,
                        'lastname': passenger.lastName,
                        'mobile': passenger.mobile,
                        'email': passenger.email,
                        'Passport No': passenger.passportNo,
                        'Date of Birth': formattedDate,
                        'Expiry': formattedExpiry,
                        'typeLable': passenger.paxType,
                        'wheelchair': false,
                        'Nationality': 'Indian',
                        'title': passenger.title,
                        "IssusingCountry": "India",
                      });
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelerDetailsPage(
                          flight: {},
                          city: widget.city,
                          destination: widget.destination,
                          airlineName: widget.airlineName,
                          airlineCode: widget.airlineCode,
                          flightNumber: widget.flightNumber,
                          cityName: widget.cityName,
                          cityCode: widget.cityCode,
                          descityName: widget.descityName,
                          descityCode: widget.descityCode,
                          depDate: widget.depDate,
                          depTime: widget.depTime,
                          arrDate: widget.arrDate,
                          arrTime: widget.arrTime,
                          duration: widget.duration,
                          refundable: widget.refundable,
                          stop: widget.stop,
                          airportName: widget.airportName,
                          desairportName: widget.desairportName,
                          basefare: widget.basefare,
                          segments: widget.segments,
                          resultindex: widget.resultindex,
                          traceid: widget.traceid,
                          outboundFlight: widget.outboundFlight,
                          inboundFlight: widget.inboundFlight,
                          total: widget.total,
                          tax: widget.tax,
                          adultCount: widget.adultCount,
                          childCount: widget.childCount,
                          infantCount: widget.infantCount,
                          isLLC: widget.isLLC,
                          outdepDate: widget.outdepDate,
                          outdepTime: widget.outdepTime,
                          outarrDate: widget.outarrDate,
                          outarrTime: widget.outarrTime,
                          indepDate: widget.indepDate,
                          indepTime: widget.indepTime,
                          inarrDate: widget.inarrDate,
                          inarrTime: widget.inarrTime,
                          outBoundData: widget.outBoundData,
                          inBoundData: widget.inBoundData,
                          segmentsJson: widget.segmentsJson,
                          coupouncode: widget.coupouncode,
                          commonPublishedFare: widget.commonPublishedFare,
                          tboOfferedFare: widget.tboOfferedFare,
                          tboCommission: widget.tboCommission,
                          tboTds: widget.tboTds,
                          trvlusCommission: widget.trvlusCommission,
                          trvlusTds: widget.trvlusTds,
                          trvlusNetFare: widget.trvlusNetFare,
                          // Pass selected passengers so they appear pre-filled
                          selectedpassengers: selectedPassengersList.isNotEmpty
                              ? selectedPassengersList
                              : null,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF37023),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "+Add More",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedPassengerIndices.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TravelerDetailsPage(
                            flight: {},
                            city: widget.city,
                            destination: widget.destination,
                            airlineName: widget.airlineName,
                            airlineCode: widget.airlineCode,
                            flightNumber: widget.flightNumber,
                            cityName: widget.cityName,
                            cityCode: widget.cityCode,
                            descityName: widget.descityName,
                            descityCode: widget.descityCode,
                            depDate: widget.depDate,
                            depTime: widget.depTime,
                            arrDate: widget.arrDate,
                            arrTime: widget.arrTime,
                            duration: widget.duration,
                            refundable: widget.refundable,
                            stop: widget.stop,
                            airportName: widget.airportName,
                            desairportName: widget.desairportName,
                            basefare: widget.basefare,
                            segments: widget.segments,
                            resultindex: widget.resultindex,
                            traceid: widget.traceid,
                            outboundFlight: widget.outboundFlight,
                            inboundFlight: widget.inboundFlight,
                            total: widget.total,
                            tax: widget.tax,
                            adultCount: widget.adultCount,
                            childCount: widget.childCount,
                            infantCount: widget.infantCount,
                            isLLC: widget.isLLC,
                            outdepDate: widget.outdepDate,
                            outdepTime: widget.outdepTime,
                            outarrDate: widget.outarrDate,
                            outarrTime: widget.outarrTime,
                            indepDate: widget.indepDate,
                            indepTime: widget.indepTime,
                            inarrDate: widget.inarrDate,
                            inarrTime: widget.inarrTime,
                            outBoundData: widget.outBoundData,
                            inBoundData: widget.inBoundData,
                            segmentsJson: widget.segmentsJson,
                            coupouncode: widget.coupouncode,
                            commonPublishedFare: widget.commonPublishedFare,
                            tboOfferedFare: widget.tboOfferedFare,
                            tboCommission: widget.tboCommission,
                            tboTds: widget.tboTds,
                            trvlusCommission: widget.trvlusCommission,
                            trvlusTds: widget.trvlusTds,
                            trvlusNetFare: widget.trvlusNetFare,
                          ),
                        ),
                      );
                      return; // ✅ stop here
                    }

                    List<Map<String, dynamic>> selectedPassengersList = [];

                    for (int index in selectedPassengerIndices) {
                      final passenger = allPassengers[index];
                      final date =
                          DateFormat('yyyy-MM-dd').parseStrict(passenger.dob);
                      final formattedDate =
                          DateFormat('dd-MM-yyyy').format(date);

                      String formattedExpiry = '';
                      final rawExpiry = passenger.passportExpiry ?? '';
                      if (rawExpiry.isNotEmpty) {
                        try {
                          final expiry =
                              DateFormat('yyyy-MM-dd').parseStrict(rawExpiry);
                          formattedExpiry =
                              DateFormat('dd-MM-yyyy').format(expiry);
                        } catch (e) {
                          formattedExpiry = '';
                        }
                      }

                      Map<String, dynamic> selectedPassenger = {
                        'id': passenger.id,
                        'gender': passenger.gender,
                        'Firstname': passenger.firstName,
                        'lastname': passenger.lastName,
                        'mobile': passenger.mobile,
                        'email': passenger.email,
                        'Passport No': passenger.passportNo,
                        'Date of Birth': formattedDate,
                        'Expiry': formattedExpiry,
                        'typeLable': passenger.paxType,
                        // 'Adult', 'Child', 'Infant'
                        'wheelchair': false,
                        'Nationality': 'Indian',
                        'title': passenger.title,
                        "IssusingCountry": "India",
                      };
                      selectedPassengersList.add(selectedPassenger);
                    }

                    if (selectedPassengerIndices.length == 1) {
                      final passenger =
                          allPassengers[selectedPassengerIndices.first];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTravelerPage(
                            flight: {},
                            city: widget.city,
                            destination: widget.destination,
                            airlineName: widget.airlineName,
                            airlineCode: widget.airlineCode,
                            flightNumber: widget.flightNumber,
                            cityName: widget.cityName,
                            cityCode: widget.cityCode,
                            descityName: widget.descityName,
                            descityCode: widget.descityCode,
                            depDate: widget.depDate,
                            depTime: widget.depTime,
                            arrDate: widget.arrDate,
                            arrTime: widget.arrTime,
                            duration: widget.duration,
                            refundable: widget.refundable,
                            stop: widget.stop,
                            airportName: widget.airportName,
                            desairportName: widget.desairportName,
                            basefare: widget.basefare,
                            tax: widget.tax,
                            segments: widget.segments,
                            travelerType: passenger.paxType.toLowerCase(),
                            // ✅ FIXED: 'adult' / 'child' / 'infant'
                            isPassportRequiredAtTicket:
                                widget.isPassportRequiredAtTicket,
                            isPassportFullDetailRequiredAtBook:
                                widget.isPassportFullDetailRequiredAtBook,
                            adultCount: widget.adultCount,
                            // ✅ always pass all counts
                            childCount: widget.childCount,
                            // ✅ always pass all counts
                            infantCount: widget.infantCount,
                            // ✅ always pass all counts
                            selectedpassenger: selectedPassengersList.first,
                            traceid: widget.traceid,
                            resultindex: widget.resultindex,
                            coupouncode: widget.coupouncode ?? 0,
                            segmentsJson: widget.segmentsJson,
                            isLLC: widget.isLLC,
                            commonPublishedFare: widget.commonPublishedFare,
                            tboOfferedFare: widget.tboOfferedFare,
                            tboCommission: widget.tboCommission,
                            tboTds: widget.tboTds,
                            trvlusCommission: widget.trvlusCommission,
                            trvlusTds: widget.trvlusTds,
                            trvlusNetFare: widget.trvlusNetFare,
                            outresultindex: widget.outresultindex,
                            inresultindex: widget.inresultindex,
                            outBoundData: widget.outBoundData,
                            inBoundData: widget.inBoundData,
                            inboundFlight: widget.inboundFlight,
                            outboundFlight: widget.outboundFlight,
                          ),
                        ),
                      );
                    } else {
                      setState(() => _isNavigating = true);
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (!mounted) return;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiAddTravelerPage(
                            flight: {},
                            city: widget.city,
                            destination: widget.destination,
                            airlineName: widget.airlineName,
                            airlineCode: widget.airlineCode,
                            flightNumber: widget.flightNumber,
                            cityName: widget.cityName,
                            cityCode: widget.cityCode,
                            descityName: widget.descityName,
                            descityCode: widget.descityCode,
                            depDate: widget.depDate,
                            depTime: widget.depTime,
                            arrDate: widget.arrDate,
                            arrTime: widget.arrTime,
                            duration: widget.duration,
                            refundable: widget.refundable,
                            stop: widget.stop,
                            airportName: widget.airportName,
                            desairportName: widget.desairportName,
                            basefare: widget.basefare,
                            tax: widget.tax,
                            segments: widget.segments,
                            isPassportRequiredAtTicket:
                                widget.isPassportRequiredAtTicket,
                            isPassportFullDetailRequiredAtBook:
                                widget.isPassportFullDetailRequiredAtBook,
                            adultCount: widget.adultCount,
                            childCount: widget.childCount,
                            infantCount: widget.infantCount,
                            selectedpassengers: selectedPassengersList,
                            traceid: widget.traceid,
                            resultindex: widget.resultindex,
                            coupouncode: widget.coupouncode ?? 0,
                            segmentsJson: widget.segmentsJson,
                            isLLC: widget.isLLC,
                            commonPublishedFare: widget.commonPublishedFare,
                            tboOfferedFare: widget.tboOfferedFare,
                            tboCommission: widget.tboCommission,
                            tboTds: widget.tboTds,
                            trvlusCommission: widget.trvlusCommission,
                            trvlusTds: widget.trvlusTds,
                            trvlusNetFare: widget.trvlusNetFare,
                            outresultindex: widget.outresultindex,
                            inresultindex: widget.inresultindex,
                            outBoundData: widget.outBoundData,
                            inBoundData: widget.inBoundData,
                            inboundFlight: widget.inboundFlight,
                            outboundFlight: widget.outboundFlight,
                          ),
                        ),
                      );
                      if (mounted) setState(() => _isNavigating = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF37023),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color(0xFFE6E6E6),
        appBar: AppBar(
          title: const Text("Select Traveller"),
          backgroundColor: const Color(0xFFE6E6E6),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : allPassengers.isEmpty
                ? const Center(child: Text("No travellers found"))
                : ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      // Group passengers by paxType
                      ...['Adult', 'Child', 'Infant'].map((type) {
                        // ✅ Skip type if count is 0 or null
                        if (type == 'Child' &&
                            (widget.childCount == null ||
                                widget.childCount == 0)) {
                          return SizedBox.shrink();
                        }
                        if (type == 'Infant' &&
                            (widget.infantCount == null ||
                                widget.infantCount == 0)) {
                          return SizedBox.shrink();
                        }

                        final passengersOfType = allPassengers
                            .where((p) => p.paxType == type)
                            .toList();

                        if (passengersOfType.isEmpty) return SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                type,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                            ...List.generate(passengersOfType.length, (index) {
                              final passenger = passengersOfType[index];
                              final originalIndex =
                                  allPassengers.indexOf(passenger);
                              final isSelected = selectedPassengerIndices
                                  .contains(originalIndex);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedPassengerIndices
                                        .contains(originalIndex)) {
                                      // Always allow deselect
                                      selectedPassengerIndices
                                          .remove(originalIndex);
                                    } else {
                                      // Count how many of this type are already selected
                                      int alreadySelectedOfType =
                                          selectedPassengerIndices.where((i) {
                                        return allPassengers[i].paxType == type;
                                      }).length;

                                      // Get the max allowed for this type
                                      int maxAllowed = 0;
                                      if (type == 'Adult')
                                        maxAllowed = widget.adultCount ?? 0;
                                      if (type == 'Child')
                                        maxAllowed = widget.childCount ?? 0;
                                      if (type == 'Infant')
                                        maxAllowed = widget.infantCount ?? 0;

                                      if (alreadySelectedOfType >= maxAllowed) {
                                        // Show snackbar warning
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'You can only select $maxAllowed $type(s)',
                                            ),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        return; // Block selection
                                      }

                                      selectedPassengerIndices
                                          .add(originalIndex);
                                    }
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: isSelected
                                            ? const Color(0xFFF37023)
                                            : Colors.grey,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          leading: passenger.paxType == 'Adult'
                                              ? (passenger.gender == "Mr"
                                                  ? Image.asset(
                                                      'assets/icon/adult.png',
                                                      height: 50)
                                                  : Image.asset(
                                                      'assets/icon/adultFemale.png',
                                                      height: 50))
                                              : passenger.paxType ==
                                                      'Child' // ✅ FIXED: 'Child' not 'child'
                                                  ? (passenger.gender == "Mstr"
                                                      ? Image.asset(
                                                          'assets/icon/child.png',
                                                          height: 50)
                                                      : Image.asset(
                                                          'assets/icon/adultFemale.png',
                                                          height: 50))
                                                  : (passenger.gender == "Mstr"
                                                      ? Image.asset(
                                                          'assets/icon/infant.png',
                                                          height: 50)
                                                      : Image.asset(
                                                          'assets/icon/adultFemale.png',
                                                          height: 50)),
                                          title: Text(
                                            "${passenger.gender} ${passenger.firstName} ${passenger.lastName}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(passenger.title),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                      const SizedBox(height: 10),
                    ],
                  ),
      ),
      if (_isNavigating)
        const ModalBarrier(dismissible: false, color: Colors.black45),
      if (_isNavigating)
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFF37023),
          ),
        ),
    ]);
  }
}
