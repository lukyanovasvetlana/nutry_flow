import '../../domain/entities/notification_preferences.dart';

/// Модель для маппинга настроек уведомлений из БД
class NotificationPreferencesModel {
  final bool mealRemindersEnabled;
  final bool workoutRemindersEnabled;
  final bool goalRemindersEnabled;
  final bool generalNotificationsEnabled;
  final DateTime? mealReminderTime;
  final DateTime? workoutReminderTime;
  final DateTime? goalReminderTime;

  const NotificationPreferencesModel({
    required this.mealRemindersEnabled,
    required this.workoutRemindersEnabled,
    required this.goalRemindersEnabled,
    required this.generalNotificationsEnabled,
    this.mealReminderTime,
    this.workoutReminderTime,
    this.goalReminderTime,
  });

  /// Создает модель из entity
  factory NotificationPreferencesModel.fromEntity(
      NotificationPreferences entity) {
    return NotificationPreferencesModel(
      mealRemindersEnabled: entity.mealRemindersEnabled,
      workoutRemindersEnabled: entity.workoutRemindersEnabled,
      goalRemindersEnabled: entity.goalRemindersEnabled,
      generalNotificationsEnabled: entity.generalNotificationsEnabled,
      mealReminderTime: entity.mealReminderTime,
      workoutReminderTime: entity.workoutReminderTime,
      goalReminderTime: entity.goalReminderTime,
    );
  }

  /// Преобразует модель в entity
  NotificationPreferences toEntity() {
    return NotificationPreferences(
      mealRemindersEnabled: mealRemindersEnabled,
      workoutRemindersEnabled: workoutRemindersEnabled,
      goalRemindersEnabled: goalRemindersEnabled,
      generalNotificationsEnabled: generalNotificationsEnabled,
      mealReminderTime: mealReminderTime,
      workoutReminderTime: workoutReminderTime,
      goalReminderTime: goalReminderTime,
    );
  }

  /// Создает модель из JSON (данные из БД)
  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      mealRemindersEnabled: json['meal_reminders_enabled'] ?? true,
      workoutRemindersEnabled: json['workout_reminders_enabled'] ?? true,
      goalRemindersEnabled: json['goal_reminders_enabled'] ?? true,
      generalNotificationsEnabled:
          json['general_notifications_enabled'] ?? true,
      mealReminderTime: json['meal_reminder_time'] != null
          ? DateTime.parse(json['meal_reminder_time'])
          : null,
      workoutReminderTime: json['workout_reminder_time'] != null
          ? DateTime.parse(json['workout_reminder_time'])
          : null,
      goalReminderTime: json['goal_reminder_time'] != null
          ? DateTime.parse(json['goal_reminder_time'])
          : null,
    );
  }

  /// Преобразует модель в JSON для сохранения в БД
  Map<String, dynamic> toJson() {
    return {
      'meal_reminders_enabled': mealRemindersEnabled,
      'workout_reminders_enabled': workoutRemindersEnabled,
      'goal_reminders_enabled': goalRemindersEnabled,
      'general_notifications_enabled': generalNotificationsEnabled,
      'meal_reminder_time': mealReminderTime?.toIso8601String(),
      'workout_reminder_time': workoutReminderTime?.toIso8601String(),
      'goal_reminder_time': goalReminderTime?.toIso8601String(),
    };
  }
}
