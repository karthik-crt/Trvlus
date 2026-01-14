// SeatSelectionScreen.dart
import 'package:flutter/material.dart';

import '../models/ssr.dart';
import '../utils/api_service.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String? traceid;
  final String? resultindex;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;

  const SeatSelectionScreen({
    super.key,
    this.traceid,
    this.resultindex,
    this.adultCount,
    this.childCount,
    this.infantCount,
  });

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen>
    with SingleTickerProviderStateMixin {
  List<String> selectedSeats = [];
  int seatPrice = 500;
  bool isLoading = true;
  late SsrData ssrseatData;

  late TabController _tabController;

  final Map<String, double> seatPriceMap = {};

  List segments = [];

  late int maxSeatCount;
  int childSeatCount = 1;

  @override
  void initState() {
    super.initState();
    maxSeatCount = widget.adultCount! +
        widget.childCount! +
        widget.infantCount!; // ✅ dynamic
    print("maxSeatCount$maxSeatCount");
    getseatdata();
  }

  getseatdata() async {
    setState(() {
      isLoading = true;
    });

    try {
      ssrseatData = await ApiService()
          .ssr(widget.resultindex ?? "", widget.traceid ?? "");

      segments = ssrseatData.response.seatDynamic.first.segmentSeat;

      _tabController = TabController(
        length: segments.length,
        vsync: this,
      );

      seatPriceMap.clear();
      for (var seatDynamic in ssrseatData.response.seatDynamic) {
        for (var segment in seatDynamic.segmentSeat) {
          for (var row in segment.rowSeats) {
            for (var seat in row.seats) {
              seatPriceMap[seat.code] = (seat.price ?? 0).toDouble();
            }
          }
        }
      }
    } catch (e) {
      debugPrint("SSR error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> buildSeatDynamicPayload() {
    List<Map<String, dynamic>> seatPayload = [];

    for (int i = 0; i < selectedSeats.length; i++) {
      String seatCode = selectedSeats[i];

      var seatInfo = ssrseatData.response.seatDynamic
          .expand((sd) => sd.segmentSeat)
          .expand((seg) => seg.rowSeats)
          .expand((row) => row.seats)
          .firstWhere((s) => s.code == seatCode);

      String paxType;

      if (i < widget.adultCount!) {
        paxType = "Adult";
      } else if (i < widget.adultCount! + widget.childCount!) {
        paxType = "Child";
      } else {
        paxType = "Infant";
      }

      seatPayload.add({
        "AirlineCode": seatInfo.airlineCode,
        "FlightNumber": seatInfo.flightNumber,
        "CraftType": seatInfo.craftType,
        "Origin": seatInfo.origin,
        "Destination": seatInfo.destination,
        "AvailablityType": seatInfo.availablityType,
        "Description": seatInfo.description,
        "Code": seatInfo.code,
        "RowNo": seatInfo.rowNo,
        "SeatNo": seatInfo.seatNo,
        "SeatType": seatInfo.seatType,
        "SeatWayType": seatInfo.seatWayType,
        "Compartment": seatInfo.compartment,
        "Deck": seatInfo.deck,
        "Currency": seatInfo.currency,
        "Price": seatInfo.price ?? 0,
        "paxIndex": i,
        "paxType": paxType, // ✅ Adult / Child / Infant
      });
    }

    return seatPayload;
  }

  double getTotalPrice() {
    double total = 0;
    for (var code in selectedSeats) {
      total += seatPriceMap[code] ?? seatPrice.toDouble();
    }
    return total;
  }

  String getCurrentPassengerLabel() {
    int index = selectedSeats.length + 1;

    if (widget.adultCount! > 0) {
      if (index <= widget.adultCount!) {
        return "Select Seat For Adult $index";
      }
      index -= widget.adultCount!;
    }

    if (widget.childCount! > 0) {
      if (index <= widget.childCount!) {
        return "Select Seat For Child $index";
      }
      index -= widget.childCount!;
    }

    if (widget.infantCount! > 0) {
      return "Select Seat For Infant $index";
    }

    return "Select Seat For Adult 1";
  }

  Widget buildSegmentTabs() {
    if (segments.isEmpty) return const SizedBox.shrink();

    if (segments.length == 1) {
      final seat = segments[0].rowSeats.first.seats.first;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  getCurrentPassengerLabel(),
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            SizedBox(height: 10),
            Text(
              "${seat.origin} - ${seat.destination}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            getCurrentPassengerLabel(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.deepOrange,
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.black,
          tabs: List.generate(segments.length, (index) {
            final seat = segments[index].rowSeats.first.seats.first;
            return Tab(
              text: "${seat.origin} - ${seat.destination}",
            );
          }),
        ),
      ],
    );
  }

  Widget buildSeatLayoutForSegment(int segmentIndex) {
    final segment = segments[segmentIndex];
    final List<Widget> rowsWidgets = [];

    for (var row in segment.rowSeats) {
      final List<Widget> seatWidgets = [];

      for (var seat in row.seats) {
        final bool isAvailable = seat.availablityType == 3;
        final String code = seat.code;
        final String seatLabel = seat.seatNo?.toString() ?? seat.code;
        final bool isSelected = selectedSeats.contains(code);

        final Color bgColor = !isAvailable
            ? Colors.grey.shade300
            : (isSelected ? Colors.blue : Colors.white);

        seatWidgets.add(
          GestureDetector(
            onTap: isAvailable
                ? () {
                    setState(() {
                      if (selectedSeats.contains(code)) {
                        selectedSeats.remove(code);
                      } else {
                        if (selectedSeats.length >= maxSeatCount) {
                          selectedSeats.clear();
                        }
                        selectedSeats.add(code);
                      }
                    });
                  }
                : null,
            child: Container(
              margin: const EdgeInsets.all(6),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    seatLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  if ((seat.price ?? 0) > 0)
                    Text(
                      '₹${(seat.price ?? 0).toInt()}',
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }

      rowsWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: seatWidgets,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(children: rowsWidgets),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildSegmentTabs(),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade500),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(90),
                  topRight: Radius.circular(90),
                ),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                      ),
                    )
                  : segments.length <= 1
                      ? buildSeatLayoutForSegment(0)
                      : TabBarView(
                          controller: _tabController,
                          children: List.generate(
                            segments.length,
                            (index) => buildSeatLayoutForSegment(index),
                          ),
                        ),
            ),
          ),
          const Divider(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.crop_square, color: Colors.white, size: 20),
                  const SizedBox(width: 5),
                  const Text(
                    "Available",
                    style: TextStyle(color: Color(0xFF606060)),
                  ),
                  const SizedBox(width: 15),
                  Icon(Icons.crop_square,
                      color: Colors.grey.shade300, size: 20),
                  const SizedBox(width: 5),
                  const Text("Reserved",
                      style: TextStyle(color: Color(0xFF606060))),
                  const SizedBox(width: 15),
                  const Icon(Icons.crop_square, color: Colors.blue, size: 20),
                  const SizedBox(width: 5),
                  const Text("Selected",
                      style: TextStyle(color: Color(0xFF606060))),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.crop_square, color: Colors.blue, size: 20),
                  const SizedBox(width: 5),
                  const Text("Free",
                      style: TextStyle(color: Color(0xFF606060))),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text("Selected seats: ${selectedSeats.join(", ")}"),
              ),
              Text(
                "Total Price: ₹${getTotalPrice().toInt()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: selectedSeats.isEmpty
                ? null
                : () {
                    // Build and print payload
                    List<Map<String, dynamic>> seatPayload =
                        buildSeatDynamicPayload();
                    print("Processed Payload: $seatPayload");

                    // TODO: send seatPayload to your API
                  },
            child: const Text("Processed"),
          ),
        ],
      ),
    );
  }
}
