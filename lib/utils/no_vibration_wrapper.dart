import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoVibrationWrapper extends StatefulWidget {
  final Widget child;

  const NoVibrationWrapper({super.key, required this.child});

  @override
  State<NoVibrationWrapper> createState() => _NoVibrationWrapperState();
}

class _NoVibrationWrapperState extends State<NoVibrationWrapper> {
  @override
  void initState() {
    super.initState();
    // ✅ Block vibration for this widget’s lifetime
    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == 'HapticFeedback.vibrate') {
        // Just return to ignore vibration
        return;
      }
    });
  }

  @override
  void dispose() {
    // ✅ Restore default behavior when leaving the screen
    SystemChannels.platform.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
