import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'workout_service.g.dart';

@HiveType(typeId: 1)
class Exercise { /* ... same as before ... */ }

@HiveType(typeId: 2)
class CustomExercise {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String muscleGroup;
  CustomExercise({required this.name, required this.muscleGroup});
}

class WorkoutService extends ChangeNotifier {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  late Box _dataBox;
  late Box<List> _historyBox;
  late Box<CustomExercise> _customExercisesBox; // Box for custom exercises

  List<Map<String, dynamic>> _weeklyPlan = [ /* ... */ ];
  Map<DateTime, List<Exercise>> _workoutHistory = {};
  List<Exercise> _currentWorkoutExercises = [];
  List<CustomExercise> _customExercises = [];
  int _weeklyWorkoutCount = 0;

  List<Map<String, dynamic>> get weeklyPlan => _weeklyPlan;
  Map<DateTime, List<Exercise>> get workoutHistory => _workoutHistory;
  List<Exercise> get todaysExercises => _currentWorkoutExercises;
  List<CustomExercise> get customExercises => _customExercises;
  int get weeklyWorkoutCount => _weeklyWorkoutCount;
  
  // ... other getters are the same ...

  Future<void> init() async {
    _dataBox = Hive.box('workout_data');
    _historyBox = Hive.box<List>('workout_history');
    _customExercisesBox = Hive.box<CustomExercise>('custom_exercises');
    _weeklyWorkoutCount = _dataBox.get('weeklyWorkoutCount', defaultValue: 0);
    _customExercises = _customExercisesBox.values.toList();
  }

  // --- New Methods to Add and Delete Custom Exercises ---
  void addCustomExercise(CustomExercise exercise) {
    _customExercises.add(exercise);
    _customExercisesBox.add(exercise); // Save to database
    notifyListeners();
  }

  void deleteCustomExercise(CustomExercise exercise) {
    _customExercises.removeWhere((ex) => ex.name == exercise.name);
    // Find the correct key in the box to delete
    final keyToDelete = _customExercisesBox.keys.firstWhere(
      (key) {
        final ex = _customExercisesBox.get(key);
        return ex?.name == exercise.name && ex?.muscleGroup == exercise.muscleGroup;
      },
    );
    if (keyToDelete != null) {
      _customExercisesBox.delete(keyToDelete); // Delete from database
    }
    notifyListeners();
  }
  
  // ... all other methods (startWorkoutForDay, finishCurrentWorkout, etc.) are the same ...
}
