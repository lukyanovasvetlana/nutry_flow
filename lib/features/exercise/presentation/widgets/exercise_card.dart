import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_styles.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
  });

  Color _getCategoryColor() {
    switch (exercise.category) {
      case 'Legs':
        return const Color(0xFFB8E6B8);
      case 'Back':
        return const Color(0xFFFDD663);
      case 'Chest':
        return const Color(0xFFFFB366);
      case 'Shoulders':
        return const Color(0xFFFDD663);
      case 'Arms':
        return const Color(0xFFFFB366);
      case 'Core':
        return const Color(0xFFB8E6B8);
      case 'Cardio':
        return const Color(0xFFB8E6B8);
      case 'Flexibility':
        return const Color(0xFFFFB366);
      default:
        return const Color(0xFFB8E6B8);
    }
  }

  IconData _getExerciseIcon() {
    switch (exercise.iconName) {
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

  String _getDisplayReps() {
    if (exercise.duration != null) {
      return exercise.duration!;
    }
    return '${exercise.reps} раз';
  }

  String _getDisplayRest() {
    if (exercise.duration != null) {
      return 'Н/Д';
    }
    return '${exercise.restSeconds} сек';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: AppColors.dynamicCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.dynamicBorder, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Exercise Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getExerciseIcon(),
                  color: AppColors.dynamicTextPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Exercise Name
              Expanded(
                flex: 2,
                child: Text(
                  exercise.name,
                  style: AppStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.dynamicTextPrimary,
                  ),
                ),
              ),

              // Sets
              Expanded(
                child: Text(
                  '${exercise.sets}',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.dynamicTextSecondary,
                  ),
                ),
              ),

              // Reps
              Expanded(
                child: Text(
                  _getDisplayReps(),
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.dynamicTextSecondary,
                  ),
                ),
              ),

              // Rest
              Expanded(
                child: Text(
                  _getDisplayRest(),
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.dynamicTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
