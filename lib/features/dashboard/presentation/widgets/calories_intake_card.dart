import 'package:flutter/material.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../../shared/theme/app_colors.dart';

class CaloriesIntakeCard extends StatelessWidget {
  final UserProfile? userProfile;

  const CaloriesIntakeCard({super.key, this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с иконкой
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    color: AppColors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Калории\nсегодня',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Основная статистика
            _buildCaloriesStats(context),

            const SizedBox(height: 12),

            // Прогресс бар или дополнительная информация
            _buildProgressSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesStats(BuildContext context) {
    // Пока используем моковые данные, так как нет интеграции с дневником питания
    final todayCalories = 1250; // Моковые данные
    final targetCalories = _calculateTargetCalories();

    return Column(
      children: [
        // Главные цифры
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              todayCalories.toString(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'ккал',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // Цель
        if (targetCalories != null)
          Row(
            children: [
              Icon(
                Icons.flag_outlined,
                size: 12,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Text(
                'Цель: ${targetCalories.toStringAsFixed(0)} ккал',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          )
        else
          Text(
            'Цель не установлена',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
          ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final todayCalories = 1250; // Моковые данные
    final targetCalories = _calculateTargetCalories();

    if (targetCalories == null) {
      return _buildNoTargetSection(context);
    }

    final progress = todayCalories / targetCalories;
    final progressColor = _getProgressColor(progress);

    return Column(
      children: [
        // Прогресс бар
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Статус
        Row(
          children: [
            Icon(
              _getProgressIcon(progress),
              size: 14,
              color: progressColor,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                _getProgressText(progress, todayCalories, targetCalories),
                style: TextStyle(
                  fontSize: 11,
                  color: progressColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoTargetSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Установите цели для отслеживания',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double? _calculateTargetCalories() {
    if (userProfile == null ||
        userProfile!.weight == null ||
        userProfile!.height == null ||
        userProfile!.age == null ||
        userProfile!.gender == null) {
      return null;
    }

    // Базовый метаболизм по формуле Миффлина-Сан Жеора
    double bmr;
    if (userProfile!.gender == Gender.male) {
      bmr = 10 * userProfile!.weight! +
          6.25 * userProfile!.height! -
          5 * userProfile!.age! +
          5;
    } else {
      bmr = 10 * userProfile!.weight! +
          6.25 * userProfile!.height! -
          5 * userProfile!.age! -
          161;
    }

    // Коэффициент активности
    final double activityFactor = _getActivityFactor();

    return bmr * activityFactor;
  }

  double _getActivityFactor() {
    if (userProfile?.activityLevel == null) {
      return 1.375; // По умолчанию умеренная активность
    }

    return userProfile!.activityLevel!.multiplier;
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.7) return AppColors.yellow; // Мало калорий
    if (progress <= 1.1) return AppColors.green; // Норма
    return AppColors.orange; // Превышение
  }

  IconData _getProgressIcon(double progress) {
    if (progress < 0.7) return Icons.trending_down;
    if (progress <= 1.1) return Icons.check_circle;
    return Icons.trending_up;
  }

  String _getProgressText(
      double progress, int todayCalories, double targetCalories) {
    final remaining = targetCalories - todayCalories;

    if (progress < 0.7) {
      return 'Осталось ${remaining.toStringAsFixed(0)} ккал';
    } else if (progress <= 1.1) {
      return 'Цель почти достигнута!';
    } else {
      return 'Превышение на ${(-remaining).toStringAsFixed(0)} ккал';
    }
  }
}
