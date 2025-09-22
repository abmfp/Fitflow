import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

part 'workout_service.g.dart';

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  bool isCompleted;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final String? imagePath;
  @HiveField(4)
  final String? videoPath;

  Exercise({
    required this.name,
    this.isCompleted = false,
    this.description,
    this.imagePath,
    this.videoPath,
  });
}

@HiveType(typeId: 2)
class CustomExercise extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String muscleGroup;
  @HiveField(2)
  String? imagePath;
  @HiveField(3)
  String? videoPath;
  
  CustomExercise({required this.name, required this.muscleGroup, this.imagePath, this.videoPath});
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
  int _lastWorkoutWeek = 0;

  List<Map<String, dynamic>> get weeklyPlan => _weeklyPlan;
  Map<DateTime, List<Exercise>> get workoutHistory => _workoutHistory;
  List<Exercise> get todaysExercises => _currentWorkoutExercises;
  List<CustomExercise> get customExercises => _customExercises;
  int get weeklyWorkoutCount => _weeklyWorkoutCount;

  List<Exercise> get todaysCompletedWorkout {
    final today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _workoutHistory[today] ?? [];
  }

  int get completedExercisesCount => _currentWorkoutExercises.where((e) => e.isCompleted).length;
  int get totalExercisesCount => _currentWorkoutExercises.length;
  double get completionPercentage => totalExercisesCount == 0 ? 0 : (completedExercisesCount / totalExercisesCount) * 100;

  Future<void> init() async {
    _dataBox = Hive.box('workout_data');
    _historyBox = Hive.box<List>('workout_history');
    _customExercisesBox = Hive.box<CustomExercise>('custom_exercises');

    _weeklyWorkoutCount = _dataBox.get('weeklyWorkoutCount', defaultValue: 0);
    _lastWorkoutWeek = _dataBox.get('lastWorkoutWeek', defaultValue: 0);
    
    int currentWeek = DateTime.now().weekOfYear;
    if (currentWeek != _lastWorkoutWeek) {
      _weeklyWorkoutCount = 0;
      _dataBox.put('weeklyWorkoutCount', 0);
    }

    _customExercises = _customExercisesBox.values.toList();
    
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
  
  void startWorkoutForDay(DateTime date) {
    List<String> musclesToTrain = getMusclesForDay(date);
    List<CustomExercise> availableExercises = getExercisesForMuscleGroups(musclesToTrain);

    _currentWorkoutExercises = availableExercises
        .map((customEx) => Exercise(
              name: customEx.name,
              description: "A sample description for ${customEx.name}.",
              imagePath: customEx.imagePath,
              videoPath: customEx.videoPath,
            ))
        .toList();
        
    for (var exercise in _currentWorkoutExercises) {
      exercise.isCompleted = false;
    }
    notifyListeners();
  }
  
  int finishCurrentWorkout() {
    final completedExercises = _currentWorkoutExercises.where((e) => e.isCompleted).toList();
    
    if (completedExercises.isEmpty && _currentWorkoutExercises.isNotEmpty) {
      for (var ex in _currentWorkoutExercises) { ex.isCompleted = true; }
      completedExercises.addAll(_currentWorkoutExercises);
    }
    
    if (completedExercises.isNotEmpty) {
      final today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      _workoutHistory[today] = completedExercises;
      _historyBox.put(today.toIso8601String(), completedExercises.cast<dynamic>());
    }
    
    int currentWeek = DateTime.now().weekOfYear;
    if (currentWeek != _lastWorkoutWeek) {
      _weeklyWorkoutCount = 1;
    } else {
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

  void updateCustomExercise(CustomExercise oldExercise, CustomExercise newExerciseData) {
    oldExercise.imagePath = newExerciseData.imagePath;
    oldExercise.videoPath = newExerciseData.videoPath;
    oldExercise.save();
    notifyListeners();
  }

  void deleteCustomExercise(CustomExercise exercise) {
    exercise.delete();
    _customExercises.removeWhere((ex) => ex.key == exercise.key);
    notifyListeners();
  }
}
