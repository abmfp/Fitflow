import 'package:fitflow/screens/plan_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});
  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final WorkoutService _workoutService = WorkoutService();
  // Updated muscle list as per your request
  final List<String> allMuscles = ['Chest', 'Biceps', 'Triceps', 'Shoulders', 'Back', 'Legs', 'Abs'];

  void _showEditMusclesDialog(String day) {
    final List<String> selectedMuscles = List<String>.from(_workoutService.getMusclesForDay(DateTime.now()));
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
           backgroundColor: const Color(0xFF252836),
          title: Text('Edit Plan for $day'),
          // Use a StatefulWidget builder to manage the state of the checkboxes
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // Use a SingleChildScrollView to prevent overflow if the list is long
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: allMuscles.map((muscle) {
                    final bool isSelected = selectedMuscles.contains(muscle);
                    // Using CheckboxListTile for each muscle
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
                // We call the main setState for the screen to reflect changes if needed
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
      body: GradientContainer(
        child: SafeArea(
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
