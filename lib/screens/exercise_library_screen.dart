import 'package:fitflow/screens/edit_exercise_screen.dart'; // Import the new screen
import 'package:flutter/material.dart';
import 'package.page_transition/page_transition.dart';

class CustomExercise {
  final String name;
  final String muscleGroup;
  CustomExercise({required this.name, required this.muscleGroup});
}

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});
  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final List<CustomExercise> _exercises = [
    CustomExercise(name: 'Deadlifts', muscleGroup: 'Back'),
    CustomExercise(name: 'Barbell Incline Bench Press', muscleGroup: 'Chest'),
    CustomExercise(name: 'Squats', muscleGroup: 'Legs'),
    CustomExercise(name: 'Barbell Push Press', muscleGroup: 'Shoulders'),
    CustomExercise(name: 'Lat Pulldowns', muscleGroup: 'Back'),
  ];

  Map<String, List<CustomExercise>> get _groupedExercises {
    final Map<String, List<CustomExercise>> grouped = {};
    for (var exercise in _exercises) {
      (grouped[exercise.muscleGroup] ??= []).add(exercise);
    }
    return grouped;
  }

  // Navigate to add a new exercise
  void _navigateToAddExercise() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const EditExerciseScreen(), // Don't pass an exercise, so it's in "Add" mode
      ),
    );
  }

  // Navigate to edit an existing exercise
  void _navigateToEditExercise(CustomExercise exercise) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: EditExerciseScreen(initialExercise: exercise), // Pass the exercise to edit
      ),
    );
  }

  void _deleteExercise(CustomExercise exercise) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${exercise.name}"?'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onPressed: () {
              setState(() { _exercises.remove(exercise); });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExercise, // Updated this line
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Theme.of(context).scaffoldBackgroundColor),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: muscleGroups.length,
        itemBuilder: (context, index) {
          final muscleGroup = muscleGroups[index];
          final exercisesInGroup = grouped[muscleGroup]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Text(muscleGroup, style: Theme.of(context).textTheme.displayMedium),
              ),
              ...exercisesInGroup.map((exercise) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(exercise.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => _navigateToEditExercise(exercise), // Updated this line
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 20, color: Theme.of(context).colorScheme.error),
                          onPressed: () => _deleteExercise(exercise),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
