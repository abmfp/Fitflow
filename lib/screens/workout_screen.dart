import 'package.fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package.page_transition/page_transition.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final WorkoutService _workoutService = WorkoutService();

  // New function to show the summary dialog
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
              Navigator.of(ctx).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back from the workout screen
            },
          ),
        ],
      ),
    );
  }

  void _finishWorkout() {
    // Call the service to save the workout and get the count of completed exercises
    final int completedCount = _workoutService.finishCurrentWorkout();
    // Show the summary
    _showSummaryDialog(completedCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chest & Biceps'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // The main action button is now "Finish Workout"
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
            : ReorderableListView.builder( /* ... same as before ... */ ),
      ),
    );
  }
}
