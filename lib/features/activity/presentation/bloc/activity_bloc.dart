import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/activity_session.dart';
import '../../domain/entities/activity_stats.dart';
import '../../domain/usecases/activity_usecases.dart';

// Events
abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class StartActivitySession extends ActivityEvent {
  final ActivitySession session;

  const StartActivitySession(this.session);

  @override
  List<Object?> get props => [session];
}

class UpdateActivitySession extends ActivityEvent {
  final ActivitySession session;

  const UpdateActivitySession(this.session);

  @override
  List<Object?> get props => [session];
}

class CompleteActivitySession extends ActivityEvent {
  final String sessionId;

  const CompleteActivitySession(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class LoadCurrentSession extends ActivityEvent {
  final String userId;

  const LoadCurrentSession(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadUserSessions extends ActivityEvent {
  final String userId;
  final DateTime? from;
  final DateTime? to;

  const LoadUserSessions(this.userId, {this.from, this.to});

  @override
  List<Object?> get props => [userId, from, to];
}

class LoadDailyStats extends ActivityEvent {
  final String userId;
  final DateTime date;

  const LoadDailyStats(this.userId, this.date);

  @override
  List<Object?> get props => [userId, date];
}

class LoadWeeklyStats extends ActivityEvent {
  final String userId;
  final DateTime weekStart;

  const LoadWeeklyStats(this.userId, this.weekStart);

  @override
  List<Object?> get props => [userId, weekStart];
}

class LoadMonthlyStats extends ActivityEvent {
  final String userId;
  final DateTime monthStart;

  const LoadMonthlyStats(this.userId, this.monthStart);

  @override
  List<Object?> get props => [userId, monthStart];
}

class LoadActivityAnalytics extends ActivityEvent {
  final String userId;
  final DateTime? from;
  final DateTime? to;

  const LoadActivityAnalytics(this.userId, {this.from, this.to});

  @override
  List<Object?> get props => [userId, from, to];
}

// States
abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivitySessionStarted extends ActivityState {
  final ActivitySession session;

  const ActivitySessionStarted(this.session);

  @override
  List<Object?> get props => [session];
}

class ActivitySessionUpdated extends ActivityState {
  final ActivitySession session;

  const ActivitySessionUpdated(this.session);

  @override
  List<Object?> get props => [session];
}

class ActivitySessionCompleted extends ActivityState {
  final ActivitySession session;

  const ActivitySessionCompleted(this.session);

  @override
  List<Object?> get props => [session];
}

class CurrentSessionLoaded extends ActivityState {
  final ActivitySession? session;

  const CurrentSessionLoaded(this.session);

  @override
  List<Object?> get props => [session];
}

class UserSessionsLoaded extends ActivityState {
  final List<ActivitySession> sessions;

  const UserSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class DailyStatsLoaded extends ActivityState {
  final ActivityStats stats;

  const DailyStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class WeeklyStatsLoaded extends ActivityState {
  final List<ActivityStats> stats;

  const WeeklyStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class MonthlyStatsLoaded extends ActivityState {
  final List<ActivityStats> stats;

  const MonthlyStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ActivityAnalyticsLoaded extends ActivityState {
  final Map<String, dynamic> analytics;

  const ActivityAnalyticsLoaded(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

class ActivityError extends ActivityState {
  final String message;

  const ActivityError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final StartActivitySessionUseCase _startActivitySessionUseCase;
  final UpdateActivitySessionUseCase _updateActivitySessionUseCase;
  final CompleteActivitySessionUseCase _completeActivitySessionUseCase;
  final GetCurrentSessionUseCase _getCurrentSessionUseCase;
  final GetUserSessionsUseCase _getUserSessionsUseCase;
  final GetDailyStatsUseCase _getDailyStatsUseCase;
  final GetWeeklyStatsUseCase _getWeeklyStatsUseCase;
  final GetMonthlyStatsUseCase _getMonthlyStatsUseCase;
  final GetActivityAnalyticsUseCase _getActivityAnalyticsUseCase;

  ActivityBloc(
    this._startActivitySessionUseCase,
    this._updateActivitySessionUseCase,
    this._completeActivitySessionUseCase,
    this._getCurrentSessionUseCase,
    this._getUserSessionsUseCase,
    this._getDailyStatsUseCase,
    this._getWeeklyStatsUseCase,
    this._getMonthlyStatsUseCase,
    this._getActivityAnalyticsUseCase,
  ) : super(ActivityInitial()) {
    on<StartActivitySession>(_onStartActivitySession);
    on<UpdateActivitySession>(_onUpdateActivitySession);
    on<CompleteActivitySession>(_onCompleteActivitySession);
    on<LoadCurrentSession>(_onLoadCurrentSession);
    on<LoadUserSessions>(_onLoadUserSessions);
    on<LoadDailyStats>(_onLoadDailyStats);
    on<LoadWeeklyStats>(_onLoadWeeklyStats);
    on<LoadMonthlyStats>(_onLoadMonthlyStats);
    on<LoadActivityAnalytics>(_onLoadActivityAnalytics);
  }

  Future<void> _onStartActivitySession(
      StartActivitySession event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result = await _startActivitySessionUseCase(event.session);

    result.fold(
      (error) => emit(ActivityError(error)),
      (session) => emit(ActivitySessionStarted(session)),
    );
  }

  Future<void> _onUpdateActivitySession(
      UpdateActivitySession event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result = await _updateActivitySessionUseCase(event.session);

    result.fold(
      (error) => emit(ActivityError(error)),
      (session) => emit(ActivitySessionUpdated(session)),
    );
  }

  Future<void> _onCompleteActivitySession(
      CompleteActivitySession event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result = await _completeActivitySessionUseCase(event.sessionId);

    result.fold(
      (error) => emit(ActivityError(error)),
      (session) => emit(ActivitySessionCompleted(session)),
    );
  }

  Future<void> _onLoadCurrentSession(
      LoadCurrentSession event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result = await _getCurrentSessionUseCase(event.userId);

    result.fold(
      (error) => emit(ActivityError(error)),
      (session) => emit(CurrentSessionLoaded(session)),
    );
  }

  Future<void> _onLoadUserSessions(
      LoadUserSessions event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result = await _getUserSessionsUseCase(event.userId,
        from: event.from, to: event.to);

    result.fold(
      (error) => emit(ActivityError(error)),
      (sessions) => emit(UserSessionsLoaded(sessions)),
    );
  }

  Future<void> _onLoadDailyStats(
      LoadDailyStats event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result = await _getDailyStatsUseCase(event.userId, event.date);

    result.fold(
      (error) => emit(ActivityError(error)),
      (stats) => emit(DailyStatsLoaded(stats)),
    );
  }

  Future<void> _onLoadWeeklyStats(
      LoadWeeklyStats event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result = await _getWeeklyStatsUseCase(event.userId, event.weekStart);

    result.fold(
      (error) => emit(ActivityError(error)),
      (stats) => emit(WeeklyStatsLoaded(stats)),
    );
  }

  Future<void> _onLoadMonthlyStats(
      LoadMonthlyStats event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result =
        await _getMonthlyStatsUseCase(event.userId, event.monthStart);

    result.fold(
      (error) => emit(ActivityError(error)),
      (stats) => emit(MonthlyStatsLoaded(stats)),
    );
  }

  Future<void> _onLoadActivityAnalytics(
      LoadActivityAnalytics event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());

    final result = await _getActivityAnalyticsUseCase(event.userId,
        from: event.from, to: event.to);

    result.fold(
      (error) => emit(ActivityError(error)),
      (analytics) => emit(ActivityAnalyticsLoaded(analytics)),
    );
  }
}
