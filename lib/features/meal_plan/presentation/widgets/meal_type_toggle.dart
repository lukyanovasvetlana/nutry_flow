import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class MealTypeToggle extends StatefulWidget {
  final String selectedMealType;
  final Function(String) onMealTypeChanged;
  const MealTypeToggle({required this.selectedMealType, required this.onMealTypeChanged, Key? key}) : super(key: key);

  @override
  State<MealTypeToggle> createState() => _MealTypeToggleState();
}

class _MealTypeToggleState extends State<MealTypeToggle> {
  static const mealTypes = [
    {'name': 'Завтрак', 'color': AppColors.green},
    {'name': 'Обед', 'color': AppColors.yellow},
    {'name': 'Перекус', 'color': AppColors.gray},
    {'name': 'Ужин', 'color': AppColors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: mealTypes.map((type) {
          final isSelected = widget.selectedMealType == type['name'];
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onMealTypeChanged(type['name'] as String),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? type['color'] as Color : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type['name'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Color(0xFF2D3748) : Color(0xFF718096),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
} 