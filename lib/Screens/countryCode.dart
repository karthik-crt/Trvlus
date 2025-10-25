import 'package:flutter/material.dart';

import '../models/countrycode.dart';
import '../utils/api_service.dart';

class countryCode extends StatefulWidget {
  final String? type;

  const countryCode({super.key, this.type});

  @override
  State<countryCode> createState() => _countryCodeState();
}

class _countryCodeState extends State<countryCode> {
  bool isLoading = true;
  late Countrycode countrycode;

  @override
  void initState() {
    super.initState();
    getcountryCodeData();
  }

  getcountryCodeData() async {
    setState(() {
      isLoading = true;
    });
    countrycode = await ApiService().countryCode();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            )
          : ListView.builder(
              itemCount: countrycode.data.length,
              itemBuilder: (context, index) {
                final country = countrycode.data[index];
                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Image.asset(
                            'assets/flag/${country.countryName}.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 8)),
                        TextSpan(
                          text: widget.type == "country"
                              ? '${country.countryName}'
                              : '${country.currencyCode}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (widget.type == "country") {
                        Navigator.pop(context, {
                          "name": country.countryName,
                          "flag": "${country.countryName}.png",
                          "currency": country.currencyCode,
                        });
                      } else {
                        Navigator.pop(context, {
                          "name": country.countryName,
                          "flag": "${country.countryName}.png",
                          "currency": country.currencyCode,
                        });
                      }
                    });
                  },
                );
              }),
    );
  }
}
