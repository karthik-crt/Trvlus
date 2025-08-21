import 'package:get/get.dart';

class AuthController extends GetxController {
  var mobileNumber = ''.obs;

  void setMobileNumber(String number) {
    mobileNumber.value = number;
  }
}
