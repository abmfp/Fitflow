import 'package:fitflow/screens/workout_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
    if (mounted) {
      setState(() {});
    }
  }

  List<Exercise> _getWorkoutsForDay(DateTime day) {
    return _workoutService.workoutHistory[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  String _getMuscleGroupsForWorkout(List<Exercise> exercises) {
    if (exercises.isEmpty) return "No Workout";
    final muscles = exercises.map((e) => e.name.replaceAll(' Press', '')).toSet();
    return muscles.join(' & ');
  }

  @override
  Widget build(BuildContext context) {
    final workoutsForSelectedDay = _getWorkoutsForDay(_selectedDay!);
    final workoutTitle = _getMuscleGroupsForWorkout(workoutsForSelectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientContainer(
        child: Column(
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
                eventLoader: _getWorkoutsForDay,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  selectedTextStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
                  markerDecoration: BoxDecoration(color: Theme.of(context).colorScheme.error, shape: BoxShape.circle),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              ),
            ),
            
            Expanded(
              child: workoutsForSelectedDay.isEmpty
                  ? const Center(child: Text("No workout logged for this day."))
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Card(
                          child: ExpansionTile(
                            title: Text(workoutTitle, style: Theme.of(context).textTheme.labelLarge),
                            children: workoutsForSelectedDay.map((exercise) {
                              return ListTile(
                                onTap: () {
                                   Navigator.push(
                                    context,
                                    // This line is corrected
                                    PageTransition(type: PageTransitionType.fade, child: WorkoutDetailScreen(exercise: exercise)),
                                  );
                                },
                                title: Text(exercise.name),
                                dense: true,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
