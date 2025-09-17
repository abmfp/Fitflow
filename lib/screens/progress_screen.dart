import 'package:fitflow/services/workout_service.dart'; // Import the service
import 'package:fitflow/screens/weight_history_screen.dart';
import 'package:fitflow/screens/workout_history_screen.dart';
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
  // Get the single instance of our workout service.
  final WorkoutService _workoutService = WorkoutService();

  @override
  void initState() {
    super.initState();
    // Add a listener that will rebuild the screen when the service notifies it.
    _workoutService.addListener(_onWorkoutChanged);
  }

  @override
  void dispose() {
    // Always remove listeners to prevent memory leaks.
    _workoutService.removeListener(_onWorkoutChanged);
    super.dispose();
  }

  void _onWorkoutChanged() {
    // This function is called by the listener. It just tells the widget to rebuild.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // The rest of your build method remains the same, but it will now have live data!
    final missedDays = {2, 4, 6, 8, 12};
    final today = DateTime.utc(2025, 9, 17);

    return Scaffold(
      body: SafeArea(
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
                _buildSectionTitle(context, 'Today\'s Stats: Chest & Biceps'),
                const SizedBox(height: 15),
                // This card will now show live data
                _buildTodayStatsCard(context),
                const SizedBox(height: 30),
                _buildSectionTitle(context, 'Workout Streak'),
                const SizedBox(height: 15),
                _buildWorkoutStreakCalendar(context, missedDays, today),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER FUNCTIONS ---

  Widget _buildSectionTitle(BuildContext context, String title) => Text(title, style: Theme.of(context).textTheme.displayMedium);
  
  // Updated to show live stats from the WorkoutService
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

  // The rest of the builder functions do not need to change.
  Widget _buildWeightAnalyticsCard(BuildContext context) {
      final List<FlSpot> weightData = [
        const FlSpot(0, 80), const FlSpot(1, 81.5), const FlSpot(2, 81),
        const FlSpot(3, 79.5), const FlSpot(4, 79), const FlSpot(5, 79.2),
      ];
    
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
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity, height: 150,
              child: Center(
                child: Text('Log more to see your chart!\n(Tap here for details)', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
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
                        spots: weightData, isCurved: true, color: Colors.white,
                        barWidth: 4, isStrokeCapRound: true, dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: true, color: Colors.white.withOpacity(0.3)),
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

   Widget _buildWorkoutStreakCalendar(BuildContext context, Set<int> missedDays, DateTime today) {
      return InkWell(
        onTap: () {
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const WorkoutHistoryScreen()));
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2025, 9, 1),
              lastDay: DateTime.utc(2025, 9, 30),
              focusedDay: today,
              headerVisible: true, calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                titleCentered: true, formatButtonVisible: false,
                titleTextStyle: Theme.of(context).textTheme.labelLarge!,
                leftChevronVisible: false, rightChevronVisible: false,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                weekendStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
                outsideDaysVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (missedDays.contains(day.day)) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${day.day}', style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 2),
                        const Icon(Icons.close, color: Colors.red, size: 14),
                      ],
                    );
                  }
                  return Center(child: Text('${day.day}', style: const TextStyle(color: Colors.white)));
                },
              ),
            ),
          ),
        ),
      );
    }
}
