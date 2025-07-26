import '../../domain/entities/analytics_event.dart';

/// Модель аналитического события для работы с данными
class AnalyticsEventModel extends AnalyticsEvent {
  AnalyticsEventModel({
    required super.name,
    super.parameters = const {},
    super.timestamp,
    super.userId,
    super.sessionId,
  });

  /// Создает модель из сущности
  factory AnalyticsEventModel.fromEntity(AnalyticsEvent event) {
    return AnalyticsEventModel(
      name: event.name,
      parameters: event.parameters,
      timestamp: event.timestamp,
      userId: event.userId,
      sessionId: event.sessionId,
    );
  }

  /// Создает модель из JSON
  factory AnalyticsEventModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsEventModel(
      name: json['name'] as String,
      parameters: Map<String, dynamic>.from(json['parameters'] as Map),
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['user_id'] as String?,
      sessionId: json['session_id'] as String?,
    );
  }

  /// Преобразует модель в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parameters': parameters,
      'timestamp': timestamp.toIso8601String(),
      'user_id': userId,
      'session_id': sessionId,
    };
  }

  /// Создает копию модели с обновленными полями
  AnalyticsEventModel copyWith({
    String? name,
    Map<String, dynamic>? parameters,
    DateTime? timestamp,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEventModel(
      name: name ?? this.name,
      parameters: parameters ?? this.parameters,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalyticsEventModel &&
        other.name == name &&
        other.parameters.toString() == parameters.toString() &&
        other.timestamp == timestamp &&
        other.userId == userId &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        parameters.toString().hashCode ^
        timestamp.hashCode ^
        userId.hashCode ^
        sessionId.hashCode;
  }
} 