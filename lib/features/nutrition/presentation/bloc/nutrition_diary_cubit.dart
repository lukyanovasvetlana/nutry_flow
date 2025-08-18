import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/usecases/get_nutrition_diary_usecase.dart';

part 'nutrition_diary_state.dart';

class NutritionDiaryCubit extends Cubit<NutritionDiaryState> {
  final GetNutritionDiaryUseCase _getNutritionDiaryUseCase;

  NutritionDiaryCubit(this._getNutritionDiaryUseCase)
      : super(NutritionDiaryInitial());

  Future<void> loadDailyDiary(String userId, DateTime date) async {
    emit(NutritionDiaryLoading());

    try {
      final diary = await _getNutritionDiaryUseCase.getDailyDiary(userId, date);
      emit(NutritionDiarySuccess(diary));
    } catch (e) {
      emit(NutritionDiaryError(e.toString()));
    }
  }

  Future<void> loadDateRangeDiary(
      String userId, DateTime startDate, DateTime endDate) async {
    emit(NutritionDiaryLoading());

    try {
      final diaries = await _getNutritionDiaryUseCase.getDateRangeDiary(
          userId, startDate, endDate);
      emit(NutritionDiaryRangeSuccess(diaries));
    } catch (e) {
      emit(NutritionDiaryError(e.toString()));
    }
  }

  Future<void> loadWeeklyDiary(String userId, DateTime startDate) async {
    emit(NutritionDiaryLoading());

    try {
      final diaries =
          await _getNutritionDiaryUseCase.getWeeklyDiary(userId, startDate);
      emit(NutritionDiaryRangeSuccess(diaries));
    } catch (e) {
      emit(NutritionDiaryError(e.toString()));
    }
  }

  Future<void> loadMonthlyDiary(String userId, DateTime month) async {
    emit(NutritionDiaryLoading());

    try {
      final diaries =
          await _getNutritionDiaryUseCase.getMonthlyDiary(userId, month);
      emit(NutritionDiaryRangeSuccess(diaries));
    } catch (e) {
      emit(NutritionDiaryError(e.toString()));
    }
  }

  Future<void> loadFilteredDiary(
      String userId, DateTime startDate, DateTime endDate,
      {MealType? mealType, String? foodCategory}) async {
    emit(NutritionDiaryLoading());

    try {
      final diaries = await _getNutritionDiaryUseCase.getFilteredDiary(
        userId,
        startDate,
        endDate,
        mealType: mealType,
        foodCategory: foodCategory,
      );
      emit(NutritionDiaryRangeSuccess(diaries));
    } catch (e) {
      emit(NutritionDiaryError(e.toString()));
    }
  }

  Future<void> loadGoalAnalysis(
      String userId, DateTime date, NutritionGoals goals) async {
    emit(NutritionDiaryLoading());

    try {
      final analysis =
          await _getNutritionDiaryUseCase.getGoalAnalysis(userId, date, goals);
      emit(NutritionDiaryGoalAnalysisSuccess(analysis));
    } catch (e) {
      emit(NutritionDiaryError(e.toString()));
    }
  }

  void resetState() {
    emit(NutritionDiaryInitial());
  }

  void setLoading() {
    emit(NutritionDiaryLoading());
  }

  void setError(String message) {
    emit(NutritionDiaryError(message));
  }
}
