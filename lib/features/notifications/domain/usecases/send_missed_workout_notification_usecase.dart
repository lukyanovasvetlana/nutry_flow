import '../repositories/notification_repository.dart';

/// Use case для отправки уведомления о пропущенной тренировке
class SendMissedWorkoutNotificationUseCase {
  final NotificationRepository _repository;

  SendMissedWorkoutNotificationUseCase(this._repository);

  Future<void> call({
    required String userId,
    required String workoutName,
  }) {
    return _repository.sendMissedWorkoutNotification(
      userId: userId,
      workoutName: workoutName,
    );
  }
}
