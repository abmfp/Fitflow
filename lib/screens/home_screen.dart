import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/services/weight_service.dart';
import 'package:fitflow/screens/weight_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

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

  @override
  void initState() {
    super.initState();
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

  void _showAddWeightDialog(BuildContext context) {
    // ... dialog code is the same ...
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final List<String> todaysMuscles = _workoutService.getMusclesForDay(today);
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
                  child: Text('Get ready, ${_userService.username}', style: Theme.of(context).textTheme.displayLarge),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Here\'s your plan for ${DateFormat('EEEE').format(today)}', style: Theme.of(context).textTheme.bodyLarge),
                ),
                const SizedBox(height: 24),
                _buildWorkoutCard(context, workoutTitle, exerciseCount),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.monitor_weight_outlined,
                  title: 'Weight for ${DateFormat('d MMM').format(today)}',
                  subtitle: 'View your history',
                  trailing: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _showAddWeightDialog(context),
                  ),
                  onTap: () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const WeightHistoryScreen()));
                  },
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.local_fire_department_outlined,
                  title: 'Day ${_workoutService.weeklyWorkoutCount} / 5',
                  subtitle: 'View your progress',
                  onTap: widget.onNavigateToProgress,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ... all helper widgets (_buildWorkoutCard, _buildInfoCard, _buildDateSelector) are the same ...
}
