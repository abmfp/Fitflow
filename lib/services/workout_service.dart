import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Exercise {
  final String name;
  bool isCompleted;

  Exercise({required this.name, this.isCompleted = false});
}

class WorkoutService extends ChangeNotifier {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  // The single source of truth for the weekly plan
  final List<Map<String, dynamic>> _weeklyPlan = [
    {'day': 'Monday', 'muscles': ['Chest', 'Biceps']},
    {'day': 'Tuesday', 'muscles': ['Back', 'Triceps']},
    {'day': 'Wednesday', 'muscles': ['Legs', 'Shoulders']},
    {'day': 'Thursday', 'muscles': []}, // Rest day
    {'day': 'Friday', 'muscles': ['Chest', 'Back']},
    {'day': 'Saturday', 'muscles': ['Abs']},
    {'day': 'Sunday', 'muscles': []}, // Rest day
  ];

  List<Map<String, dynamic>> get weeklyPlan => _weeklyPlan;

  // The state for the currently active workout
  List<Exercise> _currentWorkoutExercises = [];

  List<Exercise> get todaysExercises => _currentWorkoutExercises;

  // Method to get the plan for a specific day
  List<String> getMusclesForDay(DateTime date) {
    String dayOfWeek = DateFormat('EEEE').format(date); // E.g., "Wednesday"
    var planForDay = _weeklyPlan.firstWhere(
      (plan) => plan['day'] == dayOfWeek,
      orElse: () => {'muscles': []},
    );
    return List<String>.from(planForDay['muscles']);
  }

  // Method to load the exercises for the current day's workout
  void startWorkoutForDay(DateTime date) {
    List<String> muscles = getMusclesForDay(date);
    // This is placeholder logic. A real app would have a map of exercises for each muscle.
    // For now, we'll just use the muscle names as exercise names.
    _currentWorkoutExercises = muscles.map((muscle) => Exercise(name: '$muscle Workout')).toList();
    notifyListeners();
  }

  // Live stats for the CURRENT workout
  int get completedExercisesCount => _currentWorkoutExercises.where((e) => e.isCompleted).length;
  int get totalExercisesCount => _currentWorkoutExercises.length;
  double get completionPercentage => totalExercisesCount == 0 ? 0 : (completedExercisesCount / totalExercisesCount) * 100;

  void toggleExerciseCompletion(Exercise exercise) {
    exercise.isCompleted = !exercise.isCompleted;
    notifyListeners();
  }

  // Method for the PlanScreen to update the schedule
  void updatePlanForDay(String day, List<String> muscles) {
      int dayIndex = _weeklyPlan.indexWhere((plan) => plan['day'] == day);
      if (dayIndex != -1) {
        _weeklyPlan[dayIndex]['muscles'] = muscles;
        notifyListeners(); // Notify if other screens depend on the plan itself
      }
  }
}
