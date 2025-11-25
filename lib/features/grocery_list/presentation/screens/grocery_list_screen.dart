import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../../../../app.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Список покупок',
          style: TextStyle(
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.dynamicSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.dynamicTextPrimary,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false,
            );
          },
        ),
      ),
      backgroundColor: AppColors.dynamicBackground,
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
                color: AppColors.dynamicGreen,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Всего товаров',
                value: '40',
                icon: Icons.inventory_2,
                color: AppColors.dynamicYellow,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Всего калорий',
                value: '21 615 ккал',
                icon: Icons.local_fire_department,
                color: AppColors.dynamicOrange,
              ),
              const SizedBox(height: 16),
              // TODO: Expense Overview (Bar Chart)
              Container(
                height: 180,
                color: AppColors.dynamicSurface,
                alignment: Alignment.center,
                child: Text(
                  'Обзор расходов (график)',
                  style: TextStyle(
                    color: AppColors.dynamicTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // TODO: Expense Breakdown (Pie Chart)
              Container(
                height: 180,
                color: AppColors.dynamicSurface,
                alignment: Alignment.center,
                child: Text(
                  'Питание и калории (диаграмма)',
                  style: TextStyle(
                    color: AppColors.dynamicTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // TODO: Grocery Category
              Container(
                height: 80,
                color: AppColors.dynamicSurface,
                alignment: Alignment.center,
                child: Text(
                  'Категории товаров',
                  style: TextStyle(
                    color: AppColors.dynamicTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // TODO: Grocery List (Search, Add, List, Pagination)
              Container(
                height: 400,
                color: AppColors.dynamicSurface,
                alignment: Alignment.center,
                child: Text(
                  'Таблица покупок',
                  style: TextStyle(
                    color: AppColors.dynamicTextSecondary,
                  ),
                ),
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
  const _InfoCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.dynamicSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dynamicShadow.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.dynamicTextPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.dynamicTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
