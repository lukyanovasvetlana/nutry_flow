import '../repositories/notification_repository.dart';

/// Use case для отправки push-уведомления
class SendPushNotificationUseCase {
  final NotificationRepository _repository;

  SendPushNotificationUseCase(this._repository);

  Future<void> call({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) {
    return _repository.sendPushNotification(
      userId: userId,
      title: title,
      body: body,
      type: type,
      data: data,
    );
  }
}
