import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Exercise {
  final String name;
  bool isCompleted;
  final String? description;
  final String? imageUrl;
  final String? videoUrl;

  Exercise({
    required this.name,
    this.isCompleted = false,
    this.description,
    this.imageUrl,
    this.videoUrl,
  });
}

class WorkoutService extends ChangeNotifier {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  final List<Map<String, dynamic>> _weeklyPlan = [
    {'day': 'Monday', 'muscles': ['Chest', 'Biceps']},
    {'day': 'Tuesday', 'muscles': ['Back', 'Triceps']},
    {'day': 'Wednesday', 'muscles': ['Legs', 'Shoulders']},
    {'day': 'Thursday', 'muscles': []},
    {'day': 'Friday', 'muscles': ['Chest', 'Back']},
    {'day': 'Saturday', 'muscles': ['Abs']},
    {'day': 'Sunday', 'muscles': []},
  ];

  // This map will store your actual completed workout history
  final Map<DateTime, List<Exercise>> _workoutHistory = {};

  List<Map<String, dynamic>> get weeklyPlan => _weeklyPlan;
  Map<DateTime, List<Exercise>> get workoutHistory => _workoutHistory;

  List<Exercise> _currentWorkoutExercises = [];
  List<Exercise> get todaysExercises => _currentWorkoutExercises;

  void startWorkoutForDay(DateTime date) {
    List<String> muscles = getMusclesForDay(date);
    _currentWorkoutExercises = muscles
        .map((muscle) => Exercise(
              name: '$muscle Press',
              description: 'A fundamental compound exercise that primarily targets the $muscle muscles. Maintain proper form for best results.',
            ))
        .toList();
    for (var exercise in _currentWorkoutExercises) {
      exercise.isCompleted = false;
    }
    notifyListeners();
  }
  
  // New method to finish and save the workout
  int finishCurrentWorkout() {
    final completedExercises = _currentWorkoutExercises.where((e) => e.isCompleted).toList();
    
    if (completedExercises.isNotEmpty) {
      final today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      _workoutHistory[today] = completedExercises;
    }
    
    _currentWorkoutExercises = []; // Clear the current workout
    notifyListeners(); // Notify listeners (like the history screen)
    return completedExercises.length;
  }

  // --- Getters and other methods ---
  List<String> getMusclesForDay(DateTime date) { /* ... same as before ... */ }
  int get completedExercisesCount => _currentWorkoutExercises.where((e) => e.isCompleted).length;
  int get totalExercisesCount => _currentWorkoutExercises.length;
  double get completionPercentage => totalExercisesCount == 0 ? 0 : (completedExercisesCount / totalExercisesCount) * 100;
  void toggleExerciseCompletion(Exercise exercise) { /* ... same as before ... */ }
  void updatePlanForDay(String day, List<String> muscles) { /* ... same as before ... */ }
}
