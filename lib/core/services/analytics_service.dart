// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/firebase_interfaces.dart';
import 'dart:developer' as developer;

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._();
  static AnalyticsService get instance => _instance;

  AnalyticsService._();

  late FirebaseAnalyticsInterface _analytics;
  bool _isInitialized = false;

  /// Инициализация сервиса аналитики
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log('📊 AnalyticsService: Initializing analytics service', name: 'AnalyticsService');

      _analytics = MockFirebaseAnalytics.instance;

      // Включаем сбор аналитики
      await _analytics.setAnalyticsCollectionEnabled(true);

      // Устанавливаем пользовательские свойства по умолчанию
      await _setDefaultUserProperties();

      _isInitialized = true;
      developer.log('📊 AnalyticsService: Analytics service initialized successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to initialize analytics service: $e', name: 'AnalyticsService');
      rethrow;
    }
  }

  /// Установка пользовательских свойств по умолчанию
  Future<void> _setDefaultUserProperties() async {
    try {
      await _analytics.setUserProperty(name: 'app_version', value: '1.0.0');
      await _analytics.setUserProperty(name: 'platform', value: 'mobile');
      
      // Получаем информацию о пользователе из Supabase
      final user = SupabaseService.instance.currentUser;
      if (user != null) {
        await _analytics.setUserProperty(name: 'user_id', value: user.id);
        if (user.email != null) {
          await _analytics.setUserProperty(name: 'user_email', value: user.email!);
        }
      }
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to set default user properties: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание события
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      if (!_isInitialized) {
        developer.log('📊 AnalyticsService: Analytics not initialized, skipping event: $name', name: 'AnalyticsService');
        return;
      }

      developer.log('📊 AnalyticsService: Logging event: $name with parameters: $parameters', name: 'AnalyticsService');

      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );

      developer.log('📊 AnalyticsService: Event logged successfully: $name', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log event $name: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание экрана
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging screen view: $screenName', name: 'AnalyticsService');

      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );

      developer.log('📊 AnalyticsService: Screen view logged successfully: $screenName', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log screen view $screenName: $e', name: 'AnalyticsService');
    }
  }

  /// Установка пользовательского свойства
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Setting user property: $name = $value', name: 'AnalyticsService');

      await _analytics.setUserProperty(name: name, value: value);

      developer.log('📊 AnalyticsService: User property set successfully: $name', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to set user property $name: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание входа пользователя
  Future<void> logLogin({
    required String method,
    String? userId,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging login with method: $method', name: 'AnalyticsService');

      await _analytics.logLogin(
        loginMethod: method,
      );

      if (userId != null) {
        await setUserProperty(name: 'user_id', value: userId);
      }

      developer.log('📊 AnalyticsService: Login logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log login: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание регистрации
  Future<void> logSignUp({
    required String method,
    String? userId,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging sign up with method: $method', name: 'AnalyticsService');

      await _analytics.logSignUp(
        signUpMethod: method,
      );

      if (userId != null) {
        await setUserProperty(name: 'user_id', value: userId);
      }

      developer.log('📊 AnalyticsService: Sign up logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log sign up: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание добавления в корзину
  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    required String currency,
    int quantity = 1,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging add to cart: $itemName', name: 'AnalyticsService');

      await _analytics.logAddToCart(
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            price: price,
            quantity: quantity,
          ),
        ],
        currency: currency,
        value: price * quantity,
      );

      developer.log('📊 AnalyticsService: Add to cart logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log add to cart: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание покупки
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    required List<AnalyticsEventItem> items,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging purchase: $transactionId', name: 'AnalyticsService');

      await _analytics.logPurchase(
        transactionId: transactionId,
        value: value,
        currency: currency,
        items: items,
      );

      developer.log('📊 AnalyticsService: Purchase logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log purchase: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание поиска
  Future<void> logSearch({
    required String searchTerm,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging search: $searchTerm', name: 'AnalyticsService');

      await _analytics.logSearch(
        searchTerm: searchTerm,
      );

      developer.log('📊 AnalyticsService: Search logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log search: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание выбора контента
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging select content: $contentType - $itemId', name: 'AnalyticsService');

      await _analytics.logSelectContent(
        contentType: contentType,
        itemId: itemId,
      );

      developer.log('📊 AnalyticsService: Select content logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log select content: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание достижения цели
  Future<void> logGoalAchievement({
    required String goalName,
    required String goalType,
    double? progress,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging goal achievement: $goalName', name: 'AnalyticsService');

      await logEvent(
        name: 'goal_achievement',
        parameters: {
          'goal_name': goalName,
          'goal_type': goalType,
          if (progress != null) 'progress': progress,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log('📊 AnalyticsService: Goal achievement logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log goal achievement: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание тренировки
  Future<void> logWorkout({
    required String workoutType,
    required int durationMinutes,
    required int caloriesBurned,
    String? workoutName,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging workout: $workoutType', name: 'AnalyticsService');

      await logEvent(
        name: 'workout_completed',
        parameters: {
          'workout_type': workoutType,
          'duration_minutes': durationMinutes,
          'calories_burned': caloriesBurned,
          if (workoutName != null) 'workout_name': workoutName,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log('📊 AnalyticsService: Workout logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log workout: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание приема пищи
  Future<void> logMeal({
    required String mealType,
    required int calories,
    required double protein,
    required double fat,
    required double carbs,
    String? mealName,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging meal: $mealType', name: 'AnalyticsService');

      await logEvent(
        name: 'meal_logged',
        parameters: {
          'meal_type': mealType,
          'calories': calories,
          'protein': protein,
          'fat': fat,
          'carbs': carbs,
          if (mealName != null) 'meal_name': mealName,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log('📊 AnalyticsService: Meal logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log meal: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание ошибки
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? screenName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging error: $errorType', name: 'AnalyticsService');

      await logEvent(
        name: 'app_error',
        parameters: {
          'error_type': errorType,
          'error_message': errorMessage,
          if (screenName != null) 'screen_name': screenName,
          if (additionalData != null) ...additionalData,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log('📊 AnalyticsService: Error logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log error: $e', name: 'AnalyticsService');
    }
  }

  /// Отслеживание производительности
  Future<void> logPerformance({
    required String metricName,
    required double value,
    String? unit,
  }) async {
    try {
      if (!_isInitialized) return;

      developer.log('📊 AnalyticsService: Logging performance: $metricName = $value', name: 'AnalyticsService');

      await logEvent(
        name: 'performance_metric',
        parameters: {
          'metric_name': metricName,
          'value': value,
          if (unit != null) 'unit': unit,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log('📊 AnalyticsService: Performance logged successfully', name: 'AnalyticsService');
    } catch (e) {
      developer.log('📊 AnalyticsService: Failed to log performance: $e', name: 'AnalyticsService');
    }
  }

  /// Получение экземпляра FirebaseAnalytics
  FirebaseAnalyticsInterface get analytics => _analytics;

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;
} 