import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class MealPlanCard extends StatelessWidget {
  const MealPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/meal-plan'),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [AppColors.green, AppColors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.restaurant_menu, color: AppColors.green, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'План питания',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      color: AppColors.green, size: 16),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Ваш персональный план питания на неделю',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.yellow,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.yellow, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Неделя 2',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.orange,
                      fontWeight: FontWeight.w500,
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
}
