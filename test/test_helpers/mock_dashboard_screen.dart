import 'package:flutter/material.dart';
import '../mocks/mock_expense_breakdown_chart.dart';

/// Упрощенная версия DashboardScreen для тестов
/// 
/// Использует моки вместо реальных компонентов
/// для избежания layout overflow и других проблем
class MockDashboardScreen extends StatelessWidget {
  const MockDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дашборд'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Приветствие
            const Text(
              'Добро пожаловать',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Аналитика
            const Text(
              'Аналитика',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Моки для графиков
            MockExpenseBreakdownChart(),
            const SizedBox(height: 16),
            MockStatsOverview(),
            const SizedBox(height: 16),
            MockProductsBreakdownChart(),
            const SizedBox(height: 16),
            MockCaloriesBreakdownChart(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
