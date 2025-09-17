import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart'; // Needed for chart data

// A model for a single weight entry
class WeightEntry {
  final DateTime date;
  final double weight; // in Kilograms

  WeightEntry({required this.date, required this.weight});
}

class WeightService extends ChangeNotifier {
  // Singleton pattern
  static final WeightService _instance = WeightService._internal();
  factory WeightService() => _instance;
  WeightService._internal();

  // The list that holds all weight entries
  final List<WeightEntry> _weightHistory = [
    // Adding some initial sample data
    WeightEntry(date: DateTime.utc(2025, 9, 12), weight: 81.5),
    WeightEntry(date: DateTime.utc(2025, 9, 13), weight: 80.8),
    WeightEntry(date: DateTime.utc(2025, 9, 14), weight: 81.0),
    WeightEntry(date: DateTime.utc(2025, 9, 15), weight: 79.5),
    WeightEntry(date: DateTime.utc(2025, 9, 16), weight: 79.0),
  ];

  // Public getter for the history, sorted by most recent
  List<WeightEntry> get weightHistory =>
      _weightHistory..sort((a, b) => b.date.compareTo(a.date));

  // A helper to get data formatted for the chart
  List<FlSpot> get weightChartData {
    final sortedHistory = _weightHistory..sort((a, b) => a.date.compareTo(b.date));
    return sortedHistory.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();
  }

  // Method to add a new weight entry
  void addWeight(double weight) {
    // Remove any entry that might already exist for today
    _weightHistory.removeWhere((entry) =>
        entry.date.year == DateTime.now().year &&
        entry.date.month == DateTime.now().month &&
        entry.date.day == DateTime.now().day);
    
    _weightHistory.add(WeightEntry(date: DateTime.now(), weight: weight));
    notifyListeners(); // Notify all listening screens of the change
  }
}
