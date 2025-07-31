import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutry_flow/features/analytics/domain/entities/analytics_data.dart';
import 'package:nutry_flow/features/analytics/domain/entities/nutrition_tracking.dart';
import 'package:nutry_flow/features/analytics/domain/entities/weight_tracking.dart';
import 'package:nutry_flow/features/analytics/domain/entities/activity_tracking.dart';
import 'package:nutry_flow/features/analytics/domain/entities/analytics_event.dart' as domain;
import 'package:nutry_flow/features/analytics/data/repositories/analytics_repository.dart';
import 'dart:developer' as developer;

// Events
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsData extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;
  
  const LoadAnalyticsData({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadNutritionTracking extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;
  
  const LoadNutritionTracking({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class SaveNutritionTracking extends AnalyticsEvent {
  final NutritionTracking tracking;
  
  const SaveNutritionTracking(this.tracking);

  @override
  List<Object?> get props => [tracking];
}

class LoadWeightTracking extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;
  
  const LoadWeightTracking({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class SaveWeightTracking extends AnalyticsEvent {
  final WeightTracking tracking;
  
  const SaveWeightTracking(this.tracking);

  @override
  List<Object?> get props => [tracking];
}

class LoadActivityTracking extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;
  
  const LoadActivityTracking({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class SaveActivityTracking extends AnalyticsEvent {
  final ActivityTracking tracking;
  
  const SaveActivityTracking(this.tracking);

  @override
  List<Object?> get props => [tracking];
}

class LoadAnalyticsSummary extends AnalyticsEvent {
  const LoadAnalyticsSummary();
}

class TrackAnalyticsEvent extends AnalyticsEvent {
  final domain.AnalyticsEvent event;
  
  const TrackAnalyticsEvent(this.event);

  @override
  List<Object?> get props => [event];
}

// States
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsData analyticsData;
  final List<NutritionTracking> nutritionTracking;
  final List<WeightTracking> weightTracking;
  final List<ActivityTracking> activityTracking;
  final DateTime startDate;
  final DateTime endDate;
  
  const AnalyticsLoaded({
    required this.analyticsData,
    required this.nutritionTracking,
    required this.weightTracking,
    required this.activityTracking,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
    analyticsData,
    nutritionTracking,
    weightTracking,
    activityTracking,
    startDate,
    endDate,
  ];

  AnalyticsLoaded copyWith({
    AnalyticsData? analyticsData,
    List<NutritionTracking>? nutritionTracking,
    List<WeightTracking>? weightTracking,
    List<ActivityTracking>? activityTracking,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AnalyticsLoaded(
      analyticsData: analyticsData ?? this.analyticsData,
      nutritionTracking: nutritionTracking ?? this.nutritionTracking,
      weightTracking: weightTracking ?? this.weightTracking,
      activityTracking: activityTracking ?? this.activityTracking,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class AnalyticsError extends AnalyticsState {
  final String message;
  
  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AnalyticsSuccess extends AnalyticsState {
  final String message;
  
  const AnalyticsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AnalyticsSummaryLoaded extends AnalyticsState {
  final Map<String, dynamic> summary;
  
  const AnalyticsSummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

// BLoC
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _analyticsRepository;

  AnalyticsBloc({
    required AnalyticsRepository analyticsRepository,
  }) : _analyticsRepository = analyticsRepository,
       super(AnalyticsInitial()) {
    
    on<LoadAnalyticsData>(_onLoadAnalyticsData);
    on<LoadNutritionTracking>(_onLoadNutritionTracking);
    on<SaveNutritionTracking>(_onSaveNutritionTracking);
    on<LoadWeightTracking>(_onLoadWeightTracking);
    on<SaveWeightTracking>(_onSaveWeightTracking);
    on<LoadActivityTracking>(_onLoadActivityTracking);
    on<SaveActivityTracking>(_onSaveActivityTracking);
    on<LoadAnalyticsSummary>(_onLoadAnalyticsSummary);
    on<TrackAnalyticsEvent>(_onTrackAnalyticsEvent);
  }

  Future<void> _onLoadAnalyticsData(
    LoadAnalyticsData event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Loading analytics data', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      final analyticsData = await _analyticsRepository.getAnalyticsData(
        event.startDate,
        event.endDate,
      );

      emit(AnalyticsLoaded(
        analyticsData: analyticsData,
        nutritionTracking: analyticsData.nutritionTracking,
        weightTracking: analyticsData.weightTracking,
        activityTracking: analyticsData.activityTracking,
        startDate: event.startDate,
        endDate: event.endDate,
      ));

      developer.log('📊 AnalyticsBloc: Analytics data loaded successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Load analytics data failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось загрузить данные аналитики: $e'));
    }
  }

  Future<void> _onLoadNutritionTracking(
    LoadNutritionTracking event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Loading nutrition tracking', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      final nutritionTracking = await _analyticsRepository.getNutritionTracking(
        event.startDate,
        event.endDate,
      );

      if (state is AnalyticsLoaded) {
        final currentState = state as AnalyticsLoaded;
        emit(currentState.copyWith(nutritionTracking: nutritionTracking));
      } else {
        emit(AnalyticsLoaded(
          analyticsData: AnalyticsData(
            userId: 'current_user',
            date: DateTime.now(),
            nutritionTracking: nutritionTracking,
            weightTracking: [],
            activityTracking: [],
            period: '${event.startDate.day}/${event.startDate.month} - ${event.endDate.day}/${event.endDate.month}',
          ),
          nutritionTracking: nutritionTracking,
          weightTracking: [],
          activityTracking: [],
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      }

      developer.log('📊 AnalyticsBloc: Nutrition tracking loaded successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Load nutrition tracking failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось загрузить данные о питании: $e'));
    }
  }

  Future<void> _onSaveNutritionTracking(
    SaveNutritionTracking event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Saving nutrition tracking', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      await _analyticsRepository.saveNutritionTracking(event.tracking);

      emit(AnalyticsSuccess('Данные о питании сохранены успешно'));
      developer.log('📊 AnalyticsBloc: Nutrition tracking saved successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Save nutrition tracking failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось сохранить данные о питании: $e'));
    }
  }

  Future<void> _onLoadWeightTracking(
    LoadWeightTracking event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Loading weight tracking', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      final weightTracking = await _analyticsRepository.getWeightTracking(
        event.startDate,
        event.endDate,
      );

      if (state is AnalyticsLoaded) {
        final currentState = state as AnalyticsLoaded;
        emit(currentState.copyWith(weightTracking: weightTracking));
      } else {
        emit(AnalyticsLoaded(
          analyticsData: AnalyticsData(
            userId: 'current_user',
            date: DateTime.now(),
            nutritionTracking: [],
            weightTracking: weightTracking,
            activityTracking: [],
            period: '${event.startDate.day}/${event.startDate.month} - ${event.endDate.day}/${event.endDate.month}',
          ),
          nutritionTracking: [],
          weightTracking: weightTracking,
          activityTracking: [],
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      }

      developer.log('📊 AnalyticsBloc: Weight tracking loaded successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Load weight tracking failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось загрузить данные о весе: $e'));
    }
  }

  Future<void> _onSaveWeightTracking(
    SaveWeightTracking event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Saving weight tracking', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      await _analyticsRepository.saveWeightTracking(event.tracking);

      emit(AnalyticsSuccess('Данные о весе сохранены успешно'));
      developer.log('📊 AnalyticsBloc: Weight tracking saved successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Save weight tracking failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось сохранить данные о весе: $e'));
    }
  }

  Future<void> _onLoadActivityTracking(
    LoadActivityTracking event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Loading activity tracking', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      final activityTracking = await _analyticsRepository.getActivityTracking(
        event.startDate,
        event.endDate,
      );

      if (state is AnalyticsLoaded) {
        final currentState = state as AnalyticsLoaded;
        emit(currentState.copyWith(activityTracking: activityTracking));
      } else {
        emit(AnalyticsLoaded(
          analyticsData: AnalyticsData(
            userId: 'current_user',
            date: DateTime.now(),
            nutritionTracking: [],
            weightTracking: [],
            activityTracking: activityTracking,
            period: '${event.startDate.day}/${event.startDate.month} - ${event.endDate.day}/${event.endDate.month}',
          ),
          nutritionTracking: [],
          weightTracking: [],
          activityTracking: activityTracking,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      }

      developer.log('📊 AnalyticsBloc: Activity tracking loaded successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Load activity tracking failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось загрузить данные об активности: $e'));
    }
  }

  Future<void> _onSaveActivityTracking(
    SaveActivityTracking event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Saving activity tracking', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      await _analyticsRepository.saveActivityTracking(event.tracking);

      emit(AnalyticsSuccess('Данные об активности сохранены успешно'));
      developer.log('📊 AnalyticsBloc: Activity tracking saved successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Save activity tracking failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось сохранить данные об активности: $e'));
    }
  }

  Future<void> _onLoadAnalyticsSummary(
    LoadAnalyticsSummary event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Loading analytics summary', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      // Загружаем данные за последние 30 дней
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 30));

      final nutritionTracking = await _analyticsRepository.getNutritionTracking(startDate, endDate);
      final weightTracking = await _analyticsRepository.getWeightTracking(startDate, endDate);
      final activityTracking = await _analyticsRepository.getActivityTracking(startDate, endDate);

      // Вычисляем сводку
      final summary = _calculateSummary(
        nutritionTracking,
        weightTracking,
        activityTracking,
      );

      emit(AnalyticsSummaryLoaded(summary));
      developer.log('📊 AnalyticsBloc: Analytics summary loaded successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Load analytics summary failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось загрузить сводку аналитики: $e'));
    }
  }

  Future<void> _onTrackAnalyticsEvent(
    TrackAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      developer.log('📊 AnalyticsBloc: Tracking analytics event', name: 'AnalyticsBloc');
      emit(AnalyticsLoading());

      await _analyticsRepository.trackEvent(event.event);

      emit(AnalyticsSuccess('Событие аналитики отслежено'));
      developer.log('📊 AnalyticsBloc: Analytics event tracked successfully', name: 'AnalyticsBloc');
    } catch (e) {
      developer.log('📊 AnalyticsBloc: Track analytics event failed: $e', name: 'AnalyticsBloc');
      emit(AnalyticsError('Не удалось отследить событие аналитики: $e'));
    }
  }

  Map<String, dynamic> _calculateSummary(
    List<NutritionTracking> nutritionTracking,
    List<WeightTracking> weightTracking,
    List<ActivityTracking> activityTracking,
  ) {
    // Средние калории за день
    final avgCalories = nutritionTracking.isNotEmpty
        ? nutritionTracking.map((n) => n.caloriesConsumed).reduce((a, b) => a + b) / nutritionTracking.length
        : 0;

    // Изменение веса
    final weightChange = weightTracking.length >= 2
        ? weightTracking.last.weight - weightTracking.first.weight
        : 0;

    // Общая активность
    final totalSteps = activityTracking.map((a) => a.stepsCount).reduce((a, b) => a + b);
    final totalCaloriesBurned = activityTracking.map((a) => a.caloriesBurned).reduce((a, b) => a + b);

    // Средний белок за день
    final avgProtein = nutritionTracking.isNotEmpty
        ? nutritionTracking.map((n) => n.proteinConsumed).reduce((a, b) => a + b) / nutritionTracking.length
        : 0;

    return {
      'avgCalories': avgCalories.round(),
      'weightChange': weightChange,
      'totalSteps': totalSteps,
      'totalCaloriesBurned': totalCaloriesBurned,
      'avgProtein': avgProtein.round(),
      'daysTracked': nutritionTracking.length,
      'workoutSessions': activityTracking.where((a) => a.workoutDuration > 0).length,
    };
  }
} 