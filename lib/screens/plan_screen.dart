import 'package:fitflow/screens/plan_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});
  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final List<String> allMuscles = ['Chest', 'Biceps', 'Triceps', 'Shoulders', 'Abs', 'Legs'];

  void _showEditMusclesDialog(String day) {
    final List<String> selectedMuscles = List<String>.from(_workoutService.getMusclesForDay(DateTime.now()));
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
           backgroundColor: const Color(0xFF252836),
          title: Text('Edit $day'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Wrap(
                spacing: 8.0,
                children: allMuscles.map((muscle) {
                  final bool isSelected = selectedMuscles.contains(muscle);
                  return FilterChip(
                    label: Text(muscle),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedMuscles.add(muscle);
                        } else {
                          selectedMuscles.remove(muscle);
                        }
                      });
                    },
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? Theme.of(context).scaffoldBackgroundColor : Colors.white70),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    checkmarkColor: Theme.of(context).scaffoldBackgroundColor,
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _workoutService.updatePlanForDay(day, selectedMuscles);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly Plan', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _workoutService.weeklyPlan.length,
                  itemBuilder: (context, index) {
                    final plan = _workoutService.weeklyPlan[index];
                    final day = plan['day']!;
                    final muscles = List<String>.from(plan['muscles']);
                    return _buildDayCard(
                      context,
                      day: day,
                      muscles: muscles,
                      onEdit: () => _showEditMusclesDialog(day),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: PlanDetailScreen(day: day, muscles: muscles),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, {required String day, required List<String> muscles, required VoidCallback onEdit, required VoidCallback onTap}) {
    final String workoutDisplay = muscles.isEmpty ? 'Rest' : muscles.join(' & ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Text(day, style: Theme.of(context).textTheme.displayMedium),
            subtitle: Text(workoutDisplay, style: Theme.of(context).textTheme.bodyLarge),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white70),
              onPressed: onEdit,
            ),
          ),
        ),
      ),
    );
  }
}
