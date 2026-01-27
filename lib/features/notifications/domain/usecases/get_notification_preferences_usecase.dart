import '../entities/notification_preferences.dart';
import '../repositories/notification_repository.dart';

/// Use case для получения настроек уведомлений
class GetNotificationPreferencesUseCase {
  final NotificationRepository _repository;

  GetNotificationPreferencesUseCase(this._repository);

  Future<NotificationPreferences> call() {
    return _repository.getNotificationPreferences();
  }
}
