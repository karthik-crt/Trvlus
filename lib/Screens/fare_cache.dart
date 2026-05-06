import 'package:flutter/foundation.dart';

class FareCache {
  static final FareCache instance = FareCache._();

  FareCache._();

  Map<DateTime, double> fareMap = {};
  bool isLoading = false;
  bool isComplete = false;

  // Add this notifier
  final ValueNotifier<int> updateNotifier = ValueNotifier(0);

  void notifyUpdate() {
    updateNotifier.value++;
  }
}
