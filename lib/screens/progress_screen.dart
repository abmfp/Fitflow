import 'package:fitflow/services/weight_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/screens/weight_history_screen.dart';
import 'package:fitflow/screens/workout_history_screen.dart';
import 'package:fitflow/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:page_transition/page_transition.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final WeightService _weightService = WeightService();

  @override
  void initState() {
    super.initState();
    _workoutService.addListener(_onDataChanged);
    _weightService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _workoutService.removeListener(_onDataChanged);
    _weightService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Progress', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 30),
                _buildSectionTitle(context, 'Weight Analytics'),
                _buildWeightAnalyticsCard(context),
                const SizedBox(height: 10),
                _buildSectionTitle(context, "Today's Stats"),
                _buildTodayStatsCard(context),
                const SizedBox(height: 10),
                _buildSectionTitle(context, 'Workout Streak'),
                _buildWorkoutStreakCalendar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) =>
      Padding(
        padding: const EdgeInsets.only(left: 24.0, bottom: 5),
        child: Text(title, style: Theme.of(context).textTheme.displayMedium),
      );

  Widget _buildWeightAnalyticsCard(BuildContext context) {
    final List<FlSpot> weightData = _weightService.weightChartData;
    final navigateToHistory = () {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const WeightHistoryScreen(),
        ),
      );
    };

    if (weightData.isEmpty) {
      return GlassCard(
        onTap: navigateToHistory,
        child: SizedBox(
          width: double.infinity,
          height: 120,
          child: Center(
            child: Text(
              'Log more to see your chart!\n(Tap here for details)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
        ),
      );
    } else {
      return GlassCard(
        onTap: navigateToHistory,
        child: AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: weightData,
                  isCurved: true,
                  color: Colors.white,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildTodayStatsCard(BuildContext context) {
    final completedWorkout = _workoutService.todaysCompletedWorkout;
    bool workoutIsFinished = completedWorkout.isNotEmpty;
    
    final int exercisesDone = workoutIsFinished ? completedWorkout.length : _workoutService.completedExercisesCount;
    final int totalExercises = workoutIsFinished ? completedWorkout.length : _workoutService.totalExercisesCount;
    final double completion = totalExercises == 0 ? 0 : (exercisesDone / totalExercises) * 100;

    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            '$exercisesDone / $totalExercises',
            'Exercises Done',
          ),
          _buildStatItem(
            context,
            '${completion.toStringAsFixed(0)}%',
            'Completion',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildWorkoutStreakCalendar(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: const WorkoutHistoryScreen()));
      },
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        headerVisible: true,
        calendarFormat: CalendarFormat.month,
        eventLoader: (day) {
          return _workoutService.workoutHistory[DateTime.utc(day.year, day.month, day.day)] ?? [];
        },
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: Theme.of(context).textTheme.labelLarge!,
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white),
          todayDecoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
          markerDecoration: BoxDecoration(color: Theme.of(context).colorScheme.error, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
