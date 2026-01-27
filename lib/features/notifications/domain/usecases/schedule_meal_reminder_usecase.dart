import '../repositories/notification_repository.dart';

/// Use case для планирования напоминания о еде
class ScheduleMealReminderUseCase {
  final NotificationRepository _repository;

  ScheduleMealReminderUseCase(this._repository);

  Future<void> call({
    required DateTime mealTime,
    required String mealName,
    String? description,
  }) {
    return _repository.scheduleMealReminder(
      mealTime: mealTime,
      mealName: mealName,
      description: description,
    );
  }
}
