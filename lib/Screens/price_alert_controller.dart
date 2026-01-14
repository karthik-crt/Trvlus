import 'package:get/get.dart';

class PriceAlertController extends GetxController {
  RxDouble oldFare = 0.0.obs;
  RxDouble newFare = 0.0.obs;

  RxBool isChanged = false.obs;

  void checkFare(double fare, bool isPriceChangedFlag) {
    // Case 1: API itself says price changed
    if (isPriceChangedFlag) {
      newFare.value = fare;
      isChanged.value = true;
      return;
    }

    // Case 2: Compare old and new fare manually
    if (oldFare.value > 0 && fare > oldFare.value) {
      newFare.value = fare;
      isChanged.value = true;
    }

    oldFare.value = fare;
  }

  void reset() {
    isChanged.value = false;
  }
}
