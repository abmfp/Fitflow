import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1F1D2B),
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
      error: const Color(0xFFE94560),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: const TextStyle(fontSize: 16.0, color: Colors.white70),
      bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.white54),
      labelLarge: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    cardTheme: CardThemeData( // Corrected from CardTheme
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
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white.withOpacity(0.1),
      disabledColor: Colors.grey,
      selectedColor: Colors.white,
      secondarySelectedColor: Colors.white,
      padding: const EdgeInsets.all(8.0),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      secondaryLabelStyle: const TextStyle(color: Color(0xFF1F1D2B)),
      brightness: Brightness.dark,
    )
  );
}
