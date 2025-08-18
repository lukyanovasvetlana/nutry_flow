import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_summary.dart';
import '../../domain/usecases/get_nutrition_diary_usecase.dart';

class NutritionGoalsChart extends StatelessWidget {
  final NutritionSummary summary;
  final NutritionGoals goals;

  const NutritionGoalsChart({
    super.key,
    required this.summary,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    final analysis =
        NutritionGoalsAnalysis.fromSummary(DateTime.now(), summary, goals);

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
                Icon(
                  Icons.track_changes,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Прогресс по целям',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getOverallScoreColor(
                            analysis.overallCompletionPercentage)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${analysis.overallCompletionPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getOverallScoreColor(
                          analysis.overallCompletionPercentage),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress bars
            _buildProgressBar(
              'Калории',
              summary.totalCalories,
              goals.dailyCalories,
              analysis.caloriesPercentage,
              Colors.orange,
              Icons.local_fire_department,
            ),

            const SizedBox(height: 12),

            _buildProgressBar(
              'Белки',
              summary.totalProtein,
              goals.dailyProtein,
              analysis.proteinPercentage,
              Colors.red,
              Icons.fitness_center,
            ),

            const SizedBox(height: 12),

            _buildProgressBar(
              'Жиры',
              summary.totalFats,
              goals.dailyFats,
              analysis.fatsPercentage,
              Colors.yellow[700]!,
              Icons.opacity,
            ),

            const SizedBox(height: 12),

            _buildProgressBar(
              'Углеводы',
              summary.totalCarbs,
              goals.dailyCarbs,
              analysis.carbsPercentage,
              Colors.blue,
              Icons.grain,
            ),

            const SizedBox(height: 16),

            // Status indicators
            if (analysis.isCaloriesOnTarget ||
                analysis.isProteinOnTarget ||
                analysis.isFatsOnTarget ||
                analysis.isCarbsOnTarget) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Статус целей',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (analysis.isCaloriesOnTarget)
                    _buildStatusChip(
                        'Калории', Colors.green, Icons.check_circle),
                  if (analysis.isProteinOnTarget)
                    _buildStatusChip('Белки', Colors.green, Icons.check_circle),
                  if (analysis.isFatsOnTarget)
                    _buildStatusChip('Жиры', Colors.green, Icons.check_circle),
                  if (analysis.isCarbsOnTarget)
                    _buildStatusChip(
                        'Углеводы', Colors.green, Icons.check_circle),
                  if (!analysis.isCaloriesOnTarget)
                    _buildStatusChip('Калории', Colors.orange, Icons.warning),
                  if (!analysis.isProteinOnTarget)
                    _buildStatusChip('Белки', Colors.red, Icons.error),
                  if (!analysis.isFatsOnTarget)
                    _buildStatusChip('Жиры', Colors.orange, Icons.warning),
                  if (!analysis.isCarbsOnTarget)
                    _buildStatusChip('Углеводы', Colors.orange, Icons.warning),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    String label,
    double current,
    double target,
    double percentage,
    Color color,
    IconData icon,
  ) {
    final isOverTarget = current > target;
    final displayPercentage = isOverTarget ? 100.0 : percentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              '${current.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isOverTarget ? Colors.red : color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: displayPercentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            isOverTarget ? Colors.red : color,
          ),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getOverallScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }
}
