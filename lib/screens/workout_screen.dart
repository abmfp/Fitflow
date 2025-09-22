import 'package:fitflow/screens/workout_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final WorkoutService _workoutService = WorkoutService();

  // 1. Add listeners to make the screen reactive
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

  // This function tells the screen to rebuild when a checkbox is ticked
  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

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
    // Get the title dynamically from the plan
    final muscles = _workoutService.todaysExercises.map((e) => e.name.replaceAll(' Press', '')).toSet().toList();
    final title = muscles.isEmpty ? 'Current Workout' : muscles.join(' & ');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // 2. The "Finish Workout" button is now correctly placed
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1F1D2B),
          ),
          onPressed: _finishWorkout,
          child: const Text('Finish Workout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
      body: GradientContainer(
        child: _workoutService.todaysExercises.isEmpty
            ? const Center(child: Text("No workout started."))
            : ReorderableListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                      borderRadius: BorderRadius.circular(20),
                      child: CheckboxListTile(
                        title: Text(
                          exercise.name,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                decoration: exercise.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                        ),
                        value: exercise.isCompleted,
                        // 3. This now correctly calls the service
                        onChanged: (bool? value) {
                          _workoutService.toggleExerciseCompletion(exercise);
                        },
                        activeColor: Colors.white,
                        checkColor: const Color(0xFF1F1D2B),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  );
                },
                // 4. The reorder logic is now correctly implemented
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
