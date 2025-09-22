import 'package:fitflow/services/weight_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/screens/weight_history_screen.dart';
import 'package:fitflow/screens/workout_history_screen.dart';
import 'package:fitflow/widgets/gradient_container.dart';
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
      body: GradientContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Progress', style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 30),
                  _buildSectionTitle(context, 'Weight Analytics'),
                  const SizedBox(height: 15),
                  _buildWeightAnalyticsCard(context),
                  const SizedBox(height: 30),
                  _buildSectionTitle(context, "Today's Stats"),
                  const SizedBox(height: 15),
                  _buildTodayStatsCard(context),
                  const SizedBox(height: 30),
                  _buildSectionTitle(context, 'Workout Streak'),
                  const SizedBox(height: 15),
                  _buildWorkoutStreakCalendar(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) =>
      Text(title, style: Theme.of(context).textTheme.displayMedium);

  Widget _buildWeightAnalyticsCard(BuildContext context) {
    final List<FlSpot> weightData = _weightService.weightChartData;

    void navigateToHistory() {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const WeightHistoryScreen(),
        ),
      );
    }

    if (weightData.isEmpty) {
      return Card(
        child: InkWell(
          onTap: navigateToHistory,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Center(
              child: Text(
                'Log more to see your chart!\n(Tap here for details)',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
            ),
          ),
        ),
      );
    } else {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: navigateToHistory,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
          ),
        ),
      );
    }
  }

  Widget _buildTodayStatsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              '${_workoutService.completedExercisesCount} / ${_workoutService.totalExercisesCount}',
              'Exercises Done',
            ),
            _buildStatItem(
              context,
              '${_workoutService.completionPercentage.toStringAsFixed(0)}%',
              'Completion',
            ),
          ],
        ),
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
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: const WorkoutHistoryScreen()));
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
              defaultTextStyle: const TextStyle(color: Colors.white),
              weekendTextStyle: const TextStyle(color: Colors.white),
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: Theme.of(context).colorScheme.error, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }
}
