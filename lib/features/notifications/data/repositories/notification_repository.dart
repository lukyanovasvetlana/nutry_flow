import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/notification_service.dart';
import 'package:nutry_flow/features/notifications/domain/entities/notification_preferences.dart';
import 'package:nutry_flow/features/notifications/domain/entities/scheduled_notification.dart';
import 'dart:developer' as developer;
import 'dart:convert';

class NotificationRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final NotificationService _notificationService = NotificationService.instance;

  /// Сохранение настроек уведомлений пользователя
  Future<void> saveNotificationPreferences(
      NotificationPreferences preferences) async {
    try {
      developer.log(
          '🔔 NotificationRepository: Saving notification preferences',
          name: 'NotificationRepository');

      if (_supabaseService.isAvailable) {
        final user = _supabaseService.currentUser;
        if (user != null) {
          await _supabaseService.saveUserData('user_notification_preferences', {
            'user_id': user.id,
            'meal_reminders_enabled': preferences.mealRemindersEnabled,
            'workout_reminders_enabled': preferences.workoutRemindersEnabled,
            'goal_reminders_enabled': preferences.goalRemindersEnabled,
            'general_notifications_enabled':
                preferences.generalNotificationsEnabled,
            'meal_reminder_time':
                preferences.mealReminderTime?.toIso8601String(),
            'workout_reminder_time':
                preferences.workoutReminderTime?.toIso8601String(),
            'goal_reminder_time':
                preferences.goalReminderTime?.toIso8601String(),
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });
          developer.log(
              '🔔 NotificationRepository: Preferences saved to Supabase',
              name: 'NotificationRepository');
        }
      } else {
        developer.log(
            '🔔 NotificationRepository: Supabase not available, using local storage',
            name: 'NotificationRepository');
        // TODO: Implement local storage fallback
      }
    } catch (e) {
      developer.log('🔔 NotificationRepository: Failed to save preferences: $e',
          name: 'NotificationRepository');
      rethrow;
    }
  }

  /// Получение настроек уведомлений пользователя
  Future<NotificationPreferences> getNotificationPreferences() async {
    try {
      developer.log(
          '🔔 NotificationRepository: Getting notification preferences',
          name: 'NotificationRepository');

      if (_supabaseService.isAvailable) {
        final user = _supabaseService.currentUser;
        if (user != null) {
          final data = await _supabaseService
              .getUserData('user_notification_preferences', userId: user.id);

          if (data.isNotEmpty) {
            final preferences = data.first;
            return NotificationPreferences(
              mealRemindersEnabled:
                  preferences['meal_reminders_enabled'] ?? true,
              workoutRemindersEnabled:
                  preferences['workout_reminders_enabled'] ?? true,
              goalRemindersEnabled:
                  preferences['goal_reminders_enabled'] ?? true,
              generalNotificationsEnabled:
                  preferences['general_notifications_enabled'] ?? true,
              mealReminderTime: preferences['meal_reminder_time'] != null
                  ? DateTime.parse(preferences['meal_reminder_time'])
                  : null,
              workoutReminderTime: preferences['workout_reminder_time'] != null
                  ? DateTime.parse(preferences['workout_reminder_time'])
                  : null,
              goalReminderTime: preferences['goal_reminder_time'] != null
                  ? DateTime.parse(preferences['goal_reminder_time'])
                  : null,
            );
          }
        }
      } else {
        developer.log(
            '🔔 NotificationRepository: Supabase not available, using default preferences',
            name: 'NotificationRepository');
      }

      // Возвращаем настройки по умолчанию
      return NotificationPreferences(
        mealRemindersEnabled: true,
        workoutRemindersEnabled: true,
        goalRemindersEnabled: true,
        generalNotificationsEnabled: true,
        mealReminderTime: DateTime.now().add(const Duration(hours: 1)),
        workoutReminderTime: DateTime.now().add(const Duration(hours: 2)),
        goalReminderTime: DateTime.now().add(const Duration(days: 1)),
      );
    } catch (e) {
      developer.log('🔔 NotificationRepository: Failed to get preferences: $e',
          name: 'NotificationRepository');
      // Возвращаем настройки по умолчанию в случае ошибки
      return NotificationPreferences(
        mealRemindersEnabled: true,
        workoutRemindersEnabled: true,
        goalRemindersEnabled: true,
        generalNotificationsEnabled: true,
        mealReminderTime: DateTime.now().add(const Duration(hours: 1)),
        workoutReminderTime: DateTime.now().add(const Duration(hours: 2)),
        goalReminderTime: DateTime.now().add(const Duration(days: 1)),
      );
    }
  }

  /// Планирование уведомления
  Future<void> scheduleNotification(ScheduledNotification notification) async {
    try {
      developer.log('🔔 NotificationRepository: Scheduling notification',
          name: 'NotificationRepository');

      // Планируем локальное уведомление
      await _notificationService.scheduleLocalNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        scheduledDate: notification.scheduledDate,
        payload: notification.payload,
        channelId: _getChannelId(notification.type),
      );

      // Сохраняем в Supabase
      if (_supabaseService.isAvailable) {
        final user = _supabaseService.currentUser;
        if (user != null) {
          await _supabaseService.saveUserData('scheduled_notifications', {
            'id': notification.id,
            'user_id': user.id,
            'title': notification.title,
            'body': notification.body,
            'type': notification.type,
            'scheduled_date': notification.scheduledDate.toIso8601String(),
            'payload': notification.payload,
            'is_active': true,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });
          developer.log(
              '🔔 NotificationRepository: Notification saved to Supabase',
              name: 'NotificationRepository');
        }
      }
    } catch (e) {
      developer.log(
          '🔔 NotificationRepository: Failed to schedule notification: $e',
          name: 'NotificationRepository');
      rethrow;
    }
  }

  /// Отмена уведомления
  Future<void> cancelNotification(int notificationId) async {
    try {
      developer.log(
          '🔔 NotificationRepository: Cancelling notification: $notificationId',
          name: 'NotificationRepository');

      // Отменяем локальное уведомление
      await _notificationService.cancelLocalNotification(notificationId);

      // Удаляем из Supabase
      if (_supabaseService.isAvailable) {
        await _supabaseService.deleteUserData(
            'scheduled_notifications', notificationId.toString());
        developer.log(
            '🔔 NotificationRepository: Notification cancelled in Supabase',
            name: 'NotificationRepository');
      }
    } catch (e) {
      developer.log(
          '🔔 NotificationRepository: Failed to cancel notification: $e',
          name: 'NotificationRepository');
      rethrow;
    }
  }

  /// Получение запланированных уведомлений
  Future<List<ScheduledNotification>> getScheduledNotifications() async {
    try {
      developer.log(
          '🔔 NotificationRepository: Getting scheduled notifications',
          name: 'NotificationRepository');

      if (_supabaseService.isAvailable) {
        final user = _supabaseService.currentUser;
        if (user != null) {
          final data = await _supabaseService
              .getUserData('scheduled_notifications', userId: user.id);

          return data
              .map((item) => ScheduledNotification(
                    id: item['id'],
                    title: item['title'],
                    body: item['body'],
                    type: item['type'],
                    scheduledDate: DateTime.parse(item['scheduled_date']),
                    payload: item['payload'],
                    isActive: item['is_active'] ?? true,
                  ))
              .toList();
        }
      }

      return [];
    } catch (e) {
      developer.log(
          '🔔 NotificationRepository: Failed to get scheduled notifications: $e',
          name: 'NotificationRepository');
      return [];
    }
  }

  /// Отправка push-уведомления через Supabase
  Future<void> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      developer.log('🔔 NotificationRepository: Sending push notification',
          name: 'NotificationRepository');

      if (_supabaseService.isAvailable) {
        // Получаем FCM токены пользователя
        final tokens = await _getUserFCMTokens(userId);

        if (tokens.isNotEmpty) {
          // Отправляем уведомление через Supabase Edge Functions
          final client = _supabaseService.client;
          if (client != null) {
            await client.functions.invoke('send-push-notification', body: {
              'tokens': tokens,
              'title': title,
              'body': body,
              'data': {
                'type': type,
                ...?data,
              },
            });
          }

          developer.log(
              '🔔 NotificationRepository: Push notification sent successfully',
              name: 'NotificationRepository');
        } else {
          developer.log(
              '🔔 NotificationRepository: No FCM tokens found for user',
              name: 'NotificationRepository');
        }
      }
    } catch (e) {
      developer.log(
          '🔔 NotificationRepository: Failed to send push notification: $e',
          name: 'NotificationRepository');
      rethrow;
    }
  }

  /// Получение FCM токенов пользователя
  Future<List<String>> _getUserFCMTokens(String userId) async {
    try {
      final data =
          await _supabaseService.getUserData('user_fcm_tokens', userId: userId);
      return data.map((item) => item['token'] as String).toList();
    } catch (e) {
      developer.log('🔔 NotificationRepository: Failed to get FCM tokens: $e',
          name: 'NotificationRepository');
      return [];
    }
  }

  /// Получение ID канала для типа уведомления
  String _getChannelId(String type) {
    switch (type) {
      case 'meal_reminder':
        return 'meal_reminder_channel';
      case 'workout_reminder':
        return 'workout_reminder_channel';
      case 'goal_achievement':
        return 'goal_reminder_channel';
      default:
        return 'general_notifications';
    }
  }

  /// Планирование напоминания о еде
  Future<void> scheduleMealReminder({
    required DateTime mealTime,
    required String mealName,
    String? description,
  }) async {
    final notification = ScheduledNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Время приема пищи',
      body: 'Не забудьте про $mealName',
      type: 'meal_reminder',
      scheduledDate: mealTime,
      payload: json.encode({
        'type': 'meal_reminder',
        'meal_name': mealName,
        'description': description,
      }),
    );

    await scheduleNotification(notification);
  }

  /// Планирование напоминания о тренировке
  Future<void> scheduleWorkoutReminder({
    required DateTime workoutTime,
    required String workoutName,
    String? description,
  }) async {
    final notification = ScheduledNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Время тренировки',
      body: 'Запланирована тренировка: $workoutName',
      type: 'workout_reminder',
      scheduledDate: workoutTime,
      payload: json.encode({
        'type': 'workout_reminder',
        'workout_name': workoutName,
        'description': description,
      }),
    );

    await scheduleNotification(notification);
  }

  /// Планирование напоминания о цели
  Future<void> scheduleGoalReminder({
    required DateTime reminderTime,
    required String goalName,
    String? description,
  }) async {
    final notification = ScheduledNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Напоминание о цели',
      body: 'Не забывайте про цель: $goalName',
      type: 'goal_reminder',
      scheduledDate: reminderTime,
      payload: json.encode({
        'type': 'goal_reminder',
        'goal_name': goalName,
        'description': description,
      }),
    );

    await scheduleNotification(notification);
  }

  /// Отправка уведомления о достижении цели
  Future<void> sendGoalAchievementNotification({
    required String userId,
    required String goalName,
    String? achievement,
  }) async {
    await sendPushNotification(
      userId: userId,
      title: 'Цель достигнута! 🎉',
      body: 'Поздравляем! Вы достигли цели: $goalName',
      type: 'goal_achievement',
      data: {
        'goal_name': goalName,
        'achievement': achievement,
      },
    );
  }

  /// Отправка уведомления о пропущенной тренировке
  Future<void> sendMissedWorkoutNotification({
    required String userId,
    required String workoutName,
  }) async {
    await sendPushNotification(
      userId: userId,
      title: 'Пропущена тренировка',
      body: 'Вы пропустили тренировку: $workoutName',
      type: 'missed_workout',
      data: {
        'workout_name': workoutName,
      },
    );
  }

  /// Отправка уведомления о превышении калорий
  Future<void> sendCalorieExceededNotification({
    required String userId,
    required int targetCalories,
    required int consumedCalories,
  }) async {
    await sendPushNotification(
      userId: userId,
      title: 'Превышение калорий',
      body:
          'Вы превысили дневную норму калорий на ${consumedCalories - targetCalories} ккал',
      type: 'calorie_exceeded',
      data: {
        'target_calories': targetCalories,
        'consumed_calories': consumedCalories,
      },
    );
  }
}
