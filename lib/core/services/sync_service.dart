import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/local_cache_service.dart';
import 'dart:developer' as developer;

class SyncService {
  static SyncService? _instance;
  static SyncService get instance => _instance ??= SyncService._();

  SyncService._();

  final SupabaseService _supabaseService = SupabaseService.instance;
  final LocalCacheService _localCache = LocalCacheService.instance;

  /// Синхронизация данных между сервером и локальным кэшем
  Future<SyncResult<T>> syncData<T>({
    required String cacheKey,
    required Future<List<T>> Function() getFromServer,
    required Future<List<T>> Function() getFromLocalCache,
    required Future<void> Function(List<T>) saveToLocalCache,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.serverWins,
  }) async {
    try {
      developer.log('🔄 SyncService: Starting sync for key: $cacheKey', name: 'SyncService');

      // Получаем данные с сервера
      final serverData = await getFromServer();
      
      // Получаем данные из локального кэша
      final localData = await getFromLocalCache();

      // Определяем конфликты
      final conflicts = _detectConflicts(serverData, localData, toJson);
      
      // Разрешаем конфликты
      final resolvedData = await _resolveConflicts(
        serverData,
        localData,
        conflicts,
        strategy,
        toJson,
        fromJson,
      );

      // Сохраняем разрешенные данные в локальный кэш
      await saveToLocalCache(resolvedData);

      final result = SyncResult<T>(
        data: resolvedData,
        source: SyncSource.hybrid,
        conflictsResolved: conflicts.isNotEmpty,
      );

      developer.log('🔄 SyncService: Sync completed for key: $cacheKey - ${resolvedData.length} items', name: 'SyncService');
      
      return result;
    } catch (e) {
      developer.log('🔄 SyncService: Failed to sync data for key: $cacheKey - $e', name: 'SyncService');
      rethrow;
    }
  }

  /// Получение данных только из локального кэша
  Future<SyncResult<T>> getFromLocalCache<T>(
    String cacheKey,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await _getFromLocalCache<T>(cacheKey, fromJson);
  }

  /// Принудительная синхронизация с сервера
  Future<List<T>> forceSyncFromServer<T>({
    required String cacheKey,
    required Future<List<T>> Function() getFromServer,
    required Future<void> Function(List<T>) saveToLocalCache,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    try {
      developer.log('🔄 SyncService: Force syncing from server for key: $cacheKey', name: 'SyncService');

      final serverData = await getFromServer();
      await saveToLocalCache(serverData);

      developer.log('🔄 SyncService: Force sync completed for key: $cacheKey - ${serverData.length} items', name: 'SyncService');
      
      return serverData;
    } catch (e) {
      developer.log('🔄 SyncService: Failed to force sync from server for key: $cacheKey - $e', name: 'SyncService');
      rethrow;
    }
  }

  /// Сохранение данных с синхронизацией
  Future<void> saveWithSync<T>({
    required String cacheKey,
    required List<T> data,
    required Future<void> Function(List<T>) saveToServer,
    required Future<void> Function(List<T>) saveToLocalCache,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    try {
      developer.log('🔄 SyncService: Saving with sync for key: $cacheKey', name: 'SyncService');

      // Сохраняем на сервер
      await saveToServer(data);
      
      // Сохраняем в локальный кэш
      await saveToLocalCache(data);

      developer.log('🔄 SyncService: Save with sync completed for key: $cacheKey', name: 'SyncService');
    } catch (e) {
      developer.log('🔄 SyncService: Failed to save with sync for key: $cacheKey - $e', name: 'SyncService');
      rethrow;
    }
  }

  /// Очистка устаревшего кэша
  Future<void> clearExpiredCache({
    required Duration maxAge,
  }) async {
    try {
      developer.log('🔄 SyncService: Clearing expired cache', name: 'SyncService');

      final now = DateTime.now();
      final expiredKeys = <String>[];

      // Проверяем все ключи кэша
      final allKeys = await LocalCacheService.instance.getAllKeys();
      
      for (final key in allKeys) {
        if (key.startsWith('sync_')) {
          final timestamp = await LocalCacheService.instance.getValue('${key}_timestamp');
          if (timestamp != null) {
            final cacheTime = DateTime.parse(timestamp);
            if (now.difference(cacheTime) > maxAge) {
              expiredKeys.add(key);
            }
          }
        }
      }

      // Удаляем устаревшие данные
      for (final key in expiredKeys) {
        await LocalCacheService.instance.removeData(key);
        await LocalCacheService.instance.removeData('${key}_timestamp');
      }

      developer.log('🔄 SyncService: Cleared ${expiredKeys.length} expired cache entries', name: 'SyncService');
    } catch (e) {
      developer.log('🔄 SyncService: Failed to clear expired cache - $e', name: 'SyncService');
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

  Future<SyncResult<T>> _getFromLocalCache<T>(
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

  /// Определение конфликтов между серверными и локальными данными
  List<SyncConflict<T>> _detectConflicts<T>(
    List<T> serverData,
    List<T> localData,
    Map<String, dynamic> Function(T) toJson,
  ) {
    final conflicts = <SyncConflict<T>>[];
    
    // Создаем Map для быстрого поиска
    final serverMap = <String, T>{};
    final localMap = <String, T>{};
    
    for (final item in serverData) {
      final json = toJson(item);
      final id = json['id'] as String? ?? json['user_id'] as String? ?? '';
      if (id.isNotEmpty) {
        serverMap[id] = item;
      }
    }
    
    for (final item in localData) {
      final json = toJson(item);
      final id = json['id'] as String? ?? json['user_id'] as String? ?? '';
      if (id.isNotEmpty) {
        localMap[id] = item;
      }
    }
    
    // Находим конфликты
    for (final id in serverMap.keys) {
      if (localMap.containsKey(id)) {
        final serverItem = serverMap[id]!;
        final localItem = localMap[id]!;
        
        final serverJson = toJson(serverItem);
        final localJson = toJson(localItem);
        
        // Проверяем, есть ли различия
        if (!_isEqual(serverJson, localJson)) {
          conflicts.add(SyncConflict<T>(
            id: id,
            serverData: serverItem,
            localData: localItem,
            conflictType: ConflictType.dataMismatch,
          ));
        }
      }
    }
    
    return conflicts;
  }

  /// Разрешение конфликтов
  Future<List<T>> _resolveConflicts<T>(
    List<T> serverData,
    List<T> localData,
    List<SyncConflict<T>> conflicts,
    ConflictResolutionStrategy strategy,
    Map<String, dynamic> Function(T) toJson,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final resolvedData = <T>[];
    
    // Создаем Map для быстрого поиска
    final serverMap = <String, T>{};
    final localMap = <String, T>{};
    
    for (final item in serverData) {
      final json = toJson(item);
      final id = json['id'] as String? ?? json['user_id'] as String? ?? '';
      if (id.isNotEmpty) {
        serverMap[id] = item;
      }
    }
    
    for (final item in localData) {
      final json = toJson(item);
      final id = json['id'] as String? ?? json['user_id'] as String? ?? '';
      if (id.isNotEmpty) {
        localMap[id] = item;
      }
    }
    
    // Обрабатываем конфликты
    for (final conflict in conflicts) {
      T resolvedItem;
      
      switch (strategy) {
        case ConflictResolutionStrategy.serverWins:
          resolvedItem = conflict.serverData;
          break;
        case ConflictResolutionStrategy.localWins:
          resolvedItem = conflict.localData;
          break;
        case ConflictResolutionStrategy.merge:
          resolvedItem = await _mergeData(conflict.serverData, conflict.localData, toJson, fromJson);
          break;
        case ConflictResolutionStrategy.timestamp:
          resolvedItem = await _resolveByTimestamp(conflict.serverData, conflict.localData, toJson);
          break;
      }
      
      // Обновляем данные
      serverMap[conflict.id] = resolvedItem;
      localMap[conflict.id] = resolvedItem;
    }
    
    // Собираем все данные
    resolvedData.addAll(serverMap.values);
    
    // Добавляем локальные данные, которых нет на сервере
    for (final entry in localMap.entries) {
      if (!serverMap.containsKey(entry.key)) {
        resolvedData.add(entry.value);
      }
    }
    
    return resolvedData;
  }

  /// Сравнение JSON объектов
  bool _isEqual(Map<String, dynamic> json1, Map<String, dynamic> json2) {
    if (json1.length != json2.length) return false;
    
    for (final key in json1.keys) {
      if (!json2.containsKey(key)) return false;
      if (json1[key] != json2[key]) return false;
    }
    
    return true;
  }

  /// Слияние данных
  Future<T> _mergeData<T>(
    T serverData,
    T localData,
    Map<String, dynamic> Function(T) toJson,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final serverJson = toJson(serverData);
    final localJson = toJson(localData);
    
    // Простое слияние - берем последние значения
    final mergedJson = Map<String, dynamic>.from(serverJson);
    mergedJson.addAll(localJson);
    
    return fromJson(mergedJson);
  }

  /// Разрешение конфликта по временной метке
  Future<T> _resolveByTimestamp<T>(
    T serverData,
    T localData,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final serverJson = toJson(serverData);
    final localJson = toJson(localData);
    
    final serverTimestamp = serverJson['updated_at'] as String?;
    final localTimestamp = localJson['updated_at'] as String?;
    
    if (serverTimestamp != null && localTimestamp != null) {
      final serverTime = DateTime.parse(serverTimestamp);
      final localTime = DateTime.parse(localTimestamp);
      
      return serverTime.isAfter(localTime) ? serverData : localData;
    }
    
    // По умолчанию берем серверные данные
    return serverData;
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

class SyncConflict<T> {
  final String id;
  final T serverData;
  final T localData;
  final ConflictType conflictType;

  SyncConflict({
    required this.id,
    required this.serverData,
    required this.localData,
    required this.conflictType,
  });

  @override
  String toString() {
    return 'SyncConflict(id: $id, type: $conflictType)';
  }
}

enum ConflictType {
  dataMismatch,
  serverOnly,
  localOnly,
  timestampConflict,
} 