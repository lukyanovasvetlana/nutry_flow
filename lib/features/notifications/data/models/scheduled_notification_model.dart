import '../../domain/entities/scheduled_notification.dart';

/// Модель для маппинга запланированных уведомлений из БД
class ScheduledNotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final DateTime scheduledDate;
  final String? payload;
  final bool isActive;

  const ScheduledNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.scheduledDate,
    this.payload,
    this.isActive = true,
  });

  /// Создает модель из entity
  factory ScheduledNotificationModel.fromEntity(ScheduledNotification entity) {
    return ScheduledNotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      scheduledDate: entity.scheduledDate,
      payload: entity.payload,
      isActive: entity.isActive,
    );
  }

  /// Преобразует модель в entity
  ScheduledNotification toEntity() {
    return ScheduledNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      scheduledDate: scheduledDate,
      payload: payload,
      isActive: isActive,
    );
  }

  /// Создает модель из JSON (данные из БД)
  factory ScheduledNotificationModel.fromJson(Map<String, dynamic> json) {
    return ScheduledNotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      scheduledDate: DateTime.parse(json['scheduled_date']),
      payload: json['payload'],
      isActive: json['is_active'] ?? true,
    );
  }

  /// Преобразует модель в JSON для сохранения в БД
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'scheduled_date': scheduledDate.toIso8601String(),
      'payload': payload,
      'is_active': isActive,
    };
  }
}
