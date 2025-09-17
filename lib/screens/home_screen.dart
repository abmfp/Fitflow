import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/services/weight_service.dart'; // Import the new service
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package.page_transition/page_transition.dart';
import 'workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final UserService _userService = UserService();
  final WeightService _weightService = WeightService(); // Add weight service instance

  @override
  void initState() {
    super.initState();
    _workoutService.addListener(_onDataChanged);
    _userService.addListener(_onDataChanged);
    _weightService.addListener(_onDataChanged); // Add listener for weight service
  }

  @override
  void dispose() {
    _workoutService.removeListener(_onDataChanged);
    _userService.removeListener(_onDataChanged);
    _weightService.removeListener(_onDataChanged); // Remove listener for weight service
    super.dispose();
  }

  void _onDataChanged() {
    setState(() {});
  }

  // This function shows the dialog to add weight
  void _showAddWeightDialog(BuildContext context) {
    final TextEditingController weightController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Your Weight'),
        content: TextField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Weight (kg)',
            suffixText: 'kg',
          ),
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              final double? weight = double.tryParse(weightController.text);
              if (weight != null) {
                _weightService.addWeight(weight);
              }
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (build method first part is the same)
    // Find the _buildInfoCard for weight and update it
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSelector(DateTime.now()),
                const SizedBox(height: 24),
                Padding( /* ... */ ),
                Padding( /* ... */ ),
                const SizedBox(height: 24),
                // This card is DYNAMIC!
                _buildWorkoutCard(context, /* ... */),
                const SizedBox(height: 16),
                // This is the updated weight card
                _buildInfoCard(
                  context,
                  icon: Icons.monitor_weight_outlined,
                  title: 'Weight for ${DateFormat('d MMM').format(DateTime.now())}',
                  subtitle: 'No Entry', // This could be made dynamic too!
                  trailing: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _showAddWeightDialog(context),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCard( /* ... */ ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // The rest of your HomeScreen code (_buildWorkoutCard, etc.) remains the same.
  // ...
}
