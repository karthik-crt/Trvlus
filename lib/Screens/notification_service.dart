import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class NotificationService {
  static Future<void> showDownloadNotification(String fileName) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      '$fileName saved successfully!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'download_channel',
          'Downloads',
          channelDescription: 'Notifications for downloaded files',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload:
          '/storage/emulated/0/Download/$fileName', // 👈 this line makes tap work
    );
    print("Notification payload: /storage/emulated/0/Download/$fileName");
  }
}
