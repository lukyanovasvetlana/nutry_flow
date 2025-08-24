// Abstract interfaces for Firebase services to enable testing without Firebase dependencies

abstract class FirebaseRemoteConfigInterface {
  static FirebaseRemoteConfigInterface get instance =>
      throw UnimplementedError();

  Future<void> setConfigSettings(RemoteConfigSettings settings);
  Future<void> setDefaults(Map<String, dynamic> defaults);
  Future<bool> fetchAndActivate();

  String getString(String key);
  double getDouble(String key);
  bool getBool(String key);

  DateTime get lastFetchTime;
  RemoteConfigFetchStatus get lastFetchStatus;
}

abstract class FirebaseAnalyticsInterface {
  static FirebaseAnalyticsInterface get instance => throw UnimplementedError();

  Future<void> initialize();
  Future<void> setAnalyticsCollectionEnabled(bool enabled);
  Future<void> logEvent(
      {required String name, Map<String, dynamic>? parameters});
  Future<void> logScreenView({required String screenName, String? screenClass});
  Future<void> setUserProperty({required String name, required String value});

  // Дополнительные методы для аналитики
  Future<void> logLogin({required String loginMethod});
  Future<void> logSignUp({required String signUpMethod});
  Future<void> logAddToCart({
    required List<CustomAnalyticsEventItem> items,
    required String currency,
    required double value,
  });
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    required List<CustomAnalyticsEventItem> items,
  });
  Future<void> logSearch({required String searchTerm});
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  });
}

// Класс для элементов аналитики
class CustomAnalyticsEventItem {
  final String itemId;
  final String itemName;
  final String itemCategory;
  final double price;
  final int quantity;

  const CustomAnalyticsEventItem({
    required this.itemId,
    required this.itemName,
    required this.itemCategory,
    required this.price,
    required this.quantity,
  });
}

// Mock implementations for testing
class MockFirebaseRemoteConfig implements FirebaseRemoteConfigInterface {
  static final MockFirebaseRemoteConfig _instance =
      MockFirebaseRemoteConfig._();
  static MockFirebaseRemoteConfig get instance => _instance;

  MockFirebaseRemoteConfig._();

  final Map<String, dynamic> _defaults = {};
  final Map<String, dynamic> _values = {};

  @override
  Future<void> setConfigSettings(RemoteConfigSettings settings) async {}

  @override
  Future<void> setDefaults(Map<String, dynamic> defaults) async {
    _defaults.addAll(defaults);
  }

  @override
  Future<bool> fetchAndActivate() async => true;

  @override
  String getString(String key) {
    return _values[key] ?? _defaults[key] ?? '';
  }

  @override
  double getDouble(String key) {
    return _values[key] ?? _defaults[key] ?? 0.0;
  }

  @override
  bool getBool(String key) {
    return _values[key] ?? _defaults[key] ?? false;
  }

  @override
  DateTime get lastFetchTime => DateTime.now();

  @override
  RemoteConfigFetchStatus get lastFetchStatus =>
      RemoteConfigFetchStatus.success;

  // Helper method for testing
  void setValue(String key, dynamic value) {
    _values[key] = value;
  }

  // Helper method to check if key exists
  bool hasKey(String key) {
    return _values.containsKey(key) || _defaults.containsKey(key);
  }
}

class MockFirebaseAnalytics implements FirebaseAnalyticsInterface {
  static final MockFirebaseAnalytics _instance = MockFirebaseAnalytics._();
  static MockFirebaseAnalytics get instance => _instance;

  MockFirebaseAnalytics._();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {}

  @override
  Future<void> logEvent(
      {required String name, Map<String, dynamic>? parameters}) async {}

  @override
  Future<void> logScreenView(
      {required String screenName, String? screenClass}) async {}

  @override
  Future<void> setUserProperty(
      {required String name, required String value}) async {}

  @override
  Future<void> logLogin({required String loginMethod}) async {}

  @override
  Future<void> logSignUp({required String signUpMethod}) async {}

  @override
  Future<void> logAddToCart({
    required List<CustomAnalyticsEventItem> items,
    required String currency,
    required double value,
  }) async {}

  @override
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    required List<CustomAnalyticsEventItem> items,
  }) async {}

  @override
  Future<void> logSearch({required String searchTerm}) async {}

  @override
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {}
}

// Remote Config Settings class
class RemoteConfigSettings {
  final Duration fetchTimeout;
  final Duration minimumFetchInterval;

  const RemoteConfigSettings({
    required this.fetchTimeout,
    required this.minimumFetchInterval,
  });
}

// Remote Config Fetch Status enum
enum RemoteConfigFetchStatus {
  noFetchYet,
  success,
  failure,
  throttled,
}

// Performance interfaces
abstract class FirebasePerformanceInterface {
  static FirebasePerformanceInterface get instance =>
      throw UnimplementedError();

  Future<void> setPerformanceCollectionEnabled(bool enabled);
  TraceInterface newTrace(String name);
  HttpMetricInterface newHttpMetric(String url, HttpMethod method);
}

abstract class TraceInterface {
  Future<void> start();
  Future<void> stop();
  Future<void> setAttribute(String name, String value);
}

abstract class HttpMetricInterface {
  Future<void> start();
  Future<void> stop();
  Future<void> setAttribute(String name, String value);
}

enum HttpMethod {
  get,
  post,
  put,
  delete,
  patch,
}

// Mock implementations for Performance
class MockFirebasePerformance implements FirebasePerformanceInterface {
  static final MockFirebasePerformance _instance = MockFirebasePerformance._();
  static MockFirebasePerformance get instance => _instance;

  MockFirebasePerformance._();

  @override
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {}

  @override
  TraceInterface newTrace(String name) {
    return MockTrace(name);
  }

  @override
  HttpMetricInterface newHttpMetric(String url, HttpMethod method) {
    return MockHttpMetric(url, method);
  }
}

class MockTrace implements TraceInterface {
  final String name;

  MockTrace(this.name);

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> setAttribute(String name, String value) async {}
}

class MockHttpMetric implements HttpMetricInterface {
  final String url;
  final HttpMethod method;

  MockHttpMetric(this.url, this.method);

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> setAttribute(String name, String value) async {}
}

// Crashlytics interfaces
abstract class FirebaseCrashlyticsInterface {
  static FirebaseCrashlyticsInterface get instance =>
      throw UnimplementedError();

  Future<void> setCrashlyticsCollectionEnabled(bool enabled);
  Future<void> setUserIdentifier(String identifier);
  Future<void> setCustomKey(String key, dynamic value);
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    List<String>? information,
  });
  Future<void> log(String message);
}

// Mock implementation for Crashlytics
class MockFirebaseCrashlytics implements FirebaseCrashlyticsInterface {
  static final MockFirebaseCrashlytics _instance = MockFirebaseCrashlytics._();
  static MockFirebaseCrashlytics get instance => _instance;

  MockFirebaseCrashlytics._();

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setUserIdentifier(String identifier) async {}

  @override
  Future<void> setCustomKey(String key, dynamic value) async {}

  @override
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    List<String>? information,
  }) async {}

  @override
  Future<void> log(String message) async {}
}
