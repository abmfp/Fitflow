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
  final List<Exercise> _exercises = [
    Exercise(name: 'Bench Press'),
    Exercise(name: 'Incline Dumbbell Press'),
    Exercise(name: 'Dumbbell Bicep Curls'),
    Exercise(name: 'Hammer Curls'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chest & Biceps'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _exercises.length,
          itemBuilder: (context, index) {
            final exercise = _exercises[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
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
                activeColor: Colors.white,
                checkColor: Theme.of(context).scaffoldBackgroundColor,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          },
        ),
      ),
    );
  }
}
