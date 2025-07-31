// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nutry_flow/core/services/analytics_service.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/firebase_interfaces.dart';
import 'dart:developer' as developer;

class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._();
  static CrashlyticsService get instance => _instance;

  CrashlyticsService._();

  late FirebaseCrashlyticsInterface _crashlytics;
  bool _isInitialized = false;

  /// Инициализация сервиса Crashlytics
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log('🚨 CrashlyticsService: Initializing crashlytics service', name: 'CrashlyticsService');

      _crashlytics = MockFirebaseCrashlytics.instance;

      // Включаем сбор crash-отчетов
      await _crashlytics.setCrashlyticsCollectionEnabled(true);

      // Устанавливаем пользовательские данные
      await _setUserData();

      _isInitialized = true;
      developer.log('🚨 CrashlyticsService: Crashlytics service initialized successfully', name: 'CrashlyticsService');
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to initialize crashlytics service: $e', name: 'CrashlyticsService');
      rethrow;
    }
  }

  /// Установка пользовательских данных
  Future<void> _setUserData() async {
    try {
      final user = SupabaseService.instance.currentUser;
      if (user != null) {
        await _crashlytics.setUserIdentifier(user.id);
        await _crashlytics.setCustomKey('user_email', user.email ?? '');
        await _crashlytics.setCustomKey('user_id', user.id);
      }
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to set user data: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование ошибки
  Future<void> logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      if (!_isInitialized) {
        developer.log('🚨 CrashlyticsService: Crashlytics not initialized, logging to console', name: 'CrashlyticsService');
        developer.log('🚨 Error: $error', name: 'CrashlyticsService');
        if (stackTrace != null) {
          developer.log('🚨 Stack trace: $stackTrace', name: 'CrashlyticsService');
        }
        return;
      }

      developer.log('🚨 CrashlyticsService: Logging error: $error', name: 'CrashlyticsService');

      // Логируем в Crashlytics
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        information: additionalData?.entries.map((e) => '${e.key}: ${e.value}').toList() ?? [],
      );

      // Логируем в аналитику
      await AnalyticsService.instance.logError(
        errorType: error.runtimeType.toString(),
        errorMessage: error.toString(),
        additionalData: additionalData,
      );

      developer.log('🚨 CrashlyticsService: Error logged successfully', name: 'CrashlyticsService');
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log error: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование исключения
  Future<void> logException(
    Exception exception,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      if (!_isInitialized) {
        developer.log('🚨 CrashlyticsService: Crashlytics not initialized, logging to console', name: 'CrashlyticsService');
        developer.log('🚨 Exception: $exception', name: 'CrashlyticsService');
        if (stackTrace != null) {
          developer.log('🚨 Stack trace: $stackTrace', name: 'CrashlyticsService');
        }
        return;
      }

      developer.log('🚨 CrashlyticsService: Logging exception: $exception', name: 'CrashlyticsService');

      // Логируем в Crashlytics
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        information: additionalData?.entries.map((e) => '${e.key}: ${e.value}').toList() ?? [],
      );

      // Логируем в аналитику
      await AnalyticsService.instance.logError(
        errorType: exception.runtimeType.toString(),
        errorMessage: exception.toString(),
        additionalData: additionalData,
      );

      developer.log('🚨 CrashlyticsService: Exception logged successfully', name: 'CrashlyticsService');
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log exception: $e', name: 'CrashlyticsService');
    }
  }

  /// Установка пользовательского ключа
  Future<void> setCustomKey(String key, dynamic value) async {
    try {
      if (!_isInitialized) {
        developer.log('🚨 CrashlyticsService: Crashlytics not initialized, skipping custom key: $key', name: 'CrashlyticsService');
        return;
      }

      developer.log('🚨 CrashlyticsService: Setting custom key: $key = $value', name: 'CrashlyticsService');

      await _crashlytics.setCustomKey(key, value);

      developer.log('🚨 CrashlyticsService: Custom key set successfully: $key', name: 'CrashlyticsService');
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to set custom key $key: $e', name: 'CrashlyticsService');
    }
  }

  /// Установка пользовательского идентификатора
  Future<void> setUserIdentifier(String identifier) async {
    try {
      if (!_isInitialized) {
        developer.log('🚨 CrashlyticsService: Crashlytics not initialized, skipping user identifier', name: 'CrashlyticsService');
        return;
      }

      developer.log('🚨 CrashlyticsService: Setting user identifier: $identifier', name: 'CrashlyticsService');

      await _crashlytics.setUserIdentifier(identifier);

      developer.log('🚨 CrashlyticsService: User identifier set successfully', name: 'CrashlyticsService');
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to set user identifier: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование сообщения
  Future<void> log(String message) async {
    try {
      if (!_isInitialized) {
        developer.log('🚨 CrashlyticsService: Crashlytics not initialized, logging to console: $message', name: 'CrashlyticsService');
        return;
      }

      developer.log('🚨 CrashlyticsService: Logging message: $message', name: 'CrashlyticsService');

      await _crashlytics.log(message);

      developer.log('🚨 CrashlyticsService: Message logged successfully', name: 'CrashlyticsService');
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log message: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование ошибки API
  Future<void> logApiError({
    required String endpoint,
    required String method,
    required int statusCode,
    required String errorMessage,
    Map<String, dynamic>? requestData,
    Map<String, dynamic>? responseData,
  }) async {
    try {
      developer.log('🚨 CrashlyticsService: Logging API error: $method $endpoint - $statusCode', name: 'CrashlyticsService');

      await logError(
        'API Error: $method $endpoint returned $statusCode',
        null,
        reason: 'API request failed',
        additionalData: {
          'endpoint': endpoint,
          'method': method,
          'status_code': statusCode,
          'error_message': errorMessage,
          if (requestData != null) 'request_data': requestData,
          if (responseData != null) 'response_data': responseData,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log API error: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование ошибки базы данных
  Future<void> logDatabaseError({
    required String operation,
    required String table,
    required String errorMessage,
    Map<String, dynamic>? queryData,
  }) async {
    try {
      developer.log('🚨 CrashlyticsService: Logging database error: $operation on $table', name: 'CrashlyticsService');

      await logError(
        'Database Error: $operation on $table failed',
        null,
        reason: 'Database operation failed',
        additionalData: {
          'operation': operation,
          'table': table,
          'error_message': errorMessage,
          if (queryData != null) 'query_data': queryData,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log database error: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование ошибки аутентификации
  Future<void> logAuthError({
    required String operation,
    required String errorMessage,
    String? userId,
  }) async {
    try {
      developer.log('🚨 CrashlyticsService: Logging auth error: $operation', name: 'CrashlyticsService');

      await logError(
        'Auth Error: $operation failed',
        null,
        reason: 'Authentication operation failed',
        additionalData: {
          'operation': operation,
          'error_message': errorMessage,
          if (userId != null) 'user_id': userId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log auth error: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование ошибки UI
  Future<void> logUIError({
    required String screenName,
    required String widgetName,
    required String errorMessage,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      developer.log('🚨 CrashlyticsService: Logging UI error: $screenName - $widgetName', name: 'CrashlyticsService');

      await logError(
        'UI Error: $widgetName on $screenName',
        null,
        reason: 'UI component error',
        additionalData: {
          'screen_name': screenName,
          'widget_name': widgetName,
          'error_message': errorMessage,
          if (additionalData != null) ...additionalData,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log UI error: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование ошибки сети
  Future<void> logNetworkError({
    required String url,
    required String method,
    required String errorMessage,
    int? statusCode,
  }) async {
    try {
      developer.log('🚨 CrashlyticsService: Logging network error: $method $url', name: 'CrashlyticsService');

      await logError(
        'Network Error: $method $url failed',
        null,
        reason: 'Network request failed',
        additionalData: {
          'url': url,
          'method': method,
          'error_message': errorMessage,
          if (statusCode != null) 'status_code': statusCode,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log network error: $e', name: 'CrashlyticsService');
    }
  }

  /// Логирование ошибки производительности
  Future<void> logPerformanceError({
    required String metricName,
    required String errorMessage,
    double? expectedValue,
    double? actualValue,
  }) async {
    try {
      developer.log('🚨 CrashlyticsService: Logging performance error: $metricName', name: 'CrashlyticsService');

      await logError(
        'Performance Error: $metricName failed',
        null,
        reason: 'Performance metric error',
        additionalData: {
          'metric_name': metricName,
          'error_message': errorMessage,
          if (expectedValue != null) 'expected_value': expectedValue,
          if (actualValue != null) 'actual_value': actualValue,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      developer.log('🚨 CrashlyticsService: Failed to log performance error: $e', name: 'CrashlyticsService');
    }
  }

  /// Получение экземпляра FirebaseCrashlytics
  FirebaseCrashlyticsInterface get crashlytics => _crashlytics;

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;
} 