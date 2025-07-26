# Техническая Спецификация NutryFlow

## 1. Обзор Системы

### 1.1 Архитектурный Стиль
- **Feature-First Architecture**: Модульная структура по функциональным возможностям
- **Clean Architecture**: Разделение на слои (presentation, domain, data)
- **SOLID Principles**: Строгое следование принципам SOLID
- **Dependency Injection**: Использование GetIt для управления зависимостями

### 1.2 Технологический Стек

#### Frontend
- **Framework**: Flutter 3.2.3+
- **Language**: Dart
- **State Management**: BLoC (flutter_bloc 8.1.4)
- **Navigation**: GoRouter (планируется)
- **DI**: GetIt (планируется)
- **UI**: Material Design 3

#### Backend
- **Auth**: Supabase Auth
- **Database**: Supabase PostgreSQL
- **Storage**: Supabase Storage
- **Functions**: Supabase Edge Functions
- **Real-time**: Supabase Realtime

#### Analytics & Monitoring
- **Analytics**: Firebase Analytics (планируется)
- **Notifications**: Firebase Cloud Messaging (планируется)
- **Crash Reporting**: Firebase Crashlytics (планируется)

## 2. Структура Проекта

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart
│   │   ├── environment.dart
│   │   └── constants.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   ├── failures.dart
│   │   └── error_handler.dart
│   ├── network/
│   │   ├── http_client.dart
│   │   ├── interceptors.dart
│   │   └── api_endpoints.dart
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── secure_storage.dart
│   └── utils/
│       ├── validators.dart
│       ├── formatters.dart
│       └── extensions.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   ├── nutrition/
│   ├── water/
│   ├── activity/
│   └── profile/
├── shared/
│   ├── widgets/
│   │   ├── common/
│   │   └── custom/
│   ├── models/
│   │   ├── user.dart
│   │   └── app_state.dart
│   └── services/
│       ├── analytics_service.dart
│       └── notification_service.dart
└── main.dart
```

## 3. Детальная Архитектура

### 3.1 Presentation Layer (UI)
```dart
// Пример структуры BLoC
abstract class NutritionEvent extends Equatable {
  const NutritionEvent();
}

abstract class NutritionState extends Equatable {
  const NutritionState();
}

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final GetNutritionData _getNutritionData;
  
  NutritionBloc(this._getNutritionData) : super(NutritionInitial()) {
    on<LoadNutritionData>(_onLoadNutritionData);
    on<AddFoodItem>(_onAddFoodItem);
  }
}
```

### 3.2 Domain Layer (Business Logic)
```dart
// Use Cases
class GetNutritionData implements UseCase<List<FoodItem>, NoParams> {
  final NutritionRepository repository;
  
  GetNutritionData(this.repository);
  
  @override
  Future<Either<Failure, List<FoodItem>>> call(NoParams params) async {
    return await repository.getNutritionData();
  }
}

// Entities
class FoodItem extends Equatable {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  
  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
  
  @override
  List<Object?> get props => [id, name, calories, protein, carbs, fats];
}
```

### 3.3 Data Layer
```dart
// Repository Implementation
class NutritionRepositoryImpl implements NutritionRepository {
  final NutritionDataSource dataSource;
  
  NutritionRepositoryImpl(this.dataSource);
  
  @override
  Future<Either<Failure, List<FoodItem>>> getNutritionData() async {
    try {
      final result = await dataSource.getNutritionData();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// Data Source
abstract class NutritionDataSource {
  Future<List<FoodItem>> getNutritionData();
  Future<void> addFoodItem(FoodItem item);
}

class NutritionDataSourceImpl implements NutritionDataSource {
  final SupabaseClient supabaseClient;
  
  NutritionDataSourceImpl(this.supabaseClient);
  
  @override
  Future<List<FoodItem>> getNutritionData() async {
    final response = await supabaseClient
        .from('nutrition_data')
        .select()
        .execute();
    
    return response.data.map((json) => FoodItem.fromJson(json)).toList();
  }
}
```

## 4. Интеграции

### 4.1 Supabase Integration
```dart
// Конфигурация Supabase
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  static SupabaseClient get client => Supabase.instance.client;
}

// Инициализация
Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
}
```

### 4.2 HealthKit/Google Fit Integration
```dart
// Абстракция для HealthKit/Google Fit
abstract class HealthKitService {
  Future<List<ActivityData>> getActivityData();
  Future<void> saveActivityData(ActivityData data);
}

class HealthKitServiceImpl implements HealthKitService {
  // Реализация для iOS HealthKit
}

class GoogleFitServiceImpl implements HealthKitService {
  // Реализация для Android Google Fit
}
```

## 5. База Данных

### 5.1 Supabase Schema
```sql
-- Пользователи
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Продукты
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  calories_per_100g DECIMAL(8,2) NOT NULL,
  protein_per_100g DECIMAL(8,2) NOT NULL,
  carbs_per_100g DECIMAL(8,2) NOT NULL,
  fats_per_100g DECIMAL(8,2) NOT NULL,
  barcode TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Дневник питания
CREATE TABLE nutrition_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  product_id UUID REFERENCES products(id),
  quantity_grams DECIMAL(8,2) NOT NULL,
  meal_type TEXT NOT NULL, -- breakfast, lunch, dinner, snack
  consumed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Водный баланс
CREATE TABLE water_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  amount_ml INTEGER NOT NULL,
  consumed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Физическая активность
CREATE TABLE activity_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  activity_type TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL,
  calories_burned INTEGER,
  distance_km DECIMAL(8,2),
  performed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Цели пользователя
CREATE TABLE user_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) UNIQUE,
  daily_calories INTEGER NOT NULL,
  daily_protein DECIMAL(8,2) NOT NULL,
  daily_carbs DECIMAL(8,2) NOT NULL,
  daily_fats DECIMAL(8,2) NOT NULL,
  daily_water_ml INTEGER NOT NULL,
  activity_level TEXT NOT NULL, -- sedentary, lightly_active, moderately_active, very_active
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 6. API Endpoints

### 6.1 Supabase Functions
```typescript
// supabase/functions/calculate-nutrition/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  const { user_id, date } = await req.json()
  
  const { data, error } = await supabase
    .from('nutrition_log')
    .select(`
      *,
      products (*)
    `)
    .eq('user_id', user_id)
    .gte('consumed_at', date)
    .lt('consumed_at', new Date(date.getTime() + 24 * 60 * 60 * 1000))
  
  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' }
    })
  }
  
  // Расчет общих калорий и макронутриентов
  const totals = data.reduce((acc, log) => {
    const product = log.products
    const multiplier = log.quantity_grams / 100
    
    acc.calories += product.calories_per_100g * multiplier
    acc.protein += product.protein_per_100g * multiplier
    acc.carbs += product.carbs_per_100g * multiplier
    acc.fats += product.fats_per_100g * multiplier
    
    return acc
  }, { calories: 0, protein: 0, carbs: 0, fats: 0 })
  
  return new Response(JSON.stringify(totals), {
    headers: { 'Content-Type': 'application/json' }
  })
})
```

## 7. Безопасность

### 7.1 Аутентификация
```dart
// Аутентификация через Supabase
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
```

### 7.2 Row Level Security (RLS)
```sql
-- RLS для таблицы nutrition_log
ALTER TABLE nutrition_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own nutrition log" ON nutrition_log
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own nutrition log" ON nutrition_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own nutrition log" ON nutrition_log
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own nutrition log" ON nutrition_log
  FOR DELETE USING (auth.uid() = user_id);
```

## 8. Производительность

### 8.1 Оптимизация
- Ленивая загрузка данных
- Кэширование в локальном хранилище
- Пагинация для больших списков
- Оптимизация изображений
- Минимизация сетевых запросов

### 8.2 Мониторинг
```dart
// Аналитика производительности
class PerformanceService {
  static void trackScreenLoad(String screenName) {
    // Firebase Performance Monitoring
  }
  
  static void trackApiCall(String endpoint, Duration duration) {
    // Отслеживание времени API вызовов
  }
  
  static void trackError(String error, StackTrace stackTrace) {
    // Firebase Crashlytics
  }
}
```

## 9. Тестирование

### 9.1 Unit Tests
```dart
// Тест Use Case
void main() {
  group('GetNutritionData', () {
    late MockNutritionRepository mockRepository;
    late GetNutritionData useCase;
    
    setUp(() {
      mockRepository = MockNutritionRepository();
      useCase = GetNutritionData(mockRepository);
    });
    
    test('should get nutrition data from repository', () async {
      // arrange
      final tFoodItems = [FoodItem(id: '1', name: 'Apple', calories: 52)];
      when(mockRepository.getNutritionData())
          .thenAnswer((_) async => Right(tFoodItems));
      
      // act
      final result = await useCase(NoParams());
      
      // assert
      expect(result, Right(tFoodItems));
      verify(mockRepository.getNutritionData());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
```

### 9.2 Widget Tests
```dart
// Тест виджета
void main() {
  group('NutritionCard', () {
    testWidgets('should display nutrition information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NutritionCard(
            foodItem: FoodItem(
              id: '1',
              name: 'Apple',
              calories: 52,
              protein: 0.3,
              carbs: 14,
              fats: 0.2,
            ),
          ),
        ),
      );
      
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('52 kcal'), findsOneWidget);
    });
  });
}
```

## 10. Развертывание

### 10.1 CI/CD Pipeline
```yaml
# .github/workflows/flutter.yml
name: Flutter CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.2.3'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.2.3'
      - run: flutter build apk
      - run: flutter build ios --no-codesign
```

### 10.2 Environment Configuration
```dart
// lib/core/config/environment.dart
enum Environment { dev, staging, prod }

class EnvironmentConfig {
  static Environment _environment = Environment.dev;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static String get supabaseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://dev-project.supabase.co';
      case Environment.staging:
        return 'https://staging-project.supabase.co';
      case Environment.prod:
        return 'https://prod-project.supabase.co';
    }
  }
  
  static String get supabaseAnonKey {
    switch (_environment) {
      case Environment.dev:
        return 'dev-anon-key';
      case Environment.staging:
        return 'staging-anon-key';
      case Environment.prod:
        return 'prod-anon-key';
    }
  }
}
```

## 11. Мониторинг и Логирование

### 11.1 Логирование
```dart
// Логирование с разными уровнями
class Logger {
  static void debug(String message) {
    if (kDebugMode) {
      print('🔍 DEBUG: $message');
    }
  }
  
  static void info(String message) {
    print('ℹ️ INFO: $message');
  }
  
  static void warning(String message) {
    print('⚠️ WARNING: $message');
  }
  
  static void error(String message, [StackTrace? stackTrace]) {
    print('❌ ERROR: $message');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }
}
```

### 11.2 Метрики
```dart
// Сбор метрик
class MetricsService {
  static void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    // Firebase Analytics
  }
  
  static void setUserProperty(String property, String value) {
    // Установка свойств пользователя
  }
  
  static void trackScreenView(String screenName) {
    // Отслеживание просмотров экранов
  }
}
```

## 12. Документация API

### 12.1 OpenAPI Specification
```yaml
openapi: 3.0.0
info:
  title: NutryFlow API
  version: 1.0.0
  description: API для приложения NutryFlow

paths:
  /nutrition-data:
    get:
      summary: Получить данные о питании
      parameters:
        - name: date
          in: query
          schema:
            type: string
            format: date
      responses:
        '200':
          description: Успешный ответ
          content:
            application/json:
              schema:
                type: object
                properties:
                  calories:
                    type: number
                  protein:
                    type: number
                  carbs:
                    type: number
                  fats:
                    type: number
```

Эта техническая спецификация предоставляет детальное описание архитектуры, технологий и реализации проекта NutryFlow, обеспечивая основу для разработки и поддержки приложения. 