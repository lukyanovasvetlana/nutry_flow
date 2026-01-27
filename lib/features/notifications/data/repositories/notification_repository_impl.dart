import 'package:injectable/injectable.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/notification_service.dart';
import 'package:nutry_flow/features/notifications/domain/entities/notification_preferences.dart';
import 'package:nutry_flow/features/notifications/domain/entities/scheduled_notification.dart';
import 'package:nutry_flow/features/notifications/domain/repositories/notification_repository.dart';
import 'package:nutry_flow/features/notifications/data/models/notification_preferences_model.dart';
import 'package:nutry_flow/features/notifications/data/models/scheduled_notification_model.dart';
import 'dart:developer' as developer;
import 'dart:convert';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final NotificationService _notificationService = NotificationService.instance;

  @override
  Future<void> saveNotificationPreferences(
      NotificationPreferences preferences) async {
    try {
      developer.log(
          '🔔 NotificationRepository: Saving notification preferences',
          name: 'NotificationRepository');

      if (_supabaseService.isAvailable) {
        final user = _supabaseService.currentUser;
        if (user != null) {
          final model = NotificationPreferencesModel.fromEntity(preferences);
          await _supabaseService.saveUserData(
              'user_notification_preferences', model.toJson());
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

  @override
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
            return NotificationPreferencesModel.fromJson(data.first).toEntity();
          }
        }
      } else {
        developer.log(
            '🔔 NotificationRepository: Supabase not available, using default preferences',
            name: 'NotificationRepository');
      }

      // Возвращаем настройки по умолчанию
      return NotificationPreferences.defaultPreferences();
    } catch (e) {
      developer.log('🔔 NotificationRepository: Failed to get preferences: $e',
          name: 'NotificationRepository');
      // Возвращаем настройки по умолчанию в случае ошибки
      return NotificationPreferences.defaultPreferences();
    }
  }

  @override
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
          final model = ScheduledNotificationModel.fromEntity(notification);
          await _supabaseService.saveUserData(
              'scheduled_notifications', model.toJson());
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

  @override
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

  @override
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
              .map((item) =>
                  ScheduledNotificationModel.fromJson(item).toEntity())
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

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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
