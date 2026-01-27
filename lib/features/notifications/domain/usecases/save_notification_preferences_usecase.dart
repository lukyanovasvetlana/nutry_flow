import '../entities/notification_preferences.dart';
import '../repositories/notification_repository.dart';

/// Use case для сохранения настроек уведомлений
class SaveNotificationPreferencesUseCase {
  final NotificationRepository _repository;

  SaveNotificationPreferencesUseCase(this._repository);

  Future<void> call(NotificationPreferences preferences) {
    return _repository.saveNotificationPreferences(preferences);
  }
}
