import 'package:flutter/material.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../../shared/theme/app_colors.dart';

class WeightDataCard extends StatelessWidget {
  final UserProfile? userProfile;
  
  const WeightDataCard({super.key, this.userProfile});

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
              Colors.blue.shade50,
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
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.monitor_weight,
                    color: AppColors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Физические\nпараметры',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Данные о весе и росте
            if (userProfile?.weight != null || userProfile?.height != null)
              _buildParametersSection(context)
            else
              _buildEmptySection(context),
              
            const SizedBox(height: 12),
            
            // ИМТ секция
            _buildBMISection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildParametersSection(BuildContext context) {
    return Column(
      children: [
        // Вес
        if (userProfile?.weight != null)
          _buildParameterRow(
            'Вес',
            '${userProfile!.weight!.toStringAsFixed(1)} кг',
            Icons.scale,
            AppColors.green,
          ),
        
        if (userProfile?.weight != null && userProfile?.height != null)
          const SizedBox(height: 8),
          
        // Рост
        if (userProfile?.height != null)
          _buildParameterRow(
            'Рост',
            '${userProfile!.height} см',
            Icons.height,
            AppColors.yellow,
          ),
      ],
    );
  }

  Widget _buildParameterRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySection(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.add_circle_outline,
          color: Colors.grey.shade400,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          'Данные не указаны',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBMISection(BuildContext context) {
    final bmi = userProfile?.bmi;
    
    if (bmi == null) {
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
              size: 16,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              'ИМТ не рассчитан',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    final bmiCategory = _getBMICategory(bmi);
    final bmiColor = _getBMIColor(bmi);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bmiColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: bmiColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _getBMIIcon(bmi),
                size: 16,
                color: bmiColor,
              ),
              const SizedBox(width: 6),
              Text(
                'ИМТ',
                style: TextStyle(
                  fontSize: 11,
                  color: bmiColor.withOpacity(0.8),
                ),
              ),
              const Spacer(),
              Text(
                bmi.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: bmiColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  bmiCategory,
                  style: TextStyle(
                    fontSize: 10,
                    color: bmiColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Недостаток веса';
    if (bmi <= 24.9) return 'Нормальный вес';
    if (bmi <= 29.9) return 'Избыточный вес';
    return 'Ожирение';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return AppColors.yellow; // Недостаток веса
    if (bmi <= 24.9) return AppColors.green; // Норма
    if (bmi <= 29.9) return AppColors.orange; // Избыток
    return Colors.red; // Ожирение
  }

  IconData _getBMIIcon(double bmi) {
    if (bmi < 18.5) return Icons.trending_down;
    if (bmi <= 24.9) return Icons.check_circle;
    if (bmi <= 29.9) return Icons.trending_up;
    return Icons.warning;
  }
} 