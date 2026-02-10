import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/components/cards/nutry_card.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class MealEntrySection extends StatefulWidget {
  final String mealType;
  final IconData icon;
  final VoidCallback onAdd;
  final Color? color;
  final List<Map<String, dynamic>> entries;
  final Function(int)? onDelete;

  const MealEntrySection({
    super.key,
    required this.mealType,
    required this.icon,
    required this.onAdd,
    this.color,
    this.entries = const [],
    this.onDelete,
  });

  @override
  State<MealEntrySection> createState() => _MealEntrySectionState();
}

class _MealEntrySectionState extends State<MealEntrySection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.color ?? AppColors.dynamicPrimary;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    // Вычисляем общие значения макронутриентов
    double totalCalories = 0;
    double totalFat = 0;
    double totalCarbs = 0;
    double totalProtein = 0;

    for (final entry in widget.entries) {
      totalCalories += (entry['calories'] as num?)?.toDouble() ?? 0;
      totalFat += (entry['fat'] as num?)?.toDouble() ?? 0;
      totalCarbs += (entry['carbs'] as num?)?.toDouble() ?? 0;
      totalProtein += (entry['protein'] as num?)?.toDouble() ?? 0;
    }

    final rdi = totalCalories > 0
        ? ((totalCalories / 2000) * 100).toStringAsFixed(0)
        : '0';

    return NutryCard(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isLightTheme ? cardColor.withValues(alpha: 0.08) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cardColor.withValues(alpha: isLightTheme ? 0.6 : 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок секции
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        cardColor.withValues(alpha: isLightTheme ? 0.3 : 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: cardColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.mealType,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicOnSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onAdd,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(
                        alpha: isLightTheme ? 0.3 : 0.15,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: cardColor,
                    ),
                  ),
                ),
                if (widget.entries.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.dynamicTextSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ],
            ),

            // Калории (если есть записи)
            if (widget.entries.isNotEmpty) ...[
              SizedBox(height: DesignTokens.spacing.sm),
              Text(
                '${totalCalories.toStringAsFixed(0)} Калории',
                style: DesignTokens.typography.bodySmallStyle.copyWith(
                  color: AppColors.dynamicTextSecondary,
                  fontSize: 13,
                ),
              ),
            ],

            // Сводка макронутриентов (если есть записи)
            if (widget.entries.isNotEmpty) ...[
              SizedBox(height: DesignTokens.spacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMacroItem(totalFat.toStringAsFixed(2), 'Жиры'),
                  _buildMacroItem(totalCarbs.toStringAsFixed(2), 'Углев'),
                  _buildMacroItem(totalProtein.toStringAsFixed(2), 'Белк'),
                  _buildMacroItem('$rdi%', 'РСК'),
                ],
              ),
              SizedBox(height: DesignTokens.spacing.sm),
            ],

            // Список продуктов (показывается только если развернуто)
            if (widget.entries.isNotEmpty && _isExpanded) ...[
              SizedBox(height: DesignTokens.spacing.md),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.dynamicBorder.withValues(alpha: 0.2),
              ),
              SizedBox(height: DesignTokens.spacing.md),
              ...widget.entries.asMap().entries.map((entry) {
                final index = entry.key;
                final foodData = entry.value;
                final isLast = index == widget.entries.length - 1;
                return _buildFoodEntry(foodData, index, cardColor, isLast);
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: DesignTokens.typography.bodySmallStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: DesignTokens.typography.labelSmallStyle.copyWith(
            color: AppColors.dynamicTextSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodEntry(
      Map<String, dynamic> foodData, int index, Color cardColor, bool isLast) {
    final foodName = foodData['foodName'] as String? ?? '';
    final quantity = foodData['quantity'] as num? ?? 0;
    final unit = foodData['unit'] as String? ?? 'г';
    final calories = foodData['calories'] as num? ?? 0;
    final fat = foodData['fat'] as num? ?? 0;
    final carbs = foodData['carbs'] as num? ?? 0;
    final protein = foodData['protein'] as num? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Название, количество и кнопка удаления
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название и количество
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodName,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacing.xs),
                  Text(
                    '${quantity.toStringAsFixed(0)} $unit',
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Кнопка удаления
            if (widget.onDelete != null)
              GestureDetector(
                onTap: () => widget.onDelete!(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.dynamicError.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.dynamicError,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        // Калории
        Row(
          children: [
            Text(
              calories.toStringAsFixed(0),
              style: DesignTokens.typography.bodyLargeStyle.copyWith(
                color: AppColors.dynamicTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(width: DesignTokens.spacing.xs),
            Text(
              'ккал',
              style: DesignTokens.typography.labelSmallStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        // Макронутриенты
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNutrientChip(
                'Белки', protein.toDouble(), 'г', AppColors.dynamicInfo),
            SizedBox(width: DesignTokens.spacing.xs),
            _buildNutrientChip(
                'Жиры', fat.toDouble(), 'г', AppColors.dynamicWarning),
            SizedBox(width: DesignTokens.spacing.xs),
            _buildNutrientChip(
                'Углев', carbs.toDouble(), 'г', AppColors.dynamicSuccess),
            Spacer(),
          ],
        ),
        // Разделитель (кроме последнего элемента)
        if (!isLast) ...[
          SizedBox(height: DesignTokens.spacing.md),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.dynamicBorder.withValues(alpha: 0.15),
          ),
          SizedBox(height: DesignTokens.spacing.md),
        ],
      ],
    );
  }

  Widget _buildNutrientChip(
      String label, double value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing.sm,
        vertical: DesignTokens.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: DesignTokens.typography.labelSmallStyle.copyWith(
              color: AppColors.dynamicTextSecondary,
              fontSize: 11,
            ),
          ),
          SizedBox(width: DesignTokens.spacing.xs),
          Text(
            '${value.toStringAsFixed(1)}$unit',
            style: DesignTokens.typography.labelSmallStyle.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
