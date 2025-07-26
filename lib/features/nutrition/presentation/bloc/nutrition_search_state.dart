part of 'nutrition_search_cubit.dart';

abstract class NutritionSearchState extends Equatable {
  const NutritionSearchState();

  @override
  List<Object> get props => [];
}

class NutritionSearchInitial extends NutritionSearchState {}

class NutritionSearchLoading extends NutritionSearchState {}

class NutritionSearchSuccess extends NutritionSearchState {
  final List<FoodItem> foodItems;

  const NutritionSearchSuccess(this.foodItems);

  @override
  List<Object> get props => [foodItems];
}

class NutritionSearchSuggestions extends NutritionSearchState {
  final List<String> suggestions;

  const NutritionSearchSuggestions(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}

class NutritionSearchEmpty extends NutritionSearchState {
  final String message;

  const NutritionSearchEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class NutritionSearchError extends NutritionSearchState {
  final String message;

  const NutritionSearchError(this.message);

  @override
  List<Object> get props => [message];
} 