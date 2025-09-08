import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'Seat.dart';

class Additions extends StatefulWidget {
  const Additions({super.key});

  @override
  State<Additions> createState() => _AdditionsState();
}

class _AdditionsState extends State<Additions> {
  int selectedindex = 0;
  int selectedBaggage = 0;
  int selectedbuild = 0;

  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final int seatsPerRow = 4;
  final Set<String> selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE8E8E8),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFE8E8E8)),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Additions",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50.h,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedindex = 0;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.sizeOf(context).height,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey),
                                  color: selectedindex == 0
                                      ? Color(0xFFFFE7DA)
                                      : Colors.white),
                              child: Text(
                                "Baggage",
                                style: TextStyle(
                                    color: selectedindex == 0
                                        ? Colors.orange
                                        : Colors.black),
                              ),
                            ))),
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedindex = 1;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.sizeOf(context).height,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: selectedindex == 1
                                      ? Color(0xFFFFE7DA)
                                      : Colors.white,
                                  border: Border.all(color: Colors.grey)),
                              child: Text(
                                "Seat",
                                style: TextStyle(
                                    color: selectedindex == 1
                                        ? Colors.orange
                                        : Colors.black),
                              ),
                            ))),
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedindex = 2;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.sizeOf(context).height,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: selectedindex == 2
                                      ? Color(0xFFFFE7DA)
                                      : Colors.white,
                                  border: Border.all(color: Colors.grey)),
                              child: Text(
                                "Meals",
                                style: TextStyle(
                                    color: selectedindex == 2
                                        ? Colors.orange
                                        : Colors.black),
                              ),
                            )))
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(12),
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0xFFF37023),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBaggage = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 44),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: selectedBaggage == 0
                              ? Colors.white
                              : Color(0xFFFFF37023),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        "MAA-BLR",
                        style: TextStyle(
                            color: selectedBaggage == 0
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBaggage = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: selectedBaggage == 1
                              ? Colors.white
                              : Color(0xFFFFF37023),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        "BLR-MAA",
                        style: TextStyle(
                            color: selectedBaggage == 1
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            selectedindex == 0
                ? buildBaggage()
                : selectedindex == 1
                    ? buildseat()
                    : selectedindex == 2
                        ? buildmeals()
                        : Container(),
          ],
        ));
  }

  buildBaggage() {
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: 15,
            ),
            // SizedBox(
            //   height: 50.h,
            //   child: Container(
            //     margin: EdgeInsets.all(10),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Expanded(
            //             child: GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     selectedindex = 0;
            //                   });
            //                 },
            //                 child: Container(
            //                   alignment: Alignment.center,
            //                   height: MediaQuery.sizeOf(context).height,
            //                   width: MediaQuery.sizeOf(context).width,
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(5),
            //                       border: Border.all(color: Colors.grey),
            //                       color: selectedindex == 0
            //                           ? Color(0xFFFFE7DA)
            //                           : Colors.white),
            //                   child: Text(
            //                     "Baggage",
            //                     style: TextStyle(
            //                         color: selectedindex == 0
            //                             ? Colors.orange
            //                             : Colors.black),
            //                   ),
            //                 ))),
            //         Expanded(
            //             child: GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     selectedindex = 1;
            //                   });
            //                 },
            //                 child: Container(
            //                   alignment: Alignment.center,
            //                   height: MediaQuery.sizeOf(context).height,
            //                   width: MediaQuery.sizeOf(context).width,
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(5),
            //                       color: selectedindex == 1
            //                           ? Color(0xFFFFE7DA)
            //                           : Colors.white,
            //                       border: Border.all(color: Colors.grey)),
            //                   child: Text(
            //                     "Seat",
            //                     style: TextStyle(
            //                         color: selectedindex == 1
            //                             ? Colors.orange
            //                             : Colors.black),
            //                   ),
            //                 ))),
            //         Expanded(
            //             child: GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     selectedindex = 2;
            //                   });
            //                 },
            //                 child: Container(
            //                   alignment: Alignment.center,
            //                   height: MediaQuery.sizeOf(context).height,
            //                   width: MediaQuery.sizeOf(context).width,
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(5),
            //                       color: selectedindex == 2
            //                           ? Color(0xFFFFE7DA)
            //                           : Colors.white,
            //                       border: Border.all(color: Colors.grey)),
            //                   child: Text(
            //                     "Meals",
            //                     style: TextStyle(
            //                         color: selectedindex == 2
            //                             ? Colors.orange
            //                             : Colors.black),
            //                   ),
            //                 )))
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   margin: EdgeInsets.all(12),
            //   height: 50,
            //   decoration: BoxDecoration(
            //       color: Color(0xFFF37023),
            //       borderRadius: BorderRadius.all(Radius.circular(15))),
            //   child: Row(
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             selectedBaggage = 0;
            //           });
            //         },
            //         child: Container(
            //           padding: EdgeInsets.symmetric(horizontal: 44),
            //           margin: EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //               color: selectedBaggage == 0
            //                   ? Colors.white
            //                   : Color(0xFFFFF37023),
            //               borderRadius: BorderRadius.all(Radius.circular(8))),
            //           child: Text(
            //             "MAA-BLR",
            //             style: TextStyle(
            //                 color: selectedBaggage == 0
            //                     ? Colors.black
            //                     : Colors.white,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             selectedBaggage = 1;
            //           });
            //         },
            //         child: Container(
            //           padding: EdgeInsets.symmetric(horizontal: 44),
            //           margin: EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //               color: selectedBaggage == 1
            //                   ? Colors.white
            //                   : Color(0xFFFFF37023),
            //               borderRadius: BorderRadius.all(Radius.circular(8))),
            //           child: Text(
            //             "BLR-MAA",
            //             style: TextStyle(
            //                 color: selectedBaggage == 1
            //                     ? Colors.black
            //                     : Colors.white,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: 170,
              // width: MediaQuery.sizeOf(context).width,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icon/baggage.svg'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Baggage",
                        style: TextStyle(
                            color: Color(0xFF1C1E1D),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text("Add additional checkin baggage at low price"),
                  Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      Text('Cabin Bag'),
                      SizedBox(
                        width: 40,
                      ),
                      Text('CheckIn Bag')
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '7kg',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 90,
                      ),
                      Text(
                        '15kg',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        '₹8,000',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.check_box,
                        color: Colors.deepOrange,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        '7kg',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 90,
                      ),
                      Text(
                        '15kg',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        '₹8,000',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.check_box_outline_blank)
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  buildmeals() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 320,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/ssr/meals.png',
                    color: Color(0xFFF37023),
                    height: 25,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Meals',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text("Add additional meals at low price"),
              Divider(
                color: Colors.grey,
              ),
              Row(
                children: [
                  Text("Items"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Water Bottle",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "₹50",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.check_box,
                    color: Color(0xFFF37023),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Water Bottle",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "₹50",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.check_box_outline_blank)
                ],
              ),
              Row(
                children: [
                  Text(
                    "Sandwich",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "₹50",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.check_box,
                    color: Color(0xFFF37023),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "meals",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "₹50",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.check_box,
                    color: Color(0xFFF37023),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Water Bottle",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "₹50",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.check_box,
                    color: Color(0xFFF37023),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Water Bottle",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "₹50",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.check_box,
                    color: Color(0xFFF37023),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Water Bottle",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "₹50",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.check_box,
                    color: Color(0xFFF37023),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Water Bottle",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "₹50",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.check_box,
                    color: Color(0xFFF37023),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildseat() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.7,
        width: MediaQuery.sizeOf(context).width,
        child: SeatSelectionScreen());
  }
}
