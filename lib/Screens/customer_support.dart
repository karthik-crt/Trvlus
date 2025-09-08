import 'package:flutter/material.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({super.key});

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
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
            SizedBox(
              width: 20,
            ),
            Text(
              "Customer Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        height: 255,
        width: MediaQuery.sizeOf(context).width,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xFFFFFFFF)),
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
            Text(
              "Contact Support",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1C1E1D),
                  fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mobile"),
                Text(
                  "54632 78945",
                  style: TextStyle(
                      color: Color(0xFF303030), fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Email"),
                Text(
                  "trvlus@gmail.com",
                  style: TextStyle(
                      color: Color(0xFF303030), fontWeight: FontWeight.bold),
                )
              ],
            ),
            Container(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xFFF37023)),
              alignment: Alignment.center,
              child: Text(
                'Call us',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
