import 'package:nutry_flow/features/onboarding/di/onboarding_dependencies.dart';
import 'package:nutry_flow/features/profile/di/profile_dependencies.dart';
import 'package:nutry_flow/features/nutrition/di/nutrition_dependencies.dart';
import 'package:nutry_flow/features/menu/di/menu_dependencies.dart';
import 'package:nutry_flow/features/meal_plan/di/meal_plan_dependencies.dart';
import 'package:nutry_flow/features/grocery_list/di/grocery_dependencies.dart';
import 'package:nutry_flow/features/calendar/di/calendar_dependencies.dart';
import 'package:nutry_flow/features/exercise/di/exercise_dependencies.dart';
import 'package:nutry_flow/features/analytics/di/analytics_dependencies.dart';
import 'package:nutry_flow/features/auth/di/auth_dependencies.dart';
import 'dart:developer' as developer;

/// Класс для инициализации всех зависимостей приложения
class AppInitializer {
  bool _isInitialized = false;
  final List<String> _initializedFeatures = [];

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;

  /// Список инициализированных фич
  List<String> get initializedFeatures =>
      List.unmodifiable(_initializedFeatures);

  /// Инициализация всех зависимостей
  Future<void> initialize() async {
    if (_isInitialized) {
      developer.log('⚠️ AppInitializer: Already initialized', name: 'app_initializer');
      return;
    }

    try {
      developer.log(
          '🚀 AppInitializer: Starting feature dependencies initialization...', name: 'app_initializer');

      // Инициализация фич в определенном порядке
      await _initializeFeatureDependencies();

      _isInitialized = true;
      developer.log('✅ AppInitializer: All dependencies initialized successfully', name: 'app_initializer');
      developer.log('📋 AppInitializer: Initialized features: \$_initializedFeatures', name: 'app_initializer');
    } catch (e, stackTrace) {
      developer.log('❌ AppInitializer: Initialization failed: \$e', name: 'app_initializer');
      developer.log('❌ Stack trace: \$stackTrace', name: 'app_initializer');
      rethrow;
    }
  }

  /// Инициализация зависимостей фич
  Future<void> _initializeFeatureDependencies() async {
    // Порядок инициализации важен для зависимостей между фичами

    // 1. Базовые фичи (без зависимостей от других)
    await _initializeFeature('Onboarding', () async {
      await OnboardingDependencies.instance.initialize();
    });

    await _initializeFeature('Auth', () async {
      await AuthDependencies.instance.initialize();
    });

    await _initializeFeature('Profile', () async {
      await ProfileDependencies.instance.initialize();
    });

    // 2. Фичи с зависимостями
    await _initializeFeature('Nutrition', () async {
      NutritionDependencies.initialize();
    });

    await _initializeFeature('Menu', () async {
      await MenuDependencies.instance.initialize();
    });

    await _initializeFeature('MealPlan', () async {
      await MealPlanDependencies.instance.initialize();
    });

    await _initializeFeature('GroceryList', () async {
      await GroceryDependencies.instance.initialize();
    });

    await _initializeFeature('Calendar', () async {
      await CalendarDependencies.instance.initialize();
    });

    await _initializeFeature('Exercise', () async {
      ExerciseDependencies.initialize();
    });

    await _initializeFeature('Analytics', () async {
      await AnalyticsDependencies.instance.initialize();
    });
  }

  /// Инициализация отдельной фичи
  Future<void> _initializeFeature(
      String featureName, Future<void> Function() initializer) async {
    try {
      developer.log('🔄 AppInitializer: Initializing \$featureName...', name: 'app_initializer');
      await initializer();
      _initializedFeatures.add(featureName);
      developer.log('✅ AppInitializer: \$featureName initialized successfully', name: 'app_initializer');
    } catch (e) {
      developer.log('❌ AppInitializer: Failed to initialize \$featureName: \$e', name: 'app_initializer');
      rethrow;
    }
  }

  /// Проверка инициализации конкретной фичи
  bool isFeatureInitialized(String featureName) {
    return _initializedFeatures.contains(featureName);
  }

  /// Получение статуса инициализации всех фич
  Map<String, bool> getFeaturesStatus() {
    final allFeatures = [
      'Onboarding',
      'Auth',
      'Profile',
      'Nutrition',
      'Menu',
      'MealPlan',
      'GroceryList',
      'Calendar',
      'Exercise',
      'Analytics'
    ];

    return Map.fromEntries(allFeatures.map((feature) =>
        MapEntry(feature, _initializedFeatures.contains(feature))));
  }

  /// Очистка ресурсов
  Future<void> dispose() async {
    if (!_isInitialized) return;

    developer.log('🧹 AppInitializer: Disposing...', name: 'app_initializer');

    // Очистка в обратном порядке
    for (final feature in _initializedFeatures.reversed) {
      developer.log('🧹 AppInitializer: Disposing \$feature...', name: 'app_initializer');
      // Здесь можно добавить логику очистки для каждой фичи
      // ignore: unused_local_variable
      feature;
    }

    _initializedFeatures.clear();
    _isInitialized = false;

    developer.log('✅ AppInitializer: Disposed successfully', name: 'app_initializer');
  }

  /// Переинициализация (для hot reload или сброса состояния)
  Future<void> reinitialize() async {
    developer.log('🔄 AppInitializer: Reinitializing...', name: 'app_initializer');
    await dispose();
    await initialize();
  }
}
