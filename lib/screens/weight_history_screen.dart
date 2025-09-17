import 'package:flutter/material.dart';

class WeightHistoryScreen extends StatelessWidget {
  const WeightHistoryScreen({super.key});

  // Sample data for the weight history list.
  static final List<Map<String, dynamic>> _weightHistoryData = [
    {'date': 'September 17, 2025', 'weight': 79.2},
    {'date': 'September 16, 2025', 'weight': 79.0},
    {'date': 'September 15, 2025', 'weight': 79.5},
    {'date': 'September 14, 2025', 'weight': 81.0},
    {'date': 'September 13, 2025', 'weight': 80.8},
    {'date': 'September 12, 2025', 'weight': 81.5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight History'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _weightHistoryData.length,
        itemBuilder: (context, index) {
          final entry = _weightHistoryData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              title: Text(
                entry['date'],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              trailing: Text(
                '${entry['weight']} kg',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          );
        },
      ),
    );
  }
}
