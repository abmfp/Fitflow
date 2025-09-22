import 'package:fitflow/screens/weight_history_screen.dart';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/services/weight_service.dart';
import 'package:fitflow/utils/app_theme.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'workout_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  // We no longer need the navigation callback for progress
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ... initState, dispose, _onDataChanged, and _showAddWeightDialog are the same ...

  // Helper to get a motivational message based on the streak
  String _getMotivationalMessage(int streak) {
    if (streak == 0) {
      return "Let's start the week strong!";
    } else if (streak < 3) {
      return "Great start, keep it up!";
    } else if (streak < 5) {
      return "You're on fire! 🔥";
    } else if (streak == 5) {
      return "Almost there, finish strong!";
    } else {
      return "Weekly goal achieved! 🎉";
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... data fetching logic is the same ...
    
    // Get the streak count and the message
    final int streak = _workoutService.weeklyWorkoutCount;
    final String motivationalMessage = _getMotivationalMessage(streak);

    return Scaffold(
      body: GradientContainer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            children: [
              // ... Date selector and greetings are the same ...
              
              _buildWorkoutCard(context, workoutTitle, exerciseCount)
                  .animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),
              
              _buildInfoCard(
                context,
                icon: Icons.monitor_weight_outlined,
                // ... same weight card ...
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),
              
              // This is the updated, dynamic streak card
              _buildInfoCard(
                context,
                icon: Icons.local_fire_department_outlined,
                title: 'Day $streak / 6',
                subtitle: motivationalMessage,
                onTap: null, // This card is no longer tappable
              ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  // Updated _buildInfoCard to handle a null onTap
  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title, required String subtitle, Widget? trailing, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Icon(icon, color: Colors.white, size: 28),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            trailing: trailing,
          ),
        ),
      ),
    );
  }

  // ... other helper methods are the same ...
}
