import 'dart:developer' as developer;
import 'package:nutry_flow/core/services/analytics_service.dart';
import 'package:nutry_flow/features/profile/domain/entities/user_profile.dart';

/// Сервис для управления персонами аналитика
class PersonaAnalyticsService {
  static final PersonaAnalyticsService _instance = PersonaAnalyticsService._();
  static PersonaAnalyticsService get instance => _instance;

  PersonaAnalyticsService._();

  bool _isInitialized = false;
  UserProfile? _currentUserProfile;

  /// Инициализация сервиса персоны аналитика
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log(
          '👤 PersonaAnalyticsService: Initializing persona analytics service',
          name: 'PersonaAnalyticsService');

      // Инициализируем основной сервис аналитики
      await AnalyticsService.instance.initialize();

      _isInitialized = true;
      developer.log(
          '👤 PersonaAnalyticsService: Persona analytics service initialized successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to initialize persona analytics service: $e',
          name: 'PersonaAnalyticsService');
      rethrow;
    }
  }

  /// Установка профиля пользователя для аналитики
  Future<void> setUserProfile(UserProfile profile) async {
    try {
      _currentUserProfile = profile;

      developer.log(
          '👤 PersonaAnalyticsService: Setting user profile for analytics',
          name: 'PersonaAnalyticsService');

      // Устанавливаем базовые свойства пользователя
      await _setBasicUserProperties(profile);

      // Устанавливаем свойства персоны
      await _setPersonaProperties(profile);

      // Устанавливаем свойства целей
      await _setGoalProperties(profile);

      // Устанавливаем свойства предпочтений
      await _setPreferenceProperties(profile);

      developer.log('👤 PersonaAnalyticsService: User profile set successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to set user profile: $e',
          name: 'PersonaAnalyticsService');
    }
  }

  /// Установка базовых свойств пользователя
  Future<void> _setBasicUserProperties(UserProfile profile) async {
    await AnalyticsService.instance
        .setUserProperty(name: 'user_id', value: profile.id);
    await AnalyticsService.instance
        .setUserProperty(name: 'user_email', value: profile.email);
    await AnalyticsService.instance
        .setUserProperty(name: 'user_name', value: profile.fullName);

    if (profile.gender != null) {
      await AnalyticsService.instance
          .setUserProperty(name: 'user_gender', value: profile.gender!.name);
    }

    if (profile.dateOfBirth != null) {
      final age = DateTime.now().year - profile.dateOfBirth!.year;
      await AnalyticsService.instance
          .setUserProperty(name: 'user_age', value: age.toString());
    }
  }

  /// Установка свойств персоны
  Future<void> _setPersonaProperties(UserProfile profile) async {
    // Определяем персону на основе характеристик пользователя
    final persona = _determinePersona(profile);
    await AnalyticsService.instance
        .setUserProperty(name: 'user_persona', value: persona);

    // Устанавливаем свойства активности
    if (profile.activityLevel != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'activity_level', value: profile.activityLevel!.name);
    }

    // Устанавливаем физические характеристики
    if (profile.height != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'user_height_cm', value: profile.height!.toString());
    }

    if (profile.weight != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'user_weight_kg', value: profile.weight!.toString());
    }

    // Вычисляем и устанавливаем BMI
    if (profile.height != null && profile.weight != null) {
      final bmi =
          profile.weight! / ((profile.height! / 100) * (profile.height! / 100));
      await AnalyticsService.instance
          .setUserProperty(name: 'user_bmi', value: bmi.toStringAsFixed(1));
    }
  }

  /// Установка свойств целей
  Future<void> _setGoalProperties(UserProfile profile) async {
    // Устанавливаем цели фитнеса
    if (profile.fitnessGoals.isNotEmpty) {
      await AnalyticsService.instance.setUserProperty(
          name: 'fitness_goals', value: profile.fitnessGoals.join(','));
    }

    // Устанавливаем целевые значения
    if (profile.targetWeight != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'target_weight_kg', value: profile.targetWeight!.toString());
    }

    if (profile.targetCalories != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'target_calories', value: profile.targetCalories!.toString());
    }

    // Устанавливаем целевые макронутриенты
    if (profile.targetProtein != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'target_protein_g', value: profile.targetProtein!.toString());
    }

    if (profile.targetCarbs != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'target_carbs_g', value: profile.targetCarbs!.toString());
    }

    if (profile.targetFat != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'target_fat_g', value: profile.targetFat!.toString());
    }
  }

  /// Установка свойств предпочтений
  Future<void> _setPreferenceProperties(UserProfile profile) async {
    // Устанавливаем диетические предпочтения
    if (profile.dietaryPreferences.isNotEmpty) {
      await AnalyticsService.instance.setUserProperty(
          name: 'dietary_preferences',
          value: profile.dietaryPreferences.map((p) => p.name).join(','));
    }

    // Устанавливаем аллергии
    if (profile.allergies.isNotEmpty) {
      await AnalyticsService.instance.setUserProperty(
          name: 'allergies', value: profile.allergies.join(','));
    }

    // Устанавливаем состояния здоровья
    if (profile.healthConditions.isNotEmpty) {
      await AnalyticsService.instance.setUserProperty(
          name: 'health_conditions', value: profile.healthConditions.join(','));
    }

    // Устанавливаем ограничения в питании
    if (profile.foodRestrictions != null) {
      await AnalyticsService.instance.setUserProperty(
          name: 'food_restrictions', value: profile.foodRestrictions!);
    }
  }

  /// Определение персоны пользователя
  String _determinePersona(UserProfile profile) {
    // Логика определения персоны на основе характеристик пользователя
    if (profile.fitnessGoals.contains('weight_loss') &&
        profile.activityLevel == ActivityLevel.sedentary) {
      return 'beginner_weight_loss';
    } else if (profile.fitnessGoals.contains('muscle_gain') &&
        profile.activityLevel == ActivityLevel.veryActive) {
      return 'advanced_fitness';
    } else if (profile.dietaryPreferences
        .contains(DietaryPreference.vegetarian)) {
      return 'health_conscious';
    } else if (profile.healthConditions.isNotEmpty) {
      return 'health_management';
    } else if (profile.activityLevel == ActivityLevel.extremelyActive) {
      return 'athlete';
    } else {
      return 'general_wellness';
    }
  }

  /// Отслеживание изменения профиля
  Future<void> trackProfileUpdate({
    required String fieldName,
    required dynamic oldValue,
    required dynamic newValue,
  }) async {
    try {
      developer.log(
          '👤 PersonaAnalyticsService: Tracking profile update: $fieldName',
          name: 'PersonaAnalyticsService');

      await AnalyticsService.instance.logEvent(
        name: 'profile_updated',
        parameters: {
          'field_name': fieldName,
          'old_value': oldValue?.toString() ?? 'null',
          'new_value': newValue?.toString() ?? 'null',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsService: Profile update tracked successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to track profile update: $e',
          name: 'PersonaAnalyticsService');
    }
  }

  /// Отслеживание достижения цели
  Future<void> trackGoalProgress({
    required String goalType,
    required double currentValue,
    required double targetValue,
    double? progressPercentage,
  }) async {
    try {
      developer.log(
          '👤 PersonaAnalyticsService: Tracking goal progress: $goalType',
          name: 'PersonaAnalyticsService');

      await AnalyticsService.instance.logEvent(
        name: 'goal_progress',
        parameters: {
          'goal_type': goalType,
          'current_value': currentValue,
          'target_value': targetValue,
          if (progressPercentage != null)
            'progress_percentage': progressPercentage,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsService: Goal progress tracked successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to track goal progress: $e',
          name: 'PersonaAnalyticsService');
    }
  }

  /// Отслеживание изменения веса
  Future<void> trackWeightChange({
    required double oldWeight,
    required double newWeight,
    double? targetWeight,
  }) async {
    try {
      final weightChange = newWeight - oldWeight;
      final progressToTarget = targetWeight != null
          ? ((newWeight - targetWeight) / (oldWeight - targetWeight)) * 100
          : null;

      developer.log(
          '👤 PersonaAnalyticsService: Tracking weight change: ${weightChange.toStringAsFixed(1)}kg',
          name: 'PersonaAnalyticsService');

      await AnalyticsService.instance.logEvent(
        name: 'weight_changed',
        parameters: {
          'old_weight_kg': oldWeight,
          'new_weight_kg': newWeight,
          'weight_change_kg': weightChange,
          if (targetWeight != null) 'target_weight_kg': targetWeight,
          if (progressToTarget != null)
            'progress_to_target_percent': progressToTarget,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsService: Weight change tracked successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to track weight change: $e',
          name: 'PersonaAnalyticsService');
    }
  }

  /// Отслеживание изменения активности
  Future<void> trackActivityLevelChange({
    required ActivityLevel oldLevel,
    required ActivityLevel newLevel,
  }) async {
    try {
      developer.log(
          '👤 PersonaAnalyticsService: Tracking activity level change: ${oldLevel.name} -> ${newLevel.name}',
          name: 'PersonaAnalyticsService');

      await AnalyticsService.instance.logEvent(
        name: 'activity_level_changed',
        parameters: {
          'old_activity_level': oldLevel.name,
          'new_activity_level': newLevel.name,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsService: Activity level change tracked successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to track activity level change: $e',
          name: 'PersonaAnalyticsService');
    }
  }

  /// Отслеживание изменения диетических предпочтений
  Future<void> trackDietaryPreferenceChange({
    required List<DietaryPreference> oldPreferences,
    required List<DietaryPreference> newPreferences,
  }) async {
    try {
      developer.log(
          '👤 PersonaAnalyticsService: Tracking dietary preference change',
          name: 'PersonaAnalyticsService');

      await AnalyticsService.instance.logEvent(
        name: 'dietary_preferences_changed',
        parameters: {
          'old_preferences': oldPreferences.map((p) => p.name).join(','),
          'new_preferences': newPreferences.map((p) => p.name).join(','),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsService: Dietary preference change tracked successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to track dietary preference change: $e',
          name: 'PersonaAnalyticsService');
    }
  }

  /// Отслеживание сессии пользователя
  Future<void> trackUserSession({
    required String sessionType,
    required int durationMinutes,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      developer.log(
          '👤 PersonaAnalyticsService: Tracking user session: $sessionType',
          name: 'PersonaAnalyticsService');

      await AnalyticsService.instance.logEvent(
        name: 'user_session',
        parameters: {
          'session_type': sessionType,
          'duration_minutes': durationMinutes,
          'user_persona': _currentUserProfile != null
              ? _determinePersona(_currentUserProfile!)
              : 'unknown',
          if (additionalData != null) ...additionalData,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsService: User session tracked successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to track user session: $e',
          name: 'PersonaAnalyticsService');
    }
  }

  /// Отслеживание взаимодействия с функциями
  Future<void> trackFeatureUsage({
    required String featureName,
    required String action,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      developer.log(
          '👤 PersonaAnalyticsService: Tracking feature usage: $featureName - $action',
          name: 'PersonaAnalyticsService');

      await AnalyticsService.instance.logEvent(
        name: 'feature_usage',
        parameters: {
          'feature_name': featureName,
          'action': action,
          'user_persona': _currentUserProfile != null
              ? _determinePersona(_currentUserProfile!)
              : 'unknown',
          if (parameters != null) ...parameters,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      developer.log(
          '👤 PersonaAnalyticsService: Feature usage tracked successfully',
          name: 'PersonaAnalyticsService');
    } catch (e) {
      developer.log(
          '👤 PersonaAnalyticsService: Failed to track feature usage: $e',
          name: 'PersonaAnalyticsService');
    }
  }

  /// Получение текущего профиля пользователя
  UserProfile? get currentUserProfile => _currentUserProfile;

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;
}
