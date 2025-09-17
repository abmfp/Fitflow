// lib/screens/home_screen.dart
import 'package:fitflow/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'workout_screen.dart'; // Placeholder for your workout screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, User!',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to crush your goals today? 🔥',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),
                _buildTodayWorkoutCard(context),
                const SizedBox(height: 20),
                _buildWeeklyPlanCard(context),
                const SizedBox(height: 20),
                _buildWeightTrackerCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Card for today's workout
  Widget _buildTodayWorkoutCard(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Workout', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 10),
            Text('Chest & Triceps', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade, // Fluid animation
                    child: const WorkoutScreen(),
                  ),
                );
              },
              child: const Text('Start Workout'),
            ),
          ],
        ),
      ),
    );
  }
  
  // You can build out these other cards similarly
  Widget _buildWeeklyPlanCard(BuildContext context) { return const SizedBox.shrink(); }
  Widget _buildWeightTrackerCard(BuildContext context) { return const SizedBox.shrink(); }
}
