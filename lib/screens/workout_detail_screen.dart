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

  Widget _buildMediaPlaceholder(BuildContext context) { /* ... */ }
  Widget _buildInfoCard(BuildContext context) { /* ... */ }
}
