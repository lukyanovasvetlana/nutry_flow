import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';

class ProfileGoalsCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileGoalsCard({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Цели и задачи',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            
            // Fitness Goals
            if (profile.fitnessGoals.isNotEmpty) ...[
              Text(
                'Фитнес-цели',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.fitnessGoals.map((goal) {
                  return _buildGoalChip(
                    label: goal,
                    icon: _getGoalIcon(goal),
                    color: _getGoalColor(goal),
                  );
                }).toList(),
              ),
              
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
            ],
            
            // Weight Goal Progress
            if (profile.weight != null && profile.targetWeight != null) ...[
              _buildWeightGoalProgress(),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
            ],
            
            // Nutrition Goals
            if (profile.targetCalories != null || 
                profile.targetProtein != null || 
                profile.targetCarbs != null || 
                profile.targetFat != null) ...[
              Text(
                'Цели по питанию',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              
              if (profile.targetCalories != null)
                _buildNutritionGoal(
                  icon: Icons.local_fire_department,
                  label: 'Дневная норма калорий',
                  value: '${profile.targetCalories} ккал',
                  color: Colors.red,
                  progress: 0.7, // Mock progress
                ),
              
              if (profile.targetProtein != null)
                _buildNutritionGoal(
                  icon: Icons.egg,
                  label: 'Белки',
                  value: '${profile.targetProtein} г',
                  color: Colors.indigo,
                  progress: 0.8, // Mock progress
                ),
              
              if (profile.targetCarbs != null)
                _buildNutritionGoal(
                  icon: Icons.grain,
                  label: 'Углеводы',
                  value: '${profile.targetCarbs} г',
                  color: Colors.amber,
                  progress: 0.6, // Mock progress
                ),
              
              if (profile.targetFat != null)
                _buildNutritionGoal(
                  icon: Icons.opacity,
                  label: 'Жиры',
                  value: '${profile.targetFat} г',
                  color: Colors.teal,
                  progress: 0.9, // Mock progress
                ),
            ],
            
            // Motivational Section
            if (profile.fitnessGoals.isNotEmpty || profile.targetWeight != null) ...[
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple.shade400,
                      Colors.purple.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Продолжайте в том же духе!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Вы на правильном пути к достижению своих целей',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          SizedBox(width: 6),
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
    final progress = totalChange > 0 ? (currentWeight - startingWeight).abs() / totalChange : 0.0;
    
    return Container(
      padding: EdgeInsets.all(16),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLosing ? 'Снижение веса' : 'Набор веса',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Осталось: ${difference.toStringAsFixed(1)} кг',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[300],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
          
          SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Старт: ${startingWeight.toStringAsFixed(1)} кг',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Цель: ${targetWeight.toStringAsFixed(1)} кг',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionGoal({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double progress,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getGoalIcon(String goal) {
    final goalLower = goal.toLowerCase();
    if (goalLower.contains('похудение') || goalLower.contains('снижение')) {
      return Icons.trending_down;
    } else if (goalLower.contains('набор') || goalLower.contains('увеличение')) {
      return Icons.trending_up;
    } else if (goalLower.contains('мышц') || goalLower.contains('сила')) {
      return Icons.fitness_center;
    } else if (goalLower.contains('выносливость') || goalLower.contains('кардио')) {
      return Icons.directions_run;
    } else if (goalLower.contains('здоровье') || goalLower.contains('поддержание')) {
      return Icons.favorite;
    } else {
      return Icons.flag;
    }
  }

  Color _getGoalColor(String goal) {
    final goalLower = goal.toLowerCase();
    if (goalLower.contains('похудение') || goalLower.contains('снижение')) {
      return Colors.red;
    } else if (goalLower.contains('набор') || goalLower.contains('увеличение')) {
      return Colors.green;
    } else if (goalLower.contains('мышц') || goalLower.contains('сила')) {
      return Colors.orange;
    } else if (goalLower.contains('выносливость') || goalLower.contains('кардио')) {
      return Colors.blue;
    } else if (goalLower.contains('здоровье') || goalLower.contains('поддержание')) {
      return Colors.purple;
    } else {
      return Colors.grey;
    }
  }
} 