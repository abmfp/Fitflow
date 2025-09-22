import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';

class EditExerciseScreen extends StatefulWidget {
  final CustomExercise? initialExercise;
  const EditExerciseScreen({super.key, this.initialExercise});

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  final WorkoutService _workoutService = WorkoutService();
  late final TextEditingController _nameController;
  late String _selectedMuscle;
  final List<String> _muscleGroups = ['Back', 'Chest', 'Legs', 'Shoulders', 'Biceps', 'Triceps', 'Abs'];

  bool get isEditMode => widget.initialExercise != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialExercise?.name ?? '');
    _selectedMuscle = widget.initialExercise?.muscleGroup ?? _muscleGroups.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Updated save function
  void _saveExercise() {
    if (_nameController.text.isNotEmpty) {
      final newExercise = CustomExercise(
        name: _nameController.text,
        muscleGroup: _selectedMuscle,
      );
      // In a real app, you would handle editing differently,
      // but for now, we'll just add it.
      if (!isEditMode) {
        _workoutService.addCustomExercise(newExercise);
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // ... the build method is the same as before ...
  }
  // ... helper methods are the same ...
}
