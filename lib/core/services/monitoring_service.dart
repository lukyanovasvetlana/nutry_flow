import 'package:nutry_flow/core/services/analytics_service.dart';
import 'package:nutry_flow/core/services/performance_service.dart';
import 'package:nutry_flow/core/services/crashlytics_service.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'dart:developer' as developer;

class MonitoringService {
  static final MonitoringService _instance = MonitoringService._();
  static MonitoringService get instance => _instance;

  MonitoringService._();

  bool _isInitialized = false;

  /// Инициализация всех сервисов мониторинга
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log('📊 MonitoringService: Initializing monitoring services', name: 'MonitoringService');

      // Инициализируем все сервисы параллельно
      await Future.wait([
        AnalyticsService.instance.initialize(),
        PerformanceService.instance.initialize(),
        CrashlyticsService.instance.initialize(),
      ]);

      _isInitialized = true;
      developer.log('📊 MonitoringService: All monitoring services initialized successfully', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to initialize monitoring services: $e', name: 'MonitoringService');
      rethrow;
    }
  }

  /// Отслеживание события с полным мониторингом
  Future<void> trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
    String? screenName,
  }) async {
    try {
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: eventName,
        parameters: parameters,
      );

      // Логируем просмотр экрана если указан
      if (screenName != null) {
        await AnalyticsService.instance.logScreenView(screenName: screenName);
      }

      developer.log('📊 MonitoringService: Event tracked successfully: $eventName', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track event: $e', name: 'MonitoringService');
      await _logError('Event tracking failed', e);
    }
  }

  /// Отслеживание экрана с производительностью
  Future<void> trackScreen({
    required String screenName,
    required Future<void> Function() screenLoadFunction,
  }) async {
    try {
      // Логируем просмотр экрана
      await AnalyticsService.instance.logScreenView(screenName: screenName);
      
      // Выполняем функцию загрузки экрана
      await screenLoadFunction();
      
      // Отслеживаем время загрузки экрана
      await PerformanceService.instance.trackScreenLoadTime(screenName);

      developer.log('📊 MonitoringService: Screen tracked successfully: $screenName', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track screen: $e', name: 'MonitoringService');
      await _logError('Screen tracking failed', e);
    }
  }

  /// Отслеживание API запроса с полным мониторингом
  Future<void> trackApiRequest({
    required String endpoint,
    required String method,
    required Future<void> Function() apiCall,
    Map<String, dynamic>? requestData,
  }) async {
    try {
      try {
        await apiCall();
      } catch (e) {
        // Логируем ошибку API
        await CrashlyticsService.instance.logApiError(
          endpoint: endpoint,
          method: method,
          statusCode: 500, // Пример
          errorMessage: e.toString(),
          requestData: requestData,
        );
        rethrow;
      }
      
      // Отслеживаем производительность API запроса
      await PerformanceService.instance.trackApiRequest(endpoint, method);

      // Логируем успешный API запрос
      await AnalyticsService.instance.logEvent(
        name: 'api_request_success',
        parameters: {
          'endpoint': endpoint,
          'method': method,
          if (requestData != null) 'request_data': requestData,
        },
      );

      developer.log('📊 MonitoringService: API request tracked successfully: $method $endpoint', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track API request: $e', name: 'MonitoringService');
      await _logError('API request tracking failed', e);
    }
  }

  /// Отслеживание пользовательского действия
  Future<void> trackUserAction({
    required String actionName,
    required String screenName,
    Map<String, dynamic>? parameters,
    Future<void> Function()? actionFunction,
  }) async {
    try {
      if (actionFunction != null) {
        // Выполняем действие
        await actionFunction();
        
        // Отслеживаем время отклика UI
        await PerformanceService.instance.trackUIResponseTime(actionName);
      }

      // Логируем действие пользователя
      await AnalyticsService.instance.logEvent(
        name: 'user_action',
        parameters: {
          'action_name': actionName,
          'screen_name': screenName,
          if (parameters != null) ...parameters,
        },
      );

      developer.log('📊 MonitoringService: User action tracked successfully: $actionName', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track user action: $e', name: 'MonitoringService');
      await _logError('User action tracking failed', e);
    }
  }

  /// Отслеживание ошибки с полным мониторингом
  Future<void> trackError({
    required dynamic error,
    StackTrace? stackTrace,
    String? screenName,
    String? actionName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Логируем в Crashlytics
      await CrashlyticsService.instance.logError(
        error,
        stackTrace,
        additionalData: {
          if (screenName != null) 'screen_name': screenName,
          if (actionName != null) 'action_name': actionName,
          if (additionalData != null) ...additionalData,
        },
      );

      // Логируем в аналитику
      await AnalyticsService.instance.logError(
        errorType: error.runtimeType.toString(),
        errorMessage: error.toString(),
        screenName: screenName,
        additionalData: additionalData,
      );

      developer.log('📊 MonitoringService: Error tracked successfully', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track error: $e', name: 'MonitoringService');
    }
  }

  /// Отслеживание производительности приложения
  Future<void> trackAppPerformance() async {
    try {
      // Отслеживаем время запуска приложения
      await PerformanceService.instance.trackAppStartTime(Duration.zero);

      // Отслеживаем использование памяти
      await PerformanceService.instance.trackMemoryUsage();

      developer.log('📊 MonitoringService: App performance tracked successfully', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track app performance: $e', name: 'MonitoringService');
      await _logError('App performance tracking failed', e);
    }
  }

  /// Отслеживание пользовательского сеанса
  Future<void> trackUserSession({
    required String userId,
    required String sessionType,
    Map<String, dynamic>? sessionData,
  }) async {
    try {
      // Устанавливаем пользовательские данные
      await AnalyticsService.instance.setUserProperty(name: 'user_id', value: userId);
      await CrashlyticsService.instance.setUserIdentifier(userId);

      // Логируем начало сеанса
      await AnalyticsService.instance.logEvent(
        name: 'user_session_start',
        parameters: {
          'session_type': sessionType,
          'user_id': userId,
          if (sessionData != null) ...sessionData,
        },
      );

      developer.log('📊 MonitoringService: User session tracked successfully: $sessionType', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track user session: $e', name: 'MonitoringService');
      await _logError('User session tracking failed', e);
    }
  }

  /// Отслеживание достижения цели
  Future<void> trackGoalAchievement({
    required String goalName,
    required String goalType,
    double? progress,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Логируем в аналитику
      await AnalyticsService.instance.logGoalAchievement(
        goalName: goalName,
        goalType: goalType,
        progress: progress,
      );

      // Логируем событие
      await AnalyticsService.instance.logEvent(
        name: 'goal_achievement',
        parameters: {
          'goal_name': goalName,
          'goal_type': goalType,
          if (progress != null) 'progress': progress,
          if (additionalData != null) ...additionalData,
        },
      );

      developer.log('📊 MonitoringService: Goal achievement tracked successfully: $goalName', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track goal achievement: $e', name: 'MonitoringService');
      await _logError('Goal achievement tracking failed', e);
    }
  }

  /// Отслеживание тренировки
  Future<void> trackWorkout({
    required String workoutType,
    required int durationMinutes,
    required int caloriesBurned,
    String? workoutName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Логируем в аналитику
      await AnalyticsService.instance.logWorkout(
        workoutType: workoutType,
        durationMinutes: durationMinutes,
        caloriesBurned: caloriesBurned,
        workoutName: workoutName,
      );

      // Логируем событие
      await AnalyticsService.instance.logEvent(
        name: 'workout_completed',
        parameters: {
          'workout_type': workoutType,
          'duration_minutes': durationMinutes,
          'calories_burned': caloriesBurned,
          if (workoutName != null) 'workout_name': workoutName,
          if (additionalData != null) ...additionalData,
        },
      );

      developer.log('📊 MonitoringService: Workout tracked successfully: $workoutType', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track workout: $e', name: 'MonitoringService');
      await _logError('Workout tracking failed', e);
    }
  }

  /// Отслеживание приема пищи
  Future<void> trackMeal({
    required String mealType,
    required int calories,
    required double protein,
    required double fat,
    required double carbs,
    String? mealName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Логируем в аналитику
      await AnalyticsService.instance.logMeal(
        mealType: mealType,
        calories: calories,
        protein: protein,
        fat: fat,
        carbs: carbs,
        mealName: mealName,
      );

      // Логируем событие
      await AnalyticsService.instance.logEvent(
        name: 'meal_logged',
        parameters: {
          'meal_type': mealType,
          'calories': calories,
          'protein': protein,
          'fat': fat,
          'carbs': carbs,
          if (mealName != null) 'meal_name': mealName,
          if (additionalData != null) ...additionalData,
        },
      );

      developer.log('📊 MonitoringService: Meal tracked successfully: $mealType', name: 'MonitoringService');
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to track meal: $e', name: 'MonitoringService');
      await _logError('Meal tracking failed', e);
    }
  }

  /// Вспомогательный метод для логирования ошибок
  Future<void> _logError(String context, dynamic error) async {
    try {
      await CrashlyticsService.instance.logError(
        error,
        null,
        reason: context,
        additionalData: {
          'context': context,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      developer.log('📊 MonitoringService: Failed to log error in _logError: $e', name: 'MonitoringService');
    }
  }

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;

  /// Получение сервисов
  AnalyticsService get analytics => AnalyticsService.instance;
  PerformanceService get performance => PerformanceService.instance;
  CrashlyticsService get crashlytics => CrashlyticsService.instance;
} 