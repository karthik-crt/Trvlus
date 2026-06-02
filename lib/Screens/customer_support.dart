import 'package:flutter/material.dart';
import 'package:trvlus/utils/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/customer_support.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({super.key});

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  late Customersupport customer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getcustomersupport();
  }

  getcustomersupport() async {
    setState(() {
      _isLoading = true;
    });
    customer = await ApiService().getcustomersupport();
    setState(() {
      _isLoading = false;
    });
  }

  // ← ADD THIS METHOD
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFE8E8E8)),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            SizedBox(width: 20),
            Text(
              "Customer Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            )
          : Container(
              width: MediaQuery.sizeOf(context).width,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFFFFFF)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFFFE7DA)),
                          child: Image.asset(
                            'assets/images/support.png',
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      "Contact Support",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1C1E1D),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer Support Mail"),
                      Text(
                        customer.data.first.supportMail,
                        style: TextStyle(
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer Support Number"),
                      Text(
                        customer.data.first.mobile,
                        style: TextStyle(
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer Account Support"),
                      Text(
                        customer.data.first.customerAccountSupport,
                        style: TextStyle(
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer Account Mobile"),
                      Text(
                        customer.data.first.customerMobile,
                        style: TextStyle(
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  // ← UPDATED BUTTON WITH GestureDetector
                  GestureDetector(
                    onTap: () => _makePhoneCall(customer.data.first.mobile),
                    child: Container(
                      height: 50,
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color(0xFFF37023)),
                      alignment: Alignment.center,
                      child: Text(
                        'Call us',
                        style:
                            TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
