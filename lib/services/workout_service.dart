import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart'; // New package for week calculation

part 'workout_service.g.dart';

@HiveType(typeId: 1)
class Exercise { /* ... */ }

@HiveType(typeId: 2)
class CustomExercise { /* ... */ }

class WorkoutService extends ChangeNotifier {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  late Box _dataBox;
  late Box<List> _historyBox;
  late Box<CustomExercise> _customExercisesBox;

  // ... other state variables ...
  int _weeklyWorkoutCount = 0;
  int _lastWorkoutWeek = 0; // New variable to track the week number

  // ... getters ...
  int get weeklyWorkoutCount => _weeklyWorkoutCount;

  Future<void> init() async {
    _dataBox = Hive.box('workout_data');
    _historyBox = Hive.box<List>('workout_history');
    _customExercisesBox = Hive.box<CustomExercise>('custom_exercises');

    _weeklyWorkoutCount = _dataBox.get('weeklyWorkoutCount', defaultValue: 0);
    _lastWorkoutWeek = _dataBox.get('lastWorkoutWeek', defaultValue: 0);
    
    // Check if the week has changed since the last workout
    int currentWeek = DateTime.now().weekOfYear;
    if (currentWeek != _lastWorkoutWeek) {
      _weeklyWorkoutCount = 0; // Reset the streak
      _dataBox.put('weeklyWorkoutCount', 0);
    }

    _customExercises = _customExercisesBox.values.toList();
    
    if (_customExercises.isEmpty) {
      _addDefaultExercises();
    }

    _workoutHistory = {};
    for (var key in _historyBox.keys) {
      final date = DateTime.parse(key as String);
      final exercises = _historyBox.get(key)!.cast<Exercise>().toList();
      _workoutHistory[date] = exercises;
    }
  }

  int finishCurrentWorkout() {
    // ... logic to save workout to history ...
    
    // Update the weekly streak
    int currentWeek = DateTime.now().weekOfYear;
    if (currentWeek != _lastWorkoutWeek) {
      _weeklyWorkoutCount = 1; // Start of a new week, first workout
    } else {
      _weeklyWorkoutCount++;
    }
    
    _lastWorkoutWeek = currentWeek; // Save the current week number
    _dataBox.put('weeklyWorkoutCount', _weeklyWorkoutCount);
    _dataBox.put('lastWorkoutWeek', _lastWorkoutWeek);
    
    _currentWorkoutExercises = [];
    notifyListeners();
    return completedExercises.length;
  }
  
  // ... rest of the service file is the same ...
}
