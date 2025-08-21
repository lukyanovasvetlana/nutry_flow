import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/design/components/cards/nutry_card.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedPeriod = 'Неделя';

  final List<String> periods = [
    'День',
    'Неделя',
    'Месяц',
    'Год',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.dynamicOnSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Аналитика',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: AppColors.dynamicOnSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: AppColors.dynamicOnSurface,
            ),
            onPressed: () {
              // TODO: Share analytics
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Период
            _buildPeriodSelector(),
            const SizedBox(height: 20), // Уменьшил с 24 до 20

            // Основные метрики
            _buildMainMetrics(),
            const SizedBox(height: 24), // Уменьшил с 32 до 24

            // Графики
            _buildChartsSection(),
            const SizedBox(height: 24), // Уменьшил с 32 до 24

            // Детальная аналитика
            _buildDetailedAnalytics(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Период',
          style: DesignTokens.typography.titleMediumStyle.copyWith(
            color: AppColors.dynamicOnBackground,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12), // Уменьшил с 16 до 12
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.dynamicSurfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: periods.map((period) {
              final isSelected = selectedPeriod == period;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPeriod = period;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.dynamicPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.dynamicPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    period,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: isSelected
                          ? AppColors.dynamicOnPrimary
                          : AppColors.dynamicOnSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMainMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Основные показатели',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: AppColors.dynamicOnBackground,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 12), // Уменьшил с 16 до 12
        // Горизонтальные карточки в одну колонку
        _buildMetricCard(
          title: 'Калории',
          value: '1,850',
          unit: 'ккал',
          icon: Icons.local_fire_department,
          color: AppColors.dynamicNutritionCarbs,
          trend: '+5%',
          isPositive: true,
        ),
        const SizedBox(height: 8), // Уменьшил с 12 до 8
        _buildMetricCard(
          title: 'Белки',
          value: '85',
          unit: 'г',
          icon: Icons.fitness_center,
          color: AppColors.dynamicNutritionProtein,
          trend: '+2%',
          isPositive: true,
        ),
        const SizedBox(height: 8), // Уменьшил с 12 до 8
        _buildMetricCard(
          title: 'Жиры',
          value: '65',
          unit: 'г',
          icon: Icons.water_drop,
          color: AppColors.dynamicNutritionFats,
          trend: '-3%',
          isPositive: false,
        ),
        const SizedBox(height: 8), // Уменьшил с 12 до 8
        _buildMetricCard(
          title: 'Углеводы',
          value: '220',
          unit: 'г',
          icon: Icons.grain,
          color: AppColors.dynamicNutritionWater,
          trend: '+8%',
          isPositive: true,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isPositive,
  }) {
    return NutryCard(
      backgroundColor: AppColors.dynamicCard,
      child: Container(
        padding: const EdgeInsets.all(14), // Уменьшил с 16 до 14
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Иконка слева
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 14), // Уменьшил с 16 до 14
            // Основная информация по центру
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicOnSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style:
                            DesignTokens.typography.headlineLargeStyle.copyWith(
                          color: AppColors.dynamicOnSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          unit,
                          style:
                              DesignTokens.typography.bodyMediumStyle.copyWith(
                            color: AppColors.dynamicOnSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Тренд справа
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isPositive
                    ? AppColors.dynamicSuccess.withOpacity(0.15)
                    : AppColors.dynamicError.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPositive
                      ? AppColors.dynamicSuccess.withOpacity(0.3)
                      : AppColors.dynamicError.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    size: 14,
                    color: isPositive
                        ? AppColors.dynamicSuccess
                        : AppColors.dynamicError,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: isPositive
                          ? AppColors.dynamicSuccess
                          : AppColors.dynamicError,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Графики',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: AppColors.dynamicOnBackground,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 12), // Уменьшил с 16 до 12
        _buildChartCard(
          title: 'Потребление калорий',
          subtitle: 'За последние 7 дней',
          icon: Icons.show_chart,
          color: AppColors.dynamicPrimary,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.dynamicSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'График калорий',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicOnSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12), // Уменьшил с 16 до 12
        _buildChartCard(
          title: 'Распределение БЖУ',
          subtitle: 'Процентное соотношение',
          icon: Icons.pie_chart,
          color: AppColors.dynamicSecondary,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.dynamicSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Круговая диаграмма',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return NutryCard(
      backgroundColor: AppColors.dynamicCard,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок карточки
            Container(
              padding: const EdgeInsets.all(16), // Уменьшил с 18 до 16
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20, // Уменьшил с 22 до 20
                    ),
                  ),
                  const SizedBox(width: 14), // Уменьшил с 16 до 14
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              DesignTokens.typography.titleMediumStyle.copyWith(
                            color: AppColors.dynamicOnSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 3), // Уменьшил с 4 до 3
                        Text(
                          subtitle,
                          style:
                              DesignTokens.typography.bodySmallStyle.copyWith(
                            color: AppColors.dynamicOnSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Содержимое графика
            Container(
              padding: const EdgeInsets.all(16), // Уменьшил с 18 до 16
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Детальная аналитика',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: AppColors.dynamicOnBackground,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 12), // Уменьшил с 16 до 12
        _buildAnalyticsCard(
          title: 'Лучший день недели',
          value: 'Понедельник',
          subtitle: '1,950 ккал',
          icon: Icons.star,
          color: AppColors.dynamicWarning,
        ),
        const SizedBox(height: 8), // Уменьшил с 12 до 8
        _buildAnalyticsCard(
          title: 'Самый активный период',
          value: '18:00 - 20:00',
          subtitle: 'Вечерние тренировки',
          icon: Icons.schedule,
          color: AppColors.dynamicInfo,
        ),
        const SizedBox(height: 8), // Уменьшил с 12 до 8
        _buildAnalyticsCard(
          title: 'Цель достигнута',
          value: '85%',
          subtitle: 'Прогресс по белкам',
          icon: Icons.check_circle,
          color: AppColors.dynamicSuccess,
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return NutryCard(
      backgroundColor: AppColors.dynamicCard,
      child: Container(
        padding: const EdgeInsets.all(14), // Уменьшил с 18 до 14
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Иконка
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24, // Уменьшил с 26 до 24
              ),
            ),
            const SizedBox(width: 16), // Уменьшил с 20 до 16
            // Текстовая информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicOnSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: DesignTokens.typography.titleMediumStyle.copyWith(
                      color: AppColors.dynamicOnSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2), // Уменьшил с 4 до 2
                  Text(
                    subtitle,
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: AppColors.dynamicOnSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Стрелка
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.dynamicOnSurfaceVariant.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
