import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(FlightSeatApp());

class FlightSeatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Seat Selection',
      home: SeatSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SeatSelectionScreen extends StatefulWidget {
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final int seatsPerRow = 4;
  final Set<String> selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Seat')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: rows.length * seatsPerRow,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: seatsPerRow,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  String row = rows[index ~/ seatsPerRow];
                  int seatNumber = (index % seatsPerRow) + 1;
                  String seatId = '$row$seatNumber';
                  bool isSelected = selectedSeats.contains(seatId);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedSeats.remove(seatId);
                        } else {
                          selectedSeats.add(seatId);
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        seatId,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle the "Set" button action
                // showDialog(
                //   context: context,
                //   // builder: (_) => AlertDialog(
                //   //   title: Text("Selected Seats"),
                //   //   content: Text(selectedSeats.isNotEmpty
                //   //       ? selectedSeats.join(', ')
                //   //       : "No seats selected."),
                //   //   actions: [
                //   //     TextButton(
                //   //       onPressed: () => Navigator.pop(context),
                //   //       child: Text("OK"),
                //   //     )
                //   //   ],
                //   // ),
                // );
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF37023),
                minimumSize: Size(double.infinity, 50), // Full width
              ),
            ),
          ],
        ),
      ),
    );
  }
}
