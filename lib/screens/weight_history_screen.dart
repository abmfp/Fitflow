import 'package:fitflow/services/weight_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = _weightService.weightHistory;
    final chartData = _weightService.weightChartData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientContainer(
        child: Column(
          children: [
            // Chart at the top
            if (chartData.isNotEmpty)
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: AspectRatio(
                    aspectRatio: 1.7,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartData,
                            isCurved: true,
                            color: Colors.white,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            
            // List of entries below
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}
