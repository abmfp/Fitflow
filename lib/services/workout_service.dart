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
  String name;
  @HiveField(1)
  String muscleGroup;
  @HiveField(2)
  String? imagePath;
  @HiveField(3)
  String? videoPath;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String subtype;
  
  CustomExercise({
    required this.name, 
    required this.muscleGroup, 
    this.imagePath, 
    this.videoPath, 
    this.description,
    required this.subtype,
  });
}

class WorkoutService extends ChangeNotifier {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  late Box _dataBox;
  late Box<List> _historyBox;
  late Box<CustomExercise> _customExercisesBox;
  
  List<Map<String, dynamic>> _weeklyPlan = [];
  Map<DateTime, List<Exercise>> _workoutHistory = {};
  List<Exercise> _currentWorkoutExercises = [];
  List<CustomExercise> _customExercises = [];
  int _weeklyWorkoutCount = 0;
  int _lastWorkoutWeek = 0;
  late DateTime _activeWorkoutDate;

  List<Map<String, dynamic>> get weeklyPlan => _weeklyPlan;
  Map<DateTime, List<Exercise>> get workoutHistory => _workoutHistory;
  List<Exercise> get todaysExercises => _currentWorkoutExercises;
  List<CustomExercise> get customExercises => _customExercises;
  int get weeklyWorkoutCount => _weeklyWorkoutCount;

  List<Exercise> get todaysCompletedWorkout {
    final today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _workoutHistory[today] ?? [];
  }
  
  int get workoutsThisMonth {
    final now = DateTime.now();
    return _workoutHistory.keys
        .where((date) => date.year == now.year && date.month == now.month)
        .length;
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
    
    var savedPlan = _dataBox.get('weeklyPlan');
    if (savedPlan == null) {
      _weeklyPlan = _getDefaultPlan();
      await _dataBox.put('weeklyPlan', _weeklyPlan);
    } else {
      _weeklyPlan = List<Map<String, dynamic>>.from(savedPlan.map((item) => Map<String, dynamic>.from(item)));
    }
    
    int currentWeek = DateTime.now().weekOfYear;
    if (currentWeek != _lastWorkoutWeek) {
      _weeklyWorkoutCount = 0;
      await _dataBox.put('weeklyWorkoutCount', 0);
    }

    _customExercises = _customExercisesBox.values.toList();
    
    if (_customExercises.isEmpty) {
      await _addDefaultExercises();
    }

    _workoutHistory = {};
    for (var key in _historyBox.keys) {
      try {
        final date = DateTime.parse(key as String);
        final exercises = _historyBox.get(key)!.map((e) => e as Exercise).toList();
        _workoutHistory[date] = exercises;
      } catch (e) {
        print("Error loading history for key $key: $e");
      }
    }
  }

  List<Map<String, dynamic>> _getDefaultPlan() {
    return [
      {'day': 'Monday', 'muscles': ['Chest', 'Biceps']},
      {'day': 'Tuesday', 'muscles': ['Back', 'Triceps']},
      {'day': 'Wednesday', 'muscles': ['Legs', 'Shoulders']},
      {'day': 'Thursday', 'muscles': []},
      {'day': 'Friday', 'muscles': ['Chest', 'Back']},
      {'day': 'Saturday', 'muscles': ['Abs']},
      {'day': 'Sunday', 'muscles': []},
    ];
  }

  Future<void> _addDefaultExercises() async {
    final defaultExercises = [
        CustomExercise(name: 'Deadlifts', muscleGroup: 'Back', subtype: 'Subtype 1', description: 'A powerful full-body exercise.'),
        CustomExercise(name: 'Lat Pulldowns', muscleGroup: 'Back', subtype: 'Subtype 2', description: 'Great for building a wide back.'),
        CustomExercise(name: 'Barbell Bench Press', muscleGroup: 'Chest', subtype: 'Subtype 1', description: 'Targets the middle chest.'),
        CustomExercise(name: 'Dumbbell Flyes', muscleGroup: 'Chest', subtype: 'Subtype 2', description: 'Focuses on chest isolation.'),
        CustomExercise(name: 'Squats', muscleGroup: 'Legs', subtype: 'Subtype 1', description: 'The ultimate lower body workout.'),
        CustomExercise(name: 'Leg Curls', muscleGroup: 'Legs', subtype: 'Subtype 2', description: 'Isolates the hamstrings.'),
    ];
    await _customExercisesBox.addAll(defaultExercises);
    _customExercises = defaultExercises;
  }
  
  void startWorkoutForDay(DateTime date) {
    _activeWorkoutDate = date;
    List<String> musclesToTrain = getMusclesForDay(date);
    List<CustomExercise> availableExercises = getExercisesForMuscleGroups(musclesToTrain);

    _currentWorkoutExercises = availableExercises
        .map((customEx) => Exercise(
              name: customEx.name,
              description: customEx.description,
              imagePath: customEx.imagePath,
              videoPath: customEx.videoPath,
            ))
        .toList();
        
    for (var exercise in _currentWorkoutExercises) {
      exercise.isCompleted = false;
    }
    notifyListeners();
  }
  
  Future<void> finishCurrentWorkout() async {
    final completedExercises = _currentWorkoutExercises.where((e) => e.isCompleted).toList();
    
    if (completedExercises.isEmpty && _currentWorkoutExercises.isNotEmpty) {
      for (var ex in _currentWorkoutExercises) { ex.isCompleted = true; }
      completedExercises.addAll(_currentWorkoutExercises);
    }
    
    if (completedExercises.isNotEmpty) {
      final dateToLog = DateTime.utc(_activeWorkoutDate.year, _activeWorkoutDate.month, _activeWorkoutDate.day);
      _workoutHistory[dateToLog] = completedExercises;
      await _historyBox.put(dateToLog.toIso8601String(), completedExercises);
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
    await _dataBox.put('weeklyWorkoutCount', _weeklyWorkoutCount);
    await _dataBox.put('lastWorkoutWeek', _lastWorkoutWeek);
    
    _currentWorkoutExercises = [];
    notifyListeners();
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

  Future<void> updatePlanForDay(String day, List<String> muscles) async {
    int dayIndex = _weeklyPlan.indexWhere((plan) => plan['day'] == day);
    if (dayIndex != -1) {
      _weeklyPlan[dayIndex]['muscles'] = muscles;
      await _dataBox.put('weeklyPlan', _weeklyPlan);
      notifyListeners();
    }
  }

  List<CustomExercise> getExercisesForMuscleGroups(List<String> muscles) {
    return _customExercises.where((ex) => muscles.contains(ex.muscleGroup)).toList();
  }

  Future<void> addCustomExercise(CustomExercise exercise) async {
    await _customExercisesBox.add(exercise);
    _customExercises.add(exercise);
    notifyListeners();
  }

  Future<void> updateCustomExercise(CustomExercise oldExercise, CustomExercise newExerciseData) async {
    oldExercise.name = newExerciseData.name;
    oldExercise.muscleGroup = newExerciseData.muscleGroup;
    oldExercise.subtype = newExerciseData.subtype;
    oldExercise.description = newExerciseData.description;
    oldExercise.imagePath = newExerciseData.imagePath;
    oldExercise.videoPath = newExerciseData.videoPath;
    await oldExercise.save();
    notifyListeners();
  }

  Future<void> deleteCustomExercise(CustomExercise exercise) async {
    await exercise.delete();
    _customExercises.removeWhere((ex) => ex.key == exercise.key);
    notifyListeners();
  }

  Future<void> deleteWorkoutHistory(DateTime date) async {
    final dateKey = DateTime.utc(date.year, date.month, date.day);
    final stringKey = dateKey.toIso8601String();

    _workoutHistory.remove(dateKey);
    await _historyBox.delete(stringKey);
    
    notifyListeners();
  }
}
