import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/api_service.dart';
import 'Search_Result_Page.dart';
import 'price_alert_bottomsheet.dart';
import 'price_alert_controller.dart';

class PriceAlertWrapper extends StatelessWidget {
  final Widget child;

  const PriceAlertWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PriceAlertController>();

    return Obx(() {
      // print("Obxxx${controller.isChanged.value}");
      if (controller.isChanged.value == true &&
          controller.isAlertShown.value == false) {
        Future.microtask(() {
          controller.isAlertShown.value = true;
          showModalBottomSheet(
            context: Get.context!,
            isScrollControlled: true,
            backgroundColor: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            builder: (_) => PriceAlertBottomSheet(
              onReturn: () async {
                final c = Get.find<PriceAlertController>();
                c.resetAll(); // Reset everything when returning to search

                // ✅ Show loading
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                try {
                  // ✅ Fetch fresh search data first
                  final searchData = await ApiService().getSearchResult(
                    c.airportCode,
                    c.fromAirport,
                    c.toairportCode,
                    c.toAirport,
                    c.selectedDepDate,
                    c.selectedReturnDate,
                    c.selectedTripType,
                    c.adultCount,
                    c.childCount,
                    c.infantCount,
                  );

                  Get.back(); // close loading dialog

                  // ✅ Now navigate with valid searchData
                  Navigator.push(
                    Get.context!,
                    MaterialPageRoute(
                      builder: (context) => FlightResultsPage(
                        airportCode: c.airportCode,
                        fromAirport: c.fromAirport,
                        toairportCode: c.toairportCode,
                        toAirport: c.toAirport,
                        selectedDepDate: c.selectedDepDate,
                        selectedReturnDate: c.selectedReturnDate,
                        selectedTripType: c.selectedTripType,
                        adultCount: c.adultCount,
                        childCount: c.childCount,
                        infantCount: c.infantCount,
                        searchData: searchData, // ✅ properly initialized
                      ),
                    ),
                  );
                } catch (e) {
                  Get.back(); // close loading dialog
                  print("Error fetching search data: $e");
                }
              },
            ),
          );

        });
      }

      return child; // return your main app content
    });
  }
}
