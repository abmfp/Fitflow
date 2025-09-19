import 'package:fitflow/screens/workout_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final WorkoutService _workoutService = WorkoutService();

  void _showSummaryDialog(int completedCount) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Workout Complete!'),
        content: Text('Great job! You completed $completedCount exercises.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _finishWorkout() {
    final int completedCount = _workoutService.finishCurrentWorkout();
    _showSummaryDialog(completedCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Workout'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          onPressed: _finishWorkout,
          child: const Text('Finish Workout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _workoutService.todaysExercises.isEmpty
            ? const Center(child: Text("No workout started."))
            : ReorderableListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                itemCount: _workoutService.todaysExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _workoutService.todaysExercises[index];
                  return Card(
                    key: Key(exercise.name),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: WorkoutDetailScreen(exercise: exercise),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: CheckboxListTile(
                        title: Text(
                          exercise.name,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                decoration: exercise.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                        ),
                        value: exercise.isCompleted,
                        onChanged: (bool? value) {
                          _workoutService.toggleExerciseCompletion(exercise);
                        },
                        activeColor: Colors.white,
                        checkColor: Theme.of(context).scaffoldBackgroundColor,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final Exercise item = _workoutService.todaysExercises.removeAt(oldIndex);
                    _workoutService.todaysExercises.insert(newIndex, item);
                  });
                },
              ),
      ),
    );
  }
}
