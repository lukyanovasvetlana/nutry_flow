import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/local_cache_service.dart';
import 'dart:developer' as developer;

class SyncService {
  static SyncService? _instance;
  static SyncService get instance => _instance ??= SyncService._();

  SyncService._();

  final SupabaseService _supabaseService = SupabaseService.instance;
  final LocalCacheService _localCache = LocalCacheService.instance;

  /// Синхронизация данных с конфликт-резолюшн
  Future<SyncResult> syncData<T>({
    required String tableName,
    required String cacheKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    Duration cacheValidity = const Duration(hours: 1),
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.serverWins,
  }) async {
    try {
      developer.log('🔄 SyncService: Starting sync for $tableName', name: 'SyncService');

      // Проверяем доступность Supabase
      if (!_supabaseService.isAvailable) {
        developer.log('🔄 SyncService: Supabase not available, using local cache', name: 'SyncService');
        return await _getFromLocalCache<T>(cacheKey, fromJson);
      }

      // Получаем данные из Supabase
      final serverData = await _getFromServer(tableName);
      
      // Получаем данные из локального кэша
      final localData = await _getFromLocalCache<T>(cacheKey, fromJson);

      // Разрешаем конфликты
      final resolvedData = await _resolveConflicts(
        serverData: serverData,
        localData: localData,
        strategy: strategy,
        tableName: tableName,
      );

      // Сохраняем в локальный кэш
      if (resolvedData != null) {
        await _saveToLocalCache(cacheKey, resolvedData, toJson);
      }

      developer.log('🔄 SyncService: Sync completed for $tableName', name: 'SyncService');
      return SyncResult(
        data: resolvedData,
        source: SyncSource.hybrid,
        conflictsResolved: serverData.isNotEmpty && localData.isNotEmpty,
      );

    } catch (e) {
      developer.log('🔄 SyncService: Sync failed for $tableName: $e', name: 'SyncService');
      return await _getFromLocalCache<T>(cacheKey, fromJson);
    }
  }

  /// Получение данных только из локального кэша
  Future<SyncResult> getFromLocalCache<T>(
    String cacheKey,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await _getFromLocalCache<T>(cacheKey, fromJson);
  }

  /// Принудительная синхронизация с сервером
  Future<SyncResult> forceSyncFromServer<T>({
    required String tableName,
    required String cacheKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    try {
      developer.log('🔄 SyncService: Force syncing from server for $tableName', name: 'SyncService');

      if (!_supabaseService.isAvailable) {
        throw Exception('Supabase not available');
      }

      final serverData = await _getFromServer(tableName);
      
      if (serverData.isNotEmpty) {
        await _saveToLocalCache(cacheKey, serverData, toJson);
      }

      return SyncResult(
        data: serverData,
        source: SyncSource.server,
        conflictsResolved: false,
      );

    } catch (e) {
      developer.log('🔄 SyncService: Force sync failed for $tableName: $e', name: 'SyncService');
      rethrow;
    }
  }

  /// Сохранение данных с синхронизацией
  Future<void> saveWithSync<T>({
    required String tableName,
    required String cacheKey,
    required T data,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    try {
      developer.log('🔄 SyncService: Saving with sync for $tableName', name: 'SyncService');

      // Сохраняем в Supabase
      if (_supabaseService.isAvailable) {
        await _saveToServer(tableName, toJson(data));
        developer.log('🔄 SyncService: Saved to server for $tableName', name: 'SyncService');
      }

      // Сохраняем в локальный кэш
      await _saveToLocalCache(cacheKey, [data], toJson);
      developer.log('🔄 SyncService: Saved to local cache for $tableName', name: 'SyncService');

    } catch (e) {
      developer.log('🔄 SyncService: Save with sync failed for $tableName: $e', name: 'SyncService');
      rethrow;
    }
  }

  /// Очистка устаревших данных
  Future<void> clearExpiredCache() async {
    try {
      developer.log('🔄 SyncService: Clearing expired cache', name: 'SyncService');

      final keys = _localCache.getAllKeys();
      final now = DateTime.now();
      final maxAge = const Duration(days: 7);

      for (final key in keys) {
        if (key.endsWith('_timestamp')) {
          final dataKey = key.replaceAll('_timestamp', '');
          if (!_localCache.isCacheValid(dataKey, maxAge)) {
            await _localCache.removeData(dataKey);
            await _localCache.removeData(key);
            developer.log('🔄 SyncService: Removed expired cache for $dataKey', name: 'SyncService');
          }
        }
      }

    } catch (e) {
      developer.log('🔄 SyncService: Clear expired cache failed: $e', name: 'SyncService');
    }
  }

  // Приватные методы

  Future<List<Map<String, dynamic>>> _getFromServer(String tableName) async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) {
        return [];
      }

      return await _supabaseService.getUserData(tableName, userId: user.id);
    } catch (e) {
      developer.log('🔄 SyncService: Get from server failed for $tableName: $e', name: 'SyncService');
      return [];
    }
  }

  Future<SyncResult> _getFromLocalCache<T>(
    String cacheKey,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final dataList = await _localCache.getDataList(cacheKey);
      final result = dataList.map((item) => fromJson(item)).toList();
      
      return SyncResult(
        data: result,
        source: SyncSource.local,
        conflictsResolved: false,
      );
    } catch (e) {
      developer.log('🔄 SyncService: Get from local cache failed for $cacheKey: $e', name: 'SyncService');
      return SyncResult(
        data: [],
        source: SyncSource.local,
        conflictsResolved: false,
      );
    }
  }

  Future<void> _saveToServer(String tableName, Map<String, dynamic> data) async {
    try {
      await _supabaseService.saveUserData(tableName, data);
    } catch (e) {
      developer.log('🔄 SyncService: Save to server failed for $tableName: $e', name: 'SyncService');
      rethrow;
    }
  }

  Future<void> _saveToLocalCache<T>(
    String cacheKey,
    List<T> data,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      final dataList = data.map((item) => toJson(item)).toList();
      await _localCache.saveDataList(cacheKey, dataList);
    } catch (e) {
      developer.log('🔄 SyncService: Save to local cache failed for $cacheKey: $e', name: 'SyncService');
      rethrow;
    }
  }

  Future<List<T>> _resolveConflicts<T>({
    required List<Map<String, dynamic>> serverData,
    required List<T> localData,
    required ConflictResolutionStrategy strategy,
    required String tableName,
  }) async {
    if (serverData.isEmpty && localData.isEmpty) {
      return [];
    }

    if (serverData.isEmpty) {
      return localData;
    }

    if (localData.isEmpty) {
      // Конвертируем serverData в T
      return serverData.map((item) => _convertToT<T>(item)).toList();
    }

    switch (strategy) {
      case ConflictResolutionStrategy.serverWins:
        developer.log('🔄 SyncService: Using server-wins strategy for $tableName', name: 'SyncService');
        return serverData.map((item) => _convertToT<T>(item)).toList();

      case ConflictResolutionStrategy.localWins:
        developer.log('🔄 SyncService: Using local-wins strategy for $tableName', name: 'SyncService');
        return localData;

      case ConflictResolutionStrategy.merge:
        developer.log('🔄 SyncService: Using merge strategy for $tableName', name: 'SyncService');
        return await _mergeData<T>(serverData, localData);

      case ConflictResolutionStrategy.timestamp:
        developer.log('🔄 SyncService: Using timestamp strategy for $tableName', name: 'SyncService');
        return await _resolveByTimestamp<T>(serverData, localData);
    }
  }

  T _convertToT<T>(Map<String, dynamic> data) {
    // Это упрощенная версия, в реальном приложении нужно использовать proper JSON deserialization
    return data as T;
  }

  Future<List<T>> _mergeData<T>(
    List<Map<String, dynamic>> serverData,
    List<T> localData,
  ) async {
    // Простая стратегия слияния - объединяем уникальные элементы
    final merged = <T>[];
    final seenIds = <String>{};

    // Добавляем серверные данные
    for (final serverItem in serverData) {
      final id = serverItem['id']?.toString() ?? '';
      if (!seenIds.contains(id)) {
        merged.add(_convertToT<T>(serverItem));
        seenIds.add(id);
      }
    }

    // Добавляем локальные данные
    for (final localItem in localData) {
      final id = localItem.toString(); // Упрощенно
      if (!seenIds.contains(id)) {
        merged.add(localItem);
        seenIds.add(id);
      }
    }

    return merged;
  }

  Future<List<T>> _resolveByTimestamp<T>(
    List<Map<String, dynamic>> serverData,
    List<T> localData,
  ) async {
    // Используем timestamp для разрешения конфликтов
    // В реальном приложении нужно сравнивать updated_at поля
    return serverData.map((item) => _convertToT<T>(item)).toList();
  }
}

// Enums и классы для результатов

enum SyncSource {
  local,
  server,
  hybrid,
}

enum ConflictResolutionStrategy {
  serverWins,
  localWins,
  merge,
  timestamp,
}

class SyncResult<T> {
  final List<T> data;
  final SyncSource source;
  final bool conflictsResolved;

  SyncResult({
    required this.data,
    required this.source,
    required this.conflictsResolved,
  });

  @override
  String toString() {
    return 'SyncResult(data: ${data.length} items, source: $source, conflictsResolved: $conflictsResolved)';
  }
} 