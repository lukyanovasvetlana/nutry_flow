import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:nutry_flow/core/architecture/app_initializer.dart';
import 'package:nutry_flow/core/architecture/app_router.dart';
import 'package:nutry_flow/core/architecture/app_state.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/local_cache_service.dart';
import 'package:nutry_flow/core/services/notification_service.dart';
import 'package:nutry_flow/core/services/monitoring_service.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:nutry_flow/features/analytics/presentation/utils/persona_analytics_tracker.dart';
import 'package:nutry_flow/shared/theme/theme_manager.dart';

/// Главный архитектурный класс приложения
/// Управляет инициализацией, состоянием и жизненным циклом приложения
class AppArchitecture {
  static final AppArchitecture _instance = AppArchitecture._internal();
  factory AppArchitecture() => _instance;
  AppArchitecture._internal();

  late final AppInitializer _initializer;
  late final AppRouter _router;
  late final AppState _state;
  late final GetIt _serviceLocator;

  /// Инициализация архитектуры приложения
  Future<void> initialize() async {
    try {
      print('🏗️ AppArchitecture: Starting initialization...');
      
      // Инициализация сервис-локатора
      _serviceLocator = GetIt.instance;
      _registerServices();
      
      // Инициализация основных сервисов
      await _initializeCoreServices();
      
      // Инициализация архитектурных компонентов
      _initializer = AppInitializer();
      _router = AppRouter();
      _state = AppState();
      
      // Инициализация зависимостей
      await _initializer.initialize();
      
      // Инициализация роутера
      await _router.initialize();
      
      // Инициализация состояния
      await _state.initialize();
      
      print('🏗️ AppArchitecture: Initialization completed successfully');
    } catch (e, stackTrace) {
      print('❌ AppArchitecture: Initialization failed: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Регистрация сервисов в GetIt
  void _registerServices() {
    print('🏗️ AppArchitecture: Registering services...');
    
    // Регистрируем основные сервисы как синглтоны
    _serviceLocator.registerSingleton<SupabaseService>(SupabaseService.instance);
    _serviceLocator.registerSingleton<LocalCacheService>(LocalCacheService.instance);
    _serviceLocator.registerSingleton<NotificationService>(NotificationService.instance);
    _serviceLocator.registerSingleton<MonitoringService>(MonitoringService.instance);
    _serviceLocator.registerSingleton<ABTestingService>(ABTestingService.instance);
    _serviceLocator.registerSingleton<PersonaAnalyticsTracker>(PersonaAnalyticsTracker.instance);
    _serviceLocator.registerSingleton<ThemeManager>(ThemeManager());
    
    print('🏗️ AppArchitecture: Services registered successfully');
  }

  /// Инициализация основных сервисов
  Future<void> _initializeCoreServices() async {
    print('🏗️ AppArchitecture: Initializing core services...');
    
    await SupabaseService.instance.initialize();
    await LocalCacheService.instance.initialize();
    await NotificationService.instance.initialize();
    await MonitoringService.instance.initialize();
    await ABTestingService.instance.initialize();
    await PersonaAnalyticsTracker.instance.initialize();
    await ThemeManager().initialize();
    
    print('🏗️ AppArchitecture: Core services initialized successfully');
  }

  /// Получение экземпляра инициализатора
  AppInitializer get initializer => _initializer;
  
  /// Получение экземпляра роутера
  AppRouter get router => _router;
  
  /// Получение экземпляра состояния
  AppState get state => _state;
  
  /// Получение сервис-локатора
  GetIt get serviceLocator => _serviceLocator;

  /// Проверка готовности архитектуры
  bool get isInitialized => 
      _initializer.isInitialized && 
      _router.isInitialized && 
      _state.isInitialized;

  /// Очистка ресурсов
  Future<void> dispose() async {
    print('🏗️ AppArchitecture: Disposing...');
    
    await _state.dispose();
    await _router.dispose();
    await _initializer.dispose();
    
    print('🏗️ AppArchitecture: Disposed successfully');
  }

  /// Создание главного виджета приложения
  Widget createApp() {
    if (!isInitialized) {
      throw StateError('AppArchitecture is not initialized. Call initialize() first.');
    }
    
    return MultiProvider(
      providers: [
        ..._state.globalProviders,
        ..._state.globalBlocProviders,
      ],
      child: _router.createApp(),
    );
  }
}
