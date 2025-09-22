import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'workout_service.g.dart';

@HiveType(typeId: 1)
class Exercise {
  // ... (content of Exercise class is the same)
}

@HiveType(typeId: 2)
class CustomExercise {
  // ... (content of CustomExercise class is the same)
}

class WorkoutService extends ChangeNotifier {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  late Box _dataBox;
  late Box<List> _historyBox;
  late Box<CustomExercise> _customExercisesBox;

  // ... (weeklyPlan, currentWorkoutExercises, etc. are the same)
  Map<DateTime, List<Exercise>> _workoutHistory = {};
  
  // ... (getters are the same)
  Map<DateTime, List<Exercise>> get workoutHistory => _workoutHistory;

  Future<void> init() async {
    _dataBox = Hive.box('workout_data');
    _historyBox = Hive.box<List>('workout_history');
    _customExercisesBox = Hive.box<CustomExercise>('custom_exercises');
    _weeklyWorkoutCount = _dataBox.get('weeklyWorkoutCount', defaultValue: 0);
    _customExercises = _customExercisesBox.values.toList();

    // This is the new logic to load saved history
    _workoutHistory = {}; // Clear in-memory map first
    for (var key in _historyBox.keys) {
      final date = DateTime.parse(key as String);
      final exercises = _historyBox.get(key)!.cast<Exercise>().toList();
      _workoutHistory[date] = exercises;
    }
  }

  // ... (The rest of the service file remains the same)
}
