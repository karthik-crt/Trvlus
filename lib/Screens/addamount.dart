import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'WalletScreen.dart';

class Addamount extends StatefulWidget {
  const Addamount({super.key});

  @override
  State<Addamount> createState() => _AddamountState();
}

class _AddamountState extends State<Addamount> {
  int? selectedFare;
  final TextEditingController _amountController =
      TextEditingController(); // ✅ Added controller

  @override
  void dispose() {
    _amountController.dispose(); // cleanup
    super.dispose();
  }

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
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
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
                            const SizedBox(height: 10),
                            const Text("Select Payment method"),
                            const SizedBox(height: 20),

                            // ✅ UPI
                            ListTile(
                              title: const Text("UPI"),
                              trailing: Radio(
                                activeColor: const Color(0xFFF37023),
                                visualDensity: const VisualDensity(
                                    horizontal: -1, vertical: -3),
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
                              title: const Text("Credit cards"),
                              trailing: Radio(
                                activeColor: const Color(0xFFF37023),
                                visualDensity: const VisualDensity(
                                    horizontal: -1, vertical: -3),
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
                              title: const Text("Debit cards"),
                              trailing: Radio(
                                activeColor: const Color(0xFFF37023),
                                visualDensity: const VisualDensity(
                                    horizontal: -1, vertical: -3),
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
                              title: const Text("Internet Banking"),
                              trailing: Radio(
                                activeColor: const Color(0xFFF37023),
                                visualDensity: const VisualDensity(
                                    horizontal: -1, vertical: -3),
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

                            const Spacer(),

                            // ✅ Confirm Button
                            Container(
                              height: 40,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xFFF37023),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 280,
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.all(5),
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
                                                    height: 25,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Image.asset(
                                              "assets/icon/successWallet.png",
                                              height: 50,
                                            ),
                                            const SizedBox(height: 15),
                                            const Text(
                                              "Amount Added!",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Wallet(),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 40,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.deepOrange,
                                                ),
                                                child: const Align(
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
                                child: const Align(
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
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFFF37023),
              ),
              child: const Align(
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
        title: const Text(
          "Add Amount To Wallet",
          style: TextStyle(fontSize: 16, color: Color(0xFF303030)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // ✅ controlled TextField
            TextField(
              controller: _amountController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // only allow numbers
              ],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: "Enter Amount",
                // ✅ added ₹ directly in hint for center alignment
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Quick Amounts Row
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

  // ✅ helper widget for chips
  Widget _amountChip(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _amountController.text = text.replaceAll("₹", "₹"); // remove symbols
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
