import 'package:flutter/material.dart';
import '../../domain/entities/food_item.dart';

class NutritionPreview extends StatelessWidget {
  final FoodItem foodItem;
  final double portionSize;

  const NutritionPreview({
    super.key,
    required this.foodItem,
    required this.portionSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Пищевая ценность на ${portionSize.toStringAsFixed(0)} г',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          // Main macros
          Row(
            children: [
              Expanded(
                child: _buildMacroCard(
                  'Калории',
                  foodItem.calculateCalories(portionSize).toStringAsFixed(0),
                  'ккал',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard(
                  'Белки',
                  foodItem.calculateProtein(portionSize).toStringAsFixed(1),
                  'г',
                  Icons.fitness_center,
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildMacroCard(
                  'Жиры',
                  foodItem.calculateFats(portionSize).toStringAsFixed(1),
                  'г',
                  Icons.opacity,
                  Colors.yellow[700]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard(
                  'Углеводы',
                  foodItem.calculateCarbs(portionSize).toStringAsFixed(1),
                  'г',
                  Icons.grain,
                  Colors.blue,
                ),
              ),
            ],
          ),

          // Additional nutrients (if available)
          if (foodItem.fiberPer100g != null ||
              foodItem.sugarPer100g != null ||
              foodItem.sodiumPer100g != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Дополнительные питательные вещества',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildNutrientRow(
                    'Клетчатка',
                    foodItem.calculateFiber(portionSize).toStringAsFixed(1) ??
                        '0',
                    Icons.eco,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildNutrientRow(
                    'Сахар',
                    foodItem.calculateSugar(portionSize).toStringAsFixed(1) ??
                        '0',
                    Icons.cake,
                    Colors.pink,
                  ),
                ),
                Expanded(
                  child: _buildNutrientRow(
                    'Натрий',
                    foodItem.calculateSodium(portionSize).toStringAsFixed(1) ??
                        '0',
                    Icons.water_drop,
                    Colors.cyan,
                  ),
                ),
              ],
            ),
          ],

          // Allergens (if any)
          if (foodItem.allergens.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Аллергены',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: foodItem.allergens.map((allergen) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    allergen,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[700],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMacroCard(
      String label, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            '$value $unit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
