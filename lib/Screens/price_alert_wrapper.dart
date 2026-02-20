import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'price_alert_bottomsheet.dart';
import 'price_alert_controller.dart';

class PriceAlertWrapper extends StatelessWidget {
  final Widget child;

  const PriceAlertWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PriceAlertController>();

    return Obx(() {
      print("Obxxx${controller.isChanged.value}");
      if (controller.isChanged.value == true) {
        Future.microtask(() {
          showModalBottomSheet(
            context: Get.context!,
            isScrollControlled: true,
            backgroundColor: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            builder: (_) => PriceAlertBottomSheet(),
          );

          controller.reset(); // reset after showing
        });
      }

      return child; // return your main app content
    });
  }
}
