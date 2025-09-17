import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// --- MODELS ---
class Exercise { /* ... same as before ... */ }

// Model for exercises in the user's library
class CustomExercise {
  final String name;
  final String muscleGroup;
  CustomExercise({required this.name, required this.muscleGroup});
}


// --- SERVICE ---
class WorkoutService extends ChangeNotifier {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  // --- STATE ---
  final List<Map<String, dynamic>> _weeklyPlan = [ /* ... same as before ... */ ];
  final Map<DateTime, List<Exercise>> _workoutHistory = {};
  List<Exercise> _currentWorkoutExercises = [];
  
  // Centralized list for the Exercise Library
  final List<CustomExercise> _customExercises = [
    CustomExercise(name: 'Deadlifts', muscleGroup: 'Back'),
    CustomExercise(name: 'Barbell Incline Bench Press', muscleGroup: 'Chest'),
    CustomExercise(name: 'Squats', muscleGroup: 'Legs'),
    CustomExercise(name: 'Barbell Push Press', muscleGroup: 'Shoulders'),
    CustomExercise(name: 'Lat Pulldowns', muscleGroup: 'Back'),
    CustomExercise(name: 'Dumbbell Curls', muscleGroup: 'Biceps'),
  ];

  // --- GETTERS ---
  List<Map<String, dynamic>> get weeklyPlan => _weeklyPlan;
  Map<DateTime, List<Exercise>> get workoutHistory => _workoutHistory;
  List<Exercise> get todaysExercises => _currentWorkoutExercises;
  List<CustomExercise> get customExercises => _customExercises;
  int get completedExercisesCount => _currentWorkoutExercises.where((e) => e.isCompleted).length;
  int get totalExercisesCount => _currentWorkoutExercises.length;
  double get completionPercentage => totalExercisesCount == 0 ? 0 : (completedExercisesCount / totalExercisesCount) * 100;

  // --- METHODS ---
  List<String> getMusclesForDay(DateTime date) { /* ... same as before ... */ }
  void startWorkoutForDay(DateTime date) { /* ... same as before ... */ }
  int finishCurrentWorkout() { /* ... same as before ... */ }
  void toggleExerciseCompletion(Exercise exercise) { /* ... same as before ... */ }
  void updatePlanForDay(String day, List<String> muscles) { /* ... same as before ... */ }

  // New method to get specific exercises for a plan
  List<CustomExercise> getExercisesForMuscleGroups(List<String> muscles) {
    return _customExercises.where((ex) => muscles.contains(ex.muscleGroup)).toList();
  }
}
