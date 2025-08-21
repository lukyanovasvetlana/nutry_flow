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

/// Класс для инициализации всех зависимостей приложения
class AppInitializer {
  bool _isInitialized = false;
  final List<String> _initializedFeatures = [];

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;

  /// Список инициализированных фич
  List<String> get initializedFeatures => List.unmodifiable(_initializedFeatures);

  /// Инициализация всех зависимостей
  Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️ AppInitializer: Already initialized');
      return;
    }

    try {
      print('🚀 AppInitializer: Starting feature dependencies initialization...');
      
      // Инициализация фич в определенном порядке
      await _initializeFeatureDependencies();
      
      _isInitialized = true;
      print('✅ AppInitializer: All dependencies initialized successfully');
      print('📋 AppInitializer: Initialized features: $_initializedFeatures');
      
    } catch (e, stackTrace) {
      print('❌ AppInitializer: Initialization failed: $e');
      print('❌ Stack trace: $stackTrace');
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
  Future<void> _initializeFeature(String featureName, Future<void> Function() initializer) async {
    try {
      print('🔄 AppInitializer: Initializing $featureName...');
      await initializer();
      _initializedFeatures.add(featureName);
      print('✅ AppInitializer: $featureName initialized successfully');
    } catch (e) {
      print('❌ AppInitializer: Failed to initialize $featureName: $e');
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
      'Onboarding', 'Auth', 'Profile', 'Nutrition', 'Menu', 
      'MealPlan', 'GroceryList', 'Calendar', 'Exercise', 'Analytics'
    ];
    
    return Map.fromEntries(
      allFeatures.map((feature) => MapEntry(
        feature, 
        _initializedFeatures.contains(feature)
      ))
    );
  }

  /// Очистка ресурсов
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    print('🧹 AppInitializer: Disposing...');
    
    // Очистка в обратном порядке
    for (final feature in _initializedFeatures.reversed) {
      print('🧹 AppInitializer: Disposing $feature...');
      // Здесь можно добавить логику очистки для каждой фичи
    }
    
    _initializedFeatures.clear();
    _isInitialized = false;
    
    print('✅ AppInitializer: Disposed successfully');
  }

  /// Переинициализация (для hot reload или сброса состояния)
  Future<void> reinitialize() async {
    print('🔄 AppInitializer: Reinitializing...');
    await dispose();
    await initialize();
  }
}
