// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// void main() => runApp(FlightSeatApp());
//
// class FlightSeatApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flight Seat Selection',
//       home: SeatSelectionScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class SeatSelectionScreen extends StatefulWidget {
//   @override
//   _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
// }
//
// class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
//   final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
//   final int seatsPerRow = 4;
//   final Set<String> selectedSeats = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         children: [
//           Expanded(
//             child: Container(
//               height: 400,
//               child: GridView.builder(
//                 itemCount: rows.length * seatsPerRow,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: seatsPerRow,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 2,
//                 ),
//                 itemBuilder: (context, index) {
//                   String row = rows[index ~/ seatsPerRow];
//                   int seatNumber = (index % seatsPerRow) + 1;
//                   String seatId = '$row$seatNumber';
//                   bool isSelected = selectedSeats.contains(seatId);
//
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (isSelected) {
//                           selectedSeats.remove(seatId);
//                         } else {
//                           selectedSeats.add(seatId);
//                         }
//                       });
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.green : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       child: Text(
//                         seatId,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white : Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Handle the "Set" button action
//               // showDialog(
//               //   context: context,
//               //   // builder: (_) => AlertDialog(
//               //   //   title: Text("Selected Seats"),
//               //   //   content: Text(selectedSeats.isNotEmpty
//               //   //       ? selectedSeats.join(', ')
//               //   //       : "No seats selected."),
//               //   //   actions: [
//               //   //     TextButton(
//               //   //       onPressed: () => Navigator.pop(context),
//               //   //       child: Text("OK"),
//               //   //     )
//               //   //   ],
//               //   // ),
//               // );
//             },
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Book',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFF37023),
//               minimumSize: Size(double.infinity, 50), // Full width
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<String> selectedSeats = [];
  int seatPrice = 500; // Example price per seat

  // Example Business + Economy seats
  final businessSeats = [
    ["A1", "B1", "C1", "D1", "E1", "F1"],
    ["A2", "B2", "C2", "D2", "E2", "F2"],
    ["A3", "B3", "C3", "D3", "E3", "F3"],
    ["A4", "B4", "C4", "D4", "E4", "F4"],
  ];

  final economySeats = [
    ["G1", "H1", "I1", "J1", "K1", "L1"],
    ["G2", "H2", "I2", "J2", "K2", "L2"],
    ["G3", "H3", "I3", "J3", "K3", "L3"],
  ];

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
        margin: EdgeInsets.all(6),
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

  Widget buildSeatRow(List<String> row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((seat) => buildSeat(seat)).toList(),
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
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.crop_square, color: Colors.white, size: 20),
              SizedBox(width: 5),
              Text("Available"),
              SizedBox(width: 15),
              Icon(Icons.crop_square, color: Colors.grey.shade300, size: 20),
              SizedBox(width: 5),
              Text("Reserved"),
              SizedBox(width: 15),
              Icon(Icons.crop_square, color: Colors.blue, size: 20),
              SizedBox(width: 5),
              Text("Selected"),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(5), // spacing between seats and border
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500, width: 1),
                  // 🔴 outer red border
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(90),
                      topLeft: Radius.circular(90)), // optional rounded corners
                ),
                child: Column(
                  children: [
                    buildSection("Business class", businessSeats),
                    buildSection("Economy class", economySeats),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Selected seats: ${selectedSeats.join(", ")}"),
              Text(
                "Total Price: \$${selectedSeats.length * seatPrice}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: selectedSeats.isEmpty ? null : () {},
            child: Text("Processed"),
          ),
        ],
      ),
    );
  }
}
