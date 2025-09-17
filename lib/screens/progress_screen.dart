// lib/screens/progress_screen.dart
import 'package:fitflow/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Workout History', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 20),
              _buildCalendar(context),
              const SizedBox(height: 40),
              Text('Weight Tracking (kg)', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 20),
              _buildWeightChart(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          calendarStyle: CalendarStyle(
            defaultTextStyle: const TextStyle(color: Colors.white),
            weekendTextStyle: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.7)),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightChart(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          // ... Chart configuration goes here ...
          // This is a placeholder for chart data
           gridData: const FlGridData(show: false),
           borderData: FlBorderData(show: false),
           lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 80),
                  FlSpot(1, 81),
                  FlSpot(2, 79),
                  FlSpot(3, 78.5),
                  FlSpot(4, 78),
                ],
                isCurved: true,
                color: Theme.of(context).primaryColor,
                barWidth: 4,
                belowBarData: BarAreaData(show: true, color: Theme.of(context).primaryColor.withOpacity(0.3)),
              )
           ]
        ),
      ),
    );
  }
}
