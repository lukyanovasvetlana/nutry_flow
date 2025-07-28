import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../../../../app.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список покупок'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false,
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFF9F4F2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Информационные карточки
              _InfoCard(
                title: 'Оценочная стоимость',
                value: '₽157',
                icon: Icons.attach_money,
                color: AppColors.green,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Всего товаров',
                value: '40',
                icon: Icons.inventory_2,
                color: AppColors.yellow,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Всего калорий',
                value: '21 615 ккал',
                icon: Icons.local_fire_department,
                color: AppColors.orange,
              ),
              const SizedBox(height: 16),
              // TODO: Expense Overview (Bar Chart)
              Container(
                height: 180,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text('Обзор расходов (график)'),
              ),
              const SizedBox(height: 16),
              // TODO: Expense Breakdown (Pie Chart)
              Container(
                height: 180,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text('Структура расходов (диаграмма)'),
              ),
              const SizedBox(height: 16),
              // TODO: Grocery Category
              Container(
                height: 80,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text('Категории товаров'),
              ),
              const SizedBox(height: 16),
              // TODO: Grocery List (Search, Add, List, Pagination)
              Container(
                height: 400,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text('Таблица покупок'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _InfoCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF2D3748), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF2D3748)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 