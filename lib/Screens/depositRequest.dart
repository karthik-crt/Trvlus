import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:trvlus/utils/api_service.dart';

import '../models/depositstatus.dart' as deposit;

class Depositrequest extends StatefulWidget {
  const Depositrequest({super.key});

  @override
  State<Depositrequest> createState() => _DepositrequestState();
}

class _DepositrequestState extends State<Depositrequest>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DEPOSIT REQUEST"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      selectedIndex == 0 ? Colors.orange : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Deposit Form",
                  style: TextStyle(
                    color: selectedIndex == 0 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      selectedIndex == 1 ? Colors.orange : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Deposit Status",
                  style: TextStyle(
                    color: selectedIndex == 1 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DepositForm(tabController: _tabController),
          const DepositStatus(),
        ],
      ),
    );
  }
}

class DepositForm extends StatefulWidget {
  final TabController tabController;

  const DepositForm({super.key, required this.tabController});

  @override
  State<DepositForm> createState() => _DepositFormState();
}

class _DepositFormState extends State<DepositForm> {
  final _formKey = GlobalKey<FormState>();

  String? selectedBank;
  String? selectedPaymentMode;

  File? depositSlip;

  final ImagePicker picker = ImagePicker();

  bool isLoading = false;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController depositBankController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  List<String> paymentModes = [
    "Cash",
    "NEFT",
    "UPI",
    "RTGS",
  ];

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        depositSlip = File(image.path);
      });
    }
  }

  Future<void> submitDeposit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    await ApiService().depositRequest(
      branchAccount: selectedBank ?? '',
      depositeBank: depositBankController.text,
      branch: branchController.text,
      modeofpayment: selectedPaymentMode ?? '',
      amount: amountController.text,
      remark: remarkController.text,
      dateOfDeposit: dateController.text,
      // slip: depositSlip,
    );

    setState(() {
      isLoading = false;
    });

    widget.tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedBank,
                  decoration: const InputDecoration(
                    labelText: "OUR BANK ACCOUNT",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? "Please select a bank account" : null,
                  items: const [
                    DropdownMenuItem(value: "SBI", child: Text("SBI")),
                    DropdownMenuItem(value: "ICICI", child: Text("ICICI")),
                    DropdownMenuItem(value: "HDFC", child: Text("HDFC")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedBank = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: branchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "BRANCH",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Branch is required"
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: depositBankController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "DEPOSIT BANK",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Deposit bank is required"
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dateController,
                  style: const TextStyle(color: Colors.black),
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "DATE OF DEPOSIT",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: selectDate,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Date of deposit is required"
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "AMOUNT",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return "Amount is required";
                    if (double.tryParse(value) == null)
                      return "Enter a valid amount";
                    if (double.parse(value) <= 0)
                      return "Amount must be greater than 0";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMode,
                  decoration: const InputDecoration(
                    labelText: "MODE OF PAYMENT",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? "Please select a payment mode" : null,
                  items: paymentModes.map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMode = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: "INR",
                  readOnly: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "CURRENCY",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: remarkController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "REMARKS",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Remarks is required"
                      : null,
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "DEPOSIT SLIP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.orange,
                        ),
                        child: const Text(
                          "UPLOAD",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (depositSlip != null)
                      const Text(
                        "Image Selected",
                        style: TextStyle(color: Colors.green),
                      )
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: submitDeposit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF37023),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            ),
          )
      ],
    );
  }
}

class DepositStatus extends StatefulWidget {
  const DepositStatus({super.key});

  @override
  State<DepositStatus> createState() => _DepositStatusState();
}

class _DepositStatusState extends State<DepositStatus> {
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
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue.shade200,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "₹ ${item.amount}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.approvedBy == 0 ? "Pending" : "Approved",
                              style: TextStyle(
                                color: item.approvedBy == 0
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Payment Type :",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  item.modeOfPayment,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Date :",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  DateFormat('dd MMM yy').format(
                                      DateTime.parse(item.dateOfDeposite)),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Reference ID :",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  item.referenceNumber ?? '',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, size: 15),
                                SizedBox(width: 8),
                                Text(
                                  "Need Help? Contact Support",
                                  style: TextStyle(color: Colors.black),
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
