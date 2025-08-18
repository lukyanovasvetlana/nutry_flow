part of 'food_entry_cubit.dart';

abstract class FoodEntryState extends Equatable {
  const FoodEntryState();

  @override
  List<Object> get props => [];
}

class FoodEntryInitial extends FoodEntryState {}

class FoodEntryLoading extends FoodEntryState {}

class FoodEntryValidating extends FoodEntryState {}

class FoodEntrySuccess extends FoodEntryState {
  final FoodEntry entry;

  const FoodEntrySuccess(this.entry);

  @override
  List<Object> get props => [entry];
}

class FoodEntryValidationSuccess extends FoodEntryState {
  final FoodEntry entry;

  const FoodEntryValidationSuccess(this.entry);

  @override
  List<Object> get props => [entry];
}

class FoodEntryError extends FoodEntryState {
  final String message;

  const FoodEntryError(this.message);

  @override
  List<Object> get props => [message];
}

class FoodEntryValidationError extends FoodEntryState {
  final String message;

  const FoodEntryValidationError(this.message);

  @override
  List<Object> get props => [message];
}
