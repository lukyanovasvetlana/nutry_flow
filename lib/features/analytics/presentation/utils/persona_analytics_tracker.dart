import 'dart:developer' as developer;
import 'package:nutry_flow/core/services/persona_analytics_service.dart';
import 'package:nutry_flow/features/profile/domain/entities/user_profile.dart';

/// Утилита для отслеживания персоны аналитика
class PersonaAnalyticsTracker {
  static final PersonaAnalyticsTracker _instance = PersonaAnalyticsTracker._();
  static PersonaAnalyticsTracker get instance => _instance;

  PersonaAnalyticsTracker._();

  UserProfile? _lastTrackedProfile;

  /// Инициализация трекера персоны
  Future<void> initialize() async {
    try {
      developer.log(
          '👤 PersonaAnalyticsTracker: Initializing persona analytics tracker',
          name: 'PersonaAnalyticsTracker');

      await PersonaAnalyticsService.instance.initialize();

      developer.log(
          '👤 PersonaAnalyticsTracker: Persona analytics tracker initialized successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to initialize persona analytics tracker: $e',
          name: 'PersonaAnalyticsTracker');
      rethrow;
    }
  }

  /// Установка профиля пользователя и отслеживание изменений
  Future<void> setUserProfile(UserProfile profile) async {
    try {
      developer.log('👤 PersonaAnalyticsTracker: Setting user profile',
          name: 'PersonaAnalyticsTracker');

      // Если это первый раз, просто устанавливаем профиль
      if (_lastTrackedProfile == null) {
        await PersonaAnalyticsService.instance.setUserProfile(profile);
        _lastTrackedProfile = profile;
        return;
      }

      // Отслеживаем изменения в профиле
      await _trackProfileChanges(_lastTrackedProfile!, profile);

      // Обновляем профиль в сервисе
      await PersonaAnalyticsService.instance.setUserProfile(profile);
      _lastTrackedProfile = profile;

      developer.log(
          '👤 PersonaAnalyticsTracker: User profile set and changes tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to set user profile: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание изменений в профиле
  Future<void> _trackProfileChanges(
      UserProfile oldProfile, UserProfile newProfile) async {
    try {
      // Отслеживаем изменение веса
      if (oldProfile.weight != null &&
          newProfile.weight != null &&
          oldProfile.weight != newProfile.weight) {
        await PersonaAnalyticsService.instance.trackWeightChange(
          oldWeight: oldProfile.weight!,
          newWeight: newProfile.weight!,
          targetWeight: newProfile.targetWeight,
        );
      }

      // Отслеживаем изменение уровня активности
      if (oldProfile.activityLevel != null &&
          newProfile.activityLevel != null &&
          oldProfile.activityLevel != newProfile.activityLevel) {
        await PersonaAnalyticsService.instance.trackActivityLevelChange(
          oldLevel: oldProfile.activityLevel!,
          newLevel: newProfile.activityLevel!,
        );
      }

      // Отслеживаем изменение диетических предпочтений
      if (!_areListsEqual(
          oldProfile.dietaryPreferences, newProfile.dietaryPreferences)) {
        await PersonaAnalyticsService.instance.trackDietaryPreferenceChange(
          oldPreferences: oldProfile.dietaryPreferences,
          newPreferences: newProfile.dietaryPreferences,
        );
      }

      // Отслеживаем изменение целей
      if (!_areListsEqual(oldProfile.fitnessGoals, newProfile.fitnessGoals)) {
        await PersonaAnalyticsService.instance.trackProfileUpdate(
          fieldName: 'fitness_goals',
          oldValue: oldProfile.fitnessGoals.join(','),
          newValue: newProfile.fitnessGoals.join(','),
        );
      }

      // Отслеживаем изменение целевого веса
      if (oldProfile.targetWeight != newProfile.targetWeight) {
        await PersonaAnalyticsService.instance.trackProfileUpdate(
          fieldName: 'target_weight',
          oldValue: oldProfile.targetWeight,
          newValue: newProfile.targetWeight,
        );
      }

      // Отслеживаем изменение целевых калорий
      if (oldProfile.targetCalories != newProfile.targetCalories) {
        await PersonaAnalyticsService.instance.trackProfileUpdate(
          fieldName: 'target_calories',
          oldValue: oldProfile.targetCalories,
          newValue: newProfile.targetCalories,
        );
      }

      // Отслеживаем изменение аллергий
      if (!_areListsEqual(oldProfile.allergies, newProfile.allergies)) {
        await PersonaAnalyticsService.instance.trackProfileUpdate(
          fieldName: 'allergies',
          oldValue: oldProfile.allergies.join(','),
          newValue: newProfile.allergies.join(','),
        );
      }

      // Отслеживаем изменение состояний здоровья
      if (!_areListsEqual(
          oldProfile.healthConditions, newProfile.healthConditions)) {
        await PersonaAnalyticsService.instance.trackProfileUpdate(
          fieldName: 'health_conditions',
          oldValue: oldProfile.healthConditions.join(','),
          newValue: newProfile.healthConditions.join(','),
        );
      }

      developer.log(
          '👤 PersonaAnalyticsTracker: Profile changes tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to track profile changes: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Проверка равенства списков
  bool _areListsEqual(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  /// Отслеживание прогресса цели
  Future<void> trackGoalProgress({
    required String goalType,
    required double currentValue,
    required double targetValue,
  }) async {
    try {
      final progressPercentage = (currentValue / targetValue) * 100;

      await PersonaAnalyticsService.instance.trackGoalProgress(
        goalType: goalType,
        currentValue: currentValue,
        targetValue: targetValue,
        progressPercentage: progressPercentage,
      );

      developer.log(
          '👤 PersonaAnalyticsTracker: Goal progress tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to track goal progress: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание сессии пользователя
  Future<void> trackUserSession({
    required String sessionType,
    required int durationMinutes,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await PersonaAnalyticsService.instance.trackUserSession(
        sessionType: sessionType,
        durationMinutes: durationMinutes,
        additionalData: additionalData,
      );

      developer.log(
          '👤 PersonaAnalyticsTracker: User session tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to track user session: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание использования функции
  Future<void> trackFeatureUsage({
    required String featureName,
    required String action,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await PersonaAnalyticsService.instance.trackFeatureUsage(
        featureName: featureName,
        action: action,
        parameters: parameters,
      );

      developer.log(
          '👤 PersonaAnalyticsTracker: Feature usage tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to track feature usage: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание входа в приложение
  Future<void> trackAppLogin() async {
    try {
      await PersonaAnalyticsService.instance.trackUserSession(
        sessionType: 'app_login',
        durationMinutes: 0,
        additionalData: {
          'login_method': 'app_launch',
        },
      );

      developer.log(
          '👤 PersonaAnalyticsTracker: App login tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log('👤 PersonaAnalyticsTracker: Failed to track app login: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание выхода из приложения
  Future<void> trackAppLogout() async {
    try {
      await PersonaAnalyticsService.instance.trackUserSession(
        sessionType: 'app_logout',
        durationMinutes: 0,
        additionalData: {
          'logout_method': 'app_close',
        },
      );

      developer.log(
          '👤 PersonaAnalyticsTracker: App logout tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to track app logout: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание просмотра экрана
  Future<void> trackScreenView({
    required String screenName,
    String? screenClass,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await PersonaAnalyticsService.instance.trackFeatureUsage(
        featureName: 'screen_view',
        action: 'view',
        parameters: {
          'screen_name': screenName,
          if (screenClass != null) 'screen_class': screenClass,
          if (additionalData != null) ...additionalData,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsTracker: Screen view tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to track screen view: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание взаимодействия с кнопкой
  Future<void> trackButtonClick({
    required String buttonName,
    required String screenName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await PersonaAnalyticsService.instance.trackFeatureUsage(
        featureName: 'button_click',
        action: 'click',
        parameters: {
          'button_name': buttonName,
          'screen_name': screenName,
          if (additionalData != null) ...additionalData,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsTracker: Button click tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to track button click: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание поиска
  Future<void> trackSearch({
    required String searchTerm,
    required String searchCategory,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await PersonaAnalyticsService.instance.trackFeatureUsage(
        featureName: 'search',
        action: 'search',
        parameters: {
          'search_term': searchTerm,
          'search_category': searchCategory,
          if (additionalData != null) ...additionalData,
        },
      );

      developer.log('👤 PersonaAnalyticsTracker: Search tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log('👤 PersonaAnalyticsTracker: Failed to track search: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Отслеживание выбора элемента
  Future<void> trackItemSelection({
    required String itemType,
    required String itemId,
    required String itemName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await PersonaAnalyticsService.instance.trackFeatureUsage(
        featureName: 'item_selection',
        action: 'select',
        parameters: {
          'item_type': itemType,
          'item_id': itemId,
          'item_name': itemName,
          if (additionalData != null) ...additionalData,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsTracker: Item selection tracked successfully',
          name: 'PersonaAnalyticsTracker');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsTracker: Failed to track item selection: $e',
          name: 'PersonaAnalyticsTracker');
    }
  }

  /// Получение текущего профиля пользователя
  UserProfile? get currentUserProfile =>
      PersonaAnalyticsService.instance.currentUserProfile;

  /// Проверка инициализации
  bool get isInitialized => PersonaAnalyticsService.instance.isInitialized;
}
