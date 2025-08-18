import 'package:flutter/material.dart';
import 'meal_day_column.dart';

class MealPlanGrid extends StatelessWidget {
  final String selectedMealType;
  const MealPlanGrid({required this.selectedMealType, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 7,
      itemBuilder: (context, day) =>
          MealDayColumn(day: day, selectedMealType: selectedMealType),
    );
  }
}
