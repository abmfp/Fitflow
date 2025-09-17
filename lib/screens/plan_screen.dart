import 'package:fitflow/screens/plan_detail_screen.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package.page_transition/page_transition.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});
  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final List<String> allMuscles = ['Chest', 'Biceps', 'Triceps', 'Shoulders', 'Abs', 'Legs'];
  
  // ... _showEditMusclesDialog remains the same ...

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
                      // Add the new onTap function for navigation
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

  // Update the _buildDayCard to be fully tappable
  Widget _buildDayCard(BuildContext context, {required String day, required List<String> muscles, required VoidCallback onEdit, required VoidCallback onTap}) {
    final String workoutDisplay = muscles.isEmpty ? 'Rest' : muscles.join(' & ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap, // Make the whole card tappable
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Text(day, style: Theme.of(context).textTheme.displayMedium),
            subtitle: Text(workoutDisplay, style: Theme.of(context).textTheme.bodyLarge),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white70),
              onPressed: onEdit, // Edit button still works independently
            ),
          ),
        ),
      ),
    );
  }
}
