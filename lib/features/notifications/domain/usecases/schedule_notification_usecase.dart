import '../entities/scheduled_notification.dart';
import '../repositories/notification_repository.dart';

/// Use case для планирования уведомления
class ScheduleNotificationUseCase {
  final NotificationRepository _repository;

  ScheduleNotificationUseCase(this._repository);

  Future<void> call(ScheduledNotification notification) {
    return _repository.scheduleNotification(notification);
  }
}
