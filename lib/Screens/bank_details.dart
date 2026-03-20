import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trvlus/utils/api_service.dart';

import '../models/bank_details.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  late Bankdetails bank;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    bankdetails();
  }

  bankdetails() async {
    setState(() {
      isLoading = true;
    });
    bank = await ApiService().bankDetails();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bank Accounts"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bank.data.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF37023)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bank Name:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                bank.data[index].bankName,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "IFSC Code:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                bank.data[index].ifscCode,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: bank.data[index].accNo),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("IFSC Code copied"),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account Number:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                bank.data[index].accNo,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: bank.data[index].accNo),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Account number copied"),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account Name:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                bank.data[index].accHolderName,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Branch Name:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                bank.data[index].branchName,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
