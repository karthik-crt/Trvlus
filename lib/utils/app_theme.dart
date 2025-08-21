import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        headlineSmall: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
        headlineLarge: TextStyle(
            fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
        bodySmall: TextStyle(
            fontSize: 10.sp, fontWeight: FontWeight.normal, color: Colors.grey),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),

      // Button Theme (Deprecated but still useful for older widgets)
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textTheme: ButtonTextTheme.primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.orange,
          side: const BorderSide(color: Colors.orange),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.black,

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70),
        labelLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),

      // Button Theme
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textTheme: ButtonTextTheme.primary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.orange,
          side: const BorderSide(color: Colors.orange),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
