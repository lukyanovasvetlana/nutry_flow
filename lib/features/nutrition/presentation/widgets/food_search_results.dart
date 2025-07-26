import 'package:flutter/material.dart';
import '../../domain/entities/food_item.dart';
import 'food_item_card.dart';

class FoodSearchResults extends StatelessWidget {
  final List<FoodItem> foodItems;
  final Function(FoodItem) onFoodItemSelected;
  final bool isLoading;

  const FoodSearchResults({
    Key? key,
    required this.foodItems,
    required this.onFoodItemSelected,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (foodItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Продукты не найдены',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить поисковый запрос',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        final foodItem = foodItems[index];
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FoodItemCard(
            foodItem: foodItem,
            onTap: () => onFoodItemSelected(foodItem),
            onFavoriteToggle: () {
              // TODO: Implement favorite toggle
              _toggleFavorite(context, foodItem);
            },
            isFavorite: false, // TODO: Get from favorites state
          ),
        );
      },
    );
  }

  void _toggleFavorite(BuildContext context, FoodItem foodItem) {
    // TODO: Implement favorite toggle logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${foodItem.name} добавлен в избранное'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 