import 'dart:async';
import 'package:fitflow/screens/workout_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final WorkoutService _workoutService = WorkoutService();
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _workoutService.addListener(_onDataChanged);
    _startTimer();
  }

  @override
  void dispose() {
    _workoutService.removeListener(_onDataChanged);
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _duration = Duration(seconds: _duration.inSeconds + 1);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
      // Check if all exercises are completed after the state has been updated
      if (_workoutService.todaysExercises.isNotEmpty &&
          _workoutService.todaysExercises.every((ex) => ex.isCompleted)) {
        // Use a short delay to allow the user to see the last checkbox being ticked
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _finishWorkout();
          }
        });
      }
    }
  }

  void _showSummaryDialog(int completedCount) {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false, // User must press OK
      builder: (ctx) => AlertDialog(
        title: const Text('Workout Complete!'),
        content: Text('Great job! You completed $completedCount exercises in ${_formatDuration(_duration)}.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back from the workout screen
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
    final muscles = _workoutService.todaysExercises.map((e) => e.name.replaceAll(' Press', '')).toSet().toList();
    final title = muscles.isEmpty ? 'Current Workout' : muscles.join(' & ');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                _formatDuration(_duration),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    child: ListTile(
                      // The onTap for the ListTile now navigates to the detail screen
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: WorkoutDetailScreen(exercise: exercise),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                      // The Checkbox only handles toggling the exercise completion
                      leading: Checkbox(
                        value: exercise.isCompleted,
                        onChanged: (bool? value) {
                          _workoutService.toggleExerciseCompletion(exercise);
                        },
                        activeColor: Colors.white,
                        checkColor: const Color(0xFF1F1D2B),
                      ),
                      title: Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              decoration: exercise.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                      ),
                      trailing: const Icon(Icons.drag_handle_rounded, color: Colors.white70),
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
