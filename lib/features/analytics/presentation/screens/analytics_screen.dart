import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/design/components/cards/nutry_card.dart';
import '../../../../shared/design/components/buttons/nutry_button.dart';
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
            const SizedBox(height: 24),

            // Основные метрики
            _buildMainMetrics(),
            const SizedBox(height: 24),

            // Графики
            _buildChartsSection(),
            const SizedBox(height: 24),

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
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: periods.length,
            itemBuilder: (context, index) {
              final period = periods[index];
              final isSelected = selectedPeriod == period;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: NutryButton.chip(
                  onPressed: () {
                    setState(() {
                      selectedPeriod = period;
                    });
                  },
                  isSelected: isSelected,
                  child: Text(period),
                ),
              );
            },
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
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Калории',
                value: '1,850',
                unit: 'ккал',
                icon: Icons.local_fire_department,
                color: AppColors.dynamicNutritionCarbs,
                trend: '+5%',
                isPositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Белки',
                value: '85',
                unit: 'г',
                icon: Icons.fitness_center,
                color: AppColors.dynamicNutritionProtein,
                trend: '+2%',
                isPositive: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Жиры',
                value: '65',
                unit: 'г',
                icon: Icons.water_drop,
                color: AppColors.dynamicNutritionFats,
                trend: '-3%',
                isPositive: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Углеводы',
                value: '220',
                unit: 'г',
                icon: Icons.grain,
                color: AppColors.dynamicNutritionWater,
                trend: '+8%',
                isPositive: true,
              ),
            ),
          ],
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? AppColors.dynamicSuccess.withOpacity(0.1)
                        : AppColors.dynamicError.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 12,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicOnSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: DesignTokens.typography.headlineLargeStyle.copyWith(
                    color: AppColors.dynamicOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicOnSurfaceVariant,
                    ),
                  ),
                ),
              ],
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
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
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
                  color: AppColors.dynamicOnSurfaceVariant,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
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
                        ),
                      ),
                      Text(
                        subtitle,
                        style: DesignTokens.typography.bodySmallStyle.copyWith(
                          color: AppColors.dynamicOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
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
          ),
        ),
        const SizedBox(height: 16),
        _buildAnalyticsCard(
          title: 'Лучший день недели',
          value: 'Понедельник',
          subtitle: '1,950 ккал',
          icon: Icons.star,
          color: AppColors.dynamicWarning,
        ),
        const SizedBox(height: 12),
        _buildAnalyticsCard(
          title: 'Самый активный период',
          value: '18:00 - 20:00',
          subtitle: 'Вечерние тренировки',
          icon: Icons.schedule,
          color: AppColors.dynamicInfo,
        ),
        const SizedBox(height: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicOnSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: DesignTokens.typography.titleMediumStyle.copyWith(
                      color: AppColors.dynamicOnSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: AppColors.dynamicOnSurfaceVariant,
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
}
