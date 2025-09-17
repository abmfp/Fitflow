import 'package:fitflow/screens/workout_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'packagepackage:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 1. Updated data structure to hold full Exercise objects, not just names.
  final Map<DateTime, List<Exercise>> _workoutHistory = {
    DateTime.utc(2025, 9, 15): [
      Exercise(name: 'Bench Press', description: 'A core compound exercise for chest development.'),
      Exercise(name: 'Incline Dumbbell Press', description: 'Targets the upper portion of the pectoral muscles.'),
      Exercise(name: 'Bicep Curls', description: 'An isolation exercise for the biceps.'),
    ],
    DateTime.utc(2025, 9, 13): [
      Exercise(name: 'Squats', description: 'The king of all leg exercises, targeting quads, hamstrings, and glutes.'),
      Exercise(name: 'Leg Press', description: 'A compound machine exercise for overall leg development.'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Exercise> _getWorkoutsForDay(DateTime day) {
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
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                selectedTextStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
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
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: workoutsForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final exercise = workoutsForSelectedDay[index];
                      // 2. Wrap the Card in an InkWell to make it tappable
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            // 3. Navigate to the detail screen, passing the specific exercise
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: WorkoutDetailScreen(exercise: exercise),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            title: Text(exercise.name),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          ),
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
