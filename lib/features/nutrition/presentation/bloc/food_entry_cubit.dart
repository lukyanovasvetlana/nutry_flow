import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/usecases/add_food_entry_usecase.dart';

part 'food_entry_state.dart';

class FoodEntryCubit extends Cubit<FoodEntryState> {
  final AddFoodEntryUseCase _addFoodEntryUseCase;

  FoodEntryCubit(this._addFoodEntryUseCase) : super(FoodEntryInitial());

  Future<void> addFoodEntry({
    required String userId,
    required FoodItem foodItem,
    required double grams,
    required MealType mealType,
    required DateTime consumedAt,
    String? notes,
  }) async {
    emit(FoodEntryLoading());

    try {
      final result = await _addFoodEntryUseCase.execute(
        userId: userId,
        foodItem: foodItem,
        grams: grams,
        mealType: mealType,
        consumedAt: consumedAt,
        notes: notes,
      );
      
      emit(FoodEntrySuccess(result));
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }

  Future<void> validateEntry({
    required String userId,
    required FoodItem foodItem,
    required double grams,
    required MealType mealType,
    required DateTime consumedAt,
    String? notes,
  }) async {
    emit(FoodEntryValidating());

    try {
      final result = await _addFoodEntryUseCase.execute(
        userId: userId,
        foodItem: foodItem,
        grams: grams,
        mealType: mealType,
        consumedAt: consumedAt,
        notes: notes,
      );
      
      emit(FoodEntryValidationSuccess(result));
    } catch (e) {
      emit(FoodEntryValidationError(e.toString()));
    }
  }

  void resetState() {
    emit(FoodEntryInitial());
  }

  void setLoading() {
    emit(FoodEntryLoading());
  }

  void setError(String message) {
    emit(FoodEntryError(message));
  }
} 