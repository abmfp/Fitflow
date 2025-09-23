import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final WorkoutService _workoutService = WorkoutService();

  @override
  void initState() {
    super.initState();
    _workoutService.addListener(_onWorkoutChanged);
  }

  @override
  void dispose() {
    _workoutService.removeListener(_onWorkoutChanged);
    super.dispose();
  }

  void _onWorkoutChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showWorkoutCompleteDialog(BuildContext context, int exercisesCompleted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          backgroundColor: const Color(0xFF252836).withOpacity(0.8), // Glassy background
          title: const Text(
            'Workout Complete!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/check.json',
                repeat: false,
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 16),
              Text(
                'Great job! You finished $exercisesCompleted exercises.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop twice to go back to home
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Exercise> todaysExercises = _workoutService.todaysExercises;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Current Workout'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: todaysExercises.length,
                itemBuilder: (context, index) {
                  final exercise = todaysExercises[index];
                  return GlassCard(
                    onTap: () {
                      // Navigate to exercise detail if needed
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(exercise.name, style: Theme.of(context).textTheme.labelLarge),
                      subtitle: exercise.description != null && exercise.description!.isNotEmpty
                          ? Text(exercise.description!, style: Theme.of(context).textTheme.bodyMedium)
                          : null,
                      trailing: Checkbox(
                        value: exercise.isCompleted,
                        onChanged: (bool? value) {
                          _workoutService.toggleExerciseCompletion(exercise);
                        },
                        activeColor: Colors.white,
                        checkColor: const Color(0xFF1F1D2B),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _workoutService.todaysExercises.isNotEmpty
                    ? () {
                        int completed = _workoutService.finishCurrentWorkout();
                        _showWorkoutCompleteDialog(context, completed);
                      }
                    : null, // Disable button if no exercises
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F1D2B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Finish Workout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
