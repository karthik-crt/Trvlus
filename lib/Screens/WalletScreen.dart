import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trvlus/utils/api_service.dart';

import '../models/payment.dart';
import '../models/user.dart';
import 'Home_Page.dart';
import 'deposit_recharge_screen.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isLoading = false;
  late Payment payment;
  late User user;
  String? myUserId;

  final ScrollController _scrollController = ScrollController();

  int _currentMax = 10;
  final int _pageSize = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    paymentStatus();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  paymentStatus() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getString('user_id');

    payment = await ApiService().payment();
    payment.data.removeWhere((item) => item.roleName == "Secret");
    user = await ApiService().user();

    setState(() {
      isLoading = false;
    });
  }

  void loadMore() async {
    if (_isLoadingMore) return;

    if (_currentMax >= payment.data.length) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _currentMax += _pageSize;

      if (_currentMax > payment.data.length) {
        _currentMax = payment.data.length;
      }

      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Image.asset("assets/images/Arrow_back.png"),
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
              child: CircularProgressIndicator(color: Colors.orange),
            )
          : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: _currentMax + 1,
              itemBuilder: (context, index) {
                // Wallet Card UI (Top Section)
                if (index == 0) {
                  return Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
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
                              "₹ ${user.data.first.walletTicketBooking.toInt()}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 26.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DepositRechargeScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange),
                              child: Text(
                                "DEPOSITE REQUEST",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  );
                }

                int dataIndex = index - 1;

                if (dataIndex >= payment.data.length) {
                  return _isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.orange),
                          ),
                        )
                      : const SizedBox();
                }

                final item = payment.data[dataIndex];

                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Row(
                    children: [
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
                              color: item.fromUserId.toString() == myUserId
                                  ? Colors.red
                                  : const Color(0xFF138808),
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
    );
  }
}

String formatDate(String dateTime) {
  final dt = DateTime.parse(dateTime).toLocal();
  return "${dt.day} ${_month(dt.month)}, ${dt.year}";
}

String formatTime(String dateTime) {
  final dt = DateTime.parse(dateTime).toLocal();

  int hour = dt.hour;
  int minute = dt.minute;

  String period = hour >= 12 ? "PM" : "AM";
  int displayHour = hour > 12 ? hour - 12 : hour;
  if (displayHour == 0) displayHour = 12;

  return "$displayHour:${minute.toString().padLeft(2, '0')} $period";
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
