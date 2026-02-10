import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class FoodDetailsScreen extends StatelessWidget {
  final String foodName;
  final String mealType;

  const FoodDetailsScreen({
    super.key,
    required this.foodName,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicBackground,
        elevation: 0,
        title: Text(
          foodName,
          style: DesignTokens.typography.titleMediumStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(DesignTokens.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Добавить в $mealType',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'mealType': mealType,
                    'foodName': foodName,
                    'quantity': 100,
                    'unit': 'г',
                    'calories': 200,
                    'fat': 5,
                    'carbs': 20,
                    'protein': 15,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Добавить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

