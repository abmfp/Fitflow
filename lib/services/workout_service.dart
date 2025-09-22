// ... imports ...
part 'workout_service.g.dart';

@HiveType(typeId: 1)
class Exercise {
  // ... fields are the same ...
  @HiveField(5) // New field
  final String? imagePath;
  @HiveField(6) // New field
  final String? videoPath;

  Exercise({
    required this.name,
    this.isCompleted = false,
    this.description,
    this.imagePath, // Add to constructor
    this.videoPath, // Add to constructor
  });
}

@HiveType(typeId: 2)
class CustomExercise extends HiveObject { // Extend HiveObject for easier updates
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String muscleGroup;
  @HiveField(2) // New field
  String? imagePath;
  @HiveField(3) // New field
  String? videoPath;
  
  CustomExercise({required this.name, required this.muscleGroup, this.imagePath, this.videoPath});
}

class WorkoutService extends ChangeNotifier {
  // ... everything else is the same until startWorkoutForDay ...

  void startWorkoutForDay(DateTime date) {
    List<String> musclesToTrain = getMusclesForDay(date);
    List<CustomExercise> availableExercises = getExercisesForMuscleGroups(musclesToTrain);

    _currentWorkoutExercises = availableExercises
        .map((customEx) => Exercise(
              name: customEx.name,
              // Copy the paths over when starting a workout
              imagePath: customEx.imagePath,
              videoPath: customEx.videoPath,
            ))
        .toList();
        
    for (var exercise in _currentWorkoutExercises) {
      exercise.isCompleted = false;
    }
    notifyListeners();
  }

  // New method to update an exercise
  void updateCustomExercise(CustomExercise oldExercise, CustomExercise newExercise) {
    final index = _customExercises.indexOf(oldExercise);
    if (index != -1) {
      _customExercises[index] = newExercise;
      oldExercise.imagePath = newExercise.imagePath;
      oldExercise.videoPath = newExercise.videoPath;
      oldExercise.save(); // Save changes to the database
      notifyListeners();
    }
  }

  // ... rest of the service is the same ...
}
