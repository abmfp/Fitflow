import 'package:fitflow/screens/weight_history_screen.dart';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/services/weight_service.dart';
import 'package:fitflow/utils/app_theme.dart'; // Import your theme
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'workout_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToProgress;
  const HomeScreen({super.key, required this.onNavigateToProgress});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final UserService _userService = UserService();
  final WeightService _weightService = WeightService();

  // This will now track the user's date selection
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Initialize with today's date
    // ... your listeners
  }

  // ... dispose and _onDataChanged methods are the same ...

  void _showAddWeightDialog(BuildContext context) {
    // ... same as before ...
  }

  @override
  Widget build(BuildContext context) {
    // Data now depends on _selectedDate instead of always being today
    final List<String> selectedDayMuscles = _workoutService.getMusclesForDay(_selectedDate);
    final String workoutTitle = selectedDayMuscles.isEmpty ? "Rest Day" : selectedDayMuscles.join(' & ');
    final String exerciseCount = selectedDayMuscles.length.toString();

    return Scaffold(
      body: Container(
        // Apply the gradient background here
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              // Use vertical padding only, horizontal padding will be on the cards
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pass the selected date to the selector
                  _buildDateSelector(_selectedDate),
                  const SizedBox(height: 24),
                  Padding(
                    // Reduced horizontal padding on text for a wider look
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text('Get ready, ${_userService.username}', style: Theme.of(context).textTheme.displayLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text('Here\'s your plan for ${DateFormat('EEEE').format(_selectedDate)}', style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildWorkoutCard(context, workoutTitle, exerciseCount)
                      .animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),
                  
                  // Updated the 'Weight' card to be dynamic
                  _buildInfoCard(
                    context,
                    icon: Icons.monitor_weight_outlined,
                    title: 'Weight for ${DateFormat('d MMM').format(_selectedDate)}',
                    subtitle: 'View your history',
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => _showAddWeightDialog(context),
                    ),
                    onTap: () {
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const WeightHistoryScreen()));
                    },
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),
                  
                  _buildInfoCard(
                    context,
                    icon: Icons.local_fire_department_outlined,
                    title: 'Day ${_workoutService.weeklyWorkoutCount} / 5',
                    subtitle: 'View your progress',
                    onTap: widget.onNavigateToProgress,
                  ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Update the date selector to be interactive
  Widget _buildDateSelector(DateTime selectedDate) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        // Add horizontal padding to the list itself
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = date.day == selectedDate.day && date.month == selectedDate.month;
          return GestureDetector(
            // When a date is tapped, update the state
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
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
            ),
          );
        },
      ),
    );
  }

  // Add horizontal padding to the cards to utilize the sides
  Widget _buildWorkoutCard(BuildContext context, String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card( /* ... Card content is the same ... */ ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title, required String subtitle, Widget? trailing, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card( /* ... Card content is the same ... */ ),
    );
  }
}
