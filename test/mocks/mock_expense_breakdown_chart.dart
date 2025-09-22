import 'package:flutter/material.dart';

/// Мок для ExpenseBreakdownChart
/// 
/// Заменяет сложный PieChart на простой Container
/// для избежания layout overflow в тестах
class MockExpenseBreakdownChart extends StatelessWidget {
  const MockExpenseBreakdownChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Фиксированная высота для тестов
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Expense Breakdown Chart\n(Mock for Testing)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

/// Мок для StatsOverview
/// 
/// Заменяет сложный StatsOverview на простой Container
/// для избежания layout overflow в тестах
class MockStatsOverview extends StatelessWidget {
  const MockStatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Фиксированная высота для тестов
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Stats Overview\n(Mock for Testing)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

/// Мок для ProductsBreakdownChart
class MockProductsBreakdownChart extends StatelessWidget {
  const MockProductsBreakdownChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Products Breakdown Chart\n(Mock for Testing)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

/// Мок для CaloriesBreakdownChart
class MockCaloriesBreakdownChart extends StatelessWidget {
  const MockCaloriesBreakdownChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Calories Breakdown Chart\n(Mock for Testing)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
