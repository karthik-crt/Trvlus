import 'package:get/get.dart';

class PriceAlertController extends GetxController {
  RxDouble oldFare = 0.0.obs;
  RxDouble newFare = 0.0.obs;

  String airportCode = '';
  String fromAirport = '';
  String toairportCode = '';
  String toAirport = '';
  String selectedDepDate = '';
  String selectedReturnDate = '';
  String selectedTripType = '';
  int adultCount = 1;
  int childCount = 0;
  int infantCount = 0;
  double overallFare = 0.0;
  double finalBaseFare = 0.0;
  double finalTax = 0.0;
  double trvlusCommission = 0.0;
  num finalCouponValue = 0.0;
  dynamic searchData;
  RxBool isChanged = false.obs;

  void checkFare(double fare, bool isPriceChangedFlag) {
    print("After getx $isPriceChangedFlag");
    print("After getx $oldFare.value");
    if (isPriceChangedFlag) {
      oldFare.value =
          oldFare.value == 0 ? fare : oldFare.value; // set oldFare if not set
      print("After getx$oldFare.value");
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
