import 'package:get_it/get_it.dart';
import '../bloc/analytics_bloc.dart' show AnalyticsBloc, TrackAnalyticsEvent;
import '../../domain/entities/analytics_event.dart' as domain;
import '../../data/services/analytics_service.dart';

/// Утилита для отслеживания аналитических событий
class AnalyticsTracker {
  static final AnalyticsTracker _instance = AnalyticsTracker._internal();
  factory AnalyticsTracker() => _instance;
  AnalyticsTracker._internal();

  static AnalyticsTracker get instance => _instance;

  /// Отслеживает событие входа пользователя
  static void trackLogin({
    required String method,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent.login(
      method: method,
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Отслеживает событие регистрации пользователя
  static void trackSignUp({
    required String method,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent.signUp(
      method: method,
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Отслеживает просмотр экрана
  static void trackScreenView({
    required String screenName,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent.screenView(
      screenName: screenName,
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Отслеживает добавление еды
  static void trackFoodAdded({
    required String foodName,
    required double calories,
    required String mealType,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent.foodAdded(
      foodName: foodName,
      calories: calories,
      mealType: mealType,
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Отслеживает завершение тренировки
  static void trackWorkoutCompleted({
    required String workoutName,
    required int duration,
    required int caloriesBurned,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent.workoutCompleted(
      workoutName: workoutName,
      duration: duration,
      caloriesBurned: caloriesBurned,
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Отслеживает установку цели
  static void trackGoalSet({
    required String goalType,
    required String targetValue,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent.goalSet(
      goalType: goalType,
      targetValue: targetValue,
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Отслеживает достижение цели
  static void trackGoalAchieved({
    required String goalType,
    required String achievedValue,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent.goalAchieved(
      goalType: goalType,
      achievedValue: achievedValue,
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Отслеживает ошибку
  static void trackError({
    required String errorType,
    required String errorMessage,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent.error(
      errorType: errorType,
      errorMessage: errorMessage,
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Отслеживает пользовательское событие
  static void trackCustomEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
    String? userId,
    String? sessionId,
  }) {
    final event = domain.AnalyticsEvent(
      name: eventName,
      parameters: parameters ?? {},
      userId: userId,
      sessionId: sessionId,
    );
    _trackEvent(event);
  }

  /// Внутренний метод для отправки события
  static void _trackEvent(domain.AnalyticsEvent event) {
    try {
      final analyticsBloc = GetIt.instance<AnalyticsBloc>();
      analyticsBloc.add(TrackAnalyticsEvent(event));
    } catch (e) {
      // Логируем ошибку, но не прерываем выполнение приложения
    }
  }

  /// Устанавливает пользователя для аналитики
  static Future<void> setUser(String userId) async {
    try {
      final analyticsService = GetIt.instance.get<AnalyticsService>();
      await analyticsService.setUser(userId);
    } catch (e) {}
  }

  /// Сбрасывает пользователя
  static Future<void> resetUser() async {
    try {
      final analyticsService = GetIt.instance.get<AnalyticsService>();
      await analyticsService.resetUser();
    } catch (e) {}
  }
}
