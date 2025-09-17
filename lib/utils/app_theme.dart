// lib/utils/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Dark blue background
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFE94560),
    fontFamily: 'Montserrat', // Make sure to add this font to your project
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white70),
      labelLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE94560),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );

  static const BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF16222A), Color(0xFF3A6073)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
