import 'package:injectable/injectable.dart';

// Data
import '../data/repositories/notification_repository_impl.dart';

// Domain
import '../domain/repositories/notification_repository.dart';
import '../domain/usecases/get_notification_preferences_usecase.dart';
import '../domain/usecases/save_notification_preferences_usecase.dart';
import '../domain/usecases/get_scheduled_notifications_usecase.dart';
import '../domain/usecases/schedule_notification_usecase.dart';
import '../domain/usecases/cancel_notification_usecase.dart';
import '../domain/usecases/schedule_meal_reminder_usecase.dart';
import '../domain/usecases/schedule_workout_reminder_usecase.dart';
import '../domain/usecases/schedule_goal_reminder_usecase.dart';
import '../domain/usecases/send_push_notification_usecase.dart';
import '../domain/usecases/send_goal_achievement_notification_usecase.dart';
import '../domain/usecases/send_missed_workout_notification_usecase.dart';
import '../domain/usecases/send_calorie_exceeded_notification_usecase.dart';

// Presentation
import '../presentation/bloc/notification_bloc.dart';

@module
abstract class NotificationModule {
  // Repository
  @lazySingleton
  NotificationRepository get notificationRepository =>
      NotificationRepositoryImpl();

  // Use Cases
  @lazySingleton
  GetNotificationPreferencesUseCase get getNotificationPreferencesUseCase =>
      GetNotificationPreferencesUseCase(notificationRepository);

  @lazySingleton
  SaveNotificationPreferencesUseCase get saveNotificationPreferencesUseCase =>
      SaveNotificationPreferencesUseCase(notificationRepository);

  @lazySingleton
  GetScheduledNotificationsUseCase get getScheduledNotificationsUseCase =>
      GetScheduledNotificationsUseCase(notificationRepository);

  @lazySingleton
  ScheduleNotificationUseCase get scheduleNotificationUseCase =>
      ScheduleNotificationUseCase(notificationRepository);

  @lazySingleton
  CancelNotificationUseCase get cancelNotificationUseCase =>
      CancelNotificationUseCase(notificationRepository);

  @lazySingleton
  ScheduleMealReminderUseCase get scheduleMealReminderUseCase =>
      ScheduleMealReminderUseCase(notificationRepository);

  @lazySingleton
  ScheduleWorkoutReminderUseCase get scheduleWorkoutReminderUseCase =>
      ScheduleWorkoutReminderUseCase(notificationRepository);

  @lazySingleton
  ScheduleGoalReminderUseCase get scheduleGoalReminderUseCase =>
      ScheduleGoalReminderUseCase(notificationRepository);

  @lazySingleton
  SendPushNotificationUseCase get sendPushNotificationUseCase =>
      SendPushNotificationUseCase(notificationRepository);

  @lazySingleton
  SendGoalAchievementNotificationUseCase
      get sendGoalAchievementNotificationUseCase =>
          SendGoalAchievementNotificationUseCase(notificationRepository);

  @lazySingleton
  SendMissedWorkoutNotificationUseCase
      get sendMissedWorkoutNotificationUseCase =>
          SendMissedWorkoutNotificationUseCase(notificationRepository);

  @lazySingleton
  SendCalorieExceededNotificationUseCase
      get sendCalorieExceededNotificationUseCase =>
          SendCalorieExceededNotificationUseCase(notificationRepository);

  // BLoC
  @lazySingleton
  NotificationBloc get notificationBloc => NotificationBloc(
        getNotificationPreferencesUseCase: getNotificationPreferencesUseCase,
        saveNotificationPreferencesUseCase: saveNotificationPreferencesUseCase,
        getScheduledNotificationsUseCase: getScheduledNotificationsUseCase,
        scheduleNotificationUseCase: scheduleNotificationUseCase,
        cancelNotificationUseCase: cancelNotificationUseCase,
        scheduleMealReminderUseCase: scheduleMealReminderUseCase,
        scheduleWorkoutReminderUseCase: scheduleWorkoutReminderUseCase,
        scheduleGoalReminderUseCase: scheduleGoalReminderUseCase,
        sendGoalAchievementNotificationUseCase:
            sendGoalAchievementNotificationUseCase,
        sendMissedWorkoutNotificationUseCase:
            sendMissedWorkoutNotificationUseCase,
        sendCalorieExceededNotificationUseCase:
            sendCalorieExceededNotificationUseCase,
      );
}
