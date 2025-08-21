import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DotDivider.dart';

class Roundtrip extends StatefulWidget {
  const Roundtrip({super.key});

  @override
  State<Roundtrip> createState() => _RoundtripState();
}

class _RoundtripState extends State<Roundtrip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Round Trip"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: 150,
        width: 340,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  // offset: Offset(0, 0.7),
                  blurRadius: 3,
                  color: Colors.grey.shade500)
            ]),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "17 sep 2024",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                ),
                Spacer(),
                Icon(Icons.edit),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Edit details",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Chennai",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                        ),
                        Text(
                          "MAA",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    Text(
                      "Chennai Airport",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
                const Spacer(),
                Image.asset('assets/images/flightStop.png'),
                const Spacer(),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hyderbad",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                        ),
                        Text(
                          "MAA",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    Text(
                      "Hyderbad Airport",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DotDivider(
              dotSize: 1.h,
              spacing: 2.r,
              dotCount: 100,
              color: Colors.grey,
            ),
            SizedBox(
              height: 15,
            ),
            const Row(
              children: [
                Text(
                  "5 Traveller",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                ),
                Spacer(),
                Text(
                  "Travel Class",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.stars,
                  color: Colors.orange,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
