import 'package:fitflow/screens/nav_screen.dart';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/services/weight_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();

  Hive.registerAdapter(WeightEntryAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(CustomExerciseAdapter());

  await Hive.openBox('user_data');
  await Hive.openBox<WeightEntry>('weight_history');
  await Hive.openBox('workout_data');
  await Hive.openBox<CustomExercise>('custom_exercises');
  await Hive.openBox<List>('workout_history');

  await UserService().init();
  await WeightService().init();
  await WorkoutService().init();

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
