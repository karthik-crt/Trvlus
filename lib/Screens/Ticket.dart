// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class Ticket extends StatefulWidget {
//   const Ticket({super.key});
//
//   @override
//   State<Ticket> createState() => _TicketState();
// }
//
// class _TicketState extends State<Ticket> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Colors.green,
//         title: Text(
//           "TICKET",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 14.sp,
//             fontFamily: 'Inter',
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               margin: EdgeInsets.all(10),
//               padding: EdgeInsets.all(10),
//
//               // color: Color(0xffFDEDE1),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xffFDEDE1),
//                   border: Border(
//                       bottom: BorderSide(color: Colors.orange, width: 2))),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.asset(
//                         "assets/images/Trvlus_Logo.png",
//                         height: 20,
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "TRVLUS",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w900,
//                             color: Colors.black,
//                             fontSize: 13),
//                       ),
//                       //GestureDetector(child: Text("abc@gmail.com"),),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.mail,
//                             size: 15,
//                           ),
//                           Text(
//                             "abc@gmail.com",
//                             style: TextStyle(color: Colors.black),
//                           )
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.phone,
//                             size: 15,
//                           ),
//                           Text(
//                             "1234567898",
//                             style: TextStyle(color: Colors.black),
//                           )
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on,
//                             size: 15,
//                           ),
//                           Text(
//                             "ABC colony",
//                             style: TextStyle(color: Colors.black),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "E-Ticket",
//                         style: TextStyle(
//                             color: Colors.orange, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "12 sep 2025 | 06.59pm",
//                         style: TextStyle(color: Colors.black, fontSize: 12),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             // 2nd box
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xffFDEDE1),
//                   boxShadow: [
//                     BoxShadow(
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         color: Color(0xFFFFAA69))
//                   ]),
//               margin: EdgeInsets.all(10),
//               padding: EdgeInsets.all(5),
//
//               width: MediaQuery.sizeOf(context).width,
//               // color: Color(0xffFDEDE1),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Icon(Icons.flight),
//                           Text(
//                             "AIRLINE NAME HERE",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                                 color: Colors.black),
//                           ),
//                           Spacer(),
//                           Text(
//                             "Booking Status",
//                             style: TextStyle(fontSize: 12),
//                           )
//                         ],
//                       ),
//                       Row(
//                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Booked on 12 Sep, 2025 |  06.59 PM",
//                             style: TextStyle(fontSize: 12),
//                           ),
//                           Spacer(),
//                           Container(
//                             color: Color(0xFF38971B),
//                             child: Text(
//                               "CONFIRMED",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 12),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   Divider(),
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                               child: Text(
//                             "BOOKINGID",
//                             style: TextStyle(fontSize: 12),
//                           )),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text("AIRLINE", style: TextStyle(fontSize: 12)),
//                           Text("GDS PNR", style: TextStyle(fontSize: 12))
//                         ],
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "CR96-68862-917802",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         "CB4DF4",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         "CDF112D",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             //3nd box
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xffF6F6F6),
//                   boxShadow: [
//                     BoxShadow(
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         color: Color(0xFFFFAA69))
//                   ]),
//               margin: EdgeInsets.all(10),
//               padding: EdgeInsets.all(5),
//               width: MediaQuery.sizeOf(context).width,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "ONWARDS FLIGHT DETAILS",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange,
//                             fontSize: 12),
//                       ),
//                       Text(
//                         "*Please verify flight timings & terminal info with the airlines prior to departure",
//                         style: TextStyle(fontSize: 9),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.flight),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "CHENNAI",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                     color: Colors.black),
//                               ),
//                               SizedBox(
//                                 width: 3,
//                               ),
//                               Text(
//                                 "MAA",
//                                 style: TextStyle(
//                                     fontSize: 12, color: Colors.black),
//                               )
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text("Wed,21May2025,12:00",
//                                   style: TextStyle(fontSize: 12))
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text("Non-Refundable",
//                                   style: TextStyle(fontSize: 12))
//                             ],
//                           )
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.flight),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "MADURAI",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                     color: Colors.black),
//                               ),
//                               SizedBox(
//                                 width: 3,
//                               ),
//                               Text("IXM",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.black))
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text("Wed,21May2025,12:00",
//                                   style: TextStyle(fontSize: 12))
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text("Non-Refundable",
//                                   style: TextStyle(fontSize: 12))
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Container(
//                     height: 25,
//                     width: MediaQuery.sizeOf(context).width,
//                     color: Color(0xFFD1D1D1),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Waiting Time: 13 Hrs 25 Mins",
//                           style: TextStyle(color: Colors.black, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.flight),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "MADURAI",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                     color: Colors.black),
//                               ),
//                               SizedBox(
//                                 width: 3,
//                               ),
//                               Text("IXM",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.black))
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text("Wed,21May2025,12:00",
//                                   style: TextStyle(fontSize: 12))
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text("Non-Refundable",
//                                   style: TextStyle(fontSize: 12))
//                             ],
//                           )
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.flight),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "CHENNAI",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                     color: Colors.black),
//                               ),
//                               SizedBox(
//                                 width: 3,
//                               ),
//                               SizedBox(
//                                 width: 3,
//                               ),
//                               Text("MAA",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.black))
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text("Wed,21May2025,12:00",
//                                   style: TextStyle(fontSize: 12))
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text("Non-Refundable",
//                                   style: TextStyle(fontSize: 12))
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // 4th box
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.grey.shade200,
//                   boxShadow: [
//                     BoxShadow(
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         color: Color(0xFFFFAA69)),
//                   ]),
//               margin: EdgeInsets.all(10),
//               padding: EdgeInsets.all(5),
//               width: MediaQuery.sizeOf(context).width,
//               // color: Color(0xffFDEDE1),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "TRAVELERS INFO",
//                             style: TextStyle(
//                                 color: Color(0xFFD37731), fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Column(
//                     children: [
//                       Row(children: [
//                         Container(
//                             height: 20,
//                             width: MediaQuery.sizeOf(context).width * 0.91,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Color(0xFFD1D1D1),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "NAME",
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                                 // SizedBox(width: 30,),
//                                 Text("Ticket No",
//                                     style: TextStyle(fontSize: 12)),
//                                 Text("Seat No", style: TextStyle(fontSize: 12)),
//                                 Text("Meals", style: TextStyle(fontSize: 12)),
//                                 Text("Baggage", style: TextStyle(fontSize: 12)),
//                               ],
//                             ))
//                         // Text("NAME"),SizedBox(width: 25,), Text("Ticket No "),Text("Seat No"),Text("Meals"),Text("Baggage")
//                       ])
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Mr.TICKET",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         "123456",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         "12B",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         "Include",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         "15kg",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // 5th box
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.grey.shade200,
//                   boxShadow: [
//                     BoxShadow(
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         color: Color(0xFFFFAA69))
//                   ]),
//               margin: EdgeInsets.all(10),
//               padding: EdgeInsets.all(5),
//               width: MediaQuery.sizeOf(context).width,
//               // color: Color(0xffFDEDE1),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "PAYMENT DETAILS",
//                             style: TextStyle(
//                                 color: Color(0xFFD37731), fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "BASE FARE",
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       Text(
//                         "6250",
//                         style: TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("TAXES & FEE", style: TextStyle(fontSize: 12)),
//                       Text("6250", style: TextStyle(fontSize: 12)),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("GRAND TOTAL", style: TextStyle(fontSize: 12)),
//                       Text("6250",
//                           style: TextStyle(fontSize: 12, color: Colors.black)),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             // 6th box
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.grey.shade200,
//                   boxShadow: [
//                     BoxShadow(
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         color: Color(0xFFFFAA69))
//                   ]),
//               margin: EdgeInsets.all(10),
//               padding: EdgeInsets.all(5),
//               width: MediaQuery.sizeOf(context).width,
//               // color: Color(0xffFDEDE1),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "FLIGHT INCLUSION",
//                             style: TextStyle(
//                                 color: Color(0xFFD37731), fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       Text("TOTAL BAGGAGE:", style: TextStyle(fontSize: 12)),
//                       Text(
//                         "RUH TO MAA",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.black),
//                       ),
//                       Spacer(),
//                       Text("35KG",
//                           style: TextStyle(fontSize: 12, color: Colors.black)),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text("TOTAL BAGGAGE:", style: TextStyle(fontSize: 12)),
//                       Text("RUH TO MAA",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: Colors.black)),
//                       Spacer(),
//                       Text("35KG",
//                           style: TextStyle(fontSize: 12, color: Colors.black)),
//                     ],
//                   ),
//                   Divider(),
//                   Row(
//                     children: [
//                       Text(
//                         "*Flight inclusions are subject to change with Airlines",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 10,
//                             color: Colors.black),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Customer Contact Details | E-mail : toubikr@GMAIL.COM | Contact No : 8248277899",
//                   style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
