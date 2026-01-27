import '../entities/notification_preferences.dart';
import '../entities/scheduled_notification.dart';

/// Интерфейс репозитория для работы с уведомлениями
abstract class NotificationRepository {
  /// Сохранение настроек уведомлений пользователя
  Future<void> saveNotificationPreferences(NotificationPreferences preferences);

  /// Получение настроек уведомлений пользователя
  Future<NotificationPreferences> getNotificationPreferences();

  /// Планирование уведомления
  Future<void> scheduleNotification(ScheduledNotification notification);

  /// Отмена уведомления
  Future<void> cancelNotification(int notificationId);

  /// Получение запланированных уведомлений
  Future<List<ScheduledNotification>> getScheduledNotifications();

  /// Отправка push-уведомления
  Future<void> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  });

  /// Планирование напоминания о еде
  Future<void> scheduleMealReminder({
    required DateTime mealTime,
    required String mealName,
    String? description,
  });

  /// Планирование напоминания о тренировке
  Future<void> scheduleWorkoutReminder({
    required DateTime workoutTime,
    required String workoutName,
    String? description,
  });

  /// Планирование напоминания о цели
  Future<void> scheduleGoalReminder({
    required DateTime reminderTime,
    required String goalName,
    String? description,
  });

  /// Отправка уведомления о достижении цели
  Future<void> sendGoalAchievementNotification({
    required String userId,
    required String goalName,
    String? achievement,
  });

  /// Отправка уведомления о пропущенной тренировке
  Future<void> sendMissedWorkoutNotification({
    required String userId,
    required String workoutName,
  });

  /// Отправка уведомления о превышении калорий
  Future<void> sendCalorieExceededNotification({
    required String userId,
    required int targetCalories,
    required int consumedCalories,
  });
}
