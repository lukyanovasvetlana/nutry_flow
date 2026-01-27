import '../repositories/notification_repository.dart';

/// Use case для планирования напоминания о цели
class ScheduleGoalReminderUseCase {
  final NotificationRepository _repository;

  ScheduleGoalReminderUseCase(this._repository);

  Future<void> call({
    required DateTime reminderTime,
    required String goalName,
    String? description,
  }) {
    return _repository.scheduleGoalReminder(
      reminderTime: reminderTime,
      goalName: goalName,
      description: description,
    );
  }
}
