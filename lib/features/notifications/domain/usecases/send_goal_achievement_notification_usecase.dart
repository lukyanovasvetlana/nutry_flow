import '../repositories/notification_repository.dart';

/// Use case для отправки уведомления о достижении цели
class SendGoalAchievementNotificationUseCase {
  final NotificationRepository _repository;

  SendGoalAchievementNotificationUseCase(this._repository);

  Future<void> call({
    required String userId,
    required String goalName,
    String? achievement,
  }) {
    return _repository.sendGoalAchievementNotification(
      userId: userId,
      goalName: goalName,
      achievement: achievement,
    );
  }
}
