// lib/screens/workout_screen.dart
import 'package:fitflow/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

class Exercise {
  final String name;
  bool isCompleted;

  Exercise({required this.name, this.isCompleted = false});
}

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // Sample list of exercises
  final List<Exercise> _exercises = [
    Exercise(name: 'Bench Press'),
    Exercise(name: 'Incline Dumbbell Press'),
    Exercise(name: 'Tricep Pushdowns'),
    Exercise(name: 'Overhead Tricep Extension'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chest & Triceps'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _exercises.length,
          itemBuilder: (context, index) {
            final exercise = _exercises[index];
            return Card(
              color: Colors.white.withOpacity(0.15),
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: CheckboxListTile(
                title: Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        decoration: exercise.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                ),
                value: exercise.isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    exercise.isCompleted = value ?? false;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          },
        ),
      ),
    );
  }
}
