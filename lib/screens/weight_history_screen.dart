import 'package:fitflow/services/weight_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightHistoryScreen extends StatefulWidget {
  const WeightHistoryScreen({super.key});

  @override
  State<WeightHistoryScreen> createState() => _WeightHistoryScreenState();
}

class _WeightHistoryScreenState extends State<WeightHistoryScreen> {
  final WeightService _weightService = WeightService();

  @override
  void initState() {
    super.initState();
    _weightService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _weightService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Get the live data from the service
    final history = _weightService.weightHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight History'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final entry = history[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              title: Text(
                DateFormat('MMMM d, yyyy').format(entry.date),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              trailing: Text(
                '${entry.weight} kg',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          );
        },
      ),
    );
  }
}
