import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class NutritionEditScreen extends StatelessWidget {
  const NutritionEditScreen({super.key});

  static const _items = <_NutritionItem>[
    _NutritionItem('Калории', Icons.local_fire_department, AppColors.orange),
    _NutritionItem('Белки', Icons.fitness_center, AppColors.purple),
    _NutritionItem('Жиры', Icons.water_drop, AppColors.orange),
    _NutritionItem('Насыщенные жиры', Icons.water_drop, AppColors.orange),
    _NutritionItem('Транс-жиры', Icons.water_drop, AppColors.orange),
    _NutritionItem('Мононенасыщенные жиры', Icons.water_drop, AppColors.orange),
    _NutritionItem('Полиненасыщенные жиры', Icons.water_drop, AppColors.orange),
    _NutritionItem('Углеводы', Icons.grain, AppColors.yellow),
    _NutritionItem('Сахар', Icons.cake, AppColors.yellow),
    _NutritionItem('Клетчатка', Icons.eco, AppColors.green),
    _NutritionItem('Натрий', Icons.opacity, AppColors.blue),
    _NutritionItem('Холестерин', Icons.bubble_chart, AppColors.blue),
    _NutritionItem('Калий', Icons.bubble_chart, AppColors.blue),
    _NutritionItem('Кальций', Icons.bubble_chart, AppColors.blue),
    _NutritionItem('Железо', Icons.bubble_chart, AppColors.blue),
    _NutritionItem('Витамин A', Icons.bubble_chart, AppColors.teal),
    _NutritionItem('Витамин C', Icons.bubble_chart, AppColors.teal),
    _NutritionItem('Витамин D', Icons.bubble_chart, AppColors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Изменить пищевую ценность',
          style: DesignTokens.typography.titleMediumStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing.lg,
            vertical: DesignTokens.spacing.md,
          ),
          itemBuilder: (context, index) => _NutritionCard(item: _items[index]),
          separatorBuilder: (_, __) =>
              SizedBox(height: DesignTokens.spacing.md),
          itemCount: _items.length,
        ),
      ),
    );
  }
}

class _NutritionItem {
  final String title;
  final IconData icon;
  final Color color;

  const _NutritionItem(this.title, this.icon, this.color);
}

class _NutritionCard extends StatelessWidget {
  final _NutritionItem item;

  const _NutritionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.color.withValues(alpha: isLightTheme ? 0.6 : 0.2),
          width: 1,
        ),
        boxShadow: DesignTokens.shadows.md,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: isLightTheme ? 0.3 : 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 24,
            ),
          ),
          SizedBox(width: DesignTokens.spacing.md),
          Expanded(
            child: Text(
              item.title,
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicOnSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: isLightTheme ? 0.3 : 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.add,
              size: 20,
              color: item.color,
            ),
          ),
        ],
      ),
    );
  }
}
