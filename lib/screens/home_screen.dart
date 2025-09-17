import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'workout_screen.dart';

// HomeScreen can go back to being a StatelessWidget as it doesn't need to pass callbacks anymore
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkoutService workoutService = WorkoutService();
    // Get the current date to determine today's workout
    final DateTime today = DateTime.now();
    
    // Ask the service for today's scheduled muscles
    final List<String> todaysMuscles = workoutService.getMusclesForDay(today);
    final String workoutTitle = todaysMuscles.isEmpty ? "Rest Day" : todaysMuscles.join(' & ');
    final String exerciseCount = todaysMuscles.length.toString();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSelector(today),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Get ready, User', style: Theme.of(context).textTheme.displayLarge),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Here\'s your plan for ${DateFormat('EEEE').format(today)}', style: Theme.of(context).textTheme.bodyLarge),
                ),
                const SizedBox(height: 24),
                
                // This card is now DYNAMIC!
                _buildWorkoutCard(context, workoutTitle, exerciseCount),

                // The rest of the cards remain the same
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.monitor_weight_outlined,
                  title: 'Weight for ${DateFormat('d MMM').format(today)}',
                  subtitle: 'No Entry',
                  trailing: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.local_fire_department_outlined,
                  title: 'Day 0 / 5',
                  subtitle: 'Let\'s start the week strong!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // This card now takes parameters to display the correct workout
  Widget _buildWorkoutCard(BuildContext context, String title, String count) {
    final WorkoutService workoutService = WorkoutService();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        child: InkWell(
          onTap: () {
            // Tell the service to prepare the exercises for today before navigating
            workoutService.startWorkoutForDay(DateTime.now());
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const WorkoutScreen()));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 4),
                    Text('$count exercises', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(DateTime selectedDate) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = date.day == selectedDate.day;
          return Container(
            width: 60, margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: isSelected ? null : Border.all(color: Colors.white24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat('E').format(date).substring(0, 3), style: TextStyle(color: isSelected ? Theme.of(context).scaffoldBackgroundColor : Colors.white70, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(DateFormat('d').format(date), style: TextStyle(color: isSelected ? Theme.of(context).scaffoldBackgroundColor : Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title, required String subtitle, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: Colors.white, size: 28),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          trailing: trailing,
        ),
      ),
    );
  }
}
