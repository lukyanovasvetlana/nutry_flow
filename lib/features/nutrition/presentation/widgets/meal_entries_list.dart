import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import 'food_entry_card.dart';

class MealEntriesList extends StatelessWidget {
  final List<FoodEntry> entries;
  final MealType mealType;
  final Function(FoodEntry) onEdit;
  final Function(FoodEntry) onDelete;
  final VoidCallback? onAddEntry;

  const MealEntriesList({
    super.key,
    required this.entries,
    required this.mealType,
    required this.onEdit,
    required this.onDelete,
    this.onAddEntry,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMealHeader(),
        const SizedBox(height: 8),
        ...entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FoodEntryCard(
            entry: entry,
            onEdit: () => onEdit(entry),
            onDelete: () => onDelete(entry),
          ),
        )),
      ],
    );
  }

  Widget _buildMealHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getMealTypeName(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onAddEntry != null)
          IconButton(
            onPressed: onAddEntry,
            icon: const Icon(Icons.add),
            tooltip: 'Add ${_getMealTypeName()} entry',
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMealHeader(),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.restaurant_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'No ${_getMealTypeName().toLowerCase()} entries yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMealTypeName() {
    switch (mealType) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }
} 