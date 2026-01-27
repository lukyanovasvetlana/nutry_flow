import 'package:shared_preferences/shared_preferences.dart';
import '../../../profile/domain/entities/user_profile.dart';

/// Репозиторий для работы с локальными данными дашборда
class DashboardRepository {
  /// Получает профиль пользователя из локального хранилища
  Future<UserProfile?> getLocalUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName');
      final userLastName = prefs.getString('userLastName');

      if (userName == null || userName.isEmpty) {
        return null;
      }

      return UserProfile(
        id: 'local-user',
        firstName: userName,
        lastName: userLastName ?? '',
        email: prefs.getString('userEmail') ?? 'user@example.com',
        phone: null,
        dateOfBirth: null,
        gender: null,
        height: null,
        weight: null,
        activityLevel: null,
        avatarUrl: null,
        dietaryPreferences: const [],
        allergies: const [],
        healthConditions: const [],
        fitnessGoals: const [],
        targetWeight: null,
        targetCalories: null,
        targetProtein: null,
        targetCarbs: null,
        targetFat: null,
        foodRestrictions: null,
        pushNotificationsEnabled: true,
        emailNotificationsEnabled: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }
}
