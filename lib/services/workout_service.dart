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

  final List<Map<String, dynamic>> _weeklyPlan = [ /* ... same plan data ... */ ];
  Map<DateTime, List<Exercise>> _workoutHistory = {};
  List<Exercise> _currentWorkoutExercises = [];
  List<CustomExercise> _customExercises = [];
  int _weeklyWorkoutCount = 0;

  List<Map<String, dynamic>> get weeklyPlan => _weeklyPlan;
  Map<DateTime, List<Exercise>> get workoutHistory => _workoutHistory;
  List<Exercise> get todaysExercises => _currentWorkoutExercises;
  List<CustomExercise> get customExercises => _customExercises;
  int get weeklyWorkoutCount => _weeklyWorkoutCount;

  Future<void> init() async {
    _dataBox = Hive.box('workout_data');
    _historyBox = Hive.box<List>('workout_history');
    _weeklyWorkoutCount = _dataBox.get('weeklyWorkoutCount', defaultValue: 0);
    // In a full app, you would also load _weeklyPlan and _customExercises from the database
  }

  int finishCurrentWorkout() {
    final completedExercises = _currentWorkoutExercises.where((e) => e.isCompleted).toList();
    
    if (completedExercises.isNotEmpty) {
      final today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      _workoutHistory[today] = completedExercises;
      _historyBox.put(today.toIso8601String(), completedExercises); // Save to DB
    }
    
    _weeklyWorkoutCount++;
    _dataBox.put('weeklyWorkoutCount', _weeklyWorkoutCount); // Save to DB
    
    _currentWorkoutExercises = [];
    notifyListeners();
    return completedExercises.length;
  }
  
  // ... other methods like startWorkoutForDay, toggleExerciseCompletion, etc., remain the same ...
}
