import '../entities/scheduled_notification.dart';
import '../repositories/notification_repository.dart';

/// Use case для получения запланированных уведомлений
class GetScheduledNotificationsUseCase {
  final NotificationRepository _repository;

  GetScheduledNotificationsUseCase(this._repository);

  Future<List<ScheduledNotification>> call() {
    return _repository.getScheduledNotifications();
  }
}
