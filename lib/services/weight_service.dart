import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';

part 'weight_service.g.dart';

@HiveType(typeId: 0)
class WeightEntry {
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
    final sortedHistory = _weightHistory..sort((a, b) => a.date.compareTo(b.date));
    return sortedHistory.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();
  }

  Future<void> init() async {
    _box = Hive.box<WeightEntry>('weight_history');
    _weightHistory = _box.values.toList();
  }

  // New function to get weight for a specific day
  WeightEntry? getWeightForDate(DateTime date) {
    try {
      return _weightHistory.firstWhere((entry) =>
          entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day);
    } catch (e) {
      return null; // Return null if no entry is found
    }
  }

  void addWeight(double weight, DateTime date) {
    _weightHistory.removeWhere((entry) =>
        entry.date.year == date.year &&
        entry.date.month == date.month &&
        entry.date.day == date.day);
    
    final newEntry = WeightEntry(date: date, weight: weight);
    _weightHistory.add(newEntry);
    _box.add(newEntry);
    notifyListeners();
  }
}
