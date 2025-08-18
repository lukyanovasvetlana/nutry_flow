// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:nutry_flow/core/services/monitoring_service.dart';
import 'package:nutry_flow/core/services/firebase_interfaces.dart';
import 'dart:developer' as developer;
import 'dart:convert';

class ABTestingService {
  static final ABTestingService _instance = ABTestingService._();
  static ABTestingService get instance => _instance;

  ABTestingService._();

  late FirebaseRemoteConfigInterface _remoteConfig;
  late FirebaseAnalyticsInterface _analytics;
  bool _isInitialized = false;

  // Ключи для A/B тестов
  static const String _welcomeScreenVariantKey = 'welcome_screen_variant';
  static const String _onboardingFlowVariantKey = 'onboarding_flow_variant';
  static const String _dashboardLayoutVariantKey = 'dashboard_layout_variant';
  static const String _mealPlanVariantKey = 'meal_plan_variant';
  static const String _workoutVariantKey = 'workout_variant';
  static const String _notificationVariantKey = 'notification_variant';
  static const String _colorSchemeVariantKey = 'color_scheme_variant';
  static const String _featureFlagsKey = 'feature_flags';

  /// Инициализация сервиса A/B тестирования
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log('🧪 ABTestingService: Initializing A/B testing service',
          name: 'ABTestingService');

      _remoteConfig = MockFirebaseRemoteConfig.instance;
      _analytics = MockFirebaseAnalytics.instance;

      // Настройка параметров
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Установка значений по умолчанию
      await _remoteConfig.setDefaults({
        _welcomeScreenVariantKey: 'control',
        _onboardingFlowVariantKey: 'standard',
        _dashboardLayoutVariantKey: 'grid',
        _mealPlanVariantKey: 'list',
        _workoutVariantKey: 'card',
        _notificationVariantKey: 'push',
        _colorSchemeVariantKey: 'default',
        _featureFlagsKey: '{}',
      });

      // Загрузка конфигурации
      await _remoteConfig.fetchAndActivate();

      _isInitialized = true;
      developer.log(
          '🧪 ABTestingService: A/B testing service initialized successfully',
          name: 'ABTestingService');

      // Логируем активные эксперименты
      await _logActiveExperiments();
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to initialize A/B testing service: $e',
          name: 'ABTestingService');
      rethrow;
    }
  }

  /// Логирование активных экспериментов
  Future<void> _logActiveExperiments() async {
    try {
      final experiments = {
        'welcome_screen': getWelcomeScreenVariant(),
        'onboarding_flow': getOnboardingFlowVariant(),
        'dashboard_layout': getDashboardLayoutVariant(),
        'meal_plan': getMealPlanVariant(),
        'workout': getWorkoutVariant(),
        'notification': getNotificationVariant(),
        'color_scheme': getColorSchemeVariant(),
      };

      await MonitoringService.instance.trackEvent(
        eventName: 'ab_test_experiments_active',
        parameters: experiments,
      );

      developer.log(
          '🧪 ABTestingService: Active experiments logged: $experiments',
          name: 'ABTestingService');
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to log active experiments: $e',
          name: 'ABTestingService');
    }
  }

  /// Получение варианта экрана приветствия
  String getWelcomeScreenVariant() {
    try {
      return _remoteConfig.getString(_welcomeScreenVariantKey);
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get welcome screen variant: $e',
          name: 'ABTestingService');
      return 'control';
    }
  }

  /// Получение варианта процесса онбординга
  String getOnboardingFlowVariant() {
    try {
      return _remoteConfig.getString(_onboardingFlowVariantKey);
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get onboarding flow variant: $e',
          name: 'ABTestingService');
      return 'standard';
    }
  }

  /// Получение варианта макета дашборда
  String getDashboardLayoutVariant() {
    try {
      return _remoteConfig.getString(_dashboardLayoutVariantKey);
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get dashboard layout variant: $e',
          name: 'ABTestingService');
      return 'grid';
    }
  }

  /// Получение варианта плана питания
  String getMealPlanVariant() {
    try {
      return _remoteConfig.getString(_mealPlanVariantKey);
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to get meal plan variant: $e',
          name: 'ABTestingService');
      return 'list';
    }
  }

  /// Получение варианта тренировок
  String getWorkoutVariant() {
    try {
      return _remoteConfig.getString(_workoutVariantKey);
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to get workout variant: $e',
          name: 'ABTestingService');
      return 'card';
    }
  }

  /// Получение варианта уведомлений
  String getNotificationVariant() {
    try {
      return _remoteConfig.getString(_notificationVariantKey);
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get notification variant: $e',
          name: 'ABTestingService');
      return 'push';
    }
  }

  /// Получение варианта цветовой схемы
  String getColorSchemeVariant() {
    try {
      return _remoteConfig.getString(_colorSchemeVariantKey);
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get color scheme variant: $e',
          name: 'ABTestingService');
      return 'default';
    }
  }

  /// Получение флагов функций
  Map<String, dynamic> getFeatureFlags() {
    try {
      final flagsJson = _remoteConfig.getString(_featureFlagsKey);
      if (flagsJson.isEmpty) return {};

      // Парсим JSON строку в Map
      // В реальном приложении используйте dart:convert
      return _parseFeatureFlags(flagsJson);
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to get feature flags: $e',
          name: 'ABTestingService');
      return {};
    }
  }

  /// Парсинг флагов функций
  Map<String, dynamic> _parseFeatureFlags(String json) {
    try {
      if (json.isEmpty) return {};
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to parse feature flags: $e',
          name: 'ABTestingService');
      return {};
    }
  }

  /// Проверка включена ли функция
  bool isFeatureEnabled(String featureName) {
    try {
      final flags = getFeatureFlags();
      return flags[featureName] == true;
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to check feature flag: $e',
          name: 'ABTestingService');
      return false;
    }
  }

  /// Отслеживание показа эксперимента
  Future<void> trackExperimentExposure({
    required String experimentName,
    required String variant,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await MonitoringService.instance.trackEvent(
        eventName: 'experiment_exposure',
        parameters: {
          'experiment_name': experimentName,
          'variant': variant,
          if (parameters != null) ...parameters,
        },
      );

      developer.log(
          '🧪 ABTestingService: Experiment exposure tracked: $experimentName - $variant',
          name: 'ABTestingService');
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to track experiment exposure: $e',
          name: 'ABTestingService');
    }
  }

  /// Отслеживание конверсии эксперимента
  Future<void> trackExperimentConversion({
    required String experimentName,
    required String variant,
    required String conversionType,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await MonitoringService.instance.trackEvent(
        eventName: 'experiment_conversion',
        parameters: {
          'experiment_name': experimentName,
          'variant': variant,
          'conversion_type': conversionType,
          if (parameters != null) ...parameters,
        },
      );

      developer.log(
          '🧪 ABTestingService: Experiment conversion tracked: $experimentName - $variant - $conversionType',
          name: 'ABTestingService');
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to track experiment conversion: $e',
          name: 'ABTestingService');
    }
  }

  /// Принудительное обновление конфигурации
  Future<void> forceUpdate() async {
    try {
      developer.log('🧪 ABTestingService: Forcing configuration update',
          name: 'ABTestingService');

      await _remoteConfig.fetchAndActivate();

      // Логируем обновленные эксперименты
      await _logActiveExperiments();

      developer.log('🧪 ABTestingService: Configuration updated successfully',
          name: 'ABTestingService');
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to force update: $e',
          name: 'ABTestingService');
      rethrow;
    }
  }

  /// Получение информации о последнем обновлении
  DateTime getLastFetchTime() {
    try {
      return _remoteConfig.lastFetchTime;
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to get last fetch time: $e',
          name: 'ABTestingService');
      return DateTime.now();
    }
  }

  /// Получение статуса конфигурации
  RemoteConfigFetchStatus getFetchStatus() {
    try {
      return _remoteConfig.lastFetchStatus;
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to get fetch status: $e',
          name: 'ABTestingService');
      return RemoteConfigFetchStatus.noFetchYet;
    }
  }

  /// Получение всех активных экспериментов
  Map<String, String> getAllActiveExperiments() {
    try {
      return {
        'welcome_screen': getWelcomeScreenVariant(),
        'onboarding_flow': getOnboardingFlowVariant(),
        'dashboard_layout': getDashboardLayoutVariant(),
        'meal_plan': getMealPlanVariant(),
        'workout': getWorkoutVariant(),
        'notification': getNotificationVariant(),
        'color_scheme': getColorSchemeVariant(),
      };
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get all active experiments: $e',
          name: 'ABTestingService');
      return {};
    }
  }

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;

  /// Получение экземпляра FirebaseRemoteConfig
  FirebaseRemoteConfigInterface get remoteConfig => _remoteConfig;

  /// Получение экземпляра FirebaseAnalytics
  FirebaseAnalyticsInterface get analytics => _analytics;

  /// Отслеживание пользовательского события с параметрами эксперимента
  Future<void> trackUserEvent({
    required String eventName,
    required String experimentName,
    required String variant,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final eventParams = {
        'experiment_name': experimentName,
        'variant': variant,
        if (parameters != null) ...parameters,
      };

      await _analytics.logEvent(
        name: eventName,
        parameters: eventParams,
      );

      await MonitoringService.instance.trackEvent(
        eventName: eventName,
        parameters: eventParams,
      );

      developer.log(
          '🧪 ABTestingService: User event tracked: $eventName - $experimentName - $variant',
          name: 'ABTestingService');
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to track user event: $e',
          name: 'ABTestingService');
    }
  }

  /// Получение числового значения из Remote Config
  double getNumericValue(String key, {double defaultValue = 0.0}) {
    try {
      final value = _remoteConfig.getDouble(key);
      // Если значение равно 0.0 и ключ не существует, возвращаем defaultValue
      if (value == 0.0 &&
          !(_remoteConfig as MockFirebaseRemoteConfig).hasKey(key)) {
        return defaultValue;
      }
      return value;
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get numeric value for $key: $e',
          name: 'ABTestingService');
      return defaultValue;
    }
  }

  /// Получение булевого значения из Remote Config
  bool getBooleanValue(String key, {bool defaultValue = false}) {
    try {
      final value = _remoteConfig.getBool(key);
      // Если значение равно false и ключ не существует, возвращаем defaultValue
      if (value == false &&
          !(_remoteConfig as MockFirebaseRemoteConfig).hasKey(key)) {
        return defaultValue;
      }
      return value;
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get boolean value for $key: $e',
          name: 'ABTestingService');
      return defaultValue;
    }
  }

  /// Получение JSON объекта из Remote Config
  Map<String, dynamic> getJsonValue(String key,
      {Map<String, dynamic> defaultValue = const {}}) {
    try {
      final jsonString = _remoteConfig.getString(key);
      if (jsonString.isEmpty) return defaultValue;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      developer.log(
          '🧪 ABTestingService: Failed to get JSON value for $key: $e',
          name: 'ABTestingService');
      return defaultValue;
    }
  }

  /// Проверка, является ли пользователь в тестовой группе
  bool isUserInTestGroup(String experimentName) {
    try {
      final variant = _getExperimentVariant(experimentName);
      return variant != 'control' && variant.isNotEmpty;
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to check test group: $e',
          name: 'ABTestingService');
      return false;
    }
  }

  /// Получение варианта эксперимента по имени
  String _getExperimentVariant(String experimentName) {
    try {
      switch (experimentName) {
        case 'welcome_screen':
          return getWelcomeScreenVariant();
        case 'onboarding_flow':
          return getOnboardingFlowVariant();
        case 'dashboard_layout':
          return getDashboardLayoutVariant();
        case 'meal_plan':
          return getMealPlanVariant();
        case 'workout':
          return getWorkoutVariant();
        case 'notification':
          return getNotificationVariant();
        case 'color_scheme':
          return getColorSchemeVariant();
        default:
          return _remoteConfig.getString(experimentName);
      }
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to get experiment variant: $e',
          name: 'ABTestingService');
      return 'control';
    }
  }

  /// Получение статистики экспериментов
  Map<String, dynamic> getExperimentStats() {
    try {
      return {
        'total_experiments': getAllActiveExperiments().length,
        'test_groups': getAllActiveExperiments()
            .entries
            .where((entry) => entry.value != 'control')
            .length,
        'last_update': getLastFetchTime().toIso8601String(),
        'fetch_status': getFetchStatus().toString(),
      };
    } catch (e) {
      developer.log('🧪 ABTestingService: Failed to get experiment stats: $e',
          name: 'ABTestingService');
      return {};
    }
  }
}
