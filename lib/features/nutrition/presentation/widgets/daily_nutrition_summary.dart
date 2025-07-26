import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_summary.dart';
import '../../domain/entities/food_entry.dart';

class DailyNutritionSummary extends StatelessWidget {
  final NutritionSummary summary;
  final Function(MealType?)? onMealTypeFilterChanged;
  final MealType? selectedMealType;

  const DailyNutritionSummary({
    Key? key,
    required this.summary,
    this.onMealTypeFilterChanged,
    this.selectedMealType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Дневная сводка',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onMealTypeFilterChanged != null)
                  IconButton(
                    icon: Icon(
                      selectedMealType == null 
                          ? Icons.filter_list 
                          : Icons.filter_list_off,
                    ),
                    onPressed: () => onMealTypeFilterChanged!(null),
                    tooltip: 'Сбросить фильтр',
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Main nutrition info
            Row(
              children: [
                Expanded(
                  child: _buildNutritionCard(
                    'Калории',
                    '${summary.totalCalories.toStringAsFixed(0)}',
                    'ккал',
                    Icons.local_fire_department,
                    Colors.orange,
                    _getCaloriesProgress(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutritionCard(
                    'Белки',
                    '${summary.totalProtein.toStringAsFixed(1)}',
                    'г',
                    Icons.fitness_center,
                    Colors.red,
                    _getProteinProgress(),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildNutritionCard(
                    'Жиры',
                    '${summary.totalFats.toStringAsFixed(1)}',
                    'г',
                    Icons.opacity,
                    Colors.yellow[700]!,
                    _getFatsProgress(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutritionCard(
                    'Углеводы',
                    '${summary.totalCarbs.toStringAsFixed(1)}',
                    'г',
                    Icons.grain,
                    Colors.blue,
                    _getCarbsProgress(),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Meal breakdown
            Text(
              'По приёмам пищи',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildMealCard(
                    'Завтрак',
                    summary.breakfastCalories,
                    Icons.wb_sunny,
                    Colors.orange,
                    MealType.breakfast,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMealCard(
                    'Обед',
                    summary.lunchCalories,
                    Icons.wb_sunny_outlined,
                    Colors.red,
                    MealType.lunch,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMealCard(
                    'Ужин',
                    summary.dinnerCalories,
                    Icons.nights_stay,
                    Colors.purple,
                    MealType.dinner,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMealCard(
                    'Перекус',
                    summary.snackCalories,
                    Icons.cookie,
                    Colors.green,
                    MealType.snack,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$value $unit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 10,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(
    String label,
    double calories,
    IconData icon,
    Color color,
    MealType mealType,
  ) {
    final isSelected = selectedMealType == mealType;
    
    return GestureDetector(
      onTap: () => onMealTypeFilterChanged?.call(isSelected ? null : mealType),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              '${calories.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.white : color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : color.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Progress calculations (assuming default goals)
  double _getCaloriesProgress() {
    const defaultCalories = 2000.0;
    return summary.totalCalories / defaultCalories;
  }

  double _getProteinProgress() {
    const defaultProtein = 150.0;
    return summary.totalProtein / defaultProtein;
  }

  double _getFatsProgress() {
    const defaultFats = 65.0;
    return summary.totalFats / defaultFats;
  }

  double _getCarbsProgress() {
    const defaultCarbs = 250.0;
    return summary.totalCarbs / defaultCarbs;
  }
} 