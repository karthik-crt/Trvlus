import 'package:get/get.dart';

class PriceAlertController extends GetxController {
  RxDouble oldFare = 0.0.obs;
  RxDouble newFare = 0.0.obs;

  RxBool isChanged = false.obs;

  void checkFare(double fare, bool isPriceChangedFlag) {
    print("After getx $isPriceChangedFlag");
    if (isPriceChangedFlag) {
      oldFare.value =
          oldFare.value == 0 ? fare : oldFare.value; // set oldFare if not set
      newFare.value = fare;
      isChanged.value = true;
      return;
    }

    if (oldFare.value > 0 && fare > oldFare.value) {
      newFare.value = fare;
      isChanged.value = false;
    }
  }

  void reset() {
    // isChanged.value = false;
  }
}
