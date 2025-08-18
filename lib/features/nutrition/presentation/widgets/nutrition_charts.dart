import 'package:flutter/material.dart';

enum ChartType { daily, weekly, monthly }

class NutritionCharts extends StatelessWidget {
  final List<dynamic> diaries;
  final ChartType chartType;

  const NutritionCharts({
    super.key,
    required this.diaries,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '${chartType.name.toUpperCase()} Charts - Coming Soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
