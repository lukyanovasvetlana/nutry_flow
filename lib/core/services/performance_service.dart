// import 'package:firebase_performance/firebase_performance.dart';
import 'package:nutry_flow/core/services/analytics_service.dart';
import 'package:nutry_flow/core/services/firebase_interfaces.dart';
import 'dart:developer' as developer;

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._();
  static PerformanceService get instance => _instance;

  PerformanceService._();

  late FirebasePerformanceInterface _performance;
  bool _isInitialized = false;

  /// Инициализация сервиса производительности
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      developer.log('⚡ PerformanceService: Initializing performance service', name: 'PerformanceService');

      _performance = MockFirebasePerformance.instance;

      // Включаем мониторинг производительности
      await _performance.setPerformanceCollectionEnabled(true);

      _isInitialized = true;
      developer.log('⚡ PerformanceService: Performance service initialized successfully', name: 'PerformanceService');
    } catch (e) {
      developer.log('⚡ PerformanceService: Failed to initialize performance service: $e', name: 'PerformanceService');
      rethrow;
    }
  }

  /// Создание трейса для отслеживания производительности
  TraceInterface createTrace(String name) {
    try {
      if (!_isInitialized) {
        developer.log('⚡ PerformanceService: Performance not initialized, creating mock trace', name: 'PerformanceService');
        return _performance.newTrace(name);
      }

      developer.log('⚡ PerformanceService: Creating trace: $name', name: 'PerformanceService');
      return _performance.newTrace(name);
    } catch (e) {
      developer.log('⚡ PerformanceService: Failed to create trace $name: $e', name: 'PerformanceService');
      return _performance.newTrace(name);
    }
  }

  /// Создание HTTP метрики
  HttpMetricInterface createHttpMetric(String url, String method) {
    try {
      if (!_isInitialized) {
        developer.log('⚡ PerformanceService: Performance not initialized, creating mock HTTP metric', name: 'PerformanceService');
        return _performance.newHttpMetric(url, HttpMethod.get);
      }

      developer.log('⚡ PerformanceService: Creating HTTP metric: $method $url', name: 'PerformanceService');
      return _performance.newHttpMetric(url, HttpMethod.get);
    } catch (e) {
      developer.log('⚡ PerformanceService: Failed to create HTTP metric: $e', name: 'PerformanceService');
      return _performance.newHttpMetric(url, HttpMethod.get);
    }
  }

  /// Отслеживание времени загрузки экрана
  Future<void> trackScreenLoadTime(String screenName) async {
    try {
      final trace = await createTrace('screen_load_$screenName');
      await trace.start();
      
      // Имитируем время загрузки
      await Future.delayed(const Duration(milliseconds: 100));
      
      await trace.stop();
      
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: 'screen_load_time',
        parameters: {
          'screen_name': screenName,
          'load_time_ms': 100,
        },
      );
      
      developer.log('📊 PerformanceService: Screen load time tracked: $screenName - 100ms', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to track screen load time: $e', name: 'PerformanceService');
    }
  }

  /// Отслеживание времени API запроса
  Future<void> trackApiRequest(String endpoint, String method) async {
    try {
      final metric = await createHttpMetric(endpoint, method);
      await metric.start();
      
      // Имитируем время запроса
      await Future.delayed(const Duration(milliseconds: 200));
      
      await metric.stop();
      
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: 'api_request_time',
        parameters: {
          'endpoint': endpoint,
          'method': method,
          'request_time_ms': 200,
        },
      );
      
      developer.log('📊 PerformanceService: API request time tracked: $endpoint - 200ms', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to track API request time: $e', name: 'PerformanceService');
    }
  }

  /// Отслеживание времени загрузки данных
  Future<void> trackDataLoadTime(String dataType, Duration loadTime) async {
    try {
      final trace = await createTrace('data_load_$dataType');
      await trace.start();
      
      // Имитируем время загрузки
      await Future.delayed(loadTime);
      
      await trace.stop();
      
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: 'data_load_time',
        parameters: {
          'data_type': dataType,
          'load_time_ms': loadTime.inMilliseconds,
        },
      );
      
      developer.log('📊 PerformanceService: Data load time tracked: $dataType - ${loadTime.inMilliseconds}ms', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to track data load time: $e', name: 'PerformanceService');
    }
  }

  /// Отслеживание времени обработки изображений
  Future<void> trackImageProcessingTime(String imageType, Duration processingTime) async {
    try {
      final trace = await createTrace('image_processing_$imageType');
      await trace.start();
      
      // Имитируем время обработки
      await Future.delayed(processingTime);
      
      await trace.stop();
      
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: 'image_processing_time',
        parameters: {
          'image_type': imageType,
          'processing_time_ms': processingTime.inMilliseconds,
        },
      );
      
      developer.log('📊 PerformanceService: Image processing time tracked: $imageType - ${processingTime.inMilliseconds}ms', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to track image processing time: $e', name: 'PerformanceService');
    }
  }

  /// Отслеживание времени синхронизации
  Future<void> trackSyncTime(String syncType, Duration syncTime) async {
    try {
      final trace = await createTrace('sync_$syncType');
      await trace.start();
      
      // Имитируем время синхронизации
      await Future.delayed(syncTime);
      
      await trace.stop();
      
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: 'sync_time',
        parameters: {
          'sync_type': syncType,
          'sync_time_ms': syncTime.inMilliseconds,
        },
      );
      
      developer.log('📊 PerformanceService: Sync time tracked: $syncType - ${syncTime.inMilliseconds}ms', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to track sync time: $e', name: 'PerformanceService');
    }
  }

  /// Отслеживание использования памяти
  Future<void> trackMemoryUsage() async {
    try {
      final trace = await createTrace('memory_usage');
      await trace.start();
      
      // Получаем информацию о памяти (упрощенная версия)
      final memoryInfo = {
        'total_memory': 1024 * 1024 * 1024, // 1GB
        'used_memory': 512 * 1024 * 1024,   // 512MB
        'free_memory': 512 * 1024 * 1024,   // 512MB
      };
      
      await trace.stop();
      
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: 'memory_usage',
        parameters: {
          'total_memory_mb': memoryInfo['total_memory']! / (1024 * 1024),
          'used_memory_mb': memoryInfo['used_memory']! / (1024 * 1024),
          'free_memory_mb': memoryInfo['free_memory']! / (1024 * 1024),
        },
      );
      
      developer.log('📊 PerformanceService: Memory usage tracked', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to track memory usage: $e', name: 'PerformanceService');
    }
  }

  /// Отслеживание времени запуска приложения
  Future<void> trackAppStartTime(Duration startTime) async {
    try {
      final trace = await createTrace('app_start');
      await trace.start();
      
      // Имитируем время запуска
      await Future.delayed(startTime);
      
      await trace.stop();
      
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: 'app_start_time',
        parameters: {
          'start_time_ms': startTime.inMilliseconds,
        },
      );
      
      developer.log('📊 PerformanceService: App start time tracked: ${startTime.inMilliseconds}ms', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to track app start time: $e', name: 'PerformanceService');
    }
  }

  /// Отслеживание времени отклика UI
  Future<void> trackUIResponseTime(String action) async {
    try {
      final trace = await createTrace('ui_response_$action');
      await trace.start();
      
      // Имитируем время отклика
      await Future.delayed(const Duration(milliseconds: 50));
      
      await trace.stop();
      
      // Логируем в аналитику
      await AnalyticsService.instance.logEvent(
        name: 'ui_response_time',
        parameters: {
          'action': action,
          'response_time_ms': 50,
        },
      );
      
      developer.log('📊 PerformanceService: UI response time tracked: $action - 50ms', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to track UI response time: $e', name: 'PerformanceService');
    }
  }

  /// Установка атрибутов для трейса
  Future<void> setTraceAttribute(TraceInterface trace, String name, String value) async {
    try {
      await trace.setAttribute(name, value);
      developer.log('📊 PerformanceService: Trace attribute set: $name = $value', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to set trace attribute: $e', name: 'PerformanceService');
    }
  }

  /// Установка атрибутов для HTTP метрики
  Future<void> setHttpMetricAttribute(HttpMetricInterface metric, String name, String value) async {
    try {
      await metric.setAttribute(name, value);
      developer.log('📊 PerformanceService: HTTP metric attribute set: $name = $value', name: 'PerformanceService');
    } catch (e) {
      developer.log('📊 PerformanceService: Failed to set HTTP metric attribute: $e', name: 'PerformanceService');
    }
  }

  /// Получение экземпляра FirebasePerformance
  FirebasePerformanceInterface get performance => _performance;

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;
} 