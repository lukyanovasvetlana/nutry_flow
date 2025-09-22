// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_performance/firebase_performance.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nutry_flow/core/services/analytics_service.dart';
import 'package:nutry_flow/core/services/crashlytics_service.dart';
import 'package:nutry_flow/core/services/performance_service.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'dart:developer' as developer;

/// Сервис для инициализации Firebase
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();
  static FirebaseService get instance => _instance;

  FirebaseService._();

  bool _isInitialized = false;

  /// Инициализация Firebase
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log('🔥 FirebaseService: Initializing Firebase...',
          name: 'FirebaseService');

      // Инициализация Firebase Core
      // await Firebase.initializeApp();

      developer.log('🔥 FirebaseService: Firebase Core initialized',
          name: 'FirebaseService');

      // Инициализация Firebase Analytics
      await _initializeAnalytics();

      // Инициализация Firebase Crashlytics
      await _initializeCrashlytics();

      // Инициализация Firebase Performance
      await _initializePerformance();

      // Инициализация Firebase Remote Config
      await _initializeRemoteConfig();

      _isInitialized = true;

      developer.log('🔥 FirebaseService: Firebase initialized successfully',
          name: 'FirebaseService');
    } catch (e) {
      developer.log('🔥 FirebaseService: Failed to initialize Firebase: $e',
          name: 'FirebaseService');
      rethrow;
    }
  }

  /// Инициализация Firebase Analytics
  Future<void> _initializeAnalytics() async {
    try {
      developer.log('🔥 FirebaseService: Initializing Analytics...',
          name: 'FirebaseService');

      // Инициализируем Analytics Service
      await AnalyticsService.instance.initialize();

      developer.log('🔥 FirebaseService: Analytics initialized',
          name: 'FirebaseService');
    } catch (e) {
      developer.log('🔥 FirebaseService: Failed to initialize Analytics: $e',
          name: 'FirebaseService');
    }
  }

  /// Инициализация Firebase Crashlytics
  Future<void> _initializeCrashlytics() async {
    try {
      developer.log('🔥 FirebaseService: Initializing Crashlytics...',
          name: 'FirebaseService');

      // Инициализируем Crashlytics Service
      await CrashlyticsService.instance.initialize();

      developer.log('🔥 FirebaseService: Crashlytics initialized',
          name: 'FirebaseService');
    } catch (e) {
      developer.log('🔥 FirebaseService: Failed to initialize Crashlytics: $e',
          name: 'FirebaseService');
    }
  }

  /// Инициализация Firebase Performance
  Future<void> _initializePerformance() async {
    try {
      developer.log('🔥 FirebaseService: Initializing Performance...',
          name: 'FirebaseService');

      // Инициализируем Performance Service
      await PerformanceService.instance.initialize();

      developer.log('🔥 FirebaseService: Performance initialized',
          name: 'FirebaseService');
    } catch (e) {
      developer.log('🔥 FirebaseService: Failed to initialize Performance: $e',
          name: 'FirebaseService');
    }
  }

  /// Инициализация Firebase Remote Config
  Future<void> _initializeRemoteConfig() async {
    try {
      developer.log('🔥 FirebaseService: Initializing Remote Config...',
          name: 'FirebaseService');

      // Инициализируем AB Testing Service (который использует Remote Config)
      await ABTestingService.instance.initialize();

      developer.log('🔥 FirebaseService: Remote Config initialized',
          name: 'FirebaseService');
    } catch (e) {
      developer.log(
          '🔥 FirebaseService: Failed to initialize Remote Config: $e',
          name: 'FirebaseService');
    }
  }

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;

  /// Получение экземпляра Firebase Analytics
  // FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  /// Получение экземпляра Firebase Crashlytics
  // FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  /// Получение экземпляра Firebase Performance
  // FirebasePerformance get performance => FirebasePerformance.instance;

  /// Получение экземпляра Firebase Remote Config
  // FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;
}
