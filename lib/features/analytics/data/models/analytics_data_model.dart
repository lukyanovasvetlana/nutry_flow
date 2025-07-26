import '../../domain/entities/analytics_data.dart';
import '../../domain/entities/analytics_event.dart';
import 'analytics_event_model.dart';

/// Модель аналитических данных для работы с данными
class AnalyticsDataModel extends AnalyticsData {
  const AnalyticsDataModel({
    required super.userId,
    required super.date,
    super.metrics = const {},
    super.events = const [],
  });

  /// Создает модель из сущности
  factory AnalyticsDataModel.fromEntity(AnalyticsData data) {
    return AnalyticsDataModel(
      userId: data.userId,
      date: data.date,
      metrics: data.metrics,
      events: data.events,
    );
  }

  /// Создает модель из JSON
  factory AnalyticsDataModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsDataModel(
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      metrics: Map<String, dynamic>.from(json['metrics'] as Map),
      events: (json['events'] as List)
          .map((eventJson) => AnalyticsEventModel.fromJson(eventJson as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Преобразует модель в JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'metrics': metrics,
      'events': events.map((event) => (event as AnalyticsEventModel).toJson()).toList(),
    };
  }

  /// Создает копию модели с обновленными полями
  AnalyticsDataModel copyWith({
    String? userId,
    DateTime? date,
    Map<String, dynamic>? metrics,
    List<AnalyticsEvent>? events,
  }) {
    return AnalyticsDataModel(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      metrics: metrics ?? this.metrics,
      events: events ?? this.events,
    );
  }

  /// Добавляет метрику и возвращает новую модель
  @override
  AnalyticsDataModel addMetric(String key, dynamic value) {
    final updatedMetrics = Map<String, dynamic>.from(metrics);
    updatedMetrics[key] = value;
    
    return AnalyticsDataModel(
      userId: userId,
      date: date,
      metrics: updatedMetrics,
      events: events,
    );
  }

  /// Добавляет событие и возвращает новую модель
  @override
  AnalyticsDataModel addEvent(AnalyticsEvent event) {
    return AnalyticsDataModel(
      userId: userId,
      date: date,
      metrics: metrics,
      events: [...events, event],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalyticsDataModel &&
        other.userId == userId &&
        other.date == date &&
        other.metrics.toString() == metrics.toString() &&
        other.events.length == events.length;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        date.hashCode ^
        metrics.toString().hashCode ^
        events.length.hashCode;
  }
} 