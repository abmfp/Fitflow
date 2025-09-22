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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final UserService _userService = UserService();
  final WeightService _weightService = WeightService();

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _workoutService.addListener(_onDataChanged);
    _userService.addListener(_onDataChanged);
    _weightService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _workoutService.removeListener(_onDataChanged);
    _userService.removeListener(_onDataChanged);
    _weightService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showAddWeightDialog(BuildContext context, DateTime date) {
    // ... same as before
  }

  String _getMotivationalMessage(int streak) {
    if (streak == 0) return "Let's start the week strong!";
    if (streak < 3) return "Great start, keep it up!";
    if (streak < 5) return "You're on fire! 🔥";
    if (streak == 5) return "Almost there, finish strong!";
    return "Weekly goal achieved! 🎉";
  }

  @override
  Widget build(BuildContext context) {
    final List<String> selectedDayMuscles = _workoutService.getMusclesForDay(_selectedDate);
    final String workoutTitle = selectedDayMuscles.isEmpty ? "Rest Day" : selectedDayMuscles.join(' & ');
    
    // This is the FIX for the exercise count
    final List<CustomExercise> todaysPlannedExercises = _workoutService.getExercisesForMuscleGroups(selectedDayMuscles);
    final String exerciseCount = todaysPlannedExercises.length.toString();

    final WeightEntry? weightEntry = _weightService.getWeightForDate(_selectedDate);
    final String weightDisplay = weightEntry != null ? '${weightEntry.weight} kg' : 'No Entry';
    final int streak = _workoutService.weeklyWorkoutCount;
    final String motivationalMessage = _getMotivationalMessage(streak);

    return Scaffold(
      body: GradientContainer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            children: [
              _buildDateSelector(_selectedDate),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('Get ready, ${_userService.username}', style: Theme.of(context).textTheme.displayLarge),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('Here\'s your plan for ${DateFormat('EEEE').format(_selectedDate)}', style: Theme.of(context).textTheme.bodyLarge),
              ),
              const SizedBox(height: 24),
              _buildWorkoutCard(context, workoutTitle, exerciseCount),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                icon: Icons.monitor_weight_outlined,
                title: 'Weight for ${DateFormat('d MMM').format(_selectedDate)}',
                subtitle: weightDisplay,
                trailing: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _showAddWeightDialog(context, _selectedDate),
                ),
                onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const WeightHistoryScreen())),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                icon: Icons.local_fire_department_outlined,
                title: 'Day $streak / 6',
                subtitle: motivationalMessage,
                onTap: null, // Card is not tappable
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ... all helper methods (_buildDateSelector, _buildWorkoutCard, _buildInfoCard) are the same ...
}
