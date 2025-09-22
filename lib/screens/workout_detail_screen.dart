import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const WorkoutDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMediaPlaceholder(context),
              const SizedBox(height: 30),
              Text('Description', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 10),
              Text(
                exercise.description ?? 'No description available for this exercise.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 30),
              _buildInfoCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPlaceholder(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            color: Colors.white54,
            size: 80,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('3', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 4),
                Text('Sets', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            Column(
              children: [
                Text('12', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 4),
                Text('Reps', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
