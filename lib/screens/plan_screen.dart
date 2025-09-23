import 'package:fitflow/screens/plan_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});
  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final List<String> allMuscles = ['Chest', 'Biceps', 'Triceps', 'Shoulders', 'Back', 'Legs', 'Abs'];

  void _showEditMusclesDialog(String day) {
    final List<String> selectedMuscles = List<String>.from(_workoutService.getMusclesForDay(DateTime.now()));
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
           backgroundColor: const Color(0xFF252836),
          title: Text('Edit Plan for $day'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: allMuscles.map((muscle) {
                    final bool isSelected = selectedMuscles.contains(muscle);
                    return CheckboxListTile(
                      title: Text(muscle),
                      value: isSelected,
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedMuscles.add(muscle);
                          } else {
                            selectedMuscles.remove(muscle);
                          }
                        });
                      },
                      activeColor: Colors.white,
                      checkColor: const Color(0xFF1F1D2B),
                    );
                  }).toList(),
                ),
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
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Text('Weekly Plan', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 20),
            ..._workoutService.weeklyPlan.map((plan) {
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
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, {required String day, required List<String> muscles, required VoidCallback onEdit, required VoidCallback onTap}) {
    final String workoutDisplay = muscles.isEmpty ? 'Rest' : muscles.join(' & ');

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(day, style: Theme.of(context).textTheme.displayMedium),
        subtitle: Text(workoutDisplay, style: Theme.of(context).textTheme.bodyLarge),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white70),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
