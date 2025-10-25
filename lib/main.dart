import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:trvlus/utils/api_service.dart';
import 'package:trvlus/utils/app_theme.dart';

import 'Screens/FrontScreen.dart';
import 'Screens/SplashScreen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

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
    ApiService().initApiService(navigatorKey);
    // ApiService().getSearchResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Trvlus App',
            theme: AppTheme.lightTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/home': (context) => FrontScreen(),
            },
          );
        });
  }
}
