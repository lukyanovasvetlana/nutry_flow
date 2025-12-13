import 'package:flutter/material.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../../shared/design/components/buttons/nutry_button.dart';
import '../../../../shared/theme/app_colors.dart';

class ExerciseScreenRedesigned extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const ExerciseScreenRedesigned({super.key, this.onBackPressed});

  @override
  State<ExerciseScreenRedesigned> createState() =>
      _ExerciseScreenRedesignedState();
}

class _ExerciseScreenRedesignedState extends State<ExerciseScreenRedesigned> {
  String selectedCategory = 'Все';

  final List<String> categories = [
    'Все',
    'Кардио',
    'Сила',
    'Йога',
    'Пилатес',
    'Танцы',
  ];

  final List<Map<String, dynamic>> exercises = [
    {
      'name': 'Бег',
      'category': 'Кардио',
      'duration': '30 мин',
      'calories': '300 ккал',
      'difficulty': 'Средний',
      'icon': Icons.directions_run,
      'color': Colors.blue,
    },
    {
      'name': 'Приседания',
      'category': 'Сила',
      'duration': '15 мин',
      'calories': '150 ккал',
      'difficulty': 'Легкий',
      'icon': Icons.fitness_center,
      'color': Colors.green,
    },
    {
      'name': 'Планка',
      'category': 'Сила',
      'duration': '10 мин',
      'calories': '100 ккал',
      'difficulty': 'Средний',
      'icon': Icons.accessibility_new,
      'color': Colors.orange,
    },
    {
      'name': 'Велосипед',
      'category': 'Кардио',
      'duration': '45 мин',
      'calories': '400 ккал',
      'difficulty': 'Средний',
      'icon': Icons.directions_bike,
      'color': Colors.purple,
    },
    {
      'name': 'Сурья Намаскар',
      'category': 'Йога',
      'duration': '20 мин',
      'calories': '120 ккал',
      'difficulty': 'Легкий',
      'icon': Icons.self_improvement,
      'color': Colors.teal,
    },
    {
      'name': 'Пилатес',
      'category': 'Пилатес',
      'duration': '25 мин',
      'calories': '180 ккал',
      'difficulty': 'Средний',
      'icon': Icons.accessibility,
      'color': Colors.indigo,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicSurface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Упражнения',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.dynamicTextPrimary,
            ),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: AppColors.dynamicTextPrimary,
            ),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Категории
          _buildCategoriesSection(),

          // Список упражнений
          Expanded(
            child: _buildExercisesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12), // Уменьшил padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Категории',
            style: DesignTokens.typography.titleMediumStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8), // Уменьшил с 12 до 8
          SizedBox(
            height: 36, // Уменьшил с 40 до 36
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 6), // Уменьшил с 8 до 6
                  child: NutryButton.chip(
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    isSelected: isSelected,
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12, // Уменьшил размер шрифта
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesList() {
    final filteredExercises = selectedCategory == 'Все'
        ? exercises
        : exercises
            .where((exercise) => exercise['category'] == selectedCategory)
            .toList();

    return ListView.builder(
      padding:
          const EdgeInsets.symmetric(horizontal: 12), // Уменьшил с 16 до 12
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = filteredExercises[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8), // Уменьшил с 12 до 8
          child: _buildExerciseCard(exercise),
        );
      },
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Card(
      color: AppColors.dynamicCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to exercise details
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12), // Уменьшил padding с 16 до 12
          child: Row(
            children: [
              // Иконка упражнения
              Container(
                width: 50, // Уменьшил с 60 до 50
                height: 50, // Уменьшил с 60 до 50
                decoration: BoxDecoration(
                  color: (exercise['color'] as Color).withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(10), // Уменьшил с 12 до 10
                ),
                child: Icon(
                  exercise['icon'] as IconData,
                  color: exercise['color'] as Color,
                  size: 24, // Уменьшил с 28 до 24
                ),
              ),
              const SizedBox(width: 12), // Уменьшил с 16 до 12

              // Информация об упражнении
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['name'] as String,
                      style: DesignTokens.typography.titleMediumStyle.copyWith(
                        color: AppColors.dynamicTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Добавил ellipsis для длинных названий
                    ),
                    const SizedBox(height: 2), // Уменьшил с 4 до 2
                    Text(
                      exercise['category'] as String,
                      style: DesignTokens.typography.bodySmallStyle.copyWith(
                        color: AppColors.dynamicTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis, // Добавил ellipsis
                    ),
                    const SizedBox(height: 6), // Уменьшил с 8 до 6

                    // Детали упражнения
                    Wrap(
                      // Заменил Row на Wrap для предотвращения переполнения
                      spacing: 8, // Уменьшил spacing между элементами
                      runSpacing: 4,
                      children: [
                        _buildExerciseDetail(
                          Icons.timer,
                          exercise['duration'] as String,
                        ),
                        _buildExerciseDetail(
                          Icons.local_fire_department,
                          exercise['calories'] as String,
                        ),
                        _buildExerciseDetail(
                          Icons.trending_up,
                          exercise['difficulty'] as String,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8), // Добавил небольшой отступ

              // Кнопка "Начать" - сделал более компактной
              SizedBox(
                height: 36, // Фиксированная высота
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Start exercise
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dynamicPrimary,
                    foregroundColor: AppColors.dynamicOnPrimary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Начать',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14, // Уменьшил с 16 до 14
          color: AppColors.dynamicTextSecondary,
        ),
        const SizedBox(width: 3), // Уменьшил с 4 до 3
        Text(
          text,
          style: DesignTokens.typography.bodySmallStyle.copyWith(
            color: AppColors.dynamicTextSecondary,
            fontSize: 11, // Уменьшил размер шрифта
          ),
        ),
      ],
    );
  }
}
