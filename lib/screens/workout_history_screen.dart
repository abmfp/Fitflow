import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Sample data: A map where the key is the date and the value is a list of exercises.
  final Map<DateTime, List<String>> _workoutHistory = {
    DateTime.utc(2025, 9, 15): ['Bench Press', 'Incline Dumbbell Press', 'Bicep Curls'],
    DateTime.utc(2025, 9, 13): ['Squats', 'Leg Press', 'Shoulder Press'],
    DateTime.utc(2025, 9, 11): ['Deadlifts', 'Pull-ups', 'Tricep Pushdowns'],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<String> _getWorkoutsForDay(DateTime day) {
    // Retrieve workouts for the selected day.
    return _workoutHistory[DateTime.utc(day.year, day.month, day.day)] ?? [];
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
          // The interactive calendar
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
                  _focusedDay = focusedDay; // update focused day as well
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
              ),
               headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),
          
          // Title for the workout list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Workout on selected day:",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 10),

          // The list of workouts for the selected day
          Expanded(
            child: workoutsForSelectedDay.isEmpty
                ? const Center(child: Text("No workout logged for this day."))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: workoutsForSelectedDay.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(workoutsForSelectedDay[index]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
