import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_performance/firebase_performance.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nutry_flow/core/services/analytics_service.dart';
// Временно отключены из-за проблем с модульными заголовками в iOS
// import 'package:nutry_flow/core/services/crashlytics_service.dart';
// import 'package:nutry_flow/core/services/performance_service.dart';
// import 'package:nutry_flow/core/services/ab_testing_service.dart';
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
      try {
        await Firebase.initializeApp();
        developer.log('🔥 FirebaseService: Firebase Core initialized',
            name: 'FirebaseService');
      } catch (e) {
        developer.log(
            '🔥 FirebaseService: Failed to initialize Firebase Core: $e',
            name: 'FirebaseService');
        // Продолжаем работу без Firebase, если инициализация не удалась
        return;
      }

      // Инициализация Firebase Analytics
      await _initializeAnalytics();

      // Временно отключены из-за проблем с модульными заголовками в iOS
      // Инициализация Firebase Crashlytics
      // await _initializeCrashlytics();

      // Инициализация Firebase Performance
      // await _initializePerformance();

      // Инициализация Firebase Remote Config
      // await _initializeRemoteConfig();

      _isInitialized = true;

      developer.log('🔥 FirebaseService: Firebase initialized successfully',
          name: 'FirebaseService');
    } catch (e, stackTrace) {
      developer.log(
          '🔥 FirebaseService: Failed to initialize Firebase: $e\n$stackTrace',
          name: 'FirebaseService');
      // Не выбрасываем исключение, чтобы приложение могло работать без Firebase
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
