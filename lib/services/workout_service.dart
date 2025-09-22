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
  
  final Map<DateTime, List<Exercise>> _workoutHistory = {};
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
  }

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
  
  int finishCurrentWorkout() {
    final completedExercises = _currentWorkoutExercises.where((e) => e.isCompleted).toList();
    
    if (completedExercises.isNotEmpty) {
      final today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      _workoutHistory[today] = completedExercises;
      _historyBox.put(today.toIso8601String(), completedExercises);
    }
    
    _weeklyWorkoutCount++;
    _dataBox.put('weeklyWorkoutCount', _weeklyWorkoutCount);
    
    _currentWorkoutExercises = [];
    notifyListeners();
    return completedExercises.length;
  }

  List<String> getMusclesForDay(DateTime date) {
    String dayOfWeek = DateFormat('EEEE').format(date);
    var planForDay = _weeklyPlan.firstWhere(
      (plan) => plan['day'] == dayOfWeek,
      orElse: () => {'muscles': []},
    );
    return List<String>.from(planForDay['muscles']);
  }

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

  List<CustomExercise> getExercisesForMuscleGroups(List<String> muscles) {
    return _customExercises.where((ex) => muscles.contains(ex.muscleGroup)).toList();
  }

  void addCustomExercise(CustomExercise exercise) {
    _customExercises.add(exercise);
    _customExercisesBox.add(exercise);
    notifyListeners();
  }

  void deleteCustomExercise(CustomExercise exercise) {
    _customExercises.removeWhere((ex) => ex.name == exercise.name);
    final keyToDelete = _customExercisesBox.keys.firstWhere(
      (key) {
        final ex = _customExercisesBox.get(key);
        return ex?.name == exercise.name && ex?.muscleGroup == exercise.muscleGroup;
      },
    );
    if (keyToDelete != null) {
      _customExercisesBox.delete(keyToDelete);
    }
    notifyListeners();
  }
}
