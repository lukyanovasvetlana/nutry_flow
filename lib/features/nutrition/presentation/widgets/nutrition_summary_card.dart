import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_summary.dart';

class NutritionSummaryCard extends StatelessWidget {
  final NutritionSummary summary;
  final bool compact;

  const NutritionSummaryCard({
    super.key,
    required this.summary,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: compact ? 20 : 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Сводка за день',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Text(
                  '${summary.totalCalories.toStringAsFixed(0)} ккал',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Macros
            Row(
              children: [
                Expanded(
                  child: _buildMacroItem(
                    'Белки',
                    '${summary.totalProtein.toStringAsFixed(1)} г',
                    Icons.fitness_center,
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildMacroItem(
                    'Жиры',
                    '${summary.totalFats.toStringAsFixed(1)} г',
                    Icons.opacity,
                    Colors.yellow[700]!,
                  ),
                ),
                Expanded(
                  child: _buildMacroItem(
                    'Углеводы',
                    '${summary.totalCarbs.toStringAsFixed(1)} г',
                    Icons.grain,
                    Colors.blue,
                  ),
                ),
              ],
            ),

            if (!compact) ...[
              const SizedBox(height: 16),

              // Meal breakdown
              Text(
                'По приёмам пищи',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildMealItem(
                      'Завтрак',
                      summary.breakfastCalories,
                      Icons.wb_sunny,
                      Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _buildMealItem(
                      'Обед',
                      summary.lunchCalories,
                      Icons.wb_sunny_outlined,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildMealItem(
                      'Ужин',
                      summary.dinnerCalories,
                      Icons.nights_stay,
                      Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: _buildMealItem(
                      'Перекус',
                      summary.snackCalories,
                      Icons.cookie,
                      Colors.green,
                    ),
                  ),
                ],
              ),

              // Additional nutrients (if available)
              if (summary.totalFiber != null ||
                  summary.totalSugar != null ||
                  summary.totalSodium != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Дополнительно',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildNutrientItem(
                        'Клетчатка',
                        '${summary.totalFiber.toStringAsFixed(1)} г',
                        Icons.eco,
                        Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _buildNutrientItem(
                        'Сахар',
                        '${summary.totalSugar.toStringAsFixed(1)} г',
                        Icons.cake,
                        Colors.pink,
                      ),
                    ),
                    Expanded(
                      child: _buildNutrientItem(
                        'Натрий',
                        '${summary.totalSodium.toStringAsFixed(1)} мг',
                        Icons.water_drop,
                        Colors.cyan,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMealItem(
      String label, double calories, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 4),
        Text(
          calories.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
