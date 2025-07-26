import 'analytics_event.dart';

/// Сущность аналитических данных
class AnalyticsData {
  final String userId;
  final DateTime date;
  final Map<String, dynamic> metrics;
  final List<AnalyticsEvent> events;

  const AnalyticsData({
    required this.userId,
    required this.date,
    this.metrics = const {},
    this.events = const [],
  });

  /// Создает аналитические данные для пользователя
  factory AnalyticsData.forUser({
    required String userId,
    DateTime? date,
  }) {
    return AnalyticsData(
      userId: userId,
      date: date ?? DateTime.now(),
      metrics: {},
      events: [],
    );
  }

  /// Добавляет метрику
  AnalyticsData addMetric(String key, dynamic value) {
    final updatedMetrics = Map<String, dynamic>.from(metrics);
    updatedMetrics[key] = value;
    
    return AnalyticsData(
      userId: userId,
      date: date,
      metrics: updatedMetrics,
      events: events,
    );
  }

  /// Добавляет событие
  AnalyticsData addEvent(AnalyticsEvent event) {
    return AnalyticsData(
      userId: userId,
      date: date,
      metrics: metrics,
      events: [...events, event],
    );
  }

  /// Получает метрику по ключу
  T? getMetric<T>(String key) {
    return metrics[key] as T?;
  }

  /// Получает все события определенного типа
  List<AnalyticsEvent> getEventsByType(String eventType) {
    return events.where((event) => event.name == eventType).toList();
  }

  /// Подсчитывает количество событий определенного типа
  int countEvents(String eventType) {
    return events.where((event) => event.name == eventType).length;
  }

  /// Получает общее количество калорий за день
  double getTotalCalories() {
    return getMetric<double>('total_calories') ?? 0.0;
  }

  /// Получает количество сожженных калорий за день
  int getBurnedCalories() {
    return getMetric<int>('burned_calories') ?? 0;
  }

  /// Получает количество выполненных тренировок
  int getCompletedWorkouts() {
    return countEvents('workout_completed');
  }

  /// Получает общее время тренировок в секундах
  int getTotalWorkoutTime() {
    return events
        .where((event) => event.name == 'workout_completed')
        .fold(0, (sum, event) => sum + (event.parameters['duration_seconds'] as int? ?? 0));
  }

  /// Получает количество приемов пищи
  int getMealCount() {
    return countEvents('food_added');
  }

  /// Преобразует данные в Map для сохранения
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'metrics': metrics,
      'events': events.map((event) => event.toMap()).toList(),
    };
  }

  /// Создает AnalyticsData из Map
  factory AnalyticsData.fromMap(Map<String, dynamic> map) {
    return AnalyticsData(
      userId: map['user_id'] as String,
      date: DateTime.parse(map['date'] as String),
      metrics: Map<String, dynamic>.from(map['metrics'] as Map),
      events: (map['events'] as List)
          .map((eventMap) => AnalyticsEvent(
                name: eventMap['name'] as String,
                parameters: Map<String, dynamic>.from(eventMap['parameters'] as Map),
                timestamp: DateTime.parse(eventMap['timestamp'] as String),
                userId: eventMap['user_id'] as String?,
                sessionId: eventMap['session_id'] as String?,
              ))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'AnalyticsData(userId: $userId, date: $date, metrics: $metrics, events: ${events.length})';
  }
} 