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

  // This function marks all exercises as complete.
  void _quickLogWorkout() {
    setState(() {
      for (final exercise in _exercises) {
        exercise.isCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chest & Biceps'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // NEW: A button is added to the bottom of the screen.
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          onPressed: _quickLogWorkout, // This calls the function to complete all exercises.
          child: const Text(
            'Quick Log',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ReorderableListView.builder(
          // Adjust bottom padding to ensure the list doesn't go under the button.
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          itemCount: _exercises.length,
          itemBuilder: (context, index) {
            final exercise = _exercises[index];
            return Card(
              key: Key(exercise.name),
              margin: const EdgeInsets.only(bottom: 15),
              child: CheckboxListTile(
                title: Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        decoration: exercise.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
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
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Exercise item = _exercises.removeAt(oldIndex);
              _exercises.insert(newIndex, item);
            });
          },
        ),
      ),
    );
  }
}
