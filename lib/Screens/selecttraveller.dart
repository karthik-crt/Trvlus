import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/search_data.dart';
import '../models/selecttraveler.dart';
import '../utils/api_service.dart';
import 'TravelerDetails.dart';

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
  final int? coupouncode;
  final bool? isLLC;
  final bool? islogin;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;

  // final bool isPassportRequiredAtTicket;
  // final bool isPassportFullDetailRequiredAtBook;

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
    // required this.isPassportRequiredAtTicket,
    // required this.isPassportFullDetailRequiredAtBook,
  });

  @override
  State<SelectTraveller> createState() => _SelectTravellerState();
}

class _SelectTravellerState extends State<SelectTraveller> {
  bool isLoading = true;

  late Selecttraveler getTraveller;
  List<PassengerDetails> allPassengers = [];
  int? selectedPassengerIndex;
  Map<String, dynamic> selectedPassenger = {};

  @override
  void initState() {
    super.initState();
    getBookingData();
    print("sdfvsvr${widget.traceid}");
    print("sdfvsvr${widget.resultindex}");
    print("sefwerfw${widget.segmentsJson}");
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
            tax: widget.tax,
            total: widget.total,
            segments: widget.segments,
            adultCount: widget.adultCount,
            childCount: widget.childCount,
            infantCount: widget.infantCount,
            // selectedpassenger: selectedPassenger,
            outBoundData: {},
            inBoundData: {},
            traceid: widget.traceid,
            resultindex: widget.resultindex,
            coupouncode: widget.coupouncode,
            segmentsJson: widget.segmentsJson,
            isLLC: widget.isLLC,
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
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 50, // better height for finger tap
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // action when pressed
                  print("Continue pressed");
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
                onPressed: () {
                  if (selectedPassengerIndex == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select a traveller")),
                    );
                    return;
                  }

                  final passenger = allPassengers[selectedPassengerIndex!];
                  print(passenger.dob);
                  final date =
                      DateFormat('yyyy-MM-dd').parseStrict(passenger.dob);

                  final formattedDate = DateFormat('dd-MM-yyyy').format(date);

                  print(formattedDate);

                  Map<String, dynamic> selectedPassenger = {
                    'gender': passenger.gender,
                    'Firstname': passenger.firstName,
                    'lastname': passenger.lastName,
                    'mobile': passenger.mobile,
                    'email': passenger.email,
                    'Passport No': passenger.passportNo,
                    'Date of Birth': formattedDate,
                    'Expiry': passenger.passportExpiry,
                    'typeLable': passenger.paxType,
                    'wheelchair': false,
                    'Nationality': 'Indian',
                    'title': passenger.title,
                    "IssusingCountry": "India",
                  };

                  print("sfgdeg");
                  print("Selected Passenger => $selectedPassenger");
                  print("srgrewg${passenger.gender}");

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
                        travelerType: 'adult',
                        isPassportRequiredAtTicket: false,
                        isPassportFullDetailRequiredAtBook: false,
                        adultCount: widget.adultCount,
                        childCount: widget.childCount,
                        infantCount: widget.infantCount,
                        selectedpassenger: selectedPassenger,
                        traceid: widget.traceid,
                        resultindex: widget.resultindex,
                        coupouncode: widget.coupouncode,
                        segmentsJson: widget.segmentsJson,
                        isLLC: widget.isLLC,
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
      appBar: AppBar(title: const Text("Select Traveller")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allPassengers.isEmpty
              ? const Center(child: Text("No travellers found"))
              : ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    // Group passengers by paxType
                    ...['Adult', 'Child', 'Infant'].map((type) {
                      final passengersOfType = allPassengers
                          .where((p) => p.paxType == type)
                          .toList();

                      if (passengersOfType.isEmpty) return SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
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
                          // Passengers of this type
                          ...List.generate(passengersOfType.length, (index) {
                            final passenger = passengersOfType[index];
                            final originalIndex =
                                allPassengers.indexOf(passenger);
                            final isSelected =
                                selectedPassengerIndex == originalIndex;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPassengerIndex = originalIndex;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: isSelected
                                        ? const Color(0xFFF37023)
                                        : Colors.grey,
                                  ),
                                  title: Text(
                                    "${passenger.gender} ${passenger.firstName} ${passenger.lastName}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(passenger.title),
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
    );
  }
}
