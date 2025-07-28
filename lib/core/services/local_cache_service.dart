import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class LocalCacheService {
  static LocalCacheService? _instance;
  static LocalCacheService get instance => _instance ??= LocalCacheService._();

  LocalCacheService._();
  
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  /// Инициализация SharedPreferences
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      developer.log('🟦 LocalCacheService: Initialized successfully', name: 'LocalCacheService');
    } catch (e) {
      developer.log('🟦 LocalCacheService: Initialization failed: $e', name: 'LocalCacheService');
      rethrow;
    }
  }

  /// Проверка инициализации
  bool get isInitialized => _isInitialized && _prefs != null;

  /// Сохранение данных пользователя
  Future<void> saveUserData(String key, Map<String, dynamic> data) async {
    if (!isInitialized) {
      developer.log('🟦 LocalCacheService: Not initialized', name: 'LocalCacheService');
      return;
    }

    try {
      final jsonString = jsonEncode(data);
      await _prefs!.setString(key, jsonString);
      developer.log('🟦 LocalCacheService: Saved data for key: $key', name: 'LocalCacheService');
    } catch (e) {
      developer.log('🟦 LocalCacheService: Save failed for key $key: $e', name: 'LocalCacheService');
      rethrow;
    }
  }

  /// Получение данных пользователя
  Future<Map<String, dynamic>?> getUserData(String key) async {
    if (!isInitialized) {
      developer.log('🟦 LocalCacheService: Not initialized', name: 'LocalCacheService');
      return null;
    }

    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString != null) {
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        developer.log('🟦 LocalCacheService: Retrieved data for key: $key', name: 'LocalCacheService');
        return data;
      }
      return null;
    } catch (e) {
      developer.log('🟦 LocalCacheService: Get failed for key $key: $e', name: 'LocalCacheService');
      return null;
    }
  }

  /// Сохранение списка данных
  Future<void> saveDataList(String key, List<Map<String, dynamic>> dataList) async {
    if (!isInitialized) {
      developer.log('🟦 LocalCacheService: Not initialized', name: 'LocalCacheService');
      return;
    }

    try {
      final jsonString = jsonEncode(dataList);
      await _prefs!.setString(key, jsonString);
      developer.log('🟦 LocalCacheService: Saved list data for key: $key (${dataList.length} items)', name: 'LocalCacheService');
    } catch (e) {
      developer.log('🟦 LocalCacheService: Save list failed for key $key: $e', name: 'LocalCacheService');
      rethrow;
    }
  }

  /// Получение списка данных
  Future<List<Map<String, dynamic>>> getDataList(String key) async {
    if (!isInitialized) {
      developer.log('🟦 LocalCacheService: Not initialized', name: 'LocalCacheService');
      return [];
    }

    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString != null) {
        final dataList = jsonDecode(jsonString) as List;
        final result = dataList.map((item) => item as Map<String, dynamic>).toList();
        developer.log('🟦 LocalCacheService: Retrieved list data for key: $key (${result.length} items)', name: 'LocalCacheService');
        return result;
      }
      return [];
    } catch (e) {
      developer.log('🟦 LocalCacheService: Get list failed for key $key: $e', name: 'LocalCacheService');
      return [];
    }
  }

  /// Сохранение простого значения
  Future<void> saveValue(String key, dynamic value) async {
    if (!isInitialized) {
      developer.log('🟦 LocalCacheService: Not initialized', name: 'LocalCacheService');
      return;
    }

    try {
      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else {
        await _prefs!.setString(key, jsonEncode(value));
      }
      developer.log('🟦 LocalCacheService: Saved value for key: $key', name: 'LocalCacheService');
    } catch (e) {
      developer.log('🟦 LocalCacheService: Save value failed for key $key: $e', name: 'LocalCacheService');
      rethrow;
    }
  }

  /// Получение простого значения
  T? getValue<T>(String key) {
    if (!isInitialized) {
      developer.log('🟦 LocalCacheService: Not initialized', name: 'LocalCacheService');
      return null;
    }

    try {
      final value = _prefs!.get(key);
      developer.log('🟦 LocalCacheService: Retrieved value for key: $key', name: 'LocalCacheService');
      return value as T?;
    } catch (e) {
      developer.log('🟦 LocalCacheService: Get value failed for key $key: $e', name: 'LocalCacheService');
      return null;
    }
  }

  /// Удаление данных
  Future<void> removeData(String key) async {
    if (!isInitialized) {
      developer.log('🟦 LocalCacheService: Not initialized', name: 'LocalCacheService');
      return;
    }

    try {
      await _prefs!.remove(key);
      developer.log('🟦 LocalCacheService: Removed data for key: $key', name: 'LocalCacheService');
    } catch (e) {
      developer.log('🟦 LocalCacheService: Remove failed for key $key: $e', name: 'LocalCacheService');
      rethrow;
    }
  }

  /// Очистка всех данных
  Future<void> clearAll() async {
    if (!isInitialized) {
      developer.log('🟦 LocalCacheService: Not initialized', name: 'LocalCacheService');
      return;
    }

    try {
      await _prefs!.clear();
      developer.log('🟦 LocalCacheService: Cleared all data', name: 'LocalCacheService');
    } catch (e) {
      developer.log('🟦 LocalCacheService: Clear all failed: $e', name: 'LocalCacheService');
      rethrow;
    }
  }

  /// Проверка наличия ключа
  bool hasKey(String key) {
    if (!isInitialized) {
      return false;
    }
    return _prefs!.containsKey(key);
  }

  /// Получение всех ключей
  Set<String> getAllKeys() {
    if (!isInitialized) {
      return {};
    }
    return _prefs!.getKeys();
  }

  /// Получение размера кэша (приблизительно)
  int getCacheSize() {
    if (!isInitialized) {
      return 0;
    }
    return _prefs!.getKeys().length;
  }

  /// Проверка срока действия кэша
  bool isCacheValid(String key, Duration maxAge) {
    if (!isInitialized) {
      return false;
    }

    try {
      final timestampKey = '${key}_timestamp';
      final timestamp = _prefs!.getInt(timestampKey);
      if (timestamp == null) {
        return false;
      }

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final isValid = now.difference(cacheTime) < maxAge;

      developer.log('🟦 LocalCacheService: Cache validity for $key: $isValid', name: 'LocalCacheService');
      return isValid;
    } catch (e) {
      developer.log('🟦 LocalCacheService: Cache validity check failed for $key: $e', name: 'LocalCacheService');
      return false;
    }
  }

  /// Сохранение данных с временной меткой
  Future<void> saveDataWithTimestamp(String key, Map<String, dynamic> data) async {
    if (!isInitialized) {
      return;
    }

    try {
      await saveUserData(key, data);
      final timestampKey = '${key}_timestamp';
      await _prefs!.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
      developer.log('🟦 LocalCacheService: Saved data with timestamp for key: $key', name: 'LocalCacheService');
    } catch (e) {
      developer.log('🟦 LocalCacheService: Save with timestamp failed for key $key: $e', name: 'LocalCacheService');
      rethrow;
    }
  }

  /// Получение данных с проверкой срока действия
  Future<Map<String, dynamic>?> getDataWithTimestamp(String key, Duration maxAge) async {
    if (!isCacheValid(key, maxAge)) {
      developer.log('🟦 LocalCacheService: Cache expired for key: $key', name: 'LocalCacheService');
      return null;
    }

    return await getUserData(key);
  }
} 