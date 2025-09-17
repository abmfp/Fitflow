import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// The updated Exercise model with details for the detail screen
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

// The service that manages workout state
class WorkoutService extends ChangeNotifier {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

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

  List<Exercise> _currentWorkoutExercises = [];
  List<Exercise> get todaysExercises => _currentWorkoutExercises;

  List<String> getMusclesForDay(DateTime date) {
    String dayOfWeek = DateFormat('EEEE').format(date);
    var planForDay = _weeklyPlan.firstWhere(
      (plan) => plan['day'] == dayOfWeek,
      orElse: () => {'muscles': []},
    );
    return List<String>.from(planForDay['muscles']);
  }

  void startWorkoutForDay(DateTime date) {
    List<String> muscles = getMusclesForDay(date);
    // Create exercises with sample descriptions for the detail screen
    _currentWorkoutExercises = muscles
        .map((muscle) => Exercise(
              name: '$muscle Press',
              description: 'A fundamental compound exercise that primarily targets the $muscle muscles. Maintain proper form for best results.',
            ))
        .toList();
    // Reset completion status when starting a new workout
    for (var exercise in _currentWorkoutExercises) {
      exercise.isCompleted = false;
    }
    notifyListeners();
  }

  int get completedExercisesCount =>
      _currentWorkoutExercises.where((e) => e.isCompleted).length;
  int get totalExercisesCount => _currentWorkoutExercises.length;
  double get completionPercentage => totalExercisesCount == 0
      ? 0
      : (completedExercisesCount / totalExercisesCount) * 100;

  void toggleExerciseCompletion(Exercise exercise) {
    exercise.isCompleted = !exercise.isCompleted;
    notifyListeners();
  }

  void updatePlanForDay(String day, List<String> muscles) {
    int dayIndex = _weeklyPlan.indexWhere((plan) => plan['day'] == day);
    if (dayIndex != -1) {
      _weeklyPlan[dayIndex]['muscles'] = muscles;
      notifyListeners();
    }
  }
}
