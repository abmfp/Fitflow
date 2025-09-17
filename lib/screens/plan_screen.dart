import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // The list of available muscles for selection.
  final List<String> allMuscles = [
    'Chest',
    'Biceps',
    'Triceps',
    'Shoulders',
    'Abs',
    'Legs',
  ];

  // Updated data structure to support a list of muscles for each workout.
  final List<Map<String, dynamic>> _weeklyPlan = [
    {'day': 'Monday', 'muscles': ['Chest', 'Biceps']},
    {'day': 'Tuesday', 'muscles': ['Back', 'Triceps']}, // Note: 'Back' is not in the list, you can add it
    {'day': 'Wednesday', 'muscles': ['Legs', 'Shoulders']},
    {'day': 'Thursday', 'muscles': []}, // Empty list represents a Rest day
    {'day': 'Friday', 'muscles': ['Chest', 'Back']},
    {'day': 'Saturday', 'muscles': ['Abs']},
    {'day': 'Sunday', 'muscles': []},
  ];

  // This function displays the multi-select dialog.
  void _showEditMusclesDialog(int dayIndex) {
    // A temporary list to hold the selections inside the dialog.
    final List<String> selectedMuscles = List<String>.from(_weeklyPlan[dayIndex]['muscles']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252836),
          title: Text('Edit ${ _weeklyPlan[dayIndex]['day']}'),
          content: StatefulBuilder( // Use StatefulBuilder to manage the dialog's state
            builder: (BuildContext context, StateSetter setState) {
              return Wrap(
                spacing: 8.0,
                children: allMuscles.map((muscle) {
                  final bool isSelected = selectedMuscles.contains(muscle);
                  return FilterChip(
                    label: Text(muscle),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() { // This setState only rebuilds the dialog's content
                        if (selected) {
                          selectedMuscles.add(muscle);
                        } else {
                          selectedMuscles.remove(muscle);
                        }
                      });
                    },
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Theme.of(context).scaffoldBackgroundColor : Colors.white70,
                    ),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    checkmarkColor: Theme.of(context).scaffoldBackgroundColor,
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Update the main plan with the new selections.
                setState(() { // This setState rebuilds the main screen
                  _weeklyPlan[dayIndex]['muscles'] = selectedMuscles;
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
                Text(
                  'Weekly Plan',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 20),
                
                // Use ListView.builder for better performance and structure
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _weeklyPlan.length,
                  itemBuilder: (context, index) {
                    final plan = _weeklyPlan[index];
                    return _buildDayCard(
                      context,
                      day: plan['day']!,
                      muscles: List<String>.from(plan['muscles']),
                      onEdit: () => _showEditMusclesDialog(index),
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

  // Updated card widget to display a list of muscles.
  Widget _buildDayCard(BuildContext context, {required String day, required List<String> muscles, required VoidCallback onEdit}) {
    // Format the muscle list for display. Show "Rest" if the list is empty.
    final String workoutDisplay = muscles.isEmpty ? 'Rest' : muscles.join(' & ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          title: Text(
            day,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          subtitle: Text(
            workoutDisplay,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white70),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}
