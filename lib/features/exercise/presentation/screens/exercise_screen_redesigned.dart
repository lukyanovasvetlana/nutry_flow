import 'package:flutter/material.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../../shared/theme/app_colors.dart';
import 'package:nutry_flow/features/activity/domain/entities/exercise.dart'
    as activity;
import 'package:nutry_flow/features/activity/domain/entities/workout.dart';
import 'package:nutry_flow/features/activity/presentation/screens/workout_session_screen.dart';

class ExerciseScreenRedesigned extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const ExerciseScreenRedesigned({super.key, this.onBackPressed});

  @override
  State<ExerciseScreenRedesigned> createState() =>
      _ExerciseScreenRedesignedState();
}

class _ExerciseScreenRedesignedState extends State<ExerciseScreenRedesigned> {
  String selectedCategory = 'Все';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
      'technique': 'Ровная осанка, мягкая постановка стопы.',
      'icon': Icons.directions_run,
      'color': Colors.blue,
    },
    {
      'name': 'Приседания',
      'category': 'Сила',
      'duration': '15 мин',
      'calories': '150 ккал',
      'difficulty': 'Легкий',
      'technique': 'Спина ровная, колени по линии носков.',
      'icon': Icons.fitness_center,
      'color': Colors.green,
    },
    {
      'name': 'Планка',
      'category': 'Сила',
      'duration': '10 мин',
      'calories': '100 ккал',
      'difficulty': 'Средний',
      'technique': 'Тело в одной линии, пресс напряжён.',
      'icon': Icons.accessibility_new,
      'color': Colors.orange,
    },
    {
      'name': 'Велосипед',
      'category': 'Кардио',
      'duration': '45 мин',
      'calories': '400 ккал',
      'difficulty': 'Средний',
      'technique': 'Круговые движения, ровный темп.',
      'icon': Icons.directions_bike,
      'color': Colors.purple,
    },
    {
      'name': 'Сурья Намаскар',
      'category': 'Йога',
      'duration': '20 мин',
      'calories': '120 ккал',
      'difficulty': 'Легкий',
      'technique': 'Плавные переходы, дыхание ровное.',
      'icon': Icons.self_improvement,
      'color': Colors.teal,
    },
    {
      'name': 'Пилатес',
      'category': 'Пилатес',
      'duration': '25 мин',
      'calories': '180 ккал',
      'difficulty': 'Средний',
      'technique': 'Контроль корпуса, движения медленные.',
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
            onPressed: _showSearchDialog,
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSearchDialog() {
    _searchController.text = _searchQuery;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.dynamicCard,
          title: Text(
            'Поиск упражнений',
            style: TextStyle(
              color: AppColors.dynamicTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Введите название',
              hintStyle: TextStyle(color: AppColors.dynamicTextSecondary),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.dynamicTextSecondary,
              ),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.dynamicTextSecondary,
                      ),
                      onPressed: () {
                        if (!mounted) return;
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    ),
              filled: true,
              fillColor: AppColors.dynamicSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.dynamicBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.dynamicBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.dynamicPrimary),
              ),
            ),
            style: TextStyle(color: AppColors.dynamicTextPrimary),
            onSubmitted: (_) => _applySearch(dialogContext),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Отмена',
                style: TextStyle(color: AppColors.dynamicTextSecondary),
              ),
            ),
            TextButton(
              onPressed: () => _applySearch(dialogContext),
              child: Text(
                'Найти',
                style: TextStyle(
                  color: AppColors.dynamicPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _applySearch(BuildContext dialogContext) {
    if (!mounted) return;
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
    Navigator.of(dialogContext).pop();
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
                  child: _buildCategoryChip(
                    category: category,
                    isSelected: isSelected,
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
    var filteredExercises = selectedCategory == 'Все'
        ? exercises
        : exercises
            .where((exercise) => exercise['category'] == selectedCategory)
            .toList();

    if (_searchQuery.isNotEmpty) {
      final normalizedQuery = _searchQuery.toLowerCase();
      filteredExercises = filteredExercises
          .where((exercise) => (exercise['name'] as String)
              .toLowerCase()
              .contains(normalizedQuery))
          .toList();
    }

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

  void _startExercise(Map<String, dynamic> exercise) {
    if (!mounted) return;
    final workout = _buildWorkoutForExercise(exercise);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutSessionScreen(workout: workout),
      ),
    );
  }

  Workout _buildWorkoutForExercise(Map<String, dynamic> exercise) {
    final now = DateTime.now();
    final name = exercise['name'] as String;
    final category = exercise['category'] as String;
    final difficulty = exercise['difficulty'] as String;
    final duration = exercise['duration'] as String?;
    final icon = exercise['icon'] as IconData?;
    final technique =
        exercise['technique'] as String? ?? 'Техника выполнения уточняется';

    final activityExercise = activity.Exercise(
      id: 'exercise_${now.millisecondsSinceEpoch}',
      name: name,
      category: _mapCategory(category),
      difficulty: _mapDifficulty(difficulty),
      duration: duration,
      iconName: _mapIconName(icon),
      description: technique,
      targetMuscles: const [],
      equipment: const [],
    );

    final workoutExercise = WorkoutExercise(
      id: 'workout_exercise_${now.millisecondsSinceEpoch}',
      exercise: activityExercise,
      orderIndex: 0,
      sets: 3,
      reps: 12,
      duration: duration,
      restSeconds: 60,
    );

    return Workout(
      id: 'workout_${now.millisecondsSinceEpoch}',
      userId: 'current_user_id',
      name: name,
      description: 'Тренировка на основе упражнения "$name"',
      estimatedDurationMinutes: _parseDurationMinutes(duration),
      difficulty: _mapWorkoutDifficulty(difficulty),
      exercises: [workoutExercise],
      createdAt: now,
      updatedAt: now,
    );
  }

  activity.ExerciseCategory _mapCategory(String category) {
    switch (category) {
      case 'Кардио':
        return activity.ExerciseCategory.cardio;
      case 'Йога':
        return activity.ExerciseCategory.yoga;
      case 'Пилатес':
        return activity.ExerciseCategory.flexibility;
      case 'Сила':
        return activity.ExerciseCategory.arms;
      case 'Танцы':
        return activity.ExerciseCategory.cardio;
      default:
        return activity.ExerciseCategory.core;
    }
  }

  activity.ExerciseDifficulty _mapDifficulty(String difficulty) {
    switch (difficulty) {
      case 'Легкий':
        return activity.ExerciseDifficulty.beginner;
      case 'Средний':
        return activity.ExerciseDifficulty.intermediate;
      case 'Сложный':
        return activity.ExerciseDifficulty.advanced;
      default:
        return activity.ExerciseDifficulty.intermediate;
    }
  }

  WorkoutDifficulty _mapWorkoutDifficulty(String difficulty) {
    switch (difficulty) {
      case 'Легкий':
        return WorkoutDifficulty.beginner;
      case 'Средний':
        return WorkoutDifficulty.intermediate;
      case 'Сложный':
        return WorkoutDifficulty.advanced;
      default:
        return WorkoutDifficulty.intermediate;
    }
  }

  String _mapIconName(IconData? icon) {
    if (icon == Icons.directions_run) return 'directions_run';
    if (icon == Icons.directions_bike) return 'directions_bike';
    if (icon == Icons.self_improvement) return 'self_improvement';
    if (icon == Icons.accessibility || icon == Icons.accessibility_new) {
      return 'accessibility';
    }
    if (icon == Icons.fitness_center) return 'fitness_center';
    return 'fitness_center';
  }

  int? _parseDurationMinutes(String? duration) {
    if (duration == null) return null;
    final match = RegExp(r'\d+').firstMatch(duration);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
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
                    Text(
                      exercise['technique'] as String? ??
                          'Техника выполнения уточняется',
                      style: DesignTokens.typography.bodySmallStyle.copyWith(
                        color: AppColors.dynamicTextSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

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

              // Кнопка "Начать" - в стиле основного приложения
              SizedBox(
                height: 36, // Фиксированная высота
                child: ElevatedButton(
                  onPressed: () {
                    _startExercise(exercise);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Начать',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  /// Упрощенная версия chip кнопки без FocusNode для использования в списках
  Widget _buildCategoryChip({
    required String category,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dynamicPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.borders.full),
          border: Border.all(
            color:
                isSelected ? AppColors.dynamicPrimary : AppColors.dynamicBorder,
            width: DesignTokens.borders.thin,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? AppColors.dynamicOnPrimary
                : AppColors.dynamicTextPrimary,
          ),
        ),
      ),
    );
  }
}
