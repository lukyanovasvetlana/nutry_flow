// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:nutry_flow/core/services/firebase_interfaces.dart';

/// Заглушка для Firebase Analytics (Firebase временно отключен)
class FirebaseAnalyticsImpl implements FirebaseAnalyticsInterface {
  static final FirebaseAnalyticsImpl _instance = FirebaseAnalyticsImpl._();
  static FirebaseAnalyticsImpl get instance => _instance;

  FirebaseAnalyticsImpl._();

  // late FirebaseAnalytics _analytics;

  /// Инициализация Firebase Analytics
  @override
  Future<void> initialize() async {
    // _analytics = FirebaseAnalytics.instance;
    print('Firebase Analytics temporarily disabled');
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    // await _analytics.setAnalyticsCollectionEnabled(enabled);
    print('Firebase Analytics temporarily disabled');
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    // await _analytics.logEvent(
    //   name: name,
    //   parameters: parameters,
    // );
    print('Firebase Analytics temporarily disabled: $name');
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    // await _analytics.logScreenView(
    //   screenName: screenName,
    //   screenClass: screenClass,
    // );
    print('Firebase Analytics temporarily disabled: screen_view');
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    // await _analytics.setUserProperty(name: name, value: value);
    print('Firebase Analytics temporarily disabled: set_user_property');
  }

  @override
  Future<void> logLogin({required String loginMethod}) async {
    // await _analytics.logLogin(loginMethod: loginMethod);
    print('Firebase Analytics temporarily disabled: log_login');
  }

  @override
  Future<void> logSignUp({required String signUpMethod}) async {
    // await _analytics.logSignUp(signUpMethod: signUpMethod);
    print('Firebase Analytics temporarily disabled: log_sign_up');
  }

  @override
  Future<void> logAddToCart({
    required List<CustomAnalyticsEventItem> items,
    required String currency,
    required double value,
  }) async {
    // final analyticsItems = items.map((item) => AnalyticsEventItem(
    //   itemId: item.itemId,
    //   itemName: item.itemName,
    //   itemCategory: item.itemCategory,
    //   price: item.price,
    //   quantity: item.quantity,
    // )).toList();

    // await _analytics.logAddToCart(
    //   items: analyticsItems,
    //   currency: currency,
    //   value: value,
    // );
    print('Firebase Analytics temporarily disabled: log_add_to_cart');
  }

  @override
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    required List<CustomAnalyticsEventItem> items,
  }) async {
    // final analyticsItems = items.map((item) => AnalyticsEventItem(
    //   itemId: item.itemId,
    //   itemName: item.itemName,
    //   itemCategory: item.itemCategory,
    //   price: item.price,
    //   quantity: item.quantity,
    // )).toList();

    // await _analytics.logPurchase(
    //   transactionId: transactionId,
    //   value: value,
    //   currency: currency,
    //   items: analyticsItems,
    // );
    print('Firebase Analytics temporarily disabled: log_purchase');
  }

  @override
  Future<void> logSearch({
    required String searchTerm,
    String? contentType,
    int? itemCount,
  }) async {
    // await _analytics.logSearch(
    //   searchTerm: searchTerm,
    //   contentType: contentType,
    //   itemCount: itemCount,
    // );
    print('Firebase Analytics temporarily disabled: log_search');
  }

  @override
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    // await _analytics.logShare(
    //   contentType: contentType,
    //   itemId: itemId,
    //   method: method,
    // );
    print('Firebase Analytics temporarily disabled: log_share');
  }

  @override
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    // await _analytics.logSelectContent(
    //   contentType: contentType,
    //   itemId: itemId,
    // );
    print('Firebase Analytics temporarily disabled: log_select_content');
  }

  @override
  Future<void> logTutorialBegin() async {
    // await _analytics.logTutorialBegin();
    print('Firebase Analytics temporarily disabled: log_tutorial_begin');
  }

  @override
  Future<void> logTutorialComplete() async {
    // await _analytics.logTutorialComplete();
    print('Firebase Analytics temporarily disabled: log_tutorial_complete');
  }

  @override
  Future<void> logAppOpen() async {
    // await _analytics.logAppOpen();
    print('Firebase Analytics temporarily disabled: log_app_open');
  }

  @override
  Future<void> logFirstOpen() async {
    // await _analytics.logFirstOpen();
    print('Firebase Analytics temporarily disabled: log_first_open');
  }

  @override
  Future<void> logInAppPurchase({
    required String productId,
    required double price,
    required String currency,
    required bool success,
  }) async {
    // await _analytics.logInAppPurchase(
    //   productId: productId,
    //   price: price,
    //   currency: currency,
    //   success: success,
    // );
    print('Firebase Analytics temporarily disabled: log_in_app_purchase');
  }

  @override
  Future<void> logCustomEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    // await _analytics.logEvent(
    //   name: name,
    //   parameters: parameters,
    // );
    print('Firebase Analytics temporarily disabled: custom_event_$name');
  }

  @override
  Future<void> logUserEngagement({
    required int engagementTimeMs,
  }) async {
    // await _analytics.logEvent(
    //   name: 'user_engagement',
    //   parameters: {
    //     'engagement_time_msec': engagementTimeMs,
    //   },
    // );
    print('Firebase Analytics temporarily disabled: log_user_engagement');
  }

  @override
  Future<void> logGoalCompletion({
    required String goalId,
    required String goalName,
    double? value,
  }) async {
    // await _analytics.logEvent(
    //   name: 'goal_completion',
    //   parameters: {
    //     'goal_id': goalId,
    //     'goal_name': goalName,
    //     if (value != null) 'value': value,
    //   },
    // );
    print('Firebase Analytics temporarily disabled: log_goal_completion');
  }

  @override
  Future<void> logWorkout({
    required String workoutType,
    required int duration,
    required int calories,
    String? equipment,
  }) async {
    // await logEvent(
    //   name: 'workout_logged',
    //   parameters: {
    //     'workout_type': workoutType,
    //     'duration': duration,
    //     'calories': calories,
    //     if (equipment != null) 'equipment': equipment,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //   },
    // );
    print('Firebase Analytics temporarily disabled: log_workout');
  }

  @override
  Future<void> logMeal({
    required String mealType,
    required int calories,
    required double protein,
    required double fat,
    required double carbs,
    String? mealName,
  }) async {
    // await logEvent(
    //   name: 'meal_logged',
    //   parameters: {
    //     'meal_type': mealType,
    //     'calories': calories,
    //     'protein': protein,
    //     'fat': fat,
    //     'carbs': carbs,
    //     if (mealName != null) 'meal_name': mealName,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //   },
    // );
    print('Firebase Analytics temporarily disabled: log_meal');
  }

  @override
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? screenName,
    Map<String, dynamic>? additionalData,
  }) async {
    // await logEvent(
    //   name: 'app_error',
    //   parameters: {
    //     'error_type': errorType,
    //     'error_message': errorMessage,
    //     if (screenName != null) 'screen_name': screenName,
    //     if (additionalData != null) ...additionalData,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //   },
    // );
    print('Firebase Analytics temporarily disabled: log_error');
  }

  @override
  Future<void> logPerformance({
    required String metricName,
    required double value,
    String? unit,
  }) async {
    // await logEvent(
    //   name: 'performance_metric',
    //   parameters: {
    //     'metric_name': metricName,
    //     'value': value,
    //     if (unit != null) 'unit': unit,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //   },
    // );
    print('Firebase Analytics temporarily disabled: log_performance');
  }

  @override
  Future<void> logNavigation({
    required String fromScreen,
    required String toScreen,
    String? navigationMethod,
  }) async {
    // await logEvent(
    //   name: 'navigation',
    //   parameters: {
    //     'from_screen': fromScreen,
    //     'to_screen': toScreen,
    //     if (navigationMethod != null) 'navigation_method': navigationMethod,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //   },
    // );
    print('Firebase Analytics temporarily disabled: log_navigation');
  }

  @override
  Future<void> logUIInteraction({
    required String elementType,
    required String elementName,
    String? action,
    Map<String, dynamic>? additionalData,
  }) async {
    // await logEvent(
    //   name: 'ui_interaction',
    //   parameters: {
    //     'element_type': elementType,
    //     'element_name': elementName,
    //     if (action != null) 'action': action,
    //     if (additionalData != null) ...additionalData,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //   },
    // );
    print('Firebase Analytics temporarily disabled: log_ui_interaction');
  }

  /// Получение экземпляра FirebaseAnalytics
  // FirebaseAnalytics get analytics => _analytics;
}
