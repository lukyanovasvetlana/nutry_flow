import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../widgets/meal_plan_card.dart';
import '../widgets/meal_entry_section.dart';
import '../widgets/additional_trackers.dart';
import 'add_food_screen.dart';
import 'water_tracker_notice_screen.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDayIndex = 0; // Индекс выбранного дня (0 = сегодня)

  // Хранилище записей о еде по типам приемов пищи
  final Map<String, List<Map<String, dynamic>>> _mealEntries = {
    'Завтрак': [],
    'Обед': [],
    'Ужин': [],
    'Перекус/Другое': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с датой
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing.lg,
                  vertical: DesignTokens.spacing.md,
                ),
                child: Text(
                  _getDateTitle(),
                  style: DesignTokens.typography.titleLargeStyle.copyWith(
                    color: AppColors.dynamicTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Карточки дней недели
              _buildWeekDays(),
              SizedBox(height: DesignTokens.spacing.md),

              // Горизонтальный скролл карточек планов питания
              _buildMealPlanCards(),
              SizedBox(height: DesignTokens.spacing.lg),

              // Секции для ввода приемов пищи
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: DesignTokens.spacing.lg),
                child: Column(
                  children: [
                    MealEntrySection(
                      mealType: 'Завтрак',
                      icon: Icons.wb_sunny,
                      onAdd: () => _openAddFoodScreen('Завтрак'),
                      color: AppColors.dynamicWarning,
                      entries: _mealEntries['Завтрак']!,
                      onDelete: (index) {
                        setState(() {
                          _mealEntries['Завтрак']!.removeAt(index);
                        });
                      },
                    ),
                    SizedBox(height: DesignTokens.spacing.md),
                    MealEntrySection(
                      mealType: 'Обед',
                      icon: Icons.restaurant,
                      onAdd: () => _openAddFoodScreen('Обед'),
                      color: AppColors.dynamicPrimary,
                      entries: _mealEntries['Обед']!,
                      onDelete: (index) {
                        setState(() {
                          _mealEntries['Обед']!.removeAt(index);
                        });
                      },
                    ),
                    SizedBox(height: DesignTokens.spacing.md),
                    MealEntrySection(
                      mealType: 'Ужин',
                      icon: Icons.dinner_dining,
                      onAdd: () => _openAddFoodScreen('Ужин'),
                      color: AppColors.dynamicInfo,
                      entries: _mealEntries['Ужин']!,
                      onDelete: (index) {
                        setState(() {
                          _mealEntries['Ужин']!.removeAt(index);
                        });
                      },
                    ),
                    SizedBox(height: DesignTokens.spacing.md),
                    MealEntrySection(
                      mealType: 'Перекус/Другое',
                      icon: Icons.fastfood,
                      onAdd: () => _openAddFoodScreen('Перекус/Другое'),
                      color: AppColors.dynamicOrange,
                      entries: _mealEntries['Перекус/Другое']!,
                      onDelete: (index) {
                        setState(() {
                          _mealEntries['Перекус/Другое']!.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: DesignTokens.spacing.lg),

              // Дополнительные трекеры
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: DesignTokens.spacing.lg),
                child: AdditionalTracker(
                  title: 'Трекер Воды',
                  icon: Icons.water_drop,
                  onAdd: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WaterTrackerNoticeScreen(
                          imageAssetPath: 'assets/images/water_green.jpg',
                        ),
                      ),
                    );
                  },
                  showAddButton: true,
                  color: AppColors.dynamicNutritionWater,
                ),
              ),
              SizedBox(height: DesignTokens.spacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  String _getDateTitle() {
    final now = DateTime.now();
    final selectedDate = now.add(Duration(days: _selectedDayIndex));

    if (_selectedDayIndex == 0) {
      return 'Сегодня';
    }

    final months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];

    return '${selectedDate.day} ${months[selectedDate.month - 1]}';
  }

  void _openAddFoodScreen(String mealType) {
    final now = DateTime.now();
    final selectedDate = now.add(Duration(days: _selectedDayIndex));

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => AddFoodScreen(
          mealType: mealType,
          selectedDate: selectedDate,
        ),
      ),
    )
        .then((result) {
      // Если данные сохранены, добавляем их в список
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          final savedMealType = result['mealType'] as String? ?? mealType;
          if (_mealEntries.containsKey(savedMealType)) {
            _mealEntries[savedMealType]!.add(result);
          }
        });
      }
    });
  }

  Widget _buildWeekDays() {
    final now = DateTime.now();
    final weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final today = now.weekday - 1; // Monday = 0

    // Цвета для разных дней недели из палитры приложения
    final dayColors = [
      AppColors.dynamicWarning, // Пн - желтый (как завтрак)
      AppColors.dynamicPrimary, // Вт - зеленый (как обед)
      AppColors.dynamicInfo, // Ср - синий (как ужин)
      AppColors.dynamicOrange, // Чт - оранжевый (как перекус)
      AppColors.dynamicSuccess, // Пт - зеленый успех
      AppColors.dynamicSecondary, // Сб - вторичный зеленый
      AppColors.dynamicTeal, // Вс - бирюзовый
    ];

    // Иконки, связанные с питанием и здоровьем для каждого дня недели
    final dayIcons = [
      Icons.wb_sunny, // Пн - завтрак, начало дня
      Icons.restaurant, // Вт - обед, питание
      Icons.local_dining, // Ср - ужин, прием пищи
      Icons.fitness_center, // Чт - активность и питание
      Icons.fastfood, // Пт - перекус, легкая еда
      Icons.emoji_food_beverage, // Сб - напитки, отдых
      Icons.health_and_safety, // Вс - здоровье, баланс
    ];

    return Column(
      children: [
        SizedBox(
          height: 70,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacing.lg),
            children: List.generate(7, (index) {
              final dayIndex = (today + index) % 7;
              final isSelected = index == _selectedDayIndex;
              final dayColor = dayColors[dayIndex];
              final dayIcon = dayIcons[dayIndex];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDayIndex = index;
                  });
                },
                child: Container(
                  width: 60,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == 6 ? 0 : 4,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? dayColor.withValues(alpha: 0.12)
                              : AppColors.dynamicCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? dayColor.withValues(alpha: 0.7)
                                : dayColor.withValues(alpha: 0.25),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dynamicShadow
                                  .withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Интересная иконка для дня
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: dayColor.withValues(
                                    alpha: isSelected ? 0.3 : 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                dayIcon,
                                color: dayColor,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacing.xs),
                      Text(
                        weekDays[dayIndex],
                        style: DesignTokens.typography.labelSmallStyle.copyWith(
                          color: isSelected
                              ? dayColor
                              : AppColors.dynamicTextSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMealPlanCards() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacing.lg),
        children: [
          MealPlanCard(
            title: 'Сбалансированное питание: белки и углеводы',
            imageUrl:
                'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&q=80',
            articleId: 'protein-carb',
          ),
          SizedBox(width: DesignTokens.spacing.md),
          MealPlanCard(
            title: 'Интервальное голодание для здоровья',
            imageUrl:
                'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
            articleId: 'intermittent-fasting',
          ),
          SizedBox(width: DesignTokens.spacing.md),
          MealPlanCard(
            title: 'Кетогенная диета: основы и преимущества',
            imageUrl:
                'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
            articleId: 'keto',
          ),
        ],
      ),
    );
  }
}
