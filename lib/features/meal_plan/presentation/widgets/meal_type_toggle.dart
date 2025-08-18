import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';

class MealTypeToggle extends StatefulWidget {
  final String selectedMealType;
  final Function(String) onMealTypeChanged;
  const MealTypeToggle(
      {required this.selectedMealType,
      required this.onMealTypeChanged,
      super.key});

  @override
  State<MealTypeToggle> createState() => _MealTypeToggleState();
}

class _MealTypeToggleState extends State<MealTypeToggle> {
  static const mealTypes = [
    {'name': 'Завтрак', 'key': 'primary'},
    {'name': 'Обед', 'key': 'warning'},
    {'name': 'Перекус', 'key': 'neutral'},
    {'name': 'Ужин', 'key': 'tertiary'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.surfaceVariant,
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
                  color: isSelected
                      ? {
                          'primary': context.primary,
                          'warning': context.warning,
                          'neutral': context.onSurfaceVariant,
                          'tertiary': context.tertiary,
                        }[type['key']]!
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type['name'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? context.onPrimary
                        : context.onSurfaceVariant,
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
