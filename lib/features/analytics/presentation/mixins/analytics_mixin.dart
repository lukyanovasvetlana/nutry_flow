import 'package:flutter/material.dart';
import 'package:nutry_flow/core/services/analytics_service.dart';

/// Миксин для автоматического отслеживания аналитики
mixin AnalyticsMixin<T extends StatefulWidget> on State<T> {
  /// Отслеживание просмотра экрана
  void trackScreenView(String screenName) {
    AnalyticsService.instance.logScreenView(
      screenName: screenName,
      screenClass: widget.runtimeType.toString(),
    );
  }

  /// Отслеживание события
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    AnalyticsService.instance.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  /// Отслеживание взаимодействия с UI
  void trackUIInteraction({
    required String elementType,
    required String elementName,
    String? action,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logEvent(
      name: 'ui_interaction',
      parameters: {
        'element_type': elementType,
        'element_name': elementName,
        if (action != null) 'action': action,
        if (additionalData != null) ...additionalData,
        'screen_name': widget.runtimeType.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Отслеживание навигации
  void trackNavigation({
    required String fromScreen,
    required String toScreen,
    String? navigationMethod,
  }) {
    AnalyticsService.instance.logEvent(
      name: 'navigation',
      parameters: {
        'from_screen': fromScreen,
        'to_screen': toScreen,
        if (navigationMethod != null) 'navigation_method': navigationMethod,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Отслеживание ошибки
  void trackError({
    required String errorType,
    required String errorMessage,
    Map<String, dynamic>? additionalData,
  }) {
    AnalyticsService.instance.logError(
      errorType: errorType,
      errorMessage: errorMessage,
      screenName: widget.runtimeType.toString(),
      additionalData: additionalData,
    );
  }

  /// Отслеживание производительности
  void trackPerformance({
    required String metricName,
    required double value,
    String? unit,
  }) {
    AnalyticsService.instance.logPerformance(
      metricName: metricName,
      value: value,
      unit: unit,
    );
  }

  /// Отслеживание достижения цели
  void trackGoalAchievement({
    required String goalName,
    required String goalType,
    double? progress,
  }) {
    AnalyticsService.instance.logGoalAchievement(
      goalName: goalName,
      goalType: goalType,
      progress: progress,
    );
  }

  /// Отслеживание тренировки
  void trackWorkout({
    required String workoutType,
    required int durationMinutes,
    required int caloriesBurned,
    String? workoutName,
  }) {
    AnalyticsService.instance.logWorkout(
      workoutType: workoutType,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      workoutName: workoutName,
    );
  }

  /// Отслеживание приема пищи
  void trackMeal({
    required String mealType,
    required int calories,
    required double protein,
    required double fat,
    required double carbs,
    String? mealName,
  }) {
    AnalyticsService.instance.logMeal(
      mealType: mealType,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      mealName: mealName,
    );
  }

  /// Отслеживание поиска
  void trackSearch(String searchTerm) {
    AnalyticsService.instance.logSearch(searchTerm: searchTerm);
  }

  /// Отслеживание выбора контента
  void trackSelectContent({
    required String contentType,
    required String itemId,
  }) {
    AnalyticsService.instance.logSelectContent(
      contentType: contentType,
      itemId: itemId,
    );
  }

  /// Отслеживание входа пользователя
  void trackLogin({required String method, String? userId}) {
    AnalyticsService.instance.logLogin(method: method);
    if (userId != null) {
      AnalyticsService.instance.setUserProperty(name: 'user_id', value: userId);
    }
  }

  /// Отслеживание регистрации
  void trackSignUp({required String method, String? userId}) {
    AnalyticsService.instance.logSignUp(method: method);
    if (userId != null) {
      AnalyticsService.instance.setUserProperty(name: 'user_id', value: userId);
    }
  }

  /// Отслеживание нажатия на кнопку
  void trackButtonTap(String buttonName, {Map<String, dynamic>? parameters}) {
    trackUIInteraction(
      elementType: 'button',
      elementName: buttonName,
      action: 'tap',
      additionalData: parameters,
    );
  }

  /// Отслеживание нажатия на элемент списка
  void trackListItemTap(String listName, String itemName,
      {Map<String, dynamic>? parameters}) {
    trackUIInteraction(
      elementType: 'list_item',
      elementName: '$listName:$itemName',
      action: 'tap',
      additionalData: parameters,
    );
  }

  /// Отслеживание изменения значения
  void trackValueChange(String elementName, String oldValue, String newValue) {
    trackUIInteraction(
      elementType: 'input',
      elementName: elementName,
      action: 'value_change',
      additionalData: {
        'old_value': oldValue,
        'new_value': newValue,
      },
    );
  }

  /// Отслеживание свайпа
  void trackSwipe(String elementName, String direction) {
    trackUIInteraction(
      elementType: 'gesture',
      elementName: elementName,
      action: 'swipe',
      additionalData: {
        'direction': direction,
      },
    );
  }

  /// Отслеживание долгого нажатия
  void trackLongPress(String elementName) {
    trackUIInteraction(
      elementType: 'gesture',
      elementName: elementName,
      action: 'long_press',
    );
  }
}
