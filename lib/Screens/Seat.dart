// SeatSelectionScreen.dart
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/ssr.dart';
import '../utils/api_service.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String? traceid;
  final String? resultindex;

  const SeatSelectionScreen({super.key, this.traceid, this.resultindex});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<String> selectedSeats = [];
  int seatPrice = 500; // fallback price per seat (kept from your original)
  bool isLoading = true;
  late SsrData ssrseatData;

  // Map to hold seatCode -> price (if API provides price)
  final Map<String, double> seatPriceMap = {};

  @override
  void initState() {
    super.initState();
    getseatdata();
    debugPrint("SEAT API CALLING");
  }

  getseatdata() async {
    setState(() {
      isLoading = true;
      debugPrint("beforeOutput");
    });

    try {
      ssrseatData = await ApiService()
          .ssr(widget.resultindex ?? "", widget.traceid ?? "");
      // debug print entire object (will use your model's toJson)
      debugPrint("ssrDATA: ${jsonEncode(ssrseatData)}", wrapWidth: 4500);

      // populate seatPriceMap from API data (if Price present)
      seatPriceMap.clear();
      try {
        for (var seatDynamic in ssrseatData.response.seatDynamic) {
          for (var segment in seatDynamic.segmentSeat) {
            for (var row in segment.rowSeats) {
              for (var seat in row.seats) {
                final code = seat.code; // seat.Code from your model
                final price = seat.price ?? 0;
                // store price (double)
                seatPriceMap[code] = price.toDouble();
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Error populating seatPriceMap: $e");
      }
    } catch (e) {
      debugPrint("Error fetching SSR: $e");
      // If API fails, leave isLoading false so UI can show message
    }

    setState(() {
      isLoading = false;
      debugPrint("AfterOutput");
    });
  }

  // Calculate total price of selected seats:
  double getTotalPrice() {
    if (seatPriceMap.isEmpty) {
      return selectedSeats.length * seatPrice.toDouble();
    }
    double total = 0;
    for (var code in selectedSeats) {
      total += seatPriceMap[code] ?? seatPrice.toDouble();
    }
    return total;
  }

  Widget buildSeatLayout() {
    // safety: no seat data
    if (ssrseatData.response.seatDynamic.isEmpty) {
      return const Center(child: Text("No seat data available"));
    }

    // We'll go through all segments -> rowSeats -> seats and render rows
    final List<Widget> rowsWidgets = [];

    // seat layout may have multiple segmentSeat entries; we'll iterate through all
    for (var seatDynamic in ssrseatData.response.seatDynamic) {
      for (var segment in seatDynamic.segmentSeat) {
        for (var row in segment.rowSeats) {
          // row.seats is a List<Seat>
          final List<Widget> seatWidgets = [];
          for (var seat in row.seats) {
            final bool isAvailable = seat.availablityType == 3;
            final String code = seat.code;
            final String seatLabel = seat.seatNo?.toString() ?? seat.code;

            final bool isSelected = selectedSeats.contains(code);
            final Color bgColor = !isAvailable
                ? Colors.grey.shade300
                : (isSelected ? Colors.blue : Colors.white);

            // seat tile
            seatWidgets.add(GestureDetector(
              onTap: isAvailable
                  ? () {
                      setState(() {
                        if (selectedSeats.contains(code)) {
                          selectedSeats.remove(code);
                        } else {
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
                    // show price if available and > 0 (small)
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
            ));
          }

          // wrap the row of seats
          rowsWidgets.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: seatWidgets,
            ),
          ));
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: rowsWidgets,
      ),
    );
  }

  // kept your original helper widgets (buildSection/buildSeatRow) signatures,
  // but we won't use static lists anymore. They are left unchanged to avoid
  // flow/design changes elsewhere in your app if referenced.
  Widget buildSeatRow(List<String> row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((seat) => buildSeat(seat)).toList(),
    );
  }

  Widget buildSeat(String seatNo) {
    bool isSelected = selectedSeats.contains(seatNo);
    bool isReserved =
        ["B1", "C2", "J1", "K1"].contains(seatNo); // example reserved seats

    Color color;
    if (isReserved) {
      color = Colors.grey.shade300;
    } else if (isSelected) {
      color = Colors.blue;
    } else {
      color = Colors.white;
    }

    return GestureDetector(
      onTap: isReserved
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  selectedSeats.remove(seatNo);
                } else {
                  selectedSeats.add(seatNo);
                }
              });
            },
      child: Container(
        margin: const EdgeInsets.all(6),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          seatNo,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<List<String>> seats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 10),
        Column(
          children: seats.map((row) => buildSeatRow(row)).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // legend
          Row(
            children: [
              Icon(Icons.crop_square, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              const Text("Available"),
              const SizedBox(width: 15),
              Icon(Icons.crop_square, color: Colors.grey.shade300, size: 20),
              const SizedBox(width: 5),
              const Text("Reserved"),
              const SizedBox(width: 15),
              const Icon(Icons.crop_square, color: Colors.blue, size: 20),
              const SizedBox(width: 5),
              const Text("Selected"),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              // spacing between seats and border
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade500, width: 1),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(90),
                    topLeft: Radius.circular(90)), // optional rounded corners
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : buildSeatLayout(),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text("Selected seats: ${selectedSeats.join(", ")}")),
              Text(
                // display rupee symbol and dynamic total price (falls back to seatPrice)
                "Total Price: ₹${getTotalPrice().toInt()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: selectedSeats.isEmpty
                ? null
                : () {
                    // currently no booking API call here to avoid changing flow.
                    // You can add booking API integration here (selectedSeats list and prices available).
                    debugPrint(
                        "Processed: ${selectedSeats.join(', ')} total: ${getTotalPrice()}");
                    // Example: Navigator.pop(context, {'selected': selectedSeats, 'total': getTotalPrice()});
                  },
            child: const Text("Processed"),
          ),
        ],
      ),
    );
  }
}
