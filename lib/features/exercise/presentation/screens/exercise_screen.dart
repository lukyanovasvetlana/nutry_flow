import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';
import '../../data/services/exercise_service.dart';
import '../widgets/exercise_card.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_styles.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    _exercises = ExerciseService.getAllExercises();
    _applyFilters();
  }

  void _applyFilters() {
    List<Exercise> filtered = _exercises;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = ExerciseService.searchExercises(_searchQuery);
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((exercise) => exercise.category == _selectedCategory)
          .toList();
    }

    // Apply difficulty filter
    if (_selectedDifficulty != 'All') {
      filtered = filtered
          .where((exercise) => exercise.difficulty == _selectedDifficulty)
          .toList();
    }

    setState(() {
      _filteredExercises = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Фильтры', style: AppStyles.headlineSmall),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Категория',
                  style: AppStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: ExerciseService.getCategories().map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category == 'All' ? 'Все' : category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text('Сложность',
                  style: AppStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedDifficulty,
                isExpanded: true,
                items:
                    ExerciseService.getDifficulties().map((String difficulty) {
                  String displayText = difficulty;
                  switch (difficulty) {
                    case 'All':
                      displayText = 'Все';
                      break;
                    case 'Beginner':
                      displayText = 'Начинающий';
                      break;
                    case 'Intermediate':
                      displayText = 'Средний';
                      break;
                    case 'Advanced':
                      displayText = 'Продвинутый';
                      break;
                  }
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(displayText),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDifficulty = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                _applyFilters();
                Navigator.of(context).pop();
              },
              child: const Text('Применить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dynamicTextPrimary),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: Text(
          'Упражнения',
          style: AppStyles.headlineMedium.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: AppColors.dynamicTextPrimary),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.dynamicSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.dynamicBorder),
                    ),
                    child: TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Поиск упражнений',
                        hintStyle: AppStyles.bodyMedium
                            .copyWith(color: AppColors.dynamicTextSecondary),
                        prefixIcon: Icon(Icons.search,
                            color: AppColors.dynamicTextSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.dynamicSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.dynamicBorder),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.more_horiz,
                        color: AppColors.dynamicTextSecondary),
                    onPressed: _showFilterDialog,
                  ),
                ),
                const SizedBox(width: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.dynamicButton,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      // Handle add exercise
                    },
                    icon: Icon(Icons.add, color: AppColors.dynamicOnPrimary),
                    label: Text(
                      'Добавить упражнение',
                      style: TextStyle(color: AppColors.dynamicOnPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const SizedBox(width: 64), // Space for icon
                Expanded(
                  flex: 2,
                  child: Text(
                    'Название упражнения',
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Подходы',
                    textAlign: TextAlign.center,
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Повторения',
                    textAlign: TextAlign.center,
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Отдых',
                    textAlign: TextAlign.center,
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Exercise List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return ExerciseCard(
                  exercise: exercise,
                  onTap: () {
                    // Navigate to exercise details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
