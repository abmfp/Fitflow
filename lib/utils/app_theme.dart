import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent, // Required for gradient
    // ... all other theme properties are correct ...
  );

  static const BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF2C2B3F), Color(0xFF1F1D2B)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}
