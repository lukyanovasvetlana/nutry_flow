import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:nutry_flow/core/services/firebase_interfaces.dart';

/// Реальная реализация Firebase Analytics
class FirebaseAnalyticsImpl implements FirebaseAnalyticsInterface {
  static final FirebaseAnalyticsImpl _instance = FirebaseAnalyticsImpl._();
  static FirebaseAnalyticsImpl get instance => _instance;

  FirebaseAnalyticsImpl._();

  late FirebaseAnalytics _analytics;

  /// Инициализация Firebase Analytics
  Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> logLogin({required String loginMethod}) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<void> logSignUp({required String signUpMethod}) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  @override
  Future<void> logAddToCart({
    required List<CustomAnalyticsEventItem> items,
    required String currency,
    required double value,
  }) async {
    final analyticsItems = items.map((item) => AnalyticsEventItem(
      itemId: item.itemId,
      itemName: item.itemName,
      itemCategory: item.itemCategory,
      price: item.price,
      quantity: item.quantity,
    )).toList();

    await _analytics.logAddToCart(
      items: analyticsItems,
      currency: currency,
      value: value,
    );
  }

  @override
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    required List<CustomAnalyticsEventItem> items,
  }) async {
    final analyticsItems = items.map((item) => AnalyticsEventItem(
      itemId: item.itemId,
      itemName: item.itemName,
      itemCategory: item.itemCategory,
      price: item.price,
      quantity: item.quantity,
    )).toList();

    await _analytics.logPurchase(
      transactionId: transactionId,
      value: value,
      currency: currency,
      items: analyticsItems,
    );
  }

  @override
  Future<void> logSearch({required String searchTerm}) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  @override
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    await _analytics.logSelectContent(
      contentType: contentType,
      itemId: itemId,
    );
  }

  /// Дополнительные методы для специфичной аналитики приложения

  /// Отслеживание достижения цели
  Future<void> logGoalAchievement({
    required String goalName,
    required String goalType,
    double? progress,
  }) async {
    await logEvent(
      name: 'goal_achievement',
      parameters: {
        'goal_name': goalName,
        'goal_type': goalType,
        if (progress != null) 'progress': progress,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Отслеживание тренировки
  Future<void> logWorkout({
    required String workoutType,
    required int durationMinutes,
    required int caloriesBurned,
    String? workoutName,
  }) async {
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
  }

  /// Отслеживание ошибки
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? screenName,
    Map<String, dynamic>? additionalData,
  }) async {
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
  }

  /// Отслеживание производительности
  Future<void> logPerformance({
    required String metricName,
    required double value,
    String? unit,
  }) async {
    await logEvent(
      name: 'performance_metric',
      parameters: {
        'metric_name': metricName,
        'value': value,
        if (unit != null) 'unit': unit,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Отслеживание навигации
  Future<void> logNavigation({
    required String fromScreen,
    required String toScreen,
    String? navigationMethod,
  }) async {
    await logEvent(
      name: 'navigation',
      parameters: {
        'from_screen': fromScreen,
        'to_screen': toScreen,
        if (navigationMethod != null) 'navigation_method': navigationMethod,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Отслеживание взаимодействия с UI
  Future<void> logUIInteraction({
    required String elementType,
    required String elementName,
    String? action,
    Map<String, dynamic>? additionalData,
  }) async {
    await logEvent(
      name: 'ui_interaction',
      parameters: {
        'element_type': elementType,
        'element_name': elementName,
        if (action != null) 'action': action,
        if (additionalData != null) ...additionalData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Получение экземпляра FirebaseAnalytics
  FirebaseAnalytics get analytics => _analytics;
}
