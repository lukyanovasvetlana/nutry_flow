import 'package:flutter/material.dart';

class FoodCategoriesGrid extends StatelessWidget {
  final Function(String) onCategorySelected;

  const FoodCategoriesGrid({
    Key? key,
    required this.onCategorySelected,
  }) : super(key: key);

  static const List<Map<String, dynamic>> _categories = [
    {'name': 'Фрукты', 'icon': Icons.apple, 'color': Colors.green},
    {'name': 'Овощи', 'icon': Icons.eco, 'color': Colors.lightGreen},
    {'name': 'Мясо', 'icon': Icons.restaurant, 'color': Colors.red},
    {'name': 'Рыба', 'icon': Icons.set_meal, 'color': Colors.blue},
    {'name': 'Молочные', 'icon': Icons.local_drink, 'color': Colors.orange},
    {'name': 'Злаки', 'icon': Icons.grain, 'color': Colors.brown},
    {'name': 'Напитки', 'icon': Icons.local_cafe, 'color': Colors.purple},
    {'name': 'Сладости', 'icon': Icons.cake, 'color': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        
        return GestureDetector(
          onTap: () => onCategorySelected(category['name']),
          child: Container(
            decoration: BoxDecoration(
              color: category['color'].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: category['color'].withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'],
                  color: category['color'],
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: category['color'],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 