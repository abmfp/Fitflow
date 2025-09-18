import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package.page_transition/page_transition.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});
  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final WorkoutService _workoutService = WorkoutService();

  // We add listeners so the screen updates if an exercise is added/removed
  @override
  void initState() {
    super.initState();
    _workoutService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _workoutService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    setState(() {});
  }
  
  Map<String, List<CustomExercise>> get _groupedExercises {
    final Map<String, List<CustomExercise>> grouped = {};
    // Get the exercise list from the service
    for (var exercise in _workoutService.customExercises) {
      (grouped[exercise.muscleGroup] ??= []).add(exercise);
    }
    return grouped;
  }
  
  // The rest of the functions (_navigateToAdd, _delete, etc.) remain the same
  void _navigateToAddExercise() { /* ... */ }
  void _navigateToEditExercise(CustomExercise exercise) { /* ... */ }
  void _deleteExercise(CustomExercise exercise) { /* ... */ }

  @override
  Widget build(BuildContext context) {
    // ... the build method is the same, but now gets data from _groupedExercises
    // which in turn gets data from the service.
  }
}
