import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';

part 'weight_service.g.dart';

@HiveType(typeId: 0)
class WeightEntry extends HiveObject { // Extend HiveObject to make deleting easier
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final double weight;

  WeightEntry({required this.date, required this.weight});
}

class WeightService extends ChangeNotifier {
  static final WeightService _instance = WeightService._internal();
  factory WeightService() => _instance;
  WeightService._internal();

  late Box<WeightEntry> _box;
  List<WeightEntry> _weightHistory = [];

  List<WeightEntry> get weightHistory =>
      _weightHistory..sort((a, b) => b.date.compareTo(a.date));

  List<FlSpot> get weightChartData {
    final sortedHistory = List<WeightEntry>.from(_weightHistory)..sort((a, b) => a.date.compareTo(b.date));
    return sortedHistory.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();
  }

  Future<void> init() async {
    _box = Hive.box<WeightEntry>('weight_history');
    _weightHistory = _box.values.toList();
  }

  WeightEntry? getWeightForDate(DateTime date) {
    try {
      return _weightHistory.firstWhere((entry) =>
          entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day);
    } catch (e) {
      return null;
    }
  }

  // Updated logic to properly replace an entry for a specific day
  void addWeight(double weight, DateTime date) {
    final dayToLog = DateTime(date.year, date.month, date.day);

    // Find if an entry already exists for this day
    final existingEntry = getWeightForDate(dayToLog);
    if (existingEntry != null) {
      // Delete the old entry before adding the new one
      deleteWeight(existingEntry);
    }
    
    final newEntry = WeightEntry(date: dayToLog, weight: weight);
    _weightHistory.add(newEntry);
    _box.add(newEntry);
    notifyListeners();
  }

  // New method to delete a weight entry
  void deleteWeight(WeightEntry entry) {
    _weightHistory.remove(entry);
    entry.delete(); // This deletes it from the Hive database
    notifyListeners();
  }
}
