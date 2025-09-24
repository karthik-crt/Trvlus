import 'package:flutter/material.dart';

import 'WalletScreen.dart';

class Addamount extends StatefulWidget {
  const Addamount({super.key});

  @override
  State<Addamount> createState() => _AddamountState();
}

class _AddamountState extends State<Addamount> {
  int? selectedFare;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: MediaQuery.paddingOf(context),
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(),
                context: context,
                builder: (BuildContext context) {
                  int? localSelectedFare =
                      selectedFare; // local state for sheet

                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add Amount Via",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image.asset(
                                    "assets/icon/Close.png",
                                    height: 25,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Text("Select Payment method"),
                            SizedBox(height: 20),

                            // ✅ UPI
                            ListTile(
                              title: Text("UPI"),
                              trailing: Radio(
                                activeColor: Color(0xFFF37023),
                                visualDensity:
                                    VisualDensity(horizontal: -1, vertical: -3),
                                value: 0,
                                groupValue: localSelectedFare,
                                onChanged: (value) {
                                  setModalState(() {
                                    localSelectedFare = value as int;
                                    selectedFare = value;
                                  });
                                },
                              ),
                              leading: Image.asset(
                                "assets/icon/gpay.png",
                                height: 30,
                              ),
                            ),

                            // ✅ Credit cards
                            ListTile(
                              title: Text("Credit cards"),
                              trailing: Radio(
                                activeColor: Color(0xFFF37023),
                                visualDensity:
                                    VisualDensity(horizontal: -1, vertical: -3),
                                value: 1,
                                groupValue: localSelectedFare,
                                onChanged: (value) {
                                  setModalState(() {
                                    localSelectedFare = value as int;
                                    selectedFare = value;
                                  });
                                },
                              ),
                              leading: Image.asset(
                                "assets/icon/creditCard.png",
                                height: 30,
                              ),
                            ),

                            // ✅ Debit cards
                            ListTile(
                              title: Text("Debit cards"),
                              trailing: Radio(
                                activeColor: Color(0xFFF37023),
                                visualDensity:
                                    VisualDensity(horizontal: -1, vertical: -3),
                                value: 2,
                                groupValue: localSelectedFare,
                                onChanged: (value) {
                                  setModalState(() {
                                    localSelectedFare = value as int;
                                    selectedFare = value;
                                  });
                                },
                              ),
                              leading: Image.asset(
                                "assets/icon/debitCard.png",
                                height: 30,
                              ),
                            ),

                            // ✅ Internet Banking
                            ListTile(
                              title: Text("Internet Banking"),
                              trailing: Radio(
                                activeColor: Color(0xFFF37023),
                                visualDensity:
                                    VisualDensity(horizontal: -1, vertical: -3),
                                value: 3,
                                groupValue: localSelectedFare,
                                onChanged: (value) {
                                  setModalState(() {
                                    localSelectedFare = value as int;
                                    selectedFare = value;
                                  });
                                },
                              ),
                              leading: Image.asset(
                                "assets/icon/netBanking.png",
                                height: 30,
                              ),
                            ),

                            Spacer(),

                            // ✅ Confirm Button
                            Container(
                              height: 40,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color(0xFFF37023),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Image.asset(
                                                    "assets/icon/Close.png",
                                                    height: 20,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Image.asset(
                                              "assets/icon/successpayment.png",
                                              height: 50,
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              "Amount Added!",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Container(
                                              height: 40,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: Colors.deepOrange,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Wallet(),
                                                    ),
                                                  );
                                                },
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Done",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFFF37023),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Confirm & pay",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Add Amount To Wallet",
          style: TextStyle(fontSize: 16, color: Color(0xFF303030)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextField(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter Amount",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),

            // Quick Amounts Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _amountChip("₹10,000"),
                _amountChip("₹50,000"),
                _amountChip("₹1,00,000"),
              ],
            )
          ],
        ),
      ),
    );
  }

  // helper widget for chips
  Widget _amountChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
