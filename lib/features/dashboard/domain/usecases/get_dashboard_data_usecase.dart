import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/domain/repositories/profile_repository.dart';

/// Use case для получения данных дашборда
class GetDashboardDataUseCase {
  final ProfileRepository _profileRepository;

  GetDashboardDataUseCase(this._profileRepository);

  /// Получает профиль пользователя для отображения на дашборде
  Future<UserProfile?> call() async {
    try {
      return await _profileRepository.getCurrentUserProfile();
    } catch (e) {
      return null;
    }
  }
}
