part of 'nutrition_diary_cubit.dart';

abstract class NutritionDiaryState extends Equatable {
  const NutritionDiaryState();

  @override
  List<Object> get props => [];
}

class NutritionDiaryInitial extends NutritionDiaryState {}

class NutritionDiaryLoading extends NutritionDiaryState {}

class NutritionDiarySuccess extends NutritionDiaryState {
  final NutritionDiary diary;

  const NutritionDiarySuccess(this.diary);

  @override
  List<Object> get props => [diary];
}

class NutritionDiaryRangeSuccess extends NutritionDiaryState {
  final List<NutritionDiary> diaries;

  const NutritionDiaryRangeSuccess(this.diaries);

  @override
  List<Object> get props => [diaries];
}

class NutritionDiaryGoalAnalysisSuccess extends NutritionDiaryState {
  final NutritionGoalsAnalysis analysis;

  const NutritionDiaryGoalAnalysisSuccess(this.analysis);

  @override
  List<Object> get props => [analysis];
}

class NutritionDiaryError extends NutritionDiaryState {
  final String message;

  const NutritionDiaryError(this.message);

  @override
  List<Object> get props => [message];
} 