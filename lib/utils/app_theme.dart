import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define the solid background color based on your screenshot
  static const Color primaryBackgroundColor = Color(0xFF4e54c8); 

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: primaryBackgroundColor, // Use solid color here
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
      error: const Color(0xFFE94560),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: const TextStyle(fontSize: 16.0, color: Colors.white70, fontWeight: FontWeight.w500),
      bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.white54),
      labelLarge: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withOpacity(0.15), // Slightly increased opacity for better contrast
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF252836), // Keeping this as a dark shade for contrast
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

  // We no longer need a gradient background, as we're using a solid color
  // The GradientContainer will be updated to use AppTheme.primaryBackgroundColor
  // static const BoxDecoration gradientBackground = BoxDecoration(...); // REMOVE THIS
}
