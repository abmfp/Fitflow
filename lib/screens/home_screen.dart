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
        title: Text('Log Weight for ${DateFormat('d MMM').format(date)}'),
        content: TextField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Weight (kg)', suffixText: 'kg'),
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Save'),
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

  @override
  Widget build(BuildContext context) {
    final List<String> selectedDayMuscles = _workoutService.getMusclesForDay(_selectedDate);
    final String workoutTitle = selectedDayMuscles.isEmpty ? "Rest Day" : selectedDayMuscles.join(' & ');
    final String exerciseCount = selectedDayMuscles.length.toString();
    final WeightEntry? weightEntry = _weightService.getWeightForDate(_selectedDate);
    final String weightDisplay = weightEntry != null ? '${weightEntry.weight} kg' : 'No Entry';

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
              
              _buildWorkoutCard(context, workoutTitle, exerciseCount)
                  .animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

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
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
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

  Widget _buildWorkoutCard(BuildContext context, String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        child: InkWell(
          onTap: () {
            // This is the important change: pass the selected date to the service
            _workoutService.startWorkoutForDay(_selectedDate); 
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const WorkoutScreen()));
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.displayMedium),
                      const SizedBox(height: 4),
                      Text('$count exercises', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}
