import 'package:flutter/material.dart';
import '../../../../shared/design/tokens/theme_tokens.dart';
import '../../domain/entities/user_profile.dart';

class ProfileGoalsCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileGoalsCard({
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
              context.primary,
              context.primaryContainer,
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
                    Icons.flag,
                    color: context.onPrimary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Мои цели',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.onPrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Goals Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildGoalChip(
                    label: 'Похудение',
                    icon: Icons.trending_down,
                    color: context.onPrimary,
                  ),
                  _buildGoalChip(
                    label: 'Набор мышечной массы',
                    icon: Icons.fitness_center,
                    color: context.onPrimary,
                  ),
                  _buildGoalChip(
                    label: 'Поддержание веса',
                    icon: Icons.balance,
                    color: context.onPrimary,
                  ),
                  _buildGoalChip(
                    label: 'Улучшение выносливости',
                    icon: Icons.directions_run,
                    color: context.onPrimary,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Progress Section
              if (profile.weight != null && profile.targetWeight != null) ...[
                _buildWeightGoalProgress(),
                const SizedBox(height: 20),
              ],

              // Motivation Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.secondary,
                      context.secondaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: context.onSecondary,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Продолжайте в том же духе!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Вы на правильном пути к достижению своих целей',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.onSecondary.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalChip({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightGoalProgress() {
    final currentWeight = profile.weight!;
    final targetWeight = profile.targetWeight!;
    final difference = (targetWeight - currentWeight).abs();
    final isLosing = currentWeight > targetWeight;

    // Mock starting weight for progress calculation
    final startingWeight = isLosing ? currentWeight + 10 : currentWeight - 10;
    final totalChange = (targetWeight - startingWeight).abs();
    final progress = totalChange > 0
        ? (currentWeight - startingWeight).abs() / totalChange
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
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
                'Прогресс по весу',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.blue.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Текущий вес: $currentWeight кг',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade600,
            ),
          ),
          Text(
            'Целевой вес: $targetWeight кг',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade600,
            ),
          ),
          Text(
            'Осталось: ${difference.toStringAsFixed(1)} кг',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
