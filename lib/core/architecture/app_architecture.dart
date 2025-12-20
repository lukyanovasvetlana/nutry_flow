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
import 'dart:developer' as developer;

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
      developer.log('🏗️ AppArchitecture: Starting initialization...', name: 'app_architecture');

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

      developer.log('🏗️ AppArchitecture: Initialization completed successfully', name: 'app_architecture');
    } catch (e, stackTrace) {
      developer.log('❌ AppArchitecture: Initialization failed: \$e', name: 'app_architecture');
      developer.log('❌ Stack trace: \$stackTrace', name: 'app_architecture');
      rethrow;
    }
  }

  /// Регистрация сервисов в GetIt
  void _registerServices() {
    developer.log('🏗️ AppArchitecture: Registering services...', name: 'app_architecture');

    // Регистрируем основные сервисы как синглтоны
    _serviceLocator
        .registerSingleton<SupabaseService>(SupabaseService.instance);
    _serviceLocator
        .registerSingleton<LocalCacheService>(LocalCacheService.instance);
    _serviceLocator
        .registerSingleton<NotificationService>(NotificationService.instance);
    _serviceLocator
        .registerSingleton<MonitoringService>(MonitoringService.instance);
    _serviceLocator
        .registerSingleton<ABTestingService>(ABTestingService.instance);
    _serviceLocator.registerSingleton<PersonaAnalyticsTracker>(
        PersonaAnalyticsTracker.instance);
    _serviceLocator.registerSingleton<ThemeManager>(ThemeManager());

    developer.log('🏗️ AppArchitecture: Services registered successfully', name: 'app_architecture');
  }

  /// Инициализация основных сервисов
  Future<void> _initializeCoreServices() async {
    developer.log('🏗️ AppArchitecture: Initializing core services...', name: 'app_architecture');

    await SupabaseService.instance.initialize();
    await LocalCacheService.instance.initialize();
    await NotificationService.instance.initialize();
    await MonitoringService.instance.initialize();
    await ABTestingService.instance.initialize();
    await PersonaAnalyticsTracker.instance.initialize();
    // ThemeManager теперь инициализируется синхронно при создании

    developer.log('🏗️ AppArchitecture: Core services initialized successfully', name: 'app_architecture');
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
    developer.log('🏗️ AppArchitecture: Disposing...', name: 'app_architecture');

    await _state.dispose();
    await _router.dispose();
    await _initializer.dispose();

    developer.log('🏗️ AppArchitecture: Disposed successfully', name: 'app_architecture');
  }

  /// Создание главного виджета приложения
  Widget createApp() {
    if (!isInitialized) {
      throw StateError(
          'AppArchitecture is not initialized. Call initialize() first.');
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
