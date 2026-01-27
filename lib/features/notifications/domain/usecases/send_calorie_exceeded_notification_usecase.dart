import '../repositories/notification_repository.dart';

/// Use case для отправки уведомления о превышении калорий
class SendCalorieExceededNotificationUseCase {
  final NotificationRepository _repository;

  SendCalorieExceededNotificationUseCase(this._repository);

  Future<void> call({
    required String userId,
    required int targetCalories,
    required int consumedCalories,
  }) {
    return _repository.sendCalorieExceededNotification(
      userId: userId,
      targetCalories: targetCalories,
      consumedCalories: consumedCalories,
    );
  }
}
