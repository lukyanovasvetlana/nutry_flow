# Local Caching Architecture

## Обзор

Локальное кэширование в NutryFlow обеспечивает работу приложения в офлайн режиме и улучшает производительность за счет хранения данных локально.

## Архитектура

### 1. LocalCacheService
Основной сервис для работы с SharedPreferences.

**Основные возможности:**
- Сохранение/получение данных пользователя
- Сохранение/получение списков данных
- Сохранение/получение простых значений
- Проверка срока действия кэша
- Очистка устаревших данных

**Ключевые методы:**
```dart
// Сохранение данных
await saveUserData(String key, Map<String, dynamic> data)

// Получение данных
Future<Map<String, dynamic>?> getUserData(String key)

// Сохранение списка
await saveDataList(String key, List<Map<String, dynamic>> dataList)

// Получение списка
Future<List<Map<String, dynamic>>> getDataList(String key)

// Проверка срока действия
bool isCacheValid(String key, Duration maxAge)
```

### 2. SyncService
Сервис для синхронизации данных между локальным кэшем и Supabase.

**Стратегии разрешения конфликтов:**
- `serverWins` - данные сервера имеют приоритет
- `localWins` - локальные данные имеют приоритет
- `merge` - объединение данных
- `timestamp` - разрешение по временным меткам

**Основные методы:**
```dart
// Синхронизация данных
Future<SyncResult> syncData<T>({
  required String tableName,
  required String cacheKey,
  required T Function(Map<String, dynamic>) fromJson,
  required Map<String, dynamic> Function(T) toJson,
  Duration cacheValidity = const Duration(hours: 1),
  ConflictResolutionStrategy strategy = ConflictResolutionStrategy.serverWins,
})

// Принудительная синхронизация с сервера
Future<SyncResult> forceSyncFromServer<T>({...})

// Сохранение с синхронизацией
Future<void> saveWithSync<T>({...})
```

## Структура кэша

### Ключи кэша
```
user_goals_cache          - Цели пользователя
meal_plans_cache          - Планы питания
exercises_cache           - Упражнения
workouts_cache            - Тренировки
nutrition_tracking_cache  - Отслеживание питания
weight_tracking_cache     - Отслеживание веса
activity_tracking_cache   - Отслеживание активности
```

### Временные метки
Для каждого ключа создается дополнительный ключ с суффиксом `_timestamp`:
```
user_goals_cache_timestamp
meal_plans_cache_timestamp
exercises_cache_timestamp
```

## Стратегии кэширования

### 1. Cache-First Strategy
```dart
// Сначала проверяем локальный кэш
final cachedData = await localCache.getDataWithTimestamp(key, maxAge);
if (cachedData != null) {
  return cachedData;
}

// Если кэш устарел или отсутствует, загружаем с сервера
final serverData = await supabaseService.getData();
await localCache.saveDataWithTimestamp(key, serverData);
return serverData;
```

### 2. Network-First Strategy
```dart
try {
  // Сначала пытаемся получить с сервера
  final serverData = await supabaseService.getData();
  await localCache.saveDataWithTimestamp(key, serverData);
  return serverData;
} catch (e) {
  // При ошибке используем кэш
  return await localCache.getDataWithTimestamp(key, maxAge);
}
```

### 3. Hybrid Strategy (по умолчанию)
```dart
// Используем SyncService для автоматического разрешения конфликтов
final syncResult = await syncService.syncData(
  tableName: 'user_goals',
  cacheKey: 'user_goals_cache',
  fromJson: (data) => UserGoals.fromJson(data),
  toJson: (goals) => goals.toJson(),
  strategy: ConflictResolutionStrategy.serverWins,
);
```

## Жизненный цикл кэша

### 1. Инициализация
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Supabase
  await SupabaseService.instance.initialize();
  
  // Инициализация локального кэша
  await LocalCacheService.instance.initialize();
  
  runApp(const MyApp());
}
```

### 2. Сохранение данных
```dart
// В UserDataRepository
Future<void> saveUserGoals(UserGoals goals) async {
  final goalsData = goals.toJson();
  
  await _syncService.saveWithSync(
    tableName: 'user_goals',
    cacheKey: 'user_goals_cache',
    data: goalsData,
    toJson: (data) => data,
  );
}
```

### 3. Получение данных
```dart
// В UserDataRepository
Future<UserGoals?> getUserGoals() async {
  final syncResult = await _syncService.syncData<Map<String, dynamic>>(
    tableName: 'user_goals',
    cacheKey: 'user_goals_cache',
    fromJson: (data) => data,
    toJson: (data) => data,
    strategy: ConflictResolutionStrategy.serverWins,
  );

  if (syncResult.data.isNotEmpty) {
    return UserGoals.fromJson(syncResult.data.first);
  }
  
  return null;
}
```

### 4. Очистка кэша
```dart
// Автоматическая очистка устаревших данных
await syncService.clearExpiredCache();

// Ручная очистка
await localCache.clearAll();
```

## Производительность

### Оптимизации
1. **Ленивая загрузка** - данные загружаются только при необходимости
2. **Кэширование с TTL** - автоматическое удаление устаревших данных
3. **Сжатие данных** - JSON сериализация для экономии места
4. **Инкрементальная синхронизация** - только измененные данные

### Мониторинг
```dart
// Размер кэша
final cacheSize = localCache.getCacheSize();

// Все ключи
final keys = localCache.getAllKeys();

// Проверка наличия ключа
final hasKey = localCache.hasKey('user_goals_cache');
```

## Безопасность

### 1. Изоляция данных
- Каждый пользователь имеет свой набор ключей
- Данные не пересекаются между пользователями

### 2. Шифрование (опционально)
```dart
// Можно добавить шифрование для чувствительных данных
import 'package:encrypt/encrypt.dart';

class SecureLocalCacheService {
  static const key = Key.fromSecureRandom(32);
  static const iv = IV.fromSecureRandom(16);
  static const encrypter = Encrypter(AES(key));
  
  Future<void> saveSecureData(String key, String data) async {
    final encrypted = encrypter.encrypt(data, iv: iv);
    await prefs.setString(key, encrypted.base64);
  }
}
```

### 3. Очистка при выходе
```dart
Future<void> logout() async {
  // Очищаем кэш при выходе пользователя
  await localCache.clearAll();
  await supabaseService.signOut();
}
```

## Обработка ошибок

### 1. Ошибки инициализации
```dart
try {
  await LocalCacheService.instance.initialize();
} catch (e) {
  // Fallback к in-memory кэшу
  developer.log('Local cache initialization failed: $e');
}
```

### 2. Ошибки синхронизации
```dart
try {
  final syncResult = await syncService.syncData(...);
  return syncResult.data;
} catch (e) {
  // Используем только локальный кэш
  return await localCache.getDataList(cacheKey);
}
```

### 3. Ошибки сохранения
```dart
try {
  await syncService.saveWithSync(...);
} catch (e) {
  // Сохраняем только локально
  await localCache.saveDataList(cacheKey, data);
}
```

## Тестирование

### Unit тесты
```dart
test('should save and retrieve data from cache', () async {
  final cache = LocalCacheService.instance;
  await cache.initialize();
  
  final testData = {'key': 'value'};
  await cache.saveUserData('test_key', testData);
  
  final retrieved = await cache.getUserData('test_key');
  expect(retrieved, equals(testData));
});
```

### Integration тесты
```dart
test('should sync data between cache and server', () async {
  final syncService = SyncService.instance;
  
  final result = await syncService.syncData(
    tableName: 'user_goals',
    cacheKey: 'test_goals_cache',
    fromJson: (data) => data,
    toJson: (data) => data,
  );
  
  expect(result.source, isA<SyncSource>());
  expect(result.data, isA<List>());
});
```

## Лучшие практики

### 1. Ключи кэша
- Используйте префиксы для группировки: `user_goals_`, `meal_plans_`
- Добавляйте версии для миграций: `user_goals_v2`
- Используйте описательные имена: `user_goals_cache` вместо `ug`

### 2. Размер кэша
- Ограничивайте размер данных
- Используйте сжатие для больших объектов
- Регулярно очищайте устаревшие данные

### 3. Синхронизация
- Выбирайте подходящую стратегию для каждого типа данных
- Используйте timestamp для критических данных
- Логируйте конфликты для анализа

### 4. Производительность
- Кэшируйте только необходимые данные
- Используйте lazy loading
- Оптимизируйте размер JSON

## Будущие улучшения

### 1. Инкрементальная синхронизация
```dart
class IncrementalSyncService {
  Future<void> syncChanges(String tableName, DateTime since) async {
    // Синхронизация только изменений с определенного времени
  }
}
```

### 2. Очередь синхронизации
```dart
class SyncQueue {
  Future<void> queueSync(SyncOperation operation) async {
    // Добавление операций в очередь для выполнения при восстановлении соединения
  }
}
```

### 3. Сжатие данных
```dart
import 'package:archive/archive.dart';

class CompressedCacheService {
  Future<void> saveCompressed(String key, String data) async {
    final compressed = GZipEncoder().encode(utf8.encode(data));
    await prefs.setString(key, base64.encode(compressed));
  }
}
```

### 4. Шифрование
```dart
class EncryptedCacheService {
  Future<void> saveEncrypted(String key, String data) async {
    final encrypted = encrypter.encrypt(data, iv: iv);
    await prefs.setString(key, encrypted.base64);
  }
}
``` 