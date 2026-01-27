import '../repositories/notification_repository.dart';

/// Use case для планирования напоминания о тренировке
class ScheduleWorkoutReminderUseCase {
  final NotificationRepository _repository;

  ScheduleWorkoutReminderUseCase(this._repository);

  Future<void> call({
    required DateTime workoutTime,
    required String workoutName,
    String? description,
  }) {
    return _repository.scheduleWorkoutReminder(
      workoutTime: workoutTime,
      workoutName: workoutName,
      description: description,
    );
  }
}
