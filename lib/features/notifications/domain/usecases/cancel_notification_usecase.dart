import '../repositories/notification_repository.dart';

/// Use case для отмены уведомления
class CancelNotificationUseCase {
  final NotificationRepository _repository;

  CancelNotificationUseCase(this._repository);

  Future<void> call(int notificationId) {
    return _repository.cancelNotification(notificationId);
  }
}
