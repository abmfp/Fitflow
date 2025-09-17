import 'package:flutter/foundation.dart';

// We'll move the Exercise class here so it can be shared.
class Exercise {
  final String name;
  bool isCompleted;

  Exercise({required this.name, this.isCompleted = false});
}

// This service manages the workout state and notifies listeners of changes.
class WorkoutService extends ChangeNotifier {
  // Singleton pattern to ensure only one instance of the service exists.
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  // The state: a list of today's exercises.
  final List<Exercise> _todaysExercises = [
    Exercise(name: 'Bench Press'),
    Exercise(name: 'Incline Dumbbell Press'),
    Exercise(name: 'Dumbbell Bicep Curls'),
    Exercise(name: 'Hammer Curls'),
  ];

  // Public getter for the exercises.
  List<Exercise> get todaysExercises => _todaysExercises;

  // Getter for live stats
  int get completedExercisesCount => _todaysExercises.where((e) => e.isCompleted).length;
  int get totalExercisesCount => _todaysExercises.length;
  double get completionPercentage => totalExercisesCount == 0 ? 0 : (completedExercisesCount / totalExercisesCount) * 100;

  // Method to update an exercise's status
  void toggleExerciseCompletion(Exercise exercise) {
    exercise.isCompleted = !exercise.isCompleted;
    notifyListeners(); // This is the crucial part! It tells listening widgets to rebuild.
  }
}
