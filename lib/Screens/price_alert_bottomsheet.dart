import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trvlus/Screens/price_alert_controller.dart';

class PriceAlertBottomSheet extends StatefulWidget {
  @override
  _PriceAlertBottomSheetState createState() => _PriceAlertBottomSheetState();
}

class _PriceAlertBottomSheetState extends State<PriceAlertBottomSheet> {
  int selectedindex = 1;

  @override
  Widget build(BuildContext context) {
    final p = Get.find<PriceAlertController>();
    print("p.isChanged${p.isChanged}");
    print("p.newFare${p.newFare}");
    print("p.oldFare${p.oldFare}");

    return Container(
      height: 450,
      padding: EdgeInsets.all(14),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.cancel_outlined),
            ),
          ),
          Image.asset("assets/icon/priceAlert.png", height: 70),
          SizedBox(height: 10),
          Text(
            "Price Alert!",
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          Text(
            "Airline has increased the price.\nPlease check the fare before booking.",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            height: 60,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Old Fare"),
                    Text(
                      "₹${p.oldFare.value.round()}",
                      style: TextStyle(color: Color(0xFFD10909)),
                    ),
                  ],
                ),
                Image.asset("assets/icon/pricechange.png"),
                Column(
                  children: [
                    Text("New Fare"),
                    Text(
                      "₹${p.newFare.value.round()}",
                      style: TextStyle(color: Color(0xFF138808)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedindex = 0;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.orange),
                      color:
                          selectedindex == 0 ? Colors.deepOrange : Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Return",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              selectedindex == 0 ? Colors.white : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedindex = 1;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.orange),
                      color:
                          selectedindex == 1 ? Colors.deepOrange : Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              selectedindex == 1 ? Colors.white : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
