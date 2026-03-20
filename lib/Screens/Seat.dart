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
  final String? airlineCode;
  final Function(List<Map<String, dynamic>>)? onPayloadUpdated;
  final List<Map<String, dynamic>>? initialPayload;
  final Map<String, dynamic>? outBoundData;
  final Map<String, dynamic>? inBoundData;
  final String? craftType; // ← add this

  const SeatSelectionScreen({
    super.key,
    this.traceid,
    this.resultindex,
    this.adultCount,
    this.childCount,
    this.infantCount,
    this.onPayloadUpdated,
    this.initialPayload,
    this.inBoundData,
    this.airlineCode,
    this.outBoundData,
    this.craftType,
  });

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen>
    with SingleTickerProviderStateMixin {
  Map<int, List<String>> selectedSeatsBySegment = {};
  int seatPrice = 500;
  bool isLoading = true;
  late SsrData ssrseatData;
  late SsrData inSsrSeatData;

  late TabController _tabController;

  final Map<String, double> seatPriceMap = {};

  List segments = [];

  late int maxSeatCount;
  int childSeatCount = 1;

  @override
  void initState() {
    super.initState();
    maxSeatCount =
        widget.adultCount! + widget.childCount! + widget.infantCount!;
    print("maxSeatCount$maxSeatCount");
    getseatdata();
  }

  getseatdata() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool isRoundTrip = widget.outBoundData != null &&
          widget.inBoundData != null &&
          widget.outBoundData!['outresultindex'] != null &&
          widget.inBoundData!['inresultindex'] != null;

      if (isRoundTrip) {
        // OUTBOUND
        ssrseatData = await ApiService()
            .ssr(widget.outBoundData!['outresultindex']!, widget.traceid!);

        // INBOUND
        inSsrSeatData = await ApiService()
            .ssr(widget.inBoundData!['inresultindex']!, widget.traceid!);

        segments = [];
        // Iterate ALL seatDynamic items (API returns one item per direction
        // group — outbound & inbound — same pattern as mealDynamic)
        if (ssrseatData.response?.seatDynamic != null &&
            ssrseatData.response!.seatDynamic.isNotEmpty) {
          for (var sd in ssrseatData.response.seatDynamic) {
            segments.addAll(sd.segmentSeat);
          }
        }
        if (inSsrSeatData.response?.seatDynamic != null &&
            inSsrSeatData.response!.seatDynamic.isNotEmpty) {
          for (var sd in inSsrSeatData.response.seatDynamic) {
            // Avoid duplicate segments already added from outbound SSR
            for (var seg in sd.segmentSeat) {
              final origin =
                  seg.rowSeats.isNotEmpty && seg.rowSeats.first.seats.isNotEmpty
                      ? seg.rowSeats.first.seats.first.origin
                      : null;
              final dest =
                  seg.rowSeats.isNotEmpty && seg.rowSeats.first.seats.isNotEmpty
                      ? seg.rowSeats.first.seats.first.destination
                      : null;
              final alreadyAdded = segments.any((s) =>
                  s.rowSeats.isNotEmpty &&
                  s.rowSeats.first.seats.isNotEmpty &&
                  s.rowSeats.first.seats.first.origin == origin &&
                  s.rowSeats.first.seats.first.destination == dest);
              if (!alreadyAdded) segments.add(seg);
            }
          }
        }
      } else {
        ssrseatData =
            await ApiService().ssr(widget.resultindex!, widget.traceid!);

        segments = [];
        if (ssrseatData.response?.seatDynamic != null &&
            ssrseatData.response!.seatDynamic.isNotEmpty) {
          for (var sd in ssrseatData.response.seatDynamic) {
            for (var seg in sd.segmentSeat) {
              segments.add(seg); // Add every segment from every seatDynamic
            }
          }
        }
      }

      _tabController = TabController(
        length: segments.length,
        vsync: this,
      );

      for (int i = 0; i < segments.length; i++) {
        selectedSeatsBySegment[i] = [];
      }

      // Build seat price map for both
      seatPriceMap.clear();

      void fillSeatPrice(SsrData data) {
        if (data.response?.seatDynamic == null ||
            data.response!.seatDynamic.isEmpty) return;
        for (var seatDynamic in data.response.seatDynamic) {
          for (var segment in seatDynamic.segmentSeat) {
            for (var row in segment.rowSeats) {
              for (var seat in row.seats) {
                seatPriceMap[seat.code] = (seat.price ?? 0).toDouble();
              }
            }
          }
        }
      }

      fillSeatPrice(ssrseatData);

      if (isRoundTrip) {
        fillSeatPrice(inSsrSeatData);
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

    // Loop by segment
    for (int segIndex = 0; segIndex < segments.length; segIndex++) {
      final seatsInSegment = selectedSeatsBySegment[segIndex] ?? [];

      for (int paxIndex = 0; paxIndex < seatsInSegment.length; paxIndex++) {
        String seatCode = seatsInSegment[paxIndex];

        bool isRoundTrip = widget.outBoundData != null &&
            widget.inBoundData != null &&
            widget.outBoundData!['outresultindex'] != null &&
            widget.inBoundData!['inresultindex'] != null;

        List allSeatDynamics = [];
        allSeatDynamics.addAll(ssrseatData.response.seatDynamic);
        if (isRoundTrip) {
          allSeatDynamics.addAll(inSsrSeatData.response.seatDynamic);
        }

        var seatInfo = allSeatDynamics
            .expand((sd) => sd.segmentSeat)
            .expand((seg) => seg.rowSeats)
            .expand((row) => row.seats)
            .firstWhere((s) => s.code == seatCode);

        String paxType;
        if (paxIndex < widget.adultCount!) {
          paxType = "Adult";
        } else if (paxIndex < widget.adultCount! + widget.childCount!) {
          paxType = "Child";
        } else {
          paxType = "Infant";
        }

        seatPayload.add({
          "AirlineCode": seatInfo.airlineCode,
          "FlightNumber":
              int.tryParse(seatInfo.flightNumber) ?? seatInfo.flightNumber,
          "CraftType":
              (seatInfo.craftType != null && seatInfo.craftType!.isNotEmpty)
                  ? seatInfo.craftType // use SSR value if available
                  : widget.craftType ?? '',
          "Origin": seatInfo.origin,
          "Destination": seatInfo.destination,
          "AvailablityType": seatInfo.availablityType,
          "Description": seatInfo.description,
          "Code": seatInfo.code,
          "RowNo": int.tryParse(seatInfo.rowNo) ?? seatInfo.rowNo,
          "SeatNo": seatInfo.seatNo,
          "SeatType": seatInfo.seatType,
          "SeatWayType": seatInfo.seatWayType,
          "Compartment": seatInfo.compartment,
          "Deck": seatInfo.deck,
          "Currency": seatInfo.currency,
          "Price": seatInfo.price ?? 0,
          // "SeatId": seatInfo.seatId,
          // "SeatNumber": seatInfo.seatNo,
          // "paxIndex": paxIndex,
        });
      }
    }

    return seatPayload;
  }

  double getTotalPrice() {
    double total = 0;
    for (var code in selectedSeatsBySegment.values.expand((e) => e)) {
      total += seatPriceMap[code] ?? seatPrice.toDouble();
    }
    return total;
  }

  String getCurrentPassengerLabel(int segmentIndex) {
    int index = (selectedSeatsBySegment[segmentIndex]?.length ?? 0) + 1;

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
                  getCurrentPassengerLabel(0),
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
            getCurrentPassengerLabel(_tabController.index),
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
    final segmentSelected = selectedSeatsBySegment[segmentIndex] ?? [];
    final List<Widget> rowsWidgets = [];

    for (var row in segment.rowSeats) {
      final List<Widget> seatWidgets = [];

      for (var seat in row.seats) {
        final bool isAvailable = seat.availablityType == 3;
        final String code = seat.code;
        final String seatLabel = seat.seatNo?.toString() ?? seat.code;
        final bool isSelected = segmentSelected.contains(code);

        final Color bgColor = isAvailable
            ? Colors.grey.shade400
            : (isSelected ? Colors.deepOrange : Color(0xFFFFF4ED));

        seatWidgets.add(
          GestureDetector(
            onTap: !isAvailable
                ? () {
                    setState(() {
                      final seats = selectedSeatsBySegment[segmentIndex] ??= [];
                      if (seats.contains(code)) {
                        seats.remove(code);
                      } else {
                        if (seats.length >= maxSeatCount) {
                          seats.clear();
                        }
                        seats.add(code);
                      }
                    });
                    if (widget.onPayloadUpdated != null) {
                      widget.onPayloadUpdated!(buildSeatDynamicPayload());
                    }
                  }
                : null,
            child: Container(
              margin: const EdgeInsets.all(6),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                  color: isAvailable
                      ? Colors.black26 // booked seats keep grey border
                      : isSelected
                          ? Colors.deepOrange // selected seat border
                          : Colors.deepOrange
                              .withOpacity(0.5), // available seat orange border
                ),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: seatWidgets,
            ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
          const Divider(height: 1),
          Container(
            color: const Color(0xFFFFF7F2),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildLegendItem(
                            const Color(0xFFFFF4ED), "Available",
                            isBorder: true, verticalOffset: 2.0)),
                    Expanded(
                        child:
                            _buildLegendItem(Colors.grey.shade400, "Booked")),
                    Expanded(
                        child: _buildLegendItem(
                            const Color(0xFFFF4D4D), "Emergency Exit",
                            isText: "EXIT")),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildLegendItem(Colors.deepOrange, "Selected")),
                    Expanded(
                        child:
                            _buildLegendItem(const Color(0xFF4CAF50), "Free")),
                    Expanded(
                        child: _buildLegendItem(Colors.white, "Maximum Space",
                            isBorder: true, isText: "XL")),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Selected seats: ${selectedSeatsBySegment.values.expand((e) => e).join(", ")}",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                      ),
                    ),
                    Text(
                      "Total Price: ₹${getTotalPrice().toInt()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label,
      {bool isBorder = false, String? isText, double verticalOffset = 0.0}) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          margin: EdgeInsets.only(top: verticalOffset),
          decoration: BoxDecoration(
            color: color,
            border: isBorder
                ? Border.all(color: Colors.deepOrange.withOpacity(0.5))
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: isText != null
              ? Text(
                  isText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF606060), fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
