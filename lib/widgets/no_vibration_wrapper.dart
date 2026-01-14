// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class NoVibrationWrapper extends StatelessWidget {
//   final Widget child;
//
//   const NoVibrationWrapper({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     // Intercept feedback and do nothing instead of vibrating
//     return NotificationListener<GestureRecognizerNotification>(
//       onNotification: (notification) {
//         HapticFeedback
//             .lightImpact(); // optional: if you still want a light effect
//         return true; // block the original vibration
//       },
//       child: child,
//     );
//   }
// }
