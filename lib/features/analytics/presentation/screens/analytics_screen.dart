import 'package:flutter/material.dart';
import 'package:pie_chart_sz/pie_chart_sz.dart';
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

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  String selectedPeriod = 'Неделя';
  String? selectedMacro; // Для интерактивности легенды
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> periods = [
    {'name': 'День', 'icon': Icons.today},
    {'name': 'Неделя', 'icon': Icons.view_week},
    {'name': 'Месяц', 'icon': Icons.calendar_month},
    {'name': 'Год', 'icon': Icons.date_range},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Градиенты для макронутриентов
  List<Color> get carbsGradient => [
        AppColors.dynamicOrange,
        AppColors.dynamicOrange.withValues(alpha: 0.7),
      ];

  List<Color> get proteinsGradient => [
        AppColors.dynamicPrimary,
        AppColors.dynamicPrimary.withValues(alpha: 0.7),
      ];

  List<Color> get fatsGradient => [
        AppColors.dynamicYellow,
        AppColors.dynamicYellow.withValues(alpha: 0.7),
  ];

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
          child: content,
        ),
      );
    }

    // Без AppBar возвращаем только контент без SingleChildScrollView
    // так как он будет внутри другого SingleChildScrollView на дашборде
    return content;
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
                            color: AppColors.dynamicShadow.withValues(alpha: 0.05),
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
                                      .withValues(alpha: isSelected ? 0.2 : 0.1),
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
        // Круговая диаграмма макронутриентов
        _buildNutritionPieChart(),
        const SizedBox(height: 16),
        // Горизонтальные карточки в одну колонку
        _buildMetricCard(
                title: 'Калории',
                value: '1,850',
                unit: 'ккал',
                icon: Icons.local_fire_department,
          color: AppColors.dynamicOrange,
                trend: '+5%',
                isPositive: true,
              ),
        const SizedBox(height: 8),
        _buildMetricCard(
                title: 'Белки',
                value: '85',
                unit: 'г',
                icon: Icons.fitness_center,
          color: AppColors.dynamicPrimary, // Зеленые
                trend: '+2%',
                isPositive: true,
        ),
        const SizedBox(height: 8),
        _buildMetricCard(
                title: 'Жиры',
                value: '65',
                unit: 'г',
                icon: Icons.water_drop,
          color: AppColors.dynamicYellow, // Желтые
                trend: '-3%',
                isPositive: false,
              ),
        const SizedBox(height: 8),
        _buildMetricCard(
                title: 'Углеводы',
                value: '220',
                unit: 'г',
                icon: Icons.grain,
          color: AppColors.dynamicOrange, // Оранжевые
                trend: '+8%',
                isPositive: true,
        ),
      ],
    );
  }

  Widget _buildNutritionPieChart() {
    // Данные для диаграммы макронутриентов
    final double carbs = 220;
    final double proteins = 85;
    final double fats = 65;
    final double total = carbs + proteins + fats;

    // Проценты для каждого макронутриента
    final double carbsPercent = (carbs / total) * 100;
    final double proteinsPercent = (proteins / total) * 100;
    final double fatsPercent = (fats / total) * 100;

     return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.dynamicShadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/images/dashboard_main_metrics_dark.jpg'
                      : 'assets/images/dashboard_main_metrics_light.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.88)
                      : Colors.white.withValues(alpha: 0.85),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
            // Размер диаграммы
            final double chartSize = constraints.maxWidth < 400 
                ? 220.0 
                : (constraints.maxWidth < 600 
                    ? 250.0 
                    : 280.0);
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Диаграмма сверху
                Center(
                  child: SizedBox(
                    width: chartSize,
                    height: chartSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dynamicPrimary.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          // Определяем цвета с учетом выбранного элемента и градиентов
                          // Выбранный элемент - яркий цвет, невыбранные - приглушенные
                          final isLightTheme = Theme.of(context).brightness == Brightness.light;
                          final desaturateColor = isLightTheme ? Colors.white : Colors.grey;
                          final mutedFactor = isLightTheme ? 0.15 : 0.6;
                          final blendFactor = isLightTheme ? 0.1 : 0.4;
                          
                          final carbsColor = selectedMacro == 'carbs'
                              ? carbsGradient[0]
                              : (selectedMacro != null 
                                  ? Color.lerp(carbsGradient[0], desaturateColor, mutedFactor) ?? AppColors.dynamicOrange
                                  : Color.lerp(carbsGradient[0], carbsGradient[1], blendFactor) ?? AppColors.dynamicOrange);
                          final proteinsColor = selectedMacro == 'proteins'
                              ? proteinsGradient[0]
                              : (selectedMacro != null 
                                  ? Color.lerp(proteinsGradient[0], desaturateColor, mutedFactor) ?? AppColors.dynamicPrimary
                                  : Color.lerp(proteinsGradient[0], proteinsGradient[1], blendFactor) ?? AppColors.dynamicPrimary);
                          final fatsColor = selectedMacro == 'fats'
                              ? fatsGradient[0]
                              : (selectedMacro != null 
                                  ? Color.lerp(fatsGradient[0], desaturateColor, mutedFactor) ?? AppColors.dynamicYellow
                                  : Color.lerp(fatsGradient[0], fatsGradient[1], blendFactor) ?? AppColors.dynamicYellow);

                          return PieChartSz(
                            colors: [
                              carbsColor,
                              proteinsColor,
                              fatsColor,
                            ],
                            values: [
                              carbsPercent * _animation.value,
                              proteinsPercent * _animation.value,
                              fatsPercent * _animation.value,
                            ],
                            gapSize: 0.18,
                            centerText: 'Всего\n${total.toInt()}г',
                            centerTextStyle: TextStyle(
                              fontSize: chartSize * 0.065,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dynamicOnBackground,
                              height: 1.3,
                            ),
                            valueSettings: Valuesettings(
                              showValues: false,
                              ValueTextStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.dynamicOnBackground,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Легенда в одну строку
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCompactLegendItem(
                        'Углеводы',
                        AppColors.dynamicOrange,
                        '${carbs.toInt()}г',
                        carbsPercent,
                        icon: Icons.grain,
                        macroKey: 'carbs',
                        gradient: carbsGradient,
                      ),
                      const SizedBox(width: 6),
                      _buildCompactLegendItem(
                        'Белки',
                        AppColors.dynamicPrimary,
                        '${proteins.toInt()}г',
                        proteinsPercent,
                        icon: Icons.fitness_center,
                        macroKey: 'proteins',
                        gradient: proteinsGradient,
                      ),
                      const SizedBox(width: 6),
                      _buildCompactLegendItem(
                        'Жиры',
                        AppColors.dynamicYellow,
                        '${fats.toInt()}г',
                        fatsPercent,
                        icon: Icons.water_drop,
                        macroKey: 'fats',
                        gradient: fatsGradient,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildCompactLegendItem(
    String label,
    Color color,
    String value,
    double percent, {
    IconData? icon,
    String? macroKey,
    List<Color>? gradient,
  }) {
    final isSelected = selectedMacro == macroKey;
    final baseColor = gradient?.first ?? color;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMacro = selectedMacro == macroKey ? null : macroKey;
        });
      },
      child: Transform.scale(
        scale: isSelected ? 1.05 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 10 : 8,
            vertical: isSelected ? 8 : 6,
          ),
        decoration: BoxDecoration(
          gradient: gradient != null && isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    gradient[0].withValues(alpha: 0.3),
                    gradient[1].withValues(alpha: 0.25),
                  ],
                )
              : null,
          color: gradient == null || !isSelected
              ? baseColor.withValues(alpha: isSelected ? 0.25 : 0.1)
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: baseColor.withValues(alpha: isSelected ? 0.8 : 0.3),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Иконка
            if (icon != null) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: gradient != null && isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradient,
                        )
                      : null,
                  color: gradient == null || !isSelected
                      ? baseColor.withValues(alpha: isSelected ? 0.3 : 0.2)
                      : null,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: baseColor.withValues(alpha: 0.4),
                            blurRadius: 4,
                            spreadRadius: 0.5,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  size: 10,
                  color: isSelected ? Colors.white : baseColor,
                ),
              ),
              const SizedBox(width: 4),
            ] else ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  gradient: gradient != null && isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradient,
                        )
                      : null,
                  color: gradient == null || !isSelected ? baseColor : null,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withValues(alpha: isSelected ? 0.5 : 0.3),
                      blurRadius: isSelected ? 4 : 3,
                      spreadRadius: isSelected ? 1 : 0.5,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
            ],
            // Текст и значения в одну строку (более компактно)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dynamicOnBackground,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${percent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: baseColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dynamicOnBackground,
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
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
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return NutryCard(
      backgroundColor: AppColors.dynamicCard,
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(14), // Уменьшил с 16 до 14
        decoration: BoxDecoration(
          color: isLightTheme ? color.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: isLightTheme ? 0.6 : 0.2),
            width: 1,
          ),
        ),
            child: Row(
              children: [
            // Иконка слева
                Container(
              padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                color: color.withValues(alpha: isLightTheme ? 0.3 : 0.15),
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


/// CustomPainter для рисования черной обводки секторов диаграммы
