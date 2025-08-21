import 'package:flutter/material.dart';
import '../../../../shared/design/tokens/theme_tokens.dart';
import '../../domain/entities/user_profile.dart';

class ProfileStatsCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileStatsCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.secondary,
              context.secondaryContainer,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: context.onSecondary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Статистика',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.onSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.monitor_weight,
                      label: 'Вес',
                      value: profile.weight != null
                          ? '${profile.weight} кг'
                          : 'Не указан',
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.height,
                      label: 'Рост',
                      value: profile.height != null
                          ? '${profile.height} см'
                          : 'Не указан',
                      context: context,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // BMI Section
              if (profile.weight != null && profile.height != null) ...[
                _buildBMISection(context),
                const SizedBox(height: 20),
              ],

              // Activity Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.fitness_center,
                      label: 'Активность',
                      value: profile.activityLevel?.displayName ?? 'Не указан',
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.calculate,
                      label: 'Целевые калории',
                      value: profile.targetCalories != null
                          ? '${profile.targetCalories} ккал'
                          : 'Не указано',
                      context: context,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.onSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.onSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: context.onSecondary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: context.onSecondary.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBMISection(BuildContext context) {
    final bmi = profile.bmi;
    final bmiColor = _getBMIColor(bmi ?? 0.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.onSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.onSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Индекс массы тела (ИМТ)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.onSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: bmiColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  bmi?.toStringAsFixed(1) ?? '0.0',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.surface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // BMI Scale
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.red,
                ],
                stops: [0.0, 0.33, 0.66, 1.0],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: _getBMIPosition(bmi ?? 0.0),
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: context.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: bmiColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '16',
                style: TextStyle(
                  fontSize: 10,
                  color: context.onSecondary.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '18.5',
                style: TextStyle(
                  fontSize: 10,
                  color: context.onSecondary.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '25',
                style: TextStyle(
                  fontSize: 10,
                  color: context.onSecondary.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '30',
                style: TextStyle(
                  fontSize: 10,
                  color: context.onSecondary.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '35+',
                style: TextStyle(
                  fontSize: 10,
                  color: context.onSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getBMIPosition(double bmi) {
    // Map BMI to position on scale (0-100%)
    double position;
    if (bmi < 16) {
      position = 0.0;
    } else if (bmi < 18.5) {
      position = (bmi - 16) / 2.5 * 0.33;
    } else if (bmi < 25) {
      position = 0.33 + (bmi - 18.5) / 6.5 * 0.33;
    } else if (bmi < 30) {
      position = 0.66 + (bmi - 25) / 5.0 * 0.34;
    } else {
      position = 1.0;
    }
    return position * 100; // Convert to percentage
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi < 25) {
      return Colors.green;
    } else if (bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
