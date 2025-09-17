import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1F1D2B),
    brightness: Brightness.dark,
    primaryColor: Colors.white,

    // Apply Poppins to the entire text theme
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      // Override specific styles to match our design
      displayLarge: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: const TextStyle(fontSize: 16.0, color: Colors.white70),
      bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.white54),
      labelLarge: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    
    // Card theme with opacity for the glassmorphism effect
    cardTheme: CardTheme(
      color: const Color(0xFF3A384B).withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF252836),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    
    // Theme for FilterChip used in the edit dialog
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
