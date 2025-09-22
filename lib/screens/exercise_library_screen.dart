import 'package:fitflow/screens/edit_exercise_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/gradient_container.dart'; // 1. Add this import
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});
  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final WorkoutService _workoutService = WorkoutService();

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
    if (mounted) {
      setState(() {});
    }
  }
  
  Map<String, List<CustomExercise>> get _groupedExercises {
    final Map<String, List<CustomExercise>> grouped = {};
    for (var exercise in _workoutService.customExercises) {
      (grouped[exercise.muscleGroup] ??= []).add(exercise);
    }
    return grouped;
  }
  
  // ... _navigateToAdd, _navigateToEdit, _deleteExercise methods are the same
  
  @override
  Widget build(BuildContext context) {
    final grouped = _groupedExercises;
    final muscleGroups = grouped.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton( /* ... */ ),
      // 2. Wrap the body with GradientContainer
      body: GradientContainer(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: muscleGroups.length,
          itemBuilder: (context, index) {
            // ... The rest of the builder code is the same
          },
        ),
      ),
    );
  }
}
