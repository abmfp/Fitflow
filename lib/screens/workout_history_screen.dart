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
  bool _isExpanded = false;

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
    final muscles = exercises.map((e) => _workoutService.customExercises.firstWhere((ce) => ce.name == e.name, orElse: () => CustomExercise(name: '', muscleGroup: 'Unknown')).muscleGroup).toSet();
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
                    _isExpanded = false; // Collapse the panel when a new day is selected
                  });
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  selectedTextStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                // This builder adds the checkmark
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final workouts = _getWorkoutsForDay(day);
                    if (workouts.isNotEmpty) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Text('${day.day}'),
                          const Positioned(
                            bottom: 2,
                            child: Icon(Icons.check_circle, color: Colors.green, size: 12),
                          ),
                        ],
                      );
                    }
                    return null; // Return null to use default builder
                  },
                ),
              ),
            ),
            
            Expanded(
              child: workoutsForSelectedDay.isEmpty
                  ? const Center(child: Text("No workout logged for this day."))
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        ExpansionPanelList(
                          elevation: 0,
                          expandedHeaderPadding: EdgeInsets.zero,
                          dividerColor: Colors.transparent,
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              backgroundColor: Theme.of(context).cardTheme.color,
                              isExpanded: _isExpanded,
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(workoutTitle, style: Theme.of(context).textTheme.labelLarge),
                                );
                              },
                              body: Column(
                                children: workoutsForSelectedDay.map((exercise) {
                                  return ListTile(
                                    title: Text(exercise.name),
                                    dense: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(type: PageTransitionType.fade, child: WorkoutDetailScreen(exercise: exercise)),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
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
