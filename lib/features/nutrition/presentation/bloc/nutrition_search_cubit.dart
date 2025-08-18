import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/usecases/search_food_items_usecase.dart';

part 'nutrition_search_state.dart';

class NutritionSearchCubit extends Cubit<NutritionSearchState> {
  final SearchFoodItemsUseCase _searchFoodItemsUseCase;

  NutritionSearchCubit(this._searchFoodItemsUseCase)
      : super(NutritionSearchInitial());

  Future<void> searchFoodItems(String query) async {
    if (query.trim().isEmpty) {
      emit(NutritionSearchInitial());
      return;
    }

    emit(NutritionSearchLoading());

    try {
      final result = await _searchFoodItemsUseCase.searchByQuery(query);

      if (result.items.isNotEmpty) {
        emit(NutritionSearchSuccess(result.items));
      } else {
        emit(const NutritionSearchEmpty('Продукты не найдены'));
      }
    } catch (e) {
      emit(NutritionSearchError(e.toString()));
    }
  }

  Future<void> searchByBarcode(String barcode) async {
    emit(NutritionSearchLoading());

    try {
      final result = await _searchFoodItemsUseCase.searchByBarcode(barcode);

      if (result != null) {
        emit(NutritionSearchSuccess([result]));
      } else {
        emit(
            const NutritionSearchEmpty('Продукт с таким штрихкодом не найден'));
      }
    } catch (e) {
      emit(NutritionSearchError(e.toString()));
    }
  }

  Future<void> getPopularItems() async {
    emit(NutritionSearchLoading());

    try {
      final result = await _searchFoodItemsUseCase.getPopularItems();

      if (result.isNotEmpty) {
        emit(NutritionSearchSuccess(result));
      } else {
        emit(const NutritionSearchEmpty('Популярные продукты не найдены'));
      }
    } catch (e) {
      emit(NutritionSearchError(e.toString()));
    }
  }

  Future<void> getFoodItemsByCategory(String category) async {
    emit(NutritionSearchLoading());

    try {
      final result = await _searchFoodItemsUseCase.getItemsByCategory(category);

      if (result.isNotEmpty) {
        emit(NutritionSearchSuccess(result));
      } else {
        emit(
            const NutritionSearchEmpty('Продукты в этой категории не найдены'));
      }
    } catch (e) {
      emit(NutritionSearchError(e.toString()));
    }
  }

  Future<void> getFavoriteItems(String userId) async {
    emit(NutritionSearchLoading());

    try {
      final result = await _searchFoodItemsUseCase.getFavoriteItems(userId);

      if (result.isNotEmpty) {
        emit(NutritionSearchSuccess(result));
      } else {
        emit(const NutritionSearchEmpty('У вас пока нет избранных продуктов'));
      }
    } catch (e) {
      emit(NutritionSearchError(e.toString()));
    }
  }

  Future<void> getRecommendedItems(String userId) async {
    emit(NutritionSearchLoading());

    try {
      final result = await _searchFoodItemsUseCase.getRecommendedItems(userId);

      if (result.isNotEmpty) {
        emit(NutritionSearchSuccess(result));
      } else {
        emit(const NutritionSearchEmpty('Рекомендации пока недоступны'));
      }
    } catch (e) {
      emit(NutritionSearchError(e.toString()));
    }
  }

  Future<void> getSearchSuggestions(String query) async {
    if (query.trim().isEmpty) {
      emit(NutritionSearchInitial());
      return;
    }

    try {
      final result = await _searchFoodItemsUseCase.getSearchSuggestions(query);

      if (result.isNotEmpty) {
        emit(NutritionSearchSuggestions(result));
      } else {
        emit(const NutritionSearchEmpty('Предложения не найдены'));
      }
    } catch (e) {
      emit(NutritionSearchError(e.toString()));
    }
  }

  void clearSearch() {
    emit(NutritionSearchInitial());
  }
}
