import 'package:fitflow/screens/nav_screen.dart';
import 'package:fitflow/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const NavScreen(),
    );
  }
}
