import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';

class ProfileStatsCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileStatsCard({
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
              'Показатели здоровья',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            
            // BMI Section
            if (profile.height != null && profile.weight != null) ...[
              _buildBMISection(),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
            ],
            
            // Physical Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.height,
                    label: 'Рост',
                    value: profile.height != null ? '${profile.height}' : '-',
                    unit: 'см',
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.monitor_weight,
                    label: 'Вес',
                    value: profile.weight != null ? '${profile.weight}' : '-',
                    unit: 'кг',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Target Weight
            if (profile.targetWeight != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.flag,
                      label: 'Целевой вес',
                      value: '${profile.targetWeight}',
                      unit: 'кг',
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.trending_up,
                      label: 'Осталось',
                      value: profile.weight != null 
                          ? '${(profile.targetWeight! - profile.weight!).abs().toStringAsFixed(1)}'
                          : '-',
                      unit: 'кг',
                      color: profile.weight != null && profile.targetWeight != null
                          ? (profile.weight! > profile.targetWeight! ? Colors.red : Colors.green)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
            ],
            
            // Calorie Targets
            if (profile.targetCalories != null) ...[
              Text(
                'Целевые показатели питания',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.local_fire_department,
                      label: 'Калории',
                      value: '${profile.targetCalories}',
                      unit: 'ккал',
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.fitness_center,
                      label: 'Активность',
                      value: profile.activityLevel?.displayName ?? '-',
                      unit: '',
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              
              if (profile.targetProtein != null || profile.targetCarbs != null || profile.targetFat != null) ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    if (profile.targetProtein != null)
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.egg,
                          label: 'Белки',
                          value: '${profile.targetProtein}',
                          unit: 'г',
                          color: Colors.indigo,
                        ),
                      ),
                    if (profile.targetProtein != null && (profile.targetCarbs != null || profile.targetFat != null))
                      SizedBox(width: 12),
                    if (profile.targetCarbs != null)
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.grain,
                          label: 'Углеводы',
                          value: '${profile.targetCarbs}',
                          unit: 'г',
                          color: Colors.amber,
                        ),
                      ),
                    if (profile.targetCarbs != null && profile.targetFat != null)
                      SizedBox(width: 12),
                    if (profile.targetFat != null)
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.opacity,
                          label: 'Жиры',
                          value: '${profile.targetFat}',
                          unit: 'г',
                          color: Colors.teal,
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

  Widget _buildBMISection() {
    final bmi = profile.bmi;
    final bmiCategory = profile.bmiCategory;
    
    Color bmiColor;
    switch (bmiCategory) {
      case BMICategory.underweight:
        bmiColor = Colors.blue;
        break;
      case BMICategory.normal:
        bmiColor = Colors.green;
        break;
      case BMICategory.overweight:
        bmiColor = Colors.orange;
        break;
      case BMICategory.obese:
        bmiColor = Colors.red;
        break;
      case null:
        bmiColor = Colors.grey;
        break;
    }
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bmiColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: bmiColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Индекс массы тела',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    bmiCategory?.displayName ?? 'Не определено',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: bmiColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: bmiColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  bmi?.toStringAsFixed(1) ?? '0.0',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // BMI Scale
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
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
                      color: Colors.white,
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
          SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '16',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '18.5',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '25',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '30',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '35+',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
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
    if (bmi < 18.5) {
      position = (bmi - 16) / (18.5 - 16) * 33;
    } else if (bmi < 25) {
      position = 33 + (bmi - 18.5) / (25 - 18.5) * 33;
    } else if (bmi < 30) {
      position = 66 + (bmi - 25) / (30 - 25) * 34;
    } else {
      position = 100;
    }
    
    // Convert to pixels (assuming container width of ~300px)
    return (position / 100) * 250;
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (unit.isNotEmpty) ...[
                SizedBox(width: 2),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
} 