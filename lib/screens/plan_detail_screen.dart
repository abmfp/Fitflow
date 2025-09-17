import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';

class PlanDetailScreen extends StatelessWidget {
  final String day;
  final List<String> muscles;

  const PlanDetailScreen({super.key, required this.day, required this.muscles});

  @override
  Widget build(BuildContext context) {
    final WorkoutService workoutService = WorkoutService();
    // Get the specific exercises for the selected muscles from our service
    final List<CustomExercise> exercises = workoutService.getExercisesForMuscleGroups(muscles);

    return Scaffold(
      appBar: AppBar(
        title: Text('Plan for $day'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: exercises.isEmpty
          ? const Center(child: Text("No exercises found for these muscle groups in your library."))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(exercise.name),
                    subtitle: Text(exercise.muscleGroup),
                  ),
                );
              },
            ),
    );
  }
}
