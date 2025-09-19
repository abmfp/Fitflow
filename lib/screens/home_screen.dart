import 'package:fitflow/screens/weight_history_screen.dart';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/services/weight_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'workout_screen.dart';

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
    final TextEditingController weightController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Your Weight'),
        content: TextField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Weight (kg)',
            suffixText: 'kg',
          ),
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              final double? weight = double.tryParse(weightController.text);
              if (weight != null) {
                _weightService.addWeight(weight);
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

  Widget _buildWorkoutCard(BuildContext context, String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        child: InkWell(
          onTap: () {
            _workoutService.startWorkoutForDay(DateTime.now());
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

  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title, required String subtitle, Widget? trailing, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ListTile(
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
