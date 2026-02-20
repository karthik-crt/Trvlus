import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/utils/api_service.dart';

import '../models/payment.dart';
import 'Home_Page.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  int a = 0;
  bool isLoading = false;
  late Payment payment;
  String? myUserId;

  paymentStatus() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getString('user_id');
    payment = await ApiService().payment();
    print("payment$payment");
    setState(() {
      isLoading = false;
    });
  }

  double calculateBalance() {
    double total = 0;

    for (var item in payment.data) {
      if (item.fromUserId.toString() == myUserId) {
        total -= item.amount;
      } else if (item.toUserId.toString() == myUserId) {
        total += item.amount;
      }
    }

    print("totaqlll$total");
    return total;
  }

  void storeBalance() async {
    double total = calculateBalance(); // your function unchanged

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("total_balance", total);

    print("Stored balance: $total");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage("assets/images/Wallet_Card.png"), context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentStatus();
    storeBalance();
    print("myUserId$myUserId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchFlightPage()));
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.0.w),
            child: Image.asset(
              "assets/images/Arrow_back.png",
            ),
          ),
        ),
        title: Text(
          "Wallet Balance",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14.sp,
          ),
        ),
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 450.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset(
                              "assets/images/Wallet_Card.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20.w,
                          top: 15.h,
                          child: Text(
                            "Trvlus balance",
                            style: TextStyle(
                              color: const Color(0xFF606060),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20.w,
                          top: 45.h,
                          child: Text(
                            "₹${calculateBalance().toInt()}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.sp,
                            ),
                          ),
                        ),
                        // Positioned(
                        //   right: 20.w,
                        //   top: 40.h,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => const Addamount()));
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Color(0xFFF37023),
                        //     ),
                        //     child: Text("Add Amount"),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     "Wallet is empty",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payment.data.length,
                    itemBuilder: (context, index) {
                      final item = payment.data[index];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Row(
                          children: [
                            Image.asset(
                              item.type == "credit"
                                  ? "assets/icon/gpay.png"
                                  : "assets/icon/wallet.png",
                              height: 30,
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDate(item.createdAt),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  formatTime(item.createdAt),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹${item.amount.toInt()}",
                                  style: TextStyle(
                                    color: item.type == "credit"
                                        ? const Color(0xFF138808)
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item.fromUserId.toString() == myUserId
                                      ? "Debited"
                                      : "Credited",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
    );
  }
}

String formatDate(String dateTime) {
  final dt = DateTime.parse(dateTime);
  return "${dt.day} ${_month(dt.month)}, ${dt.year}";
}

String formatTime(String dateTime) {
  final dt = DateTime.parse(dateTime);
  return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
}

String _month(int month) {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return months[month - 1];
}
