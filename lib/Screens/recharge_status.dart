import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/depositstatus.dart' as deposit;
import '../utils/api_service.dart';

class RechargeStatus extends StatefulWidget {
  const RechargeStatus({super.key});

  @override
  State<RechargeStatus> createState() => _RechargeStatusState();
}

class _RechargeStatusState extends State<RechargeStatus> {
  bool isLoading = false;
  deposit.DepositStatus? depositData;

  @override
  void initState() {
    super.initState();
    getDepositStatus();
  }

  getDepositStatus() async {
    setState(() {
      isLoading = true;
    });
    depositData = await ApiService().getdepositStatus();
    if (depositData != null && depositData!.data.isNotEmpty) {
      depositData!.data.sort((a, b) => b.id.compareTo(a.id));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recharge Status"),
      ),
      backgroundColor: const Color(0xFFE6E6E6),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ))
          : depositData == null || depositData!.data.isEmpty
              ? const Center(child: Text("No deposit records found."))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: depositData!.data.length,
                    itemBuilder: (context, index) {
                      final item = depositData!.data[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Deposit Update",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "₹ ${item.amount}",
                                  style: const TextStyle(
                                    color: Color(0xFFF37023),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd MMM yy').format(
                                      DateTime.parse(item.dateOfDeposite)),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 10,
                                  width: 1,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  item.TransactionNumber ?? '',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const Spacer(),
                                Text(
                                  item.approvedBy == 0 ? "Pending" : "Approved",
                                  style: TextStyle(
                                    color: item.approvedBy == 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
