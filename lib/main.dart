import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trvlus/utils/api_service.dart';
import 'package:trvlus/utils/app_theme.dart';

import 'Screens/FrontScreen.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/price_alert_controller.dart';
import 'Screens/price_alert_wrapper.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _requestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.status;
  print("Notification permission status: $status");
  if (!status.isGranted) {
    status = await Permission.notification.request();
  }

  if (status.isGranted) {
    //SharedPreferenceHelper.setString('notification_permission', 'agree');
    print("Notification permission granted");
    //await initialDialogLocation();
  } else {
    //SharedPreferenceHelper.setString('notification_permission', 'denied');
    if (status.isPermanentlyDenied) {
      //_showNotificationPermissionDeniedDialog();
    } else {
      // await initialDialogLocation();
    }
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/app_logo');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
  ));

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      debugPrint("Notification tapped! Response payload: ${response.payload}");
      final String? filePath = response.payload;
      if (filePath != null && filePath.isNotEmpty) {
        await OpenFilex.open(filePath);
      }
    },
  );
  await _requestNotificationPermission();

  // ✅ Handle case when app is launched from notification
  final NotificationAppLaunchDetails? details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (details?.didNotificationLaunchApp ?? false) {
    final String? filePath = details?.notificationResponse?.payload;
    if (filePath != null && filePath.isNotEmpty) {
      await OpenFilex.open(filePath);
    }
  }
  Get.put(PriceAlertController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    ApiService().initApiService(navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Trvlus App',
          theme: AppTheme.lightTheme,
          initialRoute: '/',
          builder: (context, child) {
            return PriceAlertWrapper(child: child!);
          },
          routes: {
            '/': (context) => SplashScreen(),
            '/home': (context) => FrontScreen(),
          },
        );
      },
    );
  }
}
