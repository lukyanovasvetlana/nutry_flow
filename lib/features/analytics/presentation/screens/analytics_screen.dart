import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/design/components/cards/nutry_card.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class AnalyticsScreen extends StatefulWidget {
  final bool showAppBar;

  const AnalyticsScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedPeriod = 'Неделя';

  final List<Map<String, dynamic>> periods = [
    {'name': 'День', 'icon': Icons.today},
    {'name': 'Неделя', 'icon': Icons.view_week},
    {'name': 'Месяц', 'icon': Icons.calendar_month},
    {'name': 'Год', 'icon': Icons.date_range},
  ];

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
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

          // Детальная аналитика
          _buildDetailedAnalytics(),
        ],
      ),
    );

    if (widget.showAppBar) {
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
        body: content,
      );
    }

    // Без AppBar возвращаем только контент без Container и SingleChildScrollView
    // так как он будет внутри другого SingleChildScrollView на дашборде
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Период
        _buildPeriodSelector(),
        const SizedBox(height: 20),

        // Основные метрики
        _buildMainMetrics(),
        const SizedBox(height: 24),

        // Детальная аналитика
        _buildDetailedAnalytics(),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    // Цвета для разных периодов, похожие на карточки структуры расходов
    final periodColors = [
      AppColors.green, // День
      AppColors.yellow, // Неделя
      AppColors.orange, // Месяц
      AppColors.primary, // Год
    ];

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
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: periods.asMap().entries.map((entry) {
              final index = entry.key;
              final period = entry.value;
              final periodName = period['name'] as String;
              final periodIcon = period['icon'] as IconData;
              final isSelected = selectedPeriod == periodName;
              final periodColor = periodColors[index % periodColors.length];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == periods.length - 1 ? 0 : 4,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPeriod = periodName;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.dynamicCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? periodColor
                              : AppColors.dynamicBorder,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dynamicShadow.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Иконка в контейнере, как в карточках структуры расходов
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: periodColor
                                      .withOpacity(isSelected ? 0.2 : 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  periodIcon,
                                  color: periodColor,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Название периода
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  periodName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.dynamicTextSecondary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
        const SizedBox(height: 12),
        // Круговая диаграмма основных показателей
        Container(
          constraints: const BoxConstraints(
            minHeight: 400,
            maxHeight: 450,
          ),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.dynamicCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.dynamicShadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: _buildMainMetricsPieChart(),
        ),
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
        const SizedBox(height: 8),
        _buildMetricCard(
          title: 'Белки',
          value: '85',
          unit: 'г',
          icon: Icons.fitness_center,
          color: AppColors.dynamicNutritionProtein,
          trend: '+2%',
          isPositive: true,
        ),
        const SizedBox(height: 8),
        _buildMetricCard(
          title: 'Жиры',
          value: '65',
          unit: 'г',
          icon: Icons.water_drop,
          color: AppColors.dynamicNutritionFats,
          trend: '-3%',
          isPositive: false,
        ),
        const SizedBox(height: 8),
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

  Widget _buildMainMetricsPieChart() {
    // Данные для диаграммы (в процентах от общего количества калорий)
    // Калории: 1850, Белки: 85г (340 ккал), Жиры: 65г (585 ккал), Углеводы: 220г (880 ккал)
    // Всего: 1850 ккал
    final double calories = 1850;
    final double proteins = 85 * 4; // 340 ккал
    final double fats = 65 * 9; // 585 ккал
    final double carbs = 220 * 4; // 880 ккал
    final double total = calories; // Используем калории как основу

    // Вычисляем проценты
    final double proteinsPercent = (proteins / total) * 100;
    final double fatsPercent = (fats / total) * 100;
    final double carbsPercent = (carbs / total) * 100;
    final double otherPercent =
        100 - proteinsPercent - fatsPercent - carbsPercent;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок с иконкой
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.dynamicPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.analytics,
                      color: AppColors.dynamicPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Распределение основных показателей',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.dynamicTextPrimary,
                            fontSize: 18,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Круговая диаграмма
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(enabled: true),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 3,
                            centerSpaceRadius: 50,
                            sections: [
                              PieChartSectionData(
                                color: _createVolumetricColor(
                                    AppColors.dynamicNutritionProtein),
                                value: proteinsPercent,
                                title: '${proteinsPercent.toStringAsFixed(0)}%',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      blurRadius: 3,
                                      offset: Offset(1, 2),
                                    ),
                                    Shadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _lightenColor(
                                        AppColors.dynamicNutritionProtein, 0.3),
                                    AppColors.dynamicNutritionProtein,
                                    _darkenColor(
                                        AppColors.dynamicNutritionProtein, 0.2),
                                  ],
                                ),
                              ),
                              PieChartSectionData(
                                color: _createVolumetricColor(
                                    AppColors.dynamicNutritionFats),
                                value: fatsPercent,
                                title: '${fatsPercent.toStringAsFixed(0)}%',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      blurRadius: 3,
                                      offset: Offset(1, 2),
                                    ),
                                    Shadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _lightenColor(
                                        AppColors.dynamicNutritionFats, 0.3),
                                    AppColors.dynamicNutritionFats,
                                    _darkenColor(
                                        AppColors.dynamicNutritionFats, 0.2),
                                  ],
                                ),
                              ),
                              PieChartSectionData(
                                color: _createVolumetricColor(
                                    AppColors.dynamicNutritionWater),
                                value: carbsPercent,
                                title: '${carbsPercent.toStringAsFixed(0)}%',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      blurRadius: 3,
                                      offset: Offset(1, 2),
                                    ),
                                    Shadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _lightenColor(
                                        AppColors.dynamicNutritionWater, 0.3),
                                    AppColors.dynamicNutritionWater,
                                    _darkenColor(
                                        AppColors.dynamicNutritionWater, 0.2),
                                  ],
                                ),
                              ),
                              if (otherPercent > 0)
                                PieChartSectionData(
                                  color: _createVolumetricColor(
                                      AppColors.dynamicNutritionCarbs),
                                  value: otherPercent,
                                  title: '${otherPercent.toStringAsFixed(0)}%',
                                  radius: 45,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black38,
                                        blurRadius: 3,
                                        offset: Offset(1, 2),
                                      ),
                                      Shadow(
                                        color: Colors.black12,
                                        blurRadius: 1,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      _lightenColor(
                                          AppColors.dynamicNutritionCarbs, 0.3),
                                      AppColors.dynamicNutritionCarbs,
                                      _darkenColor(
                                          AppColors.dynamicNutritionCarbs, 0.2),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Легенда
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem('Белки', proteinsPercent.toInt(),
                              AppColors.dynamicNutritionProtein),
                          const SizedBox(height: 16),
                          _buildLegendItem('Жиры', fatsPercent.toInt(),
                              AppColors.dynamicNutritionFats),
                          const SizedBox(height: 16),
                          _buildLegendItem('Углеводы', carbsPercent.toInt(),
                              AppColors.dynamicNutritionWater),
                          if (otherPercent > 0) ...[
                            const SizedBox(height: 16),
                            _buildLegendItem('Прочее', otherPercent.toInt(),
                                AppColors.dynamicNutritionCarbs),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _createVolumetricColor(Color baseColor) {
    return Color.lerp(baseColor, Colors.black, 0.1) ?? baseColor;
  }

  Color _lightenColor(Color color, double amount) {
    return Color.lerp(color, Colors.white, amount) ?? color;
  }

  Color _darkenColor(Color color, double amount) {
    return Color.lerp(color, Colors.black, amount) ?? color;
  }

  Widget _buildLegendItem(String label, int percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.dynamicTextPrimary,
            ),
          ),
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.dynamicTextSecondary,
          ),
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
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(14), // Уменьшил с 16 до 14
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Иконка слева
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
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
                    ? AppColors.dynamicSuccess.withValues(alpha: 0.15)
                    : AppColors.dynamicError.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPositive
                      ? AppColors.dynamicSuccess.withValues(alpha: 0.3)
                      : AppColors.dynamicError.withValues(alpha: 0.3),
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
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(14), // Уменьшил с 18 до 14
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Иконка
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
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
              color: AppColors.dynamicOnSurfaceVariant.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
