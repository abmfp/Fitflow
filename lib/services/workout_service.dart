import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'workout_service.g.dart';

@HiveType(typeId: 1)
class Exercise {
  @HiveField(0)
  final String name;
  @HiveField(1)
  bool isCompleted;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final String? videoUrl;

  Exercise({
    required this.name,
    this.isCompleted = false,
    this.description,
    this.imageUrl,
    this.videoUrl,
  });
}

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
  late Box<CustomExercise> _customExercisesBox;

  final List<Map<String, dynamic>> _weeklyPlan = [
    {'day': 'Monday', 'muscles': ['Chest', 'Biceps']},
    {'day': 'Tuesday', 'muscles': ['Back', 'Triceps']},
    {'day': 'Wednesday', 'muscles': ['Legs', 'Shoulders']},
    {'day': 'Thursday', 'muscles': []},
    {'day': 'Friday', 'muscles': ['Chest', 'Back']},
    {'day': 'Saturday', 'muscles': ['Abs']},
    {'day': 'Sunday', 'muscles': []},
  ];
  
  Map<DateTime, List<Exercise>> _workoutHistory = {};
  List<Exercise> _currentWorkoutExercises = [];
  List<CustomExercise> _customExercises = [];
  int _weeklyWorkoutCount = 0;

  List<Map<String, dynamic>> get weeklyPlan => _weeklyPlan;
  Map<DateTime, List<Exercise>> get workoutHistory => _workoutHistory;
  List<Exercise> get todaysExercises => _currentWorkoutExercises;
  List<CustomExercise> get customExercises => _customExercises;
  int get weeklyWorkoutCount => _weeklyWorkoutCount;
  int get completedExercisesCount => _currentWorkoutExercises.where((e) => e.isCompleted).length;
  int get totalExercisesCount => _currentWorkoutExercises.length;
  double get completionPercentage => totalExercisesCount == 0 ? 0 : (completedExercisesCount / totalExercisesCount) * 100;

  Future<void> init() async {
    _dataBox = Hive.box('workout_data');
    _historyBox = Hive.box<List>('workout_history');
    _customExercisesBox = Hive.box<CustomExercise>('custom_exercises');

    _weeklyWorkoutCount = _dataBox.get('weeklyWorkoutCount', defaultValue: 0);
    _customExercises = _customExercisesBox.values.toList();
    
    // Add default exercises if the library is empty
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

  void _addDefaultExercises() {
    final defaultExercises = [
        CustomExercise(name: 'Deadlifts', muscleGroup: 'Back'),
        CustomExercise(name: 'Barbell Incline Bench Press', muscleGroup: 'Chest'),
        CustomExercise(name: 'Squats', muscleGroup: 'Legs'),
        CustomExercise(name: 'Barbell Push Press', muscleGroup: 'Shoulders'),
        CustomExercise(name: 'Lat Pulldowns', muscleGroup: 'Back'),
        CustomExercise(name: 'Dumbbell Curls', muscleGroup: 'Biceps'),
    ];
    for (var ex in defaultExercises) {
      _customExercisesBox.add(ex);
    }
    _customExercises = defaultExercises;
  }
  
  void startWorkoutForDay(DateTime date) { /* ... same as before ... */ }
  int finishCurrentWorkout() { /* ... same as before ... */ }
  List<String> getMusclesForDay(DateTime date) { /* ... same as before ... */ }
  void toggleExerciseCompletion(Exercise exercise) { /* ... same as before ... */ }
  void updatePlanForDay(String day, List<String> muscles) { /* ... same as before ... */ }
  List<CustomExercise> getExercisesForMuscleGroups(List<String> muscles) { /* ... same as before ... */ }
  void addCustomExercise(CustomExercise exercise) { /* ... same as before ... */ }
  void deleteCustomExercise(CustomExercise exercise) { /* ... same as before ... */ }
}
