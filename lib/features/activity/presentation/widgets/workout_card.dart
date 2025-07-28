import 'package:flutter/material.dart';
import '../../domain/entities/workout.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const WorkoutCard({
    Key? key,
    required this.workout,
    this.onTap,
    this.onStart,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
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
                  _buildWorkoutIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.name,
                          style: context.typography.titleMediumStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDifficultyDisplayName(workout.difficulty),
                          style: context.typography.bodySmallStyle.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (workout.isTemplate)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.secondaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Шаблон',
                        style: context.typography.labelSmallStyle.copyWith(
                          color: context.colors.onSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              
              if (workout.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  workout.description!,
                  style: context.typography.bodyMediumStyle.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 16),
              _buildWorkoutStats(),
              
              if (showActions) ...[
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getDifficultyColor(workout.difficulty).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.fitness_center,
        color: _getDifficultyColor(workout.difficulty),
        size: 24,
      ),
    );
  }

  Widget _buildWorkoutStats() {
    return Row(
      children: [
        _buildStatItem(
          Icons.fitness_center,
          'Упражнений',
          workout.totalExercises.toString(),
        ),
        const SizedBox(width: 16),
        _buildStatItem(
          Icons.timer,
          'Длительность',
          '${workout.totalEstimatedDuration} мин',
        ),
        const SizedBox(width: 16),
        _buildStatItem(
          Icons.calendar_today,
          'Создана',
          _formatDate(workout.createdAt),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (onStart != null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Начать'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        if (onEdit != null) ...[
          if (onStart != null) const SizedBox(width: 8),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
            ),
          ),
        ],
        if (onDelete != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.1),
            ),
          ),
        ],
      ],
    );
  }

  Color _getDifficultyColor(WorkoutDifficulty difficulty) {
    switch (difficulty) {
      case WorkoutDifficulty.beginner:
        return Colors.green;
      case WorkoutDifficulty.intermediate:
        return Colors.orange;
      case WorkoutDifficulty.advanced:
        return Colors.red;
    }
  }

  String _getDifficultyDisplayName(WorkoutDifficulty difficulty) {
    switch (difficulty) {
      case WorkoutDifficulty.beginner:
        return 'Начинающий';
      case WorkoutDifficulty.intermediate:
        return 'Средний';
      case WorkoutDifficulty.advanced:
        return 'Продвинутый';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
} 