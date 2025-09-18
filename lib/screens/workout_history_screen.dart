import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package.page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});
  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  final WorkoutService _workoutService = WorkoutService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _workoutService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _workoutService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    setState(() {});
  }

  List<Exercise> _getWorkoutsForDay(DateTime day) {
    // Get live data from the service
    return _workoutService.workoutHistory[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final workoutsForSelectedDay = _getWorkoutsForDay(_selectedDay!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              // Add an event loader to mark days with workouts
              eventLoader: _getWorkoutsForDay,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                selectedTextStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
                markerDecoration: BoxDecoration(color: Theme.of(context).colorScheme.error, shape: BoxShape.circle),
              ),
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("Workout on selected day:", style: Theme.of(context).textTheme.displayMedium),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: workoutsForSelectedDay.isEmpty
                ? const Center(child: Text("No workout logged for this day."))
                : ListView.builder( /* ... same as before ... */ ),
          ),
        ],
      ),
    );
  }
}
