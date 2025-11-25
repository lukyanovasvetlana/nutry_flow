import 'package:shared_preferences/shared_preferences.dart';

/// Мок для SharedPreferences
/// 
/// Предоставляет статические методы для тестирования
/// без реальной инициализации плагина
class MockSharedPreferences {
  static final Map<String, dynamic> _storage = {};

  /// Инициализация мока
  static void initialize() {
    _storage.clear();
  }

  /// Получение экземпляра
  static Future<SharedPreferences> getInstance() async {
    return MockSharedPreferencesImpl();
  }

  /// Установка значений по умолчанию
  static void setMockInitialValues(Map<String, dynamic> values) {
    _storage.clear();
    _storage.addAll(values);
  }

  /// Получение значения
  static dynamic getValue(String key) {
    return _storage[key];
  }

  /// Установка значения
  static void setValue(String key, dynamic value) {
    _storage[key] = value;
  }

  /// Очистка хранилища
  static void clear() {
    _storage.clear();
  }
}

/// Реализация мока SharedPreferences
class MockSharedPreferencesImpl implements SharedPreferences {
  @override
  Set<String> getKeys() {
    return MockSharedPreferences._storage.keys.toSet();
  }

  @override
  dynamic get(String key) {
    return MockSharedPreferences._storage[key];
  }

  @override
  bool? getBool(String key) {
    final value = MockSharedPreferences._storage[key];
    return value is bool ? value : null;
  }

  @override
  int? getInt(String key) {
    final value = MockSharedPreferences._storage[key];
    return value is int ? value : null;
  }

  @override
  double? getDouble(String key) {
    final value = MockSharedPreferences._storage[key];
    return value is double ? value : null;
  }

  @override
  String? getString(String key) {
    final value = MockSharedPreferences._storage[key];
    return value is String ? value : null;
  }

  @override
  bool containsKey(String key) {
    return MockSharedPreferences._storage.containsKey(key);
  }

  @override
  Set<String> getStringSet(String key) {
    final value = MockSharedPreferences._storage[key];
    return value is Set<String> ? value : <String>{};
  }

  @override
  List<String>? getStringList(String key) {
    final value = MockSharedPreferences._storage[key];
    return value is List<String> ? value : null;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    MockSharedPreferences._storage[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    MockSharedPreferences._storage[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    MockSharedPreferences._storage[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    MockSharedPreferences._storage[key] = value;
    return true;
  }

  @override
  Future<bool> setStringSet(String key, Set<String> value) async {
    MockSharedPreferences._storage[key] = value;
    return true;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    MockSharedPreferences._storage[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    MockSharedPreferences._storage.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    MockSharedPreferences._storage.clear();
    return true;
  }

  @override
  Future<bool> reload() async {
    return true;
  }

  @override
  Future<bool> commit() async {
    // Mock implementation - no-op
    return true;
  }
}
