import 'package:flutter/material.dart';
import '../../domain/entities/exercise.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    this.onTap,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildExerciseIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: context.typography.titleMediumStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCategoryDisplayName(exercise.category),
                          style: context.typography.bodySmallStyle.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onFavoriteToggle != null)
                    IconButton(
                      icon: Icon(
                        exercise.isFavorite 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                        color: exercise.isFavorite 
                            ? context.colors.error 
                            : context.colors.onSurfaceVariant,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                exercise.description,
                style: context.typography.bodyMediumStyle.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              _buildExerciseDetails(),
              const SizedBox(height: 8),
              _buildTargetMuscles(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getCategoryColor(exercise.category).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getIconData(exercise.iconName),
        color: _getCategoryColor(exercise.category),
        size: 24,
      ),
    );
  }

  Widget _buildExerciseDetails() {
    return Row(
      children: [
        _buildDetailChip(
          'Сложность',
          _getDifficultyDisplayName(exercise.difficulty),
          _getDifficultyColor(exercise.difficulty),
        ),
        const SizedBox(width: 8),
        if (exercise.sets != null && exercise.reps != null)
          _buildDetailChip(
            'Подходы',
            '${exercise.sets} x ${exercise.reps}',
            Colors.blue,
          ),
        if (exercise.duration != null) ...[
          const SizedBox(width: 8),
          _buildDetailChip(
            'Длительность',
            exercise.duration!,
            Colors.green,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTargetMuscles() {
    if (exercise.targetMuscles.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: exercise.targetMuscles.take(3).map((muscle) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            muscle,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getCategoryDisplayName(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.legs:
        return 'Ноги';
      case ExerciseCategory.back:
        return 'Спина';
      case ExerciseCategory.chest:
        return 'Грудь';
      case ExerciseCategory.shoulders:
        return 'Плечи';
      case ExerciseCategory.arms:
        return 'Руки';
      case ExerciseCategory.core:
        return 'Пресс';
      case ExerciseCategory.cardio:
        return 'Кардио';
      case ExerciseCategory.flexibility:
        return 'Растяжка';
      case ExerciseCategory.yoga:
        return 'Йога';
    }
  }

  String _getDifficultyDisplayName(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        return 'Начинающий';
      case ExerciseDifficulty.intermediate:
        return 'Средний';
      case ExerciseDifficulty.advanced:
        return 'Продвинутый';
    }
  }

  Color _getCategoryColor(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.legs:
        return Colors.blue;
      case ExerciseCategory.back:
        return Colors.green;
      case ExerciseCategory.chest:
        return Colors.red;
      case ExerciseCategory.shoulders:
        return Colors.orange;
      case ExerciseCategory.arms:
        return Colors.purple;
      case ExerciseCategory.core:
        return Colors.teal;
      case ExerciseCategory.cardio:
        return Colors.pink;
      case ExerciseCategory.flexibility:
        return Colors.indigo;
      case ExerciseCategory.yoga:
        return Colors.amber;
    }
  }

  Color _getDifficultyColor(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        return Colors.green;
      case ExerciseDifficulty.intermediate:
        return Colors.orange;
      case ExerciseDifficulty.advanced:
        return Colors.red;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'fitness_center':
        return Icons.fitness_center;
      case 'directions_run':
        return Icons.directions_run;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'self_improvement':
        return Icons.self_improvement;
      default:
        return Icons.fitness_center;
    }
  }
} 