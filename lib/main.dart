// lib/main.dart
import 'package:fitflow/screens/home_screen.dart';
import 'package:fitflow/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Lock device orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFlow',
      theme: AppTheme.darkTheme, // Apply our custom dark theme
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
