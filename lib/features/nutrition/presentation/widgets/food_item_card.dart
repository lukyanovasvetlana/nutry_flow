import 'package:flutter/material.dart';
import '../../domain/entities/food_item.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;
  final bool showActions;
  final double portionSize;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    this.onTap,
    this.onFavoriteToggle,
    this.isFavorite = false,
    this.showActions = true,
    this.portionSize = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food image or placeholder
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: foodItem.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              foodItem.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderImage();
                              },
                            ),
                          )
                        : _buildPlaceholderImage(),
                  ),

                  const SizedBox(width: 12),

                  // Food info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and brand
                        Text(
                          foodItem.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        if (foodItem.brand != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            foodItem.brand!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],

                        if (foodItem.category != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              foodItem.category!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Actions
                  if (showActions) ...[
                    Column(
                      children: [
                        if (onFavoriteToggle != null)
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: onFavoriteToggle,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        if (foodItem.isVerified) ...[
                          const SizedBox(height: 8),
                          Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              // Nutrition info
              Row(
                children: [
                  Expanded(
                    child: _buildNutritionItem(
                      'Калории',
                      '${foodItem.calculateCalories(portionSize).toStringAsFixed(0)} ккал',
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionItem(
                      'Белки',
                      '${foodItem.calculateProtein(portionSize).toStringAsFixed(1)} г',
                      Icons.fitness_center,
                      Colors.red,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionItem(
                      'Жиры',
                      '${foodItem.calculateFats(portionSize).toStringAsFixed(1)} г',
                      Icons.opacity,
                      Colors.yellow[700]!,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionItem(
                      'Углеводы',
                      '${foodItem.calculateCarbs(portionSize).toStringAsFixed(1)} г',
                      Icons.grain,
                      Colors.blue,
                    ),
                  ),
                ],
              ),

              // Portion size info
              if (portionSize != 100.0) ...[
                const SizedBox(height: 8),
                Text(
                  'На ${portionSize.toStringAsFixed(0)} г',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],

              // Description
              if (foodItem.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  foodItem.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Icon(
        Icons.restaurant,
        color: Colors.grey[400],
        size: 30,
      ),
    );
  }

  Widget _buildNutritionItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
