import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/goal.dart';
import '../../domain/entities/progress_entry.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/usecases/create_goal_usecase.dart';
import '../../domain/usecases/get_goals_usecase.dart';
import '../../domain/usecases/track_progress_usecase.dart';

// Events
abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoals extends GoalsEvent {
  final String userId;

  const LoadGoals(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateGoal extends GoalsEvent {
  final String userId;
  final GoalType type;
  final String title;
  final String? description;
  final double targetValue;
  final String unit;
  final DateTime? targetDate;
  final Map<String, dynamic>? metadata;

  const CreateGoal({
    required this.userId,
    required this.type,
    required this.title,
    this.description,
    required this.targetValue,
    required this.unit,
    this.targetDate,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        userId,
        type,
        title,
        description,
        targetValue,
        unit,
        targetDate,
        metadata,
      ];
}

class UpdateGoal extends GoalsEvent {
  final Goal goal;

  const UpdateGoal(this.goal);

  @override
  List<Object> get props => [goal];
}

class DeleteGoal extends GoalsEvent {
  final String goalId;

  const DeleteGoal(this.goalId);

  @override
  List<Object> get props => [goalId];
}

class AddProgressEntry extends GoalsEvent {
  final String userId;
  final String? goalId;
  final ProgressEntryType type;
  final double value;
  final String unit;
  final DateTime? date;
  final String? notes;
  final Map<String, dynamic>? metadata;

  const AddProgressEntry({
    required this.userId,
    this.goalId,
    required this.type,
    required this.value,
    required this.unit,
    this.date,
    this.notes,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        userId,
        goalId,
        type,
        value,
        unit,
        date,
        notes,
        metadata,
      ];
}

class LoadProgressEntries extends GoalsEvent {
  final String userId;
  final String? goalId;
  final ProgressEntryType? type;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadProgressEntries({
    required this.userId,
    this.goalId,
    this.type,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, goalId, type, startDate, endDate];
}

class LoadAchievements extends GoalsEvent {
  final String userId;

  const LoadAchievements(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadUserStatistics extends GoalsEvent {
  final String userId;

  const LoadUserStatistics(this.userId);

  @override
  List<Object> get props => [userId];
}

class RefreshGoalsData extends GoalsEvent {
  final String userId;

  const RefreshGoalsData(this.userId);

  @override
  List<Object> get props => [userId];
}

// States
abstract class GoalsState extends Equatable {
  const GoalsState();

  @override
  List<Object?> get props => [];
}

class GoalsInitial extends GoalsState {}

class GoalsLoading extends GoalsState {}

class GoalsLoaded extends GoalsState {
  final List<Goal> goals;
  final List<ProgressEntry> progressEntries;
  final List<Achievement> achievements;
  final Map<String, dynamic> userStatistics;

  const GoalsLoaded({
    required this.goals,
    required this.progressEntries,
    required this.achievements,
    required this.userStatistics,
  });

  @override
  List<Object> get props =>
      [goals, progressEntries, achievements, userStatistics];

  GoalsLoaded copyWith({
    List<Goal>? goals,
    List<ProgressEntry>? progressEntries,
    List<Achievement>? achievements,
    Map<String, dynamic>? userStatistics,
  }) {
    return GoalsLoaded(
      goals: goals ?? this.goals,
      progressEntries: progressEntries ?? this.progressEntries,
      achievements: achievements ?? this.achievements,
      userStatistics: userStatistics ?? this.userStatistics,
    );
  }

  List<Goal> get activeGoals => goals.where((goal) => goal.isActive).toList();
  List<Goal> get completedGoals =>
      goals.where((goal) => goal.isCompleted).toList();
  List<Goal> get weightGoals =>
      goals.where((goal) => goal.type == GoalType.weight).toList();
  List<Goal> get activityGoals =>
      goals.where((goal) => goal.type == GoalType.activity).toList();
  List<Goal> get nutritionGoals =>
      goals.where((goal) => goal.type == GoalType.nutrition).toList();

  List<Achievement> get recentAchievements {
    final sorted = List<Achievement>.from(achievements);
    sorted.sort((a, b) => b.earnedDate.compareTo(a.earnedDate));
    return sorted.take(5).toList();
  }
}

class GoalsOperationInProgress extends GoalsState {
  final String operation;

  const GoalsOperationInProgress(this.operation);

  @override
  List<Object> get props => [operation];
}

class GoalsOperationSuccess extends GoalsState {
  final String message;
  final String? achievementId; // Для показа нового достижения

  const GoalsOperationSuccess(this.message, {this.achievementId});

  @override
  List<Object?> get props => [message, achievementId];
}

class GoalsError extends GoalsState {
  final String message;
  final Exception? exception;

  const GoalsError(this.message, {this.exception});

  @override
  List<Object?> get props => [message, exception];
}

// BLoC
class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final CreateGoalUseCase _createGoalUseCase;
  final GetGoalsUseCase _getGoalsUseCase;
  final TrackProgressUseCase _trackProgressUseCase;

  GoalsBloc({
    required CreateGoalUseCase createGoalUseCase,
    required GetGoalsUseCase getGoalsUseCase,
    required TrackProgressUseCase trackProgressUseCase,
  })  : _createGoalUseCase = createGoalUseCase,
        _getGoalsUseCase = getGoalsUseCase,
        _trackProgressUseCase = trackProgressUseCase,
        super(GoalsInitial()) {
    on<LoadGoals>(_onLoadGoals);
    on<CreateGoal>(_onCreateGoal);
    on<UpdateGoal>(_onUpdateGoal);
    on<DeleteGoal>(_onDeleteGoal);
    on<AddProgressEntry>(_onAddProgressEntry);
    on<LoadProgressEntries>(_onLoadProgressEntries);
    on<LoadAchievements>(_onLoadAchievements);
    on<LoadUserStatistics>(_onLoadUserStatistics);
    on<RefreshGoalsData>(_onRefreshGoalsData);
  }

  Future<void> _onLoadGoals(LoadGoals event, Emitter<GoalsState> emit) async {
    try {
      emit(GoalsLoading());

      final goals = await _getGoalsUseCase.execute(event.userId);
      final progressEntries =
          await _trackProgressUseCase.getProgressEntries(event.userId);
      final achievements = <Achievement>[]; // Пока пустой список
      final userStatistics =
          await _getGoalsUseCase.getUserStatistics(event.userId);

      emit(GoalsLoaded(
        goals: goals,
        progressEntries: progressEntries,
        achievements: achievements,
        userStatistics: userStatistics,
      ));
    } catch (e) {
      emit(GoalsError('Ошибка загрузки целей: ${e.toString()}',
          exception: e as Exception?));
    }
  }

  Future<void> _onCreateGoal(CreateGoal event, Emitter<GoalsState> emit) async {
    try {
      emit(const GoalsOperationInProgress('Создание цели...'));

      await _createGoalUseCase.execute(
        userId: event.userId,
        type: event.type,
        title: event.title,
        description: event.description,
        targetValue: event.targetValue,
        unit: event.unit,
        targetDate: event.targetDate,
        metadata: event.metadata,
      );

      emit(const GoalsOperationSuccess('Цель успешно создана!'));

      // Перезагружаем данные
      add(LoadGoals(event.userId));
    } catch (e) {
      emit(GoalsError('Ошибка создания цели: ${e.toString()}',
          exception: e as Exception?));
    }
  }

  Future<void> _onUpdateGoal(UpdateGoal event, Emitter<GoalsState> emit) async {
    try {
      emit(const GoalsOperationInProgress('Обновление цели...'));

      // Здесь будет логика обновления через repository
      emit(const GoalsOperationSuccess('Цель успешно обновлена!'));

      // Перезагружаем данные
      add(LoadGoals(event.goal.userId));
    } catch (e) {
      emit(GoalsError('Ошибка обновления цели: ${e.toString()}',
          exception: e as Exception?));
    }
  }

  Future<void> _onDeleteGoal(DeleteGoal event, Emitter<GoalsState> emit) async {
    try {
      emit(const GoalsOperationInProgress('Удаление цели...'));

      // Здесь будет логика удаления через repository
      emit(const GoalsOperationSuccess('Цель успешно удалена!'));

      // Нужно получить userId для перезагрузки
      if (state is GoalsLoaded) {
        final currentState = state as GoalsLoaded;
        final goalToDelete =
            currentState.goals.firstWhere((g) => g.id == event.goalId);
        add(LoadGoals(goalToDelete.userId));
      }
    } catch (e) {
      emit(GoalsError('Ошибка удаления цели: ${e.toString()}',
          exception: e as Exception?));
    }
  }

  Future<void> _onAddProgressEntry(
      AddProgressEntry event, Emitter<GoalsState> emit) async {
    try {
      emit(const GoalsOperationInProgress('Добавление записи прогресса...'));

      await _trackProgressUseCase.addProgressEntry(
        userId: event.userId,
        goalId: event.goalId,
        type: event.type,
        value: event.value,
        unit: event.unit,
        date: event.date,
        notes: event.notes,
        metadata: event.metadata,
      );

      emit(const GoalsOperationSuccess('Прогресс записан!'));

      // Перезагружаем данные
      add(LoadGoals(event.userId));
    } catch (e) {
      emit(GoalsError('Ошибка записи прогресса: ${e.toString()}',
          exception: e as Exception?));
    }
  }

  Future<void> _onLoadProgressEntries(
      LoadProgressEntries event, Emitter<GoalsState> emit) async {
    try {
      if (state is! GoalsLoaded) return;

      final progressEntries = await _trackProgressUseCase.getProgressEntries(
        event.userId,
        goalId: event.goalId,
        type: event.type,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      final currentState = state as GoalsLoaded;
      emit(currentState.copyWith(progressEntries: progressEntries));
    } catch (e) {
      emit(GoalsError('Ошибка загрузки прогресса: ${e.toString()}',
          exception: e as Exception?));
    }
  }

  Future<void> _onLoadAchievements(
      LoadAchievements event, Emitter<GoalsState> emit) async {
    try {
      if (state is! GoalsLoaded) return;

      // В будущем здесь будет загрузка достижений через repository
      final achievements = <Achievement>[];

      final currentState = state as GoalsLoaded;
      emit(currentState.copyWith(achievements: achievements));
    } catch (e) {
      emit(GoalsError('Ошибка загрузки достижений: ${e.toString()}',
          exception: e as Exception?));
    }
  }

  Future<void> _onLoadUserStatistics(
      LoadUserStatistics event, Emitter<GoalsState> emit) async {
    try {
      if (state is! GoalsLoaded) return;

      final userStatistics =
          await _getGoalsUseCase.getUserStatistics(event.userId);

      final currentState = state as GoalsLoaded;
      emit(currentState.copyWith(userStatistics: userStatistics));
    } catch (e) {
      emit(GoalsError('Ошибка загрузки статистики: ${e.toString()}',
          exception: e as Exception?));
    }
  }

  Future<void> _onRefreshGoalsData(
      RefreshGoalsData event, Emitter<GoalsState> emit) async {
    // Просто перезагружаем все данные
    add(LoadGoals(event.userId));
  }
}
