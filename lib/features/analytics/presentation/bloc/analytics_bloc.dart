import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/analytics_event.dart' as domain;
import '../../domain/entities/analytics_data.dart';
import '../../domain/usecases/track_event_usecase.dart';
import '../../domain/usecases/track_event_usecase.dart' as usecases;

/// События для AnalyticsBloc
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Отслеживание события
class TrackAnalyticsEvent extends AnalyticsEvent {
  final domain.AnalyticsEvent event;

  const TrackAnalyticsEvent(this.event);

  @override
  List<Object?> get props => [event];
}

/// Отслеживание нескольких событий
class TrackAnalyticsEvents extends AnalyticsEvent {
  final List<domain.AnalyticsEvent> events;

  const TrackAnalyticsEvents(this.events);

  @override
  List<Object?> get props => [events];
}

/// Получение аналитических данных за сегодня
class GetTodayAnalytics extends AnalyticsEvent {
  final String userId;

  const GetTodayAnalytics(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Получение аналитических данных за неделю
class GetWeeklyAnalytics extends AnalyticsEvent {
  final String userId;

  const GetWeeklyAnalytics(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Получение аналитических данных за месяц
class GetMonthlyAnalytics extends AnalyticsEvent {
  final String userId;

  const GetMonthlyAnalytics(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Получение аналитических данных за период
class GetAnalyticsForPeriod extends AnalyticsEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  const GetAnalyticsForPeriod({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [userId, startDate, endDate];
}

/// Состояния для AnalyticsBloc
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class AnalyticsInitial extends AnalyticsState {}

/// Загрузка
class AnalyticsLoading extends AnalyticsState {}

/// Аналитические данные загружены
class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsData data;
  final String period;

  const AnalyticsLoaded(this.data, this.period);

  @override
  List<Object?> get props => [data, period];
}

/// Ошибка
class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Событие отслежено
class AnalyticsEventTracked extends AnalyticsState {
  final String eventName;

  const AnalyticsEventTracked(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

/// BLoC для аналитики
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final TrackEventUseCase _trackEventUseCase;
  final usecases.TrackEventsUseCase _trackEventsUseCase;
  final usecases.GetTodayAnalyticsUseCase _getTodayAnalyticsUseCase;
  final usecases.GetWeeklyAnalyticsUseCase _getWeeklyAnalyticsUseCase;
  final usecases.GetMonthlyAnalyticsUseCase _getMonthlyAnalyticsUseCase;
  final usecases.GetAnalyticsForPeriodUseCase _getAnalyticsForPeriodUseCase;

  AnalyticsBloc({
    required TrackEventUseCase trackEventUseCase,
    required usecases.TrackEventsUseCase trackEventsUseCase,
    required usecases.GetTodayAnalyticsUseCase getTodayAnalyticsUseCase,
    required usecases.GetWeeklyAnalyticsUseCase getWeeklyAnalyticsUseCase,
    required usecases.GetMonthlyAnalyticsUseCase getMonthlyAnalyticsUseCase,
    required usecases.GetAnalyticsForPeriodUseCase getAnalyticsForPeriodUseCase,
  }) : _trackEventUseCase = trackEventUseCase,
       _trackEventsUseCase = trackEventsUseCase,
       _getTodayAnalyticsUseCase = getTodayAnalyticsUseCase,
       _getWeeklyAnalyticsUseCase = getWeeklyAnalyticsUseCase,
       _getMonthlyAnalyticsUseCase = getMonthlyAnalyticsUseCase,
       _getAnalyticsForPeriodUseCase = getAnalyticsForPeriodUseCase,
       super(AnalyticsInitial()) {
    
    on<TrackAnalyticsEvent>(_onTrackEvent);
    on<TrackAnalyticsEvents>(_onTrackEvents);
    on<GetTodayAnalytics>(_onGetTodayAnalytics);
    on<GetWeeklyAnalytics>(_onGetWeeklyAnalytics);
    on<GetMonthlyAnalytics>(_onGetMonthlyAnalytics);
    on<GetAnalyticsForPeriod>(_onGetAnalyticsForPeriod);
  }

  Future<void> _onTrackEvent(
    TrackAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      final result = await _trackEventUseCase(event.event);
      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),
        (_) => emit(AnalyticsEventTracked(event.event.name)),
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onTrackEvents(
    TrackAnalyticsEvents event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      final result = await _trackEventsUseCase(event.events);
      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),
        (_) => emit(AnalyticsEventTracked('${event.events.length} events')),
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onGetTodayAnalytics(
    GetTodayAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final result = await _getTodayAnalyticsUseCase(event.userId);
      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),
        (data) => emit(AnalyticsLoaded(data, 'today')),
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onGetWeeklyAnalytics(
    GetWeeklyAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final result = await _getWeeklyAnalyticsUseCase(event.userId);
      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),
        (data) => emit(AnalyticsLoaded(data, 'week')),
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onGetMonthlyAnalytics(
    GetMonthlyAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final result = await _getMonthlyAnalyticsUseCase(event.userId);
      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),
        (data) => emit(AnalyticsLoaded(data, 'month')),
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onGetAnalyticsForPeriod(
    GetAnalyticsForPeriod event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final result = await _getAnalyticsForPeriodUseCase(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),
        (data) => emit(AnalyticsLoaded(data, 'period')),
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
} 