import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'DotDivider.dart';

class Roundtrip extends StatefulWidget {
  const Roundtrip({super.key});

  @override
  State<Roundtrip> createState() => _RoundtripState();
}

class _RoundtripState extends State<Roundtrip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Round Trip"),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            height: 150,
            width: 340,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      // offset: Offset(0, 0.7),
                      blurRadius: 3,
                      color: Colors.grey.shade500)
                ]),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "17 sep 2024",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15),
                    ),
                    Spacer(),
                    Icon(Icons.edit),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Edit details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Chennai",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                            Text(
                              "MAA",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ],
                        ),
                        Text(
                          "Chennai Airport",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Image.asset('assets/images/flightStop.png'),
                    const Spacer(),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Hyderbad",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                            Text(
                              "MAA",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ],
                        ),
                        Text(
                          "Hyderbad Airport",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                DotDivider(
                  dotSize: 1.h,
                  spacing: 2.r,
                  dotCount: 100,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 15,
                ),
                const Row(
                  children: [
                    Text(
                      "5 Traveller",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15),
                    ),
                    Spacer(),
                    Text(
                      "Travel Class",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.stars,
                      color: Colors.orange,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 400,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFFFE7DA),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Round Trip",
                          style: TextStyle(
                              color: Color(0xFF1C1E1D),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹ 4666",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12),
                            ),
                            Text(
                              "₹ 4566",
                              style: TextStyle(
                                  color: Color(0xFFF37023),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "11h 15 layover at Bangalore",
                        style: TextStyle(
                            color: Color(0xFFF37023),
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/flight.png",
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Indigo",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                "XL-2724",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 4.w,
                                height: 3.h,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "NR",
                                style: TextStyle(
                                    color: Color(0xFFF37023),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
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
                            "05:35",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Sat, 30 Nov 24",
                            style: TextStyle(
                                color: Color(0xFF909090), fontSize: 10),
                          ),
                          Row(
                            children: [
                              Text(
                                "Chennai",
                                style: TextStyle(
                                    color: Color(0xFF1C1E1D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "MAA",
                                style: TextStyle(
                                    color: Color(0xFF909090),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "1 stop",
                            style: TextStyle(
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                          Image.asset('assets/images/flightStop.png'),
                          Text(
                            "1hr 14 min",
                            style: TextStyle(
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "05:35",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Sat, 30 Nov 24",
                            style: TextStyle(
                                color: Color(0xFF909090), fontSize: 10),
                          ),
                          Row(
                            children: [
                              Text(
                                "Madurai",
                                style: TextStyle(
                                    color: Color(0xFF1C1E1D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "IXM",
                                style: TextStyle(
                                    color: Color(0xFF909090),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DotDivider(
                    dotSize: 1.h,
                    spacing: 2.r,
                    dotCount: 97,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "11h 15 layover at Bangalore",
                    style: TextStyle(
                        color: Color(0xFFF37023),
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/flight.png",
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Emriates",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                "XL-2724",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 4.w,
                                height: 3.h,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "NR",
                                style: TextStyle(
                                    color: Color(0xFFF37023),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "05:35",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Sat, 30 Nov 24",
                            style: TextStyle(
                                color: Color(0xFF909090), fontSize: 10),
                          ),
                          Row(
                            children: [
                              Text(
                                "Madurai",
                                style: TextStyle(
                                    color: Color(0xFF1C1E1D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "IXM",
                                style: TextStyle(
                                    color: Color(0xFF909090),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "1 stop",
                            style: TextStyle(
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                          Image.asset('assets/images/flightStop.png'),
                          Text(
                            "1hr 14 min",
                            style: TextStyle(
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "05:35",
                            style: TextStyle(
                                color: Color(0xFF1C1E1D),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Sat, 30 Nov 24",
                            style: TextStyle(
                                color: Color(0xFF909090), fontSize: 10),
                          ),
                          Row(
                            children: [
                              Text(
                                "Chennai",
                                style: TextStyle(
                                    color: Color(0xFF1C1E1D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "MAA",
                                style: TextStyle(
                                    color: Color(0xFF909090),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 25,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFDAE5FF),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        SvgPicture.asset(
                          "assets/icon/promocode.svg",
                          color: Color(0xFF5D89F0),
                          height: 15,
                          width: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Flat 10% Off upto Rs.with trvlus coupon",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
