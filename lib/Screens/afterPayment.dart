import 'package:flutter/material.dart';

import 'BookingHistory.dart';

class Afterpayment extends StatefulWidget {
  const Afterpayment({super.key});

  @override
  State<Afterpayment> createState() => _AfterpaymentState();
}

class _AfterpaymentState extends State<Afterpayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BookingHistoryPage()));
        },
        child: Container(
          height: 50,
          width: MediaQuery.sizeOf(context).width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color(0xFFF37023)),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Go To My Booking",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icon/left.png",
                height: 200,
                width: 60,
              ),
              Image.asset(
                "assets/icon/successpayment.png",
                height: 200,
                width: 80,
              ),
              Image.asset(
                "assets/icon/right.png",
                height: 200,
                width: 60,
              )
            ],
          ),
          Text(
            "Payment Successfull",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "₹8,000",
            style: TextStyle(
                color: Color(0xFFF37023),
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          Text(
            "Transaction ID :985y348y385",
            style: TextStyle(color: Color(0xFF909090)),
          )
        ],
      ),
    );
  }
}
