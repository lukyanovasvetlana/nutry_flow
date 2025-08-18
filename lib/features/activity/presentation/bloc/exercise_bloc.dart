import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/usecases/exercise_usecases.dart';

// Events
abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExercises extends ExerciseEvent {}

class SearchExercises extends ExerciseEvent {
  final String query;

  const SearchExercises(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends ExerciseEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class FilterByDifficulty extends ExerciseEvent {
  final String difficulty;

  const FilterByDifficulty(this.difficulty);

  @override
  List<Object?> get props => [difficulty];
}

class LoadFavoriteExercises extends ExerciseEvent {
  final String userId;

  const LoadFavoriteExercises(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleFavorite extends ExerciseEvent {
  final String userId;
  final String exerciseId;

  const ToggleFavorite(this.userId, this.exerciseId);

  @override
  List<Object?> get props => [userId, exerciseId];
}

class LoadCategories extends ExerciseEvent {}

class LoadDifficulties extends ExerciseEvent {}

// States
abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final List<String> categories;
  final List<String> difficulties;
  final String? selectedCategory;
  final String? selectedDifficulty;
  final String? searchQuery;

  const ExerciseLoaded({
    required this.exercises,
    required this.categories,
    required this.difficulties,
    this.selectedCategory,
    this.selectedDifficulty,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        exercises,
        categories,
        difficulties,
        selectedCategory,
        selectedDifficulty,
        searchQuery,
      ];

  ExerciseLoaded copyWith({
    List<Exercise>? exercises,
    List<String>? categories,
    List<String>? difficulties,
    String? selectedCategory,
    String? selectedDifficulty,
    String? searchQuery,
  }) {
    return ExerciseLoaded(
      exercises: exercises ?? this.exercises,
      categories: categories ?? this.categories,
      difficulties: difficulties ?? this.difficulties,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetExercisesUseCase _getExercisesUseCase;
  final SearchExercisesUseCase _searchExercisesUseCase;
  final FilterExercisesByCategoryUseCase _filterByCategoryUseCase;
  final FilterExercisesByDifficultyUseCase _filterByDifficultyUseCase;
  final GetFavoriteExercisesUseCase _getFavoriteExercisesUseCase;
  final ToggleFavoriteExerciseUseCase _toggleFavoriteUseCase;
  final GetExerciseCategoriesUseCase _getCategoriesUseCase;
  final GetExerciseDifficultiesUseCase _getDifficultiesUseCase;

  ExerciseBloc(
    this._getExercisesUseCase,
    this._searchExercisesUseCase,
    this._filterByCategoryUseCase,
    this._filterByDifficultyUseCase,
    this._getFavoriteExercisesUseCase,
    this._toggleFavoriteUseCase,
    this._getCategoriesUseCase,
    this._getDifficultiesUseCase,
  ) : super(ExerciseInitial()) {
    on<LoadExercises>(_onLoadExercises);
    on<SearchExercises>(_onSearchExercises);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByDifficulty>(_onFilterByDifficulty);
    on<LoadFavoriteExercises>(_onLoadFavoriteExercises);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadCategories>(_onLoadCategories);
    on<LoadDifficulties>(_onLoadDifficulties);
  }

  Future<void> _onLoadExercises(
      LoadExercises event, Emitter<ExerciseState> emit) async {
    emit(ExerciseLoading());

    final result = await _getExercisesUseCase();
    final categoriesResult = await _getCategoriesUseCase();
    final difficultiesResult = await _getDifficultiesUseCase();

    result.fold(
      (error) => emit(ExerciseError(error)),
      (exercises) {
        categoriesResult.fold(
          (error) => emit(ExerciseError(error)),
          (categories) {
            difficultiesResult.fold(
              (error) => emit(ExerciseError(error)),
              (difficulties) {
                emit(ExerciseLoaded(
                  exercises: exercises,
                  categories: categories,
                  difficulties: difficulties,
                ));
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onSearchExercises(
      SearchExercises event, Emitter<ExerciseState> emit) async {
    if (state is ExerciseLoaded) {
      final currentState = state as ExerciseLoaded;
      emit(ExerciseLoading());

      final result = await _searchExercisesUseCase(event.query);

      result.fold(
        (error) => emit(ExerciseError(error)),
        (exercises) {
          emit(currentState.copyWith(
            exercises: exercises,
            searchQuery: event.query,
            selectedCategory: null,
            selectedDifficulty: null,
          ));
        },
      );
    }
  }

  Future<void> _onFilterByCategory(
      FilterByCategory event, Emitter<ExerciseState> emit) async {
    if (state is ExerciseLoaded) {
      final currentState = state as ExerciseLoaded;
      emit(ExerciseLoading());

      final result = await _filterByCategoryUseCase(event.category);

      result.fold(
        (error) => emit(ExerciseError(error)),
        (exercises) {
          emit(currentState.copyWith(
            exercises: exercises,
            selectedCategory: event.category,
            searchQuery: null,
          ));
        },
      );
    }
  }

  Future<void> _onFilterByDifficulty(
      FilterByDifficulty event, Emitter<ExerciseState> emit) async {
    if (state is ExerciseLoaded) {
      final currentState = state as ExerciseLoaded;
      emit(ExerciseLoading());

      final result = await _filterByDifficultyUseCase(event.difficulty);

      result.fold(
        (error) => emit(ExerciseError(error)),
        (exercises) {
          emit(currentState.copyWith(
            exercises: exercises,
            selectedDifficulty: event.difficulty,
            searchQuery: null,
          ));
        },
      );
    }
  }

  Future<void> _onLoadFavoriteExercises(
      LoadFavoriteExercises event, Emitter<ExerciseState> emit) async {
    emit(ExerciseLoading());

    final result = await _getFavoriteExercisesUseCase(event.userId);

    result.fold(
      (error) => emit(ExerciseError(error)),
      (exercises) {
        if (state is ExerciseLoaded) {
          final currentState = state as ExerciseLoaded;
          emit(currentState.copyWith(exercises: exercises));
        } else {
          emit(ExerciseLoaded(
            exercises: exercises,
            categories: [],
            difficulties: [],
          ));
        }
      },
    );
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<ExerciseState> emit) async {
    final result = await _toggleFavoriteUseCase(event.userId, event.exerciseId);

    result.fold(
      (error) => emit(ExerciseError(error)),
      (_) {
        // Обновляем состояние, перезагружая упражнения
        add(LoadExercises());
      },
    );
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<ExerciseState> emit) async {
    final result = await _getCategoriesUseCase();

    result.fold(
      (error) => emit(ExerciseError(error)),
      (categories) {
        if (state is ExerciseLoaded) {
          final currentState = state as ExerciseLoaded;
          emit(currentState.copyWith(categories: categories));
        }
      },
    );
  }

  Future<void> _onLoadDifficulties(
      LoadDifficulties event, Emitter<ExerciseState> emit) async {
    final result = await _getDifficultiesUseCase();

    result.fold(
      (error) => emit(ExerciseError(error)),
      (difficulties) {
        if (state is ExerciseLoaded) {
          final currentState = state as ExerciseLoaded;
          emit(currentState.copyWith(difficulties: difficulties));
        }
      },
    );
  }
}
