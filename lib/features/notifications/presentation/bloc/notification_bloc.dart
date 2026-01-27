import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutry_flow/features/notifications/domain/entities/notification_preferences.dart';
import 'package:nutry_flow/features/notifications/domain/entities/scheduled_notification.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/get_notification_preferences_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/save_notification_preferences_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/get_scheduled_notifications_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/schedule_notification_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/cancel_notification_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/schedule_meal_reminder_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/schedule_workout_reminder_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/schedule_goal_reminder_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/send_goal_achievement_notification_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/send_missed_workout_notification_usecase.dart';
import 'package:nutry_flow/features/notifications/domain/usecases/send_calorie_exceeded_notification_usecase.dart';
import 'dart:developer' as developer;

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationPreferences extends NotificationEvent {
  const LoadNotificationPreferences();
}

class SaveNotificationPreferences extends NotificationEvent {
  final NotificationPreferences preferences;

  const SaveNotificationPreferences(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class LoadScheduledNotifications extends NotificationEvent {
  const LoadScheduledNotifications();
}

class ScheduleNotification extends NotificationEvent {
  final ScheduledNotification notification;

  const ScheduleNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

class CancelNotification extends NotificationEvent {
  final int notificationId;

  const CancelNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class ScheduleMealReminder extends NotificationEvent {
  final DateTime mealTime;
  final String mealName;
  final String? description;

  const ScheduleMealReminder({
    required this.mealTime,
    required this.mealName,
    this.description,
  });

  @override
  List<Object?> get props => [mealTime, mealName, description];
}

class ScheduleWorkoutReminder extends NotificationEvent {
  final DateTime workoutTime;
  final String workoutName;
  final String? description;

  const ScheduleWorkoutReminder({
    required this.workoutTime,
    required this.workoutName,
    this.description,
  });

  @override
  List<Object?> get props => [workoutTime, workoutName, description];
}

class ScheduleGoalReminder extends NotificationEvent {
  final DateTime reminderTime;
  final String goalName;
  final String? description;

  const ScheduleGoalReminder({
    required this.reminderTime,
    required this.goalName,
    this.description,
  });

  @override
  List<Object?> get props => [reminderTime, goalName, description];
}

class SendGoalAchievementNotification extends NotificationEvent {
  final String userId;
  final String goalName;
  final String? achievement;

  const SendGoalAchievementNotification({
    required this.userId,
    required this.goalName,
    this.achievement,
  });

  @override
  List<Object?> get props => [userId, goalName, achievement];
}

class SendMissedWorkoutNotification extends NotificationEvent {
  final String userId;
  final String workoutName;

  const SendMissedWorkoutNotification({
    required this.userId,
    required this.workoutName,
  });

  @override
  List<Object?> get props => [userId, workoutName];
}

class SendCalorieExceededNotification extends NotificationEvent {
  final String userId;
  final int targetCalories;
  final int consumedCalories;

  const SendCalorieExceededNotification({
    required this.userId,
    required this.targetCalories,
    required this.consumedCalories,
  });

  @override
  List<Object?> get props => [userId, targetCalories, consumedCalories];
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationPreferencesLoaded extends NotificationState {
  final NotificationPreferences preferences;

  const NotificationPreferencesLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class ScheduledNotificationsLoaded extends NotificationState {
  final List<ScheduledNotification> notifications;

  const ScheduledNotificationsLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationSuccess extends NotificationState {
  final String message;

  const NotificationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationPreferencesUseCase _getNotificationPreferencesUseCase;
  final SaveNotificationPreferencesUseCase _saveNotificationPreferencesUseCase;
  final GetScheduledNotificationsUseCase _getScheduledNotificationsUseCase;
  final ScheduleNotificationUseCase _scheduleNotificationUseCase;
  final CancelNotificationUseCase _cancelNotificationUseCase;
  final ScheduleMealReminderUseCase _scheduleMealReminderUseCase;
  final ScheduleWorkoutReminderUseCase _scheduleWorkoutReminderUseCase;
  final ScheduleGoalReminderUseCase _scheduleGoalReminderUseCase;
  final SendGoalAchievementNotificationUseCase
      _sendGoalAchievementNotificationUseCase;
  final SendMissedWorkoutNotificationUseCase
      _sendMissedWorkoutNotificationUseCase;
  final SendCalorieExceededNotificationUseCase
      _sendCalorieExceededNotificationUseCase;

  NotificationBloc({
    required GetNotificationPreferencesUseCase
        getNotificationPreferencesUseCase,
    required SaveNotificationPreferencesUseCase
        saveNotificationPreferencesUseCase,
    required GetScheduledNotificationsUseCase getScheduledNotificationsUseCase,
    required ScheduleNotificationUseCase scheduleNotificationUseCase,
    required CancelNotificationUseCase cancelNotificationUseCase,
    required ScheduleMealReminderUseCase scheduleMealReminderUseCase,
    required ScheduleWorkoutReminderUseCase scheduleWorkoutReminderUseCase,
    required ScheduleGoalReminderUseCase scheduleGoalReminderUseCase,
    required SendGoalAchievementNotificationUseCase
        sendGoalAchievementNotificationUseCase,
    required SendMissedWorkoutNotificationUseCase
        sendMissedWorkoutNotificationUseCase,
    required SendCalorieExceededNotificationUseCase
        sendCalorieExceededNotificationUseCase,
  })  : _getNotificationPreferencesUseCase = getNotificationPreferencesUseCase,
        _saveNotificationPreferencesUseCase =
            saveNotificationPreferencesUseCase,
        _getScheduledNotificationsUseCase = getScheduledNotificationsUseCase,
        _scheduleNotificationUseCase = scheduleNotificationUseCase,
        _cancelNotificationUseCase = cancelNotificationUseCase,
        _scheduleMealReminderUseCase = scheduleMealReminderUseCase,
        _scheduleWorkoutReminderUseCase = scheduleWorkoutReminderUseCase,
        _scheduleGoalReminderUseCase = scheduleGoalReminderUseCase,
        _sendGoalAchievementNotificationUseCase =
            sendGoalAchievementNotificationUseCase,
        _sendMissedWorkoutNotificationUseCase =
            sendMissedWorkoutNotificationUseCase,
        _sendCalorieExceededNotificationUseCase =
            sendCalorieExceededNotificationUseCase,
        super(NotificationInitial()) {
    on<LoadNotificationPreferences>(_onLoadNotificationPreferences);
    on<SaveNotificationPreferences>(_onSaveNotificationPreferences);
    on<LoadScheduledNotifications>(_onLoadScheduledNotifications);
    on<ScheduleNotification>(_onScheduleNotification);
    on<CancelNotification>(_onCancelNotification);
    on<ScheduleMealReminder>(_onScheduleMealReminder);
    on<ScheduleWorkoutReminder>(_onScheduleWorkoutReminder);
    on<ScheduleGoalReminder>(_onScheduleGoalReminder);
    on<SendGoalAchievementNotification>(_onSendGoalAchievementNotification);
    on<SendMissedWorkoutNotification>(_onSendMissedWorkoutNotification);
    on<SendCalorieExceededNotification>(_onSendCalorieExceededNotification);
  }

  Future<void> _onLoadNotificationPreferences(
    LoadNotificationPreferences event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log('🔔 NotificationBloc: Loading notification preferences',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      final preferences = await _getNotificationPreferencesUseCase();

      emit(NotificationPreferencesLoaded(preferences));
      developer.log(
          '🔔 NotificationBloc: Notification preferences loaded successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log(
          '🔔 NotificationBloc: Failed to load notification preferences: $e',
          name: 'NotificationBloc');
      emit(NotificationError('Не удалось загрузить настройки уведомлений: $e'));
    }
  }

  Future<void> _onSaveNotificationPreferences(
    SaveNotificationPreferences event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log('🔔 NotificationBloc: Saving notification preferences',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _saveNotificationPreferencesUseCase(event.preferences);

      emit(NotificationSuccess('Настройки уведомлений сохранены успешно'));
      developer.log(
          '🔔 NotificationBloc: Notification preferences saved successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log(
          '🔔 NotificationBloc: Failed to save notification preferences: $e',
          name: 'NotificationBloc');
      emit(NotificationError('Не удалось сохранить настройки уведомлений: $e'));
    }
  }

  Future<void> _onLoadScheduledNotifications(
    LoadScheduledNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log('🔔 NotificationBloc: Loading scheduled notifications',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      final notifications = await _getScheduledNotificationsUseCase();

      emit(ScheduledNotificationsLoaded(notifications));
      developer.log(
          '🔔 NotificationBloc: Scheduled notifications loaded successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log(
          '🔔 NotificationBloc: Failed to load scheduled notifications: $e',
          name: 'NotificationBloc');
      emit(NotificationError(
          'Не удалось загрузить запланированные уведомления: $e'));
    }
  }

  Future<void> _onScheduleNotification(
    ScheduleNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log('🔔 NotificationBloc: Scheduling notification',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _scheduleNotificationUseCase(event.notification);

      emit(NotificationSuccess('Уведомление запланировано успешно'));
      developer.log('🔔 NotificationBloc: Notification scheduled successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log('🔔 NotificationBloc: Failed to schedule notification: $e',
          name: 'NotificationBloc');
      emit(NotificationError('Не удалось запланировать уведомление: $e'));
    }
  }

  Future<void> _onCancelNotification(
    CancelNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log(
          '🔔 NotificationBloc: Cancelling notification: ${event.notificationId}',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _cancelNotificationUseCase(event.notificationId);

      emit(NotificationSuccess('Уведомление отменено успешно'));
      developer.log('🔔 NotificationBloc: Notification cancelled successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log('🔔 NotificationBloc: Failed to cancel notification: $e',
          name: 'NotificationBloc');
      emit(NotificationError('Не удалось отменить уведомление: $e'));
    }
  }

  Future<void> _onScheduleMealReminder(
    ScheduleMealReminder event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log('🔔 NotificationBloc: Scheduling meal reminder',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _scheduleMealReminderUseCase(
        mealTime: event.mealTime,
        mealName: event.mealName,
        description: event.description,
      );

      emit(NotificationSuccess('Напоминание о еде запланировано успешно'));
      developer.log('🔔 NotificationBloc: Meal reminder scheduled successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log('🔔 NotificationBloc: Failed to schedule meal reminder: $e',
          name: 'NotificationBloc');
      emit(NotificationError('Не удалось запланировать напоминание о еде: $e'));
    }
  }

  Future<void> _onScheduleWorkoutReminder(
    ScheduleWorkoutReminder event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log('🔔 NotificationBloc: Scheduling workout reminder',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _scheduleWorkoutReminderUseCase(
        workoutTime: event.workoutTime,
        workoutName: event.workoutName,
        description: event.description,
      );

      emit(NotificationSuccess(
          'Напоминание о тренировке запланировано успешно'));
      developer.log(
          '🔔 NotificationBloc: Workout reminder scheduled successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log(
          '🔔 NotificationBloc: Failed to schedule workout reminder: $e',
          name: 'NotificationBloc');
      emit(NotificationError(
          'Не удалось запланировать напоминание о тренировке: $e'));
    }
  }

  Future<void> _onScheduleGoalReminder(
    ScheduleGoalReminder event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log('🔔 NotificationBloc: Scheduling goal reminder',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _scheduleGoalReminderUseCase(
        reminderTime: event.reminderTime,
        goalName: event.goalName,
        description: event.description,
      );

      emit(NotificationSuccess('Напоминание о цели запланировано успешно'));
      developer.log('🔔 NotificationBloc: Goal reminder scheduled successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log('🔔 NotificationBloc: Failed to schedule goal reminder: $e',
          name: 'NotificationBloc');
      emit(
          NotificationError('Не удалось запланировать напоминание о цели: $e'));
    }
  }

  Future<void> _onSendGoalAchievementNotification(
    SendGoalAchievementNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log(
          '🔔 NotificationBloc: Sending goal achievement notification',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _sendGoalAchievementNotificationUseCase(
        userId: event.userId,
        goalName: event.goalName,
        achievement: event.achievement,
      );

      emit(NotificationSuccess(
          'Уведомление о достижении цели отправлено успешно'));
      developer.log(
          '🔔 NotificationBloc: Goal achievement notification sent successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log(
          '🔔 NotificationBloc: Failed to send goal achievement notification: $e',
          name: 'NotificationBloc');
      emit(NotificationError(
          'Не удалось отправить уведомление о достижении цели: $e'));
    }
  }

  Future<void> _onSendMissedWorkoutNotification(
    SendMissedWorkoutNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log('🔔 NotificationBloc: Sending missed workout notification',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _sendMissedWorkoutNotificationUseCase(
        userId: event.userId,
        workoutName: event.workoutName,
      );

      emit(NotificationSuccess(
          'Уведомление о пропущенной тренировке отправлено успешно'));
      developer.log(
          '🔔 NotificationBloc: Missed workout notification sent successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log(
          '🔔 NotificationBloc: Failed to send missed workout notification: $e',
          name: 'NotificationBloc');
      emit(NotificationError(
          'Не удалось отправить уведомление о пропущенной тренировке: $e'));
    }
  }

  Future<void> _onSendCalorieExceededNotification(
    SendCalorieExceededNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      developer.log(
          '🔔 NotificationBloc: Sending calorie exceeded notification',
          name: 'NotificationBloc');
      emit(NotificationLoading());

      await _sendCalorieExceededNotificationUseCase(
        userId: event.userId,
        targetCalories: event.targetCalories,
        consumedCalories: event.consumedCalories,
      );

      emit(NotificationSuccess(
          'Уведомление о превышении калорий отправлено успешно'));
      developer.log(
          '🔔 NotificationBloc: Calorie exceeded notification sent successfully',
          name: 'NotificationBloc');
    } catch (e) {
      developer.log(
          '🔔 NotificationBloc: Failed to send calorie exceeded notification: $e',
          name: 'NotificationBloc');
      emit(NotificationError(
          'Не удалось отправить уведомление о превышении калорий: $e'));
    }
  }
}
