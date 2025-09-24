import 'package:flutter/material.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon/noNetwork.png",
              height: 60,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "No Internet",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please Check your internet Connction or \n retry for smoother experiance",
              style: TextStyle(fontSize: 12, color: Color(0xFF909090)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              width: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Color(0xFFF37023)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Retry",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
