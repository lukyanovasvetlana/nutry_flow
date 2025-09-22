import 'package:nutry_flow/core/services/analytics_service.dart';

/// Утилиты для работы с аналитикой
class AnalyticsUtils {
  /// Константы для названий событий
  static const String eventScreenView = 'screen_view';
  static const String eventButtonTap = 'button_tap';
  static const String eventNavigation = 'navigation';
  static const String eventError = 'app_error';
  static const String eventPerformance = 'performance_metric';
  static const String eventGoalAchievement = 'goal_achievement';
  static const String eventWorkout = 'workout_completed';
  static const String eventMeal = 'meal_logged';
  static const String eventSearch = 'search';
  static const String eventSelectContent = 'select_content';
  static const String eventLogin = 'login';
  static const String eventSignUp = 'sign_up';
  static const String eventUIInteraction = 'ui_interaction';

  /// Константы для названий экранов
  static const String screenSplash = 'splash';
  static const String screenWelcome = 'welcome';
  static const String screenLogin = 'login';
  static const String screenRegistration = 'registration';
  static const String screenProfileInfo = 'profile_info';
  static const String screenGoalsSetup = 'goals_setup';
  static const String screenDashboard = 'dashboard';
  static const String screenCalendar = 'calendar';
  static const String screenNotifications = 'notifications';
  static const String screenMealPlan = 'meal_plan';
  static const String screenGroceryList = 'grocery_list';
  static const String screenProfileSettings = 'profile_settings';
  static const String screenAnalytics = 'analytics';
  static const String screenABTesting = 'ab_testing';
  static const String screenHealthArticles = 'health_articles';

  /// Константы для типов элементов UI
  static const String elementTypeButton = 'button';
  static const String elementTypeInput = 'input';
  static const String elementTypeList = 'list';
  static const String elementTypeCard = 'card';
  static const String elementTypeImage = 'image';
  static const String elementTypeIcon = 'icon';
  static const String elementTypeGesture = 'gesture';

  /// Константы для действий
  static const String actionTap = 'tap';
  static const String actionLongPress = 'long_press';
  static const String actionSwipe = 'swipe';
  static const String actionScroll = 'scroll';
  static const String actionInput = 'input';
  static const String actionSelect = 'select';
  static const String actionDeselect = 'deselect';

  /// Отслеживание нажатия на кнопку
  static void trackButtonTap(String buttonName,
      {Map<String, dynamic>? parameters}) {
    AnalyticsService.instance.logEvent(
      name: eventButtonTap,
      parameters: {
        'button_name': buttonName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        if (parameters != null) ...parameters,
      },
    );
  }

  /// Отслеживание навигации
  static void trackNavigation({
    required String fromScreen,
    required String toScreen,
    String? navigationMethod,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logEvent(
      name: eventNavigation,
      parameters: {
        'from_screen': fromScreen,
        'to_screen': toScreen,
        if (navigationMethod != null) 'navigation_method': navigationMethod,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        if (additionalData != null) ...additionalData,
      },
    );
  }

  /// Отслеживание ошибки
  static void trackError({
    required String errorType,
    required String errorMessage,
    String? screenName,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logError(
      errorType: errorType,
      errorMessage: errorMessage,
      screenName: screenName,
      additionalData: additionalData,
    );
  }

  /// Отслеживание производительности
  static void trackPerformance({
    required String metricName,
    required double value,
    String? unit,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logPerformance(
      metricName: metricName,
      value: value,
      unit: unit,
    );

    // Дополнительное событие с расширенными данными
    if (additionalData != null) {
      AnalyticsService.instance.logEvent(
        name: eventPerformance,
        parameters: {
          'metric_name': metricName,
          'value': value,
          if (unit != null) 'unit': unit,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...additionalData,
        },
      );
    }
  }

  /// Отслеживание достижения цели
  static void trackGoalAchievement({
    required String goalName,
    required String goalType,
    double? progress,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logGoalAchievement(
      goalName: goalName,
      goalType: goalType,
      progress: progress,
    );

    // Дополнительное событие с расширенными данными
    if (additionalData != null) {
      AnalyticsService.instance.logEvent(
        name: eventGoalAchievement,
        parameters: {
          'goal_name': goalName,
          'goal_type': goalType,
          if (progress != null) 'progress': progress,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...additionalData,
        },
      );
    }
  }

  /// Отслеживание тренировки
  static void trackWorkout({
    required String workoutType,
    required int durationMinutes,
    required int caloriesBurned,
    String? workoutName,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logWorkout(
      workoutType: workoutType,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      workoutName: workoutName,
    );

    // Дополнительное событие с расширенными данными
    if (additionalData != null) {
      AnalyticsService.instance.logEvent(
        name: eventWorkout,
        parameters: {
          'workout_type': workoutType,
          'duration_minutes': durationMinutes,
          'calories_burned': caloriesBurned,
          if (workoutName != null) 'workout_name': workoutName,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...additionalData,
        },
      );
    }
  }

  /// Отслеживание приема пищи
  static void trackMeal({
    required String mealType,
    required int calories,
    required double protein,
    required double fat,
    required double carbs,
    String? mealName,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logMeal(
      mealType: mealType,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      mealName: mealName,
    );

    // Дополнительное событие с расширенными данными
    if (additionalData != null) {
      AnalyticsService.instance.logEvent(
        name: eventMeal,
        parameters: {
          'meal_type': mealType,
          'calories': calories,
          'protein': protein,
          'fat': fat,
          'carbs': carbs,
          if (mealName != null) 'meal_name': mealName,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...additionalData,
        },
      );
    }
  }

  /// Отслеживание поиска
  static void trackSearch(String searchTerm,
      {Map<String, dynamic>? additionalData}) {
    AnalyticsService.instance.logSearch(searchTerm: searchTerm);

    // Дополнительное событие с расширенными данными
    if (additionalData != null) {
      AnalyticsService.instance.logEvent(
        name: eventSearch,
        parameters: {
          'search_term': searchTerm,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...additionalData,
        },
      );
    }
  }

  /// Отслеживание выбора контента
  static void trackSelectContent({
    required String contentType,
    required String itemId,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logSelectContent(
      contentType: contentType,
      itemId: itemId,
    );

    // Дополнительное событие с расширенными данными
    if (additionalData != null) {
      AnalyticsService.instance.logEvent(
        name: eventSelectContent,
        parameters: {
          'content_type': contentType,
          'item_id': itemId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...additionalData,
        },
      );
    }
  }

  /// Отслеживание входа пользователя
  static void trackLogin({
    required String method,
    String? userId,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logLogin(method: method, userId: userId);

    // Дополнительное событие с расширенными данными
    if (additionalData != null) {
      AnalyticsService.instance.logEvent(
        name: eventLogin,
        parameters: {
          'login_method': method,
          if (userId != null) 'user_id': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...additionalData,
        },
      );
    }
  }

  /// Отслеживание регистрации
  static void trackSignUp({
    required String method,
    String? userId,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logSignUp(method: method, userId: userId);

    // Дополнительное событие с расширенными данными
    if (additionalData != null) {
      AnalyticsService.instance.logEvent(
        name: eventSignUp,
        parameters: {
          'signup_method': method,
          if (userId != null) 'user_id': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...additionalData,
        },
      );
    }
  }

  /// Отслеживание взаимодействия с UI
  static void trackUIInteraction({
    required String elementType,
    required String elementName,
    String? action,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logEvent(
      name: eventUIInteraction,
      parameters: {
        'element_type': elementType,
        'element_name': elementName,
        if (action != null) 'action': action,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        if (additionalData != null) ...additionalData,
      },
    );
  }

  /// Отслеживание времени загрузки экрана
  static void trackScreenLoadTime(String screenName, Duration loadTime) {
    trackPerformance(
      metricName: 'screen_load_time',
      value: loadTime.inMilliseconds.toDouble(),
      unit: 'ms',
      additionalData: {
        'screen_name': screenName,
      },
    );
  }

  /// Отслеживание времени ответа API
  static void trackAPIResponseTime(String endpoint, Duration responseTime) {
    trackPerformance(
      metricName: 'api_response_time',
      value: responseTime.inMilliseconds.toDouble(),
      unit: 'ms',
      additionalData: {
        'endpoint': endpoint,
      },
    );
  }

  /// Отслеживание использования памяти
  static void trackMemoryUsage(double memoryUsageMB) {
    trackPerformance(
      metricName: 'memory_usage',
      value: memoryUsageMB,
      unit: 'MB',
    );
  }

  /// Отслеживание FPS
  static void trackFPS(double fps) {
    trackPerformance(
      metricName: 'fps',
      value: fps,
      unit: 'fps',
    );
  }
}
