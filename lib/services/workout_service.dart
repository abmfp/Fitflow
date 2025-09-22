import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

part 'workout_service.g.dart';

// ... Exercise and CustomExercise models are the same ...

class WorkoutService extends ChangeNotifier {
  // ... _instance, _dataBox, etc., are the same ...

  // New getter to see today's COMPLETED workout from the history
  List<Exercise> get todaysCompletedWorkout {
    final today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _workoutHistory[today] ?? [];
  }

  Future<void> init() {
    // ... same as before, loading data from Hive ...
  }
  
  // THIS IS THE FIX for the streak count
  int finishCurrentWorkout() {
    final completedExercises = _currentWorkoutExercises.where((e) => e.isCompleted).toList();
    
    if (completedExercises.isNotEmpty) {
      final today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      _workoutHistory[today] = completedExercises;
      _historyBox.put(today.toIso8601String(), completedExercises);
    }
    
    int currentWeek = DateTime.now().weekOfYear;
    if (currentWeek != _lastWorkoutWeek) {
      _weeklyWorkoutCount = 1;
    } else {
      // Only increment if we are below the goal
      if (_weeklyWorkoutCount < 6) {
        _weeklyWorkoutCount++;
      }
    }
    
    _lastWorkoutWeek = currentWeek;
    _dataBox.put('weeklyWorkoutCount', _weeklyWorkoutCount);
    _dataBox.put('lastWorkoutWeek', _lastWorkoutWeek);
    
    _currentWorkoutExercises = [];
    notifyListeners();
    return completedExercises.length;
  }

  // ... rest of the service file is the same ...
}
