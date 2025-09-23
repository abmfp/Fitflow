import 'package:fitflow/screens/weight_history_screen.dart';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/services/weight_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fitflow/screens/workout_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fitflow/widgets/glass_card.dart';

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
    final TextEditingController weightController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        backgroundColor: const Color(0xFF252836).withOpacity(0.8),
        title: Text('Log Weight for ${DateFormat('d MMM').format(date)}'),
        content: TextField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Weight (kg)',
            suffixText: 'kg',
            labelStyle: const TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () {
              final double? weight = double.tryParse(weightController.text);
              if (weight != null) {
                _weightService.addWeight(weight, date);
              }
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
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
    final List<CustomExercise> todaysPlannedExercises = _workoutService.getExercisesForMuscleGroups(selectedDayMuscles);
    final String exerciseCount = todaysPlannedExercises.length.toString();
    final WeightEntry? weightEntry = _weightService.getWeightForDate(_selectedDate);
    final String weightDisplay = weightEntry != null ? '${weightEntry.weight} kg' : 'No Entry';
    final int streak = _workoutService.weeklyWorkoutCount;
    final String motivationalMessage = _getMotivationalMessage(streak);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 120),
          children: [
            _buildDateSelector(_selectedDate),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Get ready, ${_userService.username}', style: Theme.of(context).textTheme.displayLarge),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Here\'s your plan for ${DateFormat('EEEE').format(_selectedDate)}', style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 10),
            GlassCard(
              onTap: () {
                _workoutService.startWorkoutForDay(_selectedDate);
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const WorkoutScreen()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(workoutTitle, style: Theme.of(context).textTheme.displayMedium),
                        const SizedBox(height: 8),
                        Text('$exerciseCount exercises', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              onTap: () {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const WeightHistoryScreen()));
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.monitor_weight_outlined, color: Colors.white, size: 28),
                title: Text('Weight for ${DateFormat('d MMM').format(_selectedDate)}', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18)),
                subtitle: Text(weightDisplay, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal)),
                trailing: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _showAddWeightDialog(context, _selectedDate),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              onTap: widget.onNavigateToProgress,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.local_fire_department_outlined, color: Colors.white, size: 28),
                title: Text('Day $streak / 6', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18)),
                subtitle: Text(motivationalMessage, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal)),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),
          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = date.day == selectedDate.day && date.month == selectedDate.month;
          const Color darkTextColor = Color(0xFF1F1D2B);

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: isSelected ? null : Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).substring(0, 3),
                    style: TextStyle(color: isSelected ? darkTextColor : Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d').format(date),
                    style: TextStyle(color: isSelected ? darkTextColor : Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
