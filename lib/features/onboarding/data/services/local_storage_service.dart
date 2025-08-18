import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Сервис для работы с локальным хранилищем
/// Инкапсулирует логику кэширования и локального сохранения данных
class LocalStorageService {
  static const String _userGoalsKey = 'user_goals';
  static const String _userProfileKey = 'user_profile';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  /// Создает экземпляр сервиса
  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // === Методы для работы с целями пользователя ===

  /// Сохраняет цели пользователя локально
  Future<bool> saveUserGoals(Map<String, dynamic> goals, String userId) async {
    final key = '${_userGoalsKey}_$userId';
    final goalsJson = jsonEncode(goals);
    return _prefs.setString(key, goalsJson);
  }

  /// Получает цели пользователя из локального хранилища
  Map<String, dynamic>? getUserGoals(String userId) {
    final key = '${_userGoalsKey}_$userId';
    final goalsJson = _prefs.getString(key);

    if (goalsJson == null) return null;

    try {
      return jsonDecode(goalsJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Удаляет цели пользователя из локального хранилища
  Future<bool> deleteUserGoals(String userId) async {
    final key = '${_userGoalsKey}_$userId';
    return _prefs.remove(key);
  }

  // === Методы для работы с профилем пользователя ===

  /// Сохраняет данные профиля локально
  Future<bool> saveUserProfile(
      Map<String, dynamic> profile, String userId) async {
    final key = '${_userProfileKey}_$userId';
    final profileJson = jsonEncode(profile);
    return _prefs.setString(key, profileJson);
  }

  /// Получает данные профиля из локального хранилища
  Map<String, dynamic>? getUserProfile(String userId) {
    final key = '${_userProfileKey}_$userId';
    final profileJson = _prefs.getString(key);

    if (profileJson == null) return null;

    try {
      return jsonDecode(profileJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // === Методы для работы с состоянием онбординга ===

  /// Отмечает онбординг как завершенный
  Future<bool> setOnboardingCompleted(bool completed) async {
    return _prefs.setBool(_onboardingCompletedKey, completed);
  }

  /// Проверяет, завершен ли онбординг
  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  // === Общие методы ===

  /// Очищает все данные пользователя
  Future<bool> clearUserData(String userId) async {
    final results = await Future.wait([
      deleteUserGoals(userId),
      _prefs.remove('${_userProfileKey}_$userId'),
    ]);

    return results.every((result) => result);
  }

  /// Очищает все локальные данные
  Future<bool> clearAll() async {
    return _prefs.clear();
  }
}
