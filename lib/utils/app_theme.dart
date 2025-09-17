import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1F1D2B), // Dark purple background
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    fontFamily: 'Montserrat', // Ensure you add this font to your project assets
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white54),
      labelLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    
    cardTheme: CardTheme(
      color: const Color(0xFF3A384B).withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF252836),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
  );
}
