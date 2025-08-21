// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../controller/auth_controller.dart';
//
// class MobileVerificationScreen extends StatefulWidget {
//   const MobileVerificationScreen({super.key});
//
//   @override
//   State<MobileVerificationScreen> createState() =>
//       _MobileVerificationScreenState();
// }
//
// class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
//   final AuthController authController = Get.put(AuthController());
//   final TextEditingController _mobileController = TextEditingController();
//
//   String selectedCode = '+91';
//
//   final RegExp _mobileRegex = RegExp(r'^[1-9]\d{9}$'); // Indian 10-digit
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 50.h),
//             Image.asset(
//               'assets/images/Home_Logo.png',
//               width: 120.w,
//             ),
//             SizedBox(height: 40.h),
//             Text(
//               'Verify Mobile',
//               style: TextStyle(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 10.h),
//             Text(
//               'Please use the mobile number linked\nwith your Aadhaar',
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 30.h),
//             Row(
//               children: [
//                 // Country Code Box
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade400),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: CountryCodePicker(
//                     onChanged: (code) {
//                       setState(() {
//                         selectedCode = code.dialCode!;
//                       });
//                     },
//                     initialSelection: 'IN',
//                     favorite: const ['+91', 'IN'],
//                     textStyle: TextStyle(fontSize: 16.sp, color: Colors.black),
//                     showCountryOnly: false,
//                     showOnlyCountryWhenClosed: false,
//                     alignLeft: false,
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//
//                 // Mobile Number Box
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey.shade400),
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 12.w),
//                     child: TextField(
//                       controller: _mobileController,
//                       keyboardType: TextInputType.number,
//                       style: TextStyle(color: Colors.black, fontSize: 16.sp),
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Enter mobile number',
//                         hintStyle: TextStyle(color: Colors.grey),
//                       ),
//                       onChanged: (value) {
//                         final fullNumber = '$selectedCode$value';
//                         authController.setMobileNumber(fullNumber);
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//           ],
//         ),
//       ),
//     );
//   }
// }
