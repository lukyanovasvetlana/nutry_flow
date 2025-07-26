import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/nutrition_search_cubit.dart';
import '../../domain/entities/food_item.dart';
import 'food_item_card.dart';

class PopularFoodsSection extends StatefulWidget {
  final Function(FoodItem) onFoodItemSelected;

  const PopularFoodsSection({
    Key? key,
    required this.onFoodItemSelected,
  }) : super(key: key);

  @override
  State<PopularFoodsSection> createState() => _PopularFoodsSectionState();
}

class _PopularFoodsSectionState extends State<PopularFoodsSection> {
  @override
  void initState() {
    super.initState();
    context.read<NutritionSearchCubit>().getPopularItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionSearchCubit, NutritionSearchState>(
      builder: (context, state) {
        if (state is NutritionSearchLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is NutritionSearchSuccess) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.foodItems.length,
              itemBuilder: (context, index) {
                final foodItem = state.foodItems[index];
                
                return Container(
                  width: 300,
                  margin: EdgeInsets.only(
                    right: index == state.foodItems.length - 1 ? 0 : 12,
                  ),
                  child: FoodItemCard(
                    foodItem: foodItem,
                    onTap: () => widget.onFoodItemSelected(foodItem),
                  ),
                );
              },
            ),
          );
        }

        if (state is NutritionSearchError) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ошибка загрузки',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NutritionSearchCubit>().getPopularItems();
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Популярные продукты не найдены',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        );
      },
    );
  }
} 