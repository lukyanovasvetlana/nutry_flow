import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:nutry_flow/core/services/firebase_interfaces.dart';

/// Реализация Firebase Analytics
class FirebaseAnalyticsImpl implements FirebaseAnalyticsInterface {
  static final FirebaseAnalyticsImpl _instance = FirebaseAnalyticsImpl._();
  static FirebaseAnalyticsImpl get instance => _instance;

  FirebaseAnalyticsImpl._();

  late FirebaseAnalytics _analytics;

  /// Инициализация Firebase Analytics
  @override
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
    final analyticsItems = items
        .map((item) => AnalyticsEventItem(
              itemId: item.itemId,
              itemName: item.itemName,
              itemCategory: item.itemCategory,
              price: item.price,
              quantity: item.quantity,
            ))
        .toList();

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
    final analyticsItems = items
        .map((item) => AnalyticsEventItem(
              itemId: item.itemId,
              itemName: item.itemName,
              itemCategory: item.itemCategory,
              price: item.price,
              quantity: item.quantity,
            ))
        .toList();

    await _analytics.logPurchase(
      transactionId: transactionId,
      value: value,
      currency: currency,
      items: analyticsItems,
    );
  }

  @override
  Future<void> logSearch({
    required String searchTerm,
    String? contentType,
    int? itemCount,
  }) async {
    // Firebase Analytics logSearch принимает только searchTerm
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  // Дополнительный метод (не в интерфейсе, но доступен для использования)
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: itemId,
      method: method ?? 'unknown',
    );
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

  // Дополнительные методы (не в интерфейсе, но доступны для использования)
  Future<void> logTutorialBegin() async {
    await _analytics.logTutorialBegin();
  }

  Future<void> logTutorialComplete() async {
    await _analytics.logTutorialComplete();
  }

  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  Future<void> logFirstOpen() async {
    // logFirstOpen не существует в Firebase Analytics, используем logEvent
    await logEvent(
      name: 'first_open',
      parameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<void> logInAppPurchase({
    required String productId,
    required double price,
    required String currency,
    required bool success,
  }) async {
    // logInAppPurchase не существует в Firebase Analytics, используем logEvent
    await logEvent(
      name: 'in_app_purchase',
      parameters: {
        'product_id': productId,
        'price': price,
        'currency': currency,
        'success': success,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<void> logCustomEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> logUserEngagement({
    required int engagementTimeMs,
  }) async {
    await _analytics.logEvent(
      name: 'user_engagement',
      parameters: {
        'engagement_time_msec': engagementTimeMs,
      },
    );
  }

  Future<void> logGoalCompletion({
    required String goalId,
    required String goalName,
    double? value,
  }) async {
    await logEvent(
      name: 'goal_completion',
      parameters: {
        'goal_id': goalId,
        'goal_name': goalName,
        if (value != null) 'value': value,
      },
    );
  }

  Future<void> logWorkout({
    required String workoutType,
    required int duration,
    required int calories,
    String? equipment,
  }) async {
    await logEvent(
      name: 'workout_logged',
      parameters: {
        'workout_type': workoutType,
        'duration': duration,
        'calories': calories,
        if (equipment != null) 'equipment': equipment,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

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
