import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'package:horizontal_gauge/horizontal_gauge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/notifiers/nutrition_metrics_notifier.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../nutrition/data/repositories/nutrition_repository_impl.dart';
import '../../../nutrition/data/services/nutrition_api_service.dart';
import '../../../nutrition/data/services/nutrition_cache_service.dart';
import '../../../nutrition/domain/entities/nutrition_summary.dart';
import '../../../profile/data/repositories/profile_repository_impl.dart';
import '../../../profile/data/services/profile_service.dart';
import '../../../profile/domain/entities/user_profile.dart';
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

  @override
  void initState() {
    super.initState();
  }

  final List<Map<String, dynamic>> periods = [
    {'name': 'День', 'icon': Icons.today},
    {'name': 'Неделя', 'icon': Icons.view_week},
    {'name': 'Месяц', 'icon': Icons.calendar_month},
    {'name': 'Год', 'icon': Icons.date_range},
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
                            color:
                                AppColors.dynamicShadow.withValues(alpha: 0.05),
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
                                  color: periodColor.withValues(
                                      alpha: isSelected ? 0.2 : 0.1),
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
    return ValueListenableBuilder<int>(
      valueListenable: nutritionMetricsRefresh,
      builder: (context, _, __) {
        return FutureBuilder<_MacroMetrics>(
          future: _loadMacroMetrics(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? const _MacroMetrics.empty();
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
                // Горизонтальная диаграмма основных показателей
                _buildMainMetricsGauge(data),
                const SizedBox(height: 16),
                // Горизонтальные карточки в одну колонку
                _buildMetricCard(
                  title: 'Калории',
                  value: data.calories.toStringAsFixed(0),
                  unit: 'ккал',
                  icon: Icons.local_fire_department,
                  color: AppColors.dynamicOrange,
                  trend: '0%',
                  isPositive: true,
                ),
                const SizedBox(height: 8),
                _buildMetricCard(
                  title: 'Белки',
                  value: data.proteins.toStringAsFixed(0),
                  unit: 'г',
                  icon: Icons.fitness_center,
                  color: AppColors.dynamicPrimary,
                  trend: '0%',
                  isPositive: true,
                ),
                const SizedBox(height: 8),
                _buildMetricCard(
                  title: 'Жиры',
                  value: data.fats.toStringAsFixed(0),
                  unit: 'г',
                  icon: Icons.water_drop,
                  color: AppColors.dynamicYellow,
                  trend: '0%',
                  isPositive: true,
                ),
                const SizedBox(height: 8),
                _buildMetricCard(
                  title: 'Углеводы',
                  value: data.carbs.toStringAsFixed(0),
                  unit: 'г',
                  icon: Icons.grain,
                  color: AppColors.dynamicOrange,
                  trend: '0%',
                  isPositive: true,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMainMetricsGauge(_MacroMetrics data) {
    final bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    final double carbs = data.carbs;
    final double proteins = data.proteins;
    final double fats = data.fats;
    final double carbsGoal = data.carbsGoal;
    final double proteinsGoal = data.proteinsGoal;
    final double fatsGoal = data.fatsGoal;

    return DecoratedBox(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IgnorePointer(
                    ignoring: true,
                    child: HorizontalGauge(
                      title: 'Углеводы',
                      min: 0.0,
                      max: carbsGoal,
                      value: carbs,
                      unit: 'г',
                      color: AppColors.dynamicOrange,
                      onChanged: null,
                      showTicks: true,
                      showLabels: true,
                      customTickCount: 61,
                      theme: _buildGaugeTheme(
                        isLightTheme: isLightTheme,
                        primaryColor: AppColors.dynamicOrange,
                        secondaryColor: AppColors.dynamicYellow,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  IgnorePointer(
                    ignoring: true,
                    child: HorizontalGauge(
                      title: 'Белки',
                      min: 0.0,
                      max: proteinsGoal,
                      value: proteins,
                      unit: 'г',
                      color: AppColors.dynamicPrimary,
                      onChanged: null,
                      showTicks: true,
                      showLabels: true,
                      customTickCount: 61,
                      theme: _buildGaugeTheme(
                        isLightTheme: isLightTheme,
                        primaryColor: AppColors.dynamicPrimary,
                        secondaryColor: AppColors.dynamicTeal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  IgnorePointer(
                    ignoring: true,
                    child: HorizontalGauge(
                      title: 'Жиры',
                      min: 0.0,
                      max: fatsGoal,
                      value: fats,
                      unit: 'г',
                      color: AppColors.dynamicYellow,
                      onChanged: null,
                      showTicks: true,
                      showLabels: true,
                      customTickCount: 61,
                      theme: _buildGaugeTheme(
                        isLightTheme: isLightTheme,
                        primaryColor: AppColors.dynamicYellow,
                        secondaryColor: AppColors.dynamicOrange,
                      ),
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

  HorizontalGaugeTheme _buildGaugeTheme({
    required bool isLightTheme,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    final scaleColor = isLightTheme ? Colors.black : Colors.white;
    return HorizontalGaugeTheme(
      backgroundColor: isLightTheme
          ? Colors.white.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.25),
      borderColor: AppColors.dynamicBorder.withValues(alpha: 0.3),
      titleColor: AppColors.dynamicTextSecondary,
      valueColor: AppColors.dynamicTextPrimary,
      unitColor: AppColors.dynamicTextSecondary,
      tickColor: scaleColor,
      majorTickColor: scaleColor,
      labelColor: scaleColor,
      indicatorGradient: LinearGradient(
        colors: [
          primaryColor,
          secondaryColor,
        ],
      ),
      indicatorShadows: [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.35),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Future<_MacroMetrics> _loadMacroMetrics() async {
    final userId =
        SupabaseService.instance.currentUser?.id ?? 'current_user_id';
    final profile = await _loadUserProfile(userId);
    final summary = await _loadNutritionSummary(userId);
    final localTotals = await _loadLocalMealTotals(DateTime.now());

    final carbs = (summary?.totalCarbs ?? 0) + localTotals.carbs;
    final proteins = (summary?.totalProtein ?? 0) + localTotals.proteins;
    final fats = (summary?.totalFats ?? 0) + localTotals.fats;
    final calories = (summary?.totalCalories ?? 0) + localTotals.calories;

    final carbsGoal = _normalizeGoal(profile?.targetCarbs, carbs, 200);
    final proteinsGoal = _normalizeGoal(profile?.targetProtein, proteins, 100);
    final fatsGoal = _normalizeGoal(profile?.targetFat, fats, 70);

    return _MacroMetrics(
      calories: calories,
      carbs: carbs,
      proteins: proteins,
      fats: fats,
      carbsGoal: carbsGoal,
      proteinsGoal: proteinsGoal,
      fatsGoal: fatsGoal,
    );
  }

  double _normalizeGoal(double? goal, double value, double fallback) {
    if (goal != null && goal > 0) {
      return goal;
    }
    if (value > 0) {
      return max(value * 1.2, fallback);
    }
    return fallback;
  }

  Future<UserProfile?> _loadUserProfile(String userId) async {
    try {
      final profileRepository = ProfileRepositoryImpl(MockProfileService());
      return await profileRepository.getUserProfile(userId);
    } catch (_) {
      return null;
    }
  }

  Future<NutritionSummary?> _loadNutritionSummary(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheService = NutritionCacheService(prefs);

      final cached =
          await cacheService.getCachedNutritionSummary(userId, DateTime.now());
      if (cached != null) {
        return cached.toEntity();
      }

      final client = SupabaseService.instance.client;
      if (client == null) {
        return null;
      }

      final apiService = NutritionApiService(client);
      final repository = NutritionRepositoryImpl(apiService, cacheService);
      return await repository.getNutritionSummaryByDate(userId, DateTime.now());
    } catch (_) {
      return null;
    }
  }

  Future<_MacroTotals> _loadLocalMealTotals(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = date.toIso8601String().split('T')[0];
      final stored = prefs.getString('meal_entries_$dateKey');
      if (stored == null || stored.isEmpty) {
        return const _MacroTotals.empty();
      }

      final decoded = jsonDecode(stored) as Map<String, dynamic>;
      double calories = 0;
      double carbs = 0;
      double proteins = 0;
      double fats = 0;

      for (final mealEntries in decoded.values) {
        if (mealEntries is! List) continue;
        for (final entry in mealEntries) {
          if (entry is! Map<String, dynamic>) continue;
          calories += (entry['calories'] as num?)?.toDouble() ?? 0;
          carbs += (entry['carbs'] as num?)?.toDouble() ?? 0;
          proteins += (entry['protein'] as num?)?.toDouble() ?? 0;
          fats += (entry['fat'] as num?)?.toDouble() ?? 0;
        }
      }

      return _MacroTotals(
        calories: calories,
        carbs: carbs,
        proteins: proteins,
        fats: fats,
      );
    } catch (_) {
      return const _MacroTotals.empty();
    }
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

class _MacroMetrics {
  final double calories;
  final double carbs;
  final double proteins;
  final double fats;
  final double carbsGoal;
  final double proteinsGoal;
  final double fatsGoal;

  const _MacroMetrics({
    required this.calories,
    required this.carbs,
    required this.proteins,
    required this.fats,
    required this.carbsGoal,
    required this.proteinsGoal,
    required this.fatsGoal,
  });

  const _MacroMetrics.empty()
      : calories = 0,
        carbs = 0,
        proteins = 0,
        fats = 0,
        carbsGoal = 200,
        proteinsGoal = 100,
        fatsGoal = 70;
}

class _MacroTotals {
  final double calories;
  final double carbs;
  final double proteins;
  final double fats;

  const _MacroTotals({
    required this.calories,
    required this.carbs,
    required this.proteins,
    required this.fats,
  });

  const _MacroTotals.empty()
      : calories = 0,
        carbs = 0,
        proteins = 0,
        fats = 0;
}

/// CustomPainter для рисования черной обводки секторов диаграммы
