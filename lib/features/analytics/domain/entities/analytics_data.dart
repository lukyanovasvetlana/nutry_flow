import 'analytics_event.dart';
import 'nutrition_tracking.dart';
import 'weight_tracking.dart';
import 'activity_tracking.dart';

/// Сущность аналитических данных
class AnalyticsData {
  final String userId;
  final DateTime date;
  final Map<String, dynamic> metrics;
  final List<AnalyticsEvent> events;
  final List<NutritionTracking> nutritionTracking;
  final List<WeightTracking> weightTracking;
  final List<ActivityTracking> activityTracking;
  final String period; // day, week, month, year

  const AnalyticsData({
    required this.userId,
    required this.date,
    this.metrics = const {},
    this.events = const [],
    this.nutritionTracking = const [],
    this.weightTracking = const [],
    this.activityTracking = const [],
    this.period = 'day',
  });

  /// Создает аналитические данные для пользователя
  factory AnalyticsData.forUser({
    required String userId,
    DateTime? date,
    String period = 'day',
  }) {
    return AnalyticsData(
      userId: userId,
      date: date ?? DateTime.now(),
      metrics: {},
      events: [],
      nutritionTracking: [],
      weightTracking: [],
      activityTracking: [],
      period: period,
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
      nutritionTracking: nutritionTracking,
      weightTracking: weightTracking,
      activityTracking: activityTracking,
      period: period,
    );
  }

  /// Добавляет событие
  AnalyticsData addEvent(AnalyticsEvent event) {
    return AnalyticsData(
      userId: userId,
      date: date,
      metrics: metrics,
      events: [...events, event],
      nutritionTracking: nutritionTracking,
      weightTracking: weightTracking,
      activityTracking: activityTracking,
      period: period,
    );
  }

  /// Добавляет данные отслеживания питания
  AnalyticsData addNutritionTracking(NutritionTracking tracking) {
    return AnalyticsData(
      userId: userId,
      date: date,
      metrics: metrics,
      events: events,
      nutritionTracking: [...nutritionTracking, tracking],
      weightTracking: weightTracking,
      activityTracking: activityTracking,
      period: period,
    );
  }

  /// Добавляет данные отслеживания веса
  AnalyticsData addWeightTracking(WeightTracking tracking) {
    return AnalyticsData(
      userId: userId,
      date: date,
      metrics: metrics,
      events: events,
      nutritionTracking: nutritionTracking,
      weightTracking: [...weightTracking, tracking],
      activityTracking: activityTracking,
      period: period,
    );
  }

  /// Добавляет данные отслеживания активности
  AnalyticsData addActivityTracking(ActivityTracking tracking) {
    return AnalyticsData(
      userId: userId,
      date: date,
      metrics: metrics,
      events: events,
      nutritionTracking: nutritionTracking,
      weightTracking: weightTracking,
      activityTracking: [...activityTracking, tracking],
      period: period,
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
    if (nutritionTracking.isNotEmpty) {
      return nutritionTracking
          .map((n) => n.caloriesConsumed)
          .reduce((a, b) => a + b);
    }
    return getMetric<double>('total_calories') ?? 0.0;
  }

  /// Получает количество сожженных калорий за день
  double getBurnedCalories() {
    if (activityTracking.isNotEmpty) {
      return activityTracking
          .map((a) => a.caloriesBurned)
          .reduce((a, b) => a + b);
    }
    return getMetric<double>('burned_calories') ?? 0.0;
  }

  /// Получает количество выполненных тренировок
  int getCompletedWorkouts() {
    return activityTracking.where((a) => a.workoutDuration > 0).length;
  }

  /// Получает общее время тренировок в минутах
  int getTotalWorkoutTime() {
    return activityTracking
        .where((a) => a.workoutDuration > 0)
        .fold(0, (sum, a) => sum + a.workoutDuration);
  }

  /// Получает количество приемов пищи
  int getMealCount() {
    return nutritionTracking.length;
  }

  /// Получает общее количество шагов
  int getTotalSteps() {
    return activityTracking
        .map((a) => a.stepsCount)
        .reduce((a, b) => a + b);
  }

  /// Получает средний вес
  double? getAverageWeight() {
    if (weightTracking.isNotEmpty) {
      final totalWeight = weightTracking
          .map((w) => w.weight)
          .reduce((a, b) => a + b);
      return totalWeight / weightTracking.length;
    }
    return null;
  }

  /// Преобразует данные в Map для сохранения
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'metrics': metrics,
      'events': events.map((event) => event.toMap()).toList(),
      'nutrition_tracking': nutritionTracking.map((n) => n.toJson()).toList(),
      'weight_tracking': weightTracking.map((w) => w.toJson()).toList(),
      'activity_tracking': activityTracking.map((a) => a.toJson()).toList(),
      'period': period,
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
      nutritionTracking: (map['nutrition_tracking'] as List?)
          ?.map((n) => NutritionTracking.fromJson(n as Map<String, dynamic>))
          .toList() ?? [],
      weightTracking: (map['weight_tracking'] as List?)
          ?.map((w) => WeightTracking.fromJson(w as Map<String, dynamic>))
          .toList() ?? [],
      activityTracking: (map['activity_tracking'] as List?)
          ?.map((a) => ActivityTracking.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
      period: map['period'] as String? ?? 'day',
    );
  }

  @override
  String toString() {
    return 'AnalyticsData(userId: $userId, date: $date, metrics: $metrics, events: ${events.length}, nutrition: ${nutritionTracking.length}, weight: ${weightTracking.length}, activity: ${activityTracking.length})';
  }
} 