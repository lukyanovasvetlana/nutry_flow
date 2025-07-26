/// Сущность аналитического события
class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;
  final String? userId;
  final String? sessionId;

  AnalyticsEvent({
    required this.name,
    this.parameters = const {},
    DateTime? timestamp,
    this.userId,
    this.sessionId,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Создает событие входа пользователя
  factory AnalyticsEvent.login({
    required String method,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      name: 'user_login',
      parameters: {
        'method': method,
        'success': true,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Создает событие регистрации пользователя
  factory AnalyticsEvent.signUp({
    required String method,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      name: 'user_signup',
      parameters: {
        'method': method,
        'success': true,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Создает событие просмотра экрана
  factory AnalyticsEvent.screenView({
    required String screenName,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      name: 'screen_view',
      parameters: {
        'screen_name': screenName,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Создает событие добавления еды
  factory AnalyticsEvent.foodAdded({
    required String foodName,
    required double calories,
    required String mealType,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      name: 'food_added',
      parameters: {
        'food_name': foodName,
        'calories': calories,
        'meal_type': mealType,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Создает событие завершения тренировки
  factory AnalyticsEvent.workoutCompleted({
    required String workoutName,
    required int duration,
    required int caloriesBurned,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      name: 'workout_completed',
      parameters: {
        'workout_name': workoutName,
        'duration_seconds': duration,
        'calories_burned': caloriesBurned,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Создает событие установки цели
  factory AnalyticsEvent.goalSet({
    required String goalType,
    required String targetValue,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      name: 'goal_set',
      parameters: {
        'goal_type': goalType,
        'target_value': targetValue,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Создает событие достижения цели
  factory AnalyticsEvent.goalAchieved({
    required String goalType,
    required String achievedValue,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      name: 'goal_achieved',
      parameters: {
        'goal_type': goalType,
        'achieved_value': achievedValue,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Создает событие ошибки
  factory AnalyticsEvent.error({
    required String errorType,
    required String errorMessage,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      name: 'error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Преобразует событие в Map для отправки
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'parameters': parameters,
      'timestamp': timestamp.toIso8601String(),
      'user_id': userId,
      'session_id': sessionId,
    };
  }

  @override
  String toString() {
    return 'AnalyticsEvent(name: $name, parameters: $parameters, timestamp: $timestamp)';
  }
} 