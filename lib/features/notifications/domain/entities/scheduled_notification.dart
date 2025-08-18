import 'package:equatable/equatable.dart';

class ScheduledNotification extends Equatable {
  final int id;
  final String title;
  final String body;
  final String type;
  final DateTime scheduledDate;
  final String? payload;
  final bool isActive;

  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.scheduledDate,
    this.payload,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        scheduledDate,
        payload,
        isActive,
      ];

  ScheduledNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? type,
    DateTime? scheduledDate,
    String? payload,
    bool? isActive,
  }) {
    return ScheduledNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      payload: payload ?? this.payload,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'scheduledDate': scheduledDate.toIso8601String(),
      'payload': payload,
      'isActive': isActive,
    };
  }

  factory ScheduledNotification.fromJson(Map<String, dynamic> json) {
    return ScheduledNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      payload: json['payload'],
      isActive: json['isActive'] ?? true,
    );
  }

  /// Проверка, является ли уведомление просроченным
  bool get isExpired => DateTime.now().isAfter(scheduledDate);

  /// Проверка, является ли уведомление активным и не просроченным
  bool get isActiveAndNotExpired => isActive && !isExpired;

  /// Получение времени до уведомления
  Duration get timeUntilNotification {
    final now = DateTime.now();
    if (scheduledDate.isBefore(now)) {
      return Duration.zero;
    }
    return scheduledDate.difference(now);
  }

  /// Получение форматированного времени до уведомления
  String get formattedTimeUntilNotification {
    final duration = timeUntilNotification;
    if (duration.inDays > 0) {
      return '${duration.inDays} дн. ${duration.inHours % 24} ч.';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ч. ${duration.inMinutes % 60} мин.';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} мин.';
    } else {
      return 'Сейчас';
    }
  }

  /// Получение типа уведомления на русском языке
  String get typeDisplayName {
    switch (type) {
      case 'meal_reminder':
        return 'Напоминание о еде';
      case 'workout_reminder':
        return 'Напоминание о тренировке';
      case 'goal_reminder':
        return 'Напоминание о цели';
      case 'goal_achievement':
        return 'Достижение цели';
      case 'missed_workout':
        return 'Пропущенная тренировка';
      case 'calorie_exceeded':
        return 'Превышение калорий';
      default:
        return 'Уведомление';
    }
  }

  /// Получение иконки для типа уведомления
  String get typeIcon {
    switch (type) {
      case 'meal_reminder':
        return '🍽️';
      case 'workout_reminder':
        return '💪';
      case 'goal_reminder':
        return '🎯';
      case 'goal_achievement':
        return '🎉';
      case 'missed_workout':
        return '⏰';
      case 'calorie_exceeded':
        return '⚠️';
      default:
        return '🔔';
    }
  }

  /// Проверка, является ли уведомление срочным (менее часа)
  bool get isUrgent => timeUntilNotification.inHours < 1;

  /// Проверка, является ли уведомление сегодняшним
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduledDay =
        DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    return today.isAtSameMomentAs(scheduledDay);
  }

  /// Проверка, является ли уведомление завтрашним
  bool get isTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final scheduledDay =
        DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    return tomorrow.isAtSameMomentAs(scheduledDay);
  }

  /// Получение относительного времени
  String get relativeTime {
    if (isExpired) {
      return 'Просрочено';
    } else if (isToday) {
      return 'Сегодня в ${scheduledDate.hour.toString().padLeft(2, '0')}:${scheduledDate.minute.toString().padLeft(2, '0')}';
    } else if (isTomorrow) {
      return 'Завтра в ${scheduledDate.hour.toString().padLeft(2, '0')}:${scheduledDate.minute.toString().padLeft(2, '0')}';
    } else {
      return '${scheduledDate.day.toString().padLeft(2, '0')}.${scheduledDate.month.toString().padLeft(2, '0')} в ${scheduledDate.hour.toString().padLeft(2, '0')}:${scheduledDate.minute.toString().padLeft(2, '0')}';
    }
  }
}
