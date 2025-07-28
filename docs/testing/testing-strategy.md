# Стратегия тестирования NutryFlow

## Обзор

NutryFlow использует многоуровневую стратегию тестирования для обеспечения качества кода и надежности приложения.

## Типы тестов

### 1. Unit тесты
Тестируют отдельные компоненты изолированно.

**Покрытие:**
- Репозитории (MealPlanRepository, ExerciseRepository, AnalyticsRepository)
- BLoC'и (MealPlanBloc, ExerciseBloc, AnalyticsBloc)
- Сервисы (SupabaseService, LocalCacheService, SyncService)
- Use Cases и Domain логика

**Пример:**
```dart
test('should save meal plan successfully when Supabase is available', () async {
  // Arrange
  final mealPlan = MealPlan(...);
  when(mockSupabaseService.isAvailable).thenReturn(true);
  
  // Act
  await repository.saveMealPlan(mealPlan);
  
  // Assert
  verify(mockSupabaseService.saveUserData('meal_plans', any)).called(1);
});
```

### 2. Widget тесты
Тестируют UI компоненты и их взаимодействие.

**Покрытие:**
- Экраны и виджеты
- Навигация между экранами
- Пользовательские взаимодействия
- Отображение состояний (loading, error, success)

**Пример:**
```dart
testWidgets('shows loading indicator when loading', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<MealPlanBloc>(
        create: (context) => MealPlanBloc(
          mealPlanRepository: MockMealPlanRepository(),
        ),
        child: MealPlanScreen(),
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### 3. Integration тесты
Тестируют взаимодействие между компонентами и реальной базой данных.

**Покрытие:**
- Полный цикл CRUD операций
- Синхронизация с Supabase
- Обработка ошибок сети
- Производительность запросов

**Пример:**
```dart
test('should save and retrieve meal plan', () async {
  // Arrange
  final testMealPlan = MealPlan(...);
  
  // Act - Save meal plan
  await mealPlanRepository.saveMealPlan(testMealPlan);
  
  // Act - Retrieve meal plans
  final retrievedPlans = await mealPlanRepository.getUserMealPlans();
  
  // Assert
  expect(retrievedPlans, isNotEmpty);
  final savedPlan = retrievedPlans.firstWhere(
    (plan) => plan.id == testMealPlan.id,
  );
  expect(savedPlan.name, equals(testMealPlan.name));
});
```

### 4. Performance тесты
Тестируют производительность и масштабируемость.

**Покрытие:**
- Время выполнения запросов
- Обработка больших наборов данных
- Конкурентные операции
- Использование памяти

**Пример:**
```dart
test('should complete single meal plan query within 1 second', () async {
  final stopwatch = Stopwatch();
  
  stopwatch.start();
  final result = await mealPlanRepository.getUserMealPlans();
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(1000));
  expect(result, isA<List<MealPlan>>());
});
```

## Структура тестов

```
test/
├── features/
│   ├── meal_plan/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── meal_plan_repository_test.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── meal_plan_bloc_test.dart
│   ├── exercise/
│   └── analytics/
├── integration/
│   └── supabase_integration_test.dart
├── performance/
│   └── database_performance_test.dart
└── widget_tests/
    └── meal_plan_screen_test.dart
```

## Инструменты тестирования

### 1. Flutter Test Framework
- Встроенный фреймворк для тестирования
- Поддержка async/await
- Mocking и stubbing

### 2. Mockito
- Генерация mock объектов
- Проверка вызовов методов
- Stubbing возвращаемых значений

```dart
@GenerateMocks([MealPlanRepository])
class MockMealPlanRepository extends Mock implements MealPlanRepository {}
```

### 3. Bloc Test
- Тестирование BLoC'ов
- Проверка состояний и событий
- Seed состояния для тестов

```dart
blocTest<MealPlanBloc, MealPlanState>(
  'emits [MealPlanLoading, MealPlanLoaded] when LoadMealPlans is added',
  build: () => bloc,
  act: (bloc) => bloc.add(LoadMealPlans()),
  expect: () => [
    isA<MealPlanLoading>(),
    isA<MealPlanLoaded>(),
  ],
);
```

### 4. Coverage
- Измерение покрытия кода
- HTML отчеты
- Интеграция с CI/CD

## Запуск тестов

### Автоматизированный скрипт
```bash
# Все тесты
./scripts/run_tests.sh

# Только unit тесты
./scripts/run_tests.sh unit

# Только widget тесты
./scripts/run_tests.sh widget

# Анализ покрытия
./scripts/run_tests.sh coverage
```

### Ручной запуск
```bash
# Unit тесты
flutter test test/features/meal_plan/data/repositories/

# Widget тесты
flutter test test/widget_tests/

# С покрытием
flutter test --coverage

# Генерация HTML отчета
genhtml coverage/lcov.info -o coverage/html
```

## Стандарты тестирования

### 1. Именование
- Тестовые файлы: `*_test.dart`
- Тестовые классы: `*Test`
- Тестовые методы: `should_*` или `test_*`

### 2. Структура теста (AAA Pattern)
```dart
test('should save meal plan successfully', () async {
  // Arrange - Подготовка
  final mealPlan = MealPlan(...);
  when(mockRepository.saveMealPlan(any)).thenAnswer((_) async {});
  
  // Act - Действие
  await repository.saveMealPlan(mealPlan);
  
  // Assert - Проверка
  verify(mockRepository.saveMealPlan(mealPlan)).called(1);
});
```

### 3. Покрытие кода
- **Минимум 80%** покрытия для новых функций
- **100%** покрытие для критических путей
- Регулярный мониторинг покрытия

### 4. Изоляция тестов
- Каждый тест независим
- Использование `setUp()` и `tearDown()`
- Очистка моков между тестами

## CI/CD интеграция

### GitHub Actions
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: ./scripts/run_tests.sh
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v1
```

### Отчеты
- Автоматическая генерация отчетов о покрытии
- Уведомления о проваленных тестах
- Интеграция с Codecov

## Тестирование базы данных

### 1. Supabase тесты
- Использование тестовой базы данных
- Очистка данных после каждого теста
- Mocking для изоляции

### 2. Миграции
- Тестирование SQL миграций
- Проверка схемы базы данных
- Валидация RLS политик

### 3. Производительность
- Бенчмарки запросов
- Тестирование индексов
- Мониторинг времени отклика

## Mock стратегия

### 1. Уровни моков
```dart
// Уровень 1: Репозиторий
class MockMealPlanRepository extends Mock implements MealPlanRepository {}

// Уровень 2: Сервис
class MockSupabaseService extends Mock implements SupabaseService {}

// Уровень 3: Внешние API
class MockHttpClient extends Mock implements http.Client {}
```

### 2. Stubbing паттерны
```dart
// Простой stub
when(mockRepository.getUserMealPlans()).thenAnswer((_) async => []);

// Stub с параметрами
when(mockRepository.saveMealPlan(any)).thenAnswer((_) async {});

// Stub с исключениями
when(mockRepository.getUserMealPlans()).thenThrow(Exception('Network error'));
```

## Тестирование ошибок

### 1. Сетевые ошибки
```dart
test('should handle network errors gracefully', () async {
  when(mockService.getData()).thenThrow(SocketException('Network error'));
  
  final result = await repository.getData();
  
  expect(result, isEmpty);
});
```

### 2. Валидация данных
```dart
test('should handle invalid data gracefully', () async {
  final invalidData = {'invalid': 'data'};
  
  expect(
    () => repository.saveData(invalidData),
    throwsA(isA<ValidationException>()),
  );
});
```

### 3. Таймауты
```dart
test('should handle timeouts', () async {
  when(mockService.getData()).thenAnswer(
    (_) => Future.delayed(Duration(seconds: 10)),
  );
  
  final result = await repository.getDataWithTimeout(Duration(seconds: 5));
  
  expect(result, isNull);
});
```

## Performance тестирование

### 1. Бенчмарки
```dart
test('should handle large datasets efficiently', () async {
  final largeDataset = List.generate(1000, (i) => createTestData(i));
  
  final stopwatch = Stopwatch()..start();
  await repository.saveBatch(largeDataset);
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(5000));
});
```

### 2. Memory тесты
```dart
test('should not cause memory leaks', () async {
  final initialMemory = ProcessInfo.currentRss;
  
  for (int i = 0; i < 100; i++) {
    await repository.performOperation();
  }
  
  final finalMemory = ProcessInfo.currentRss;
  expect(finalMemory - initialMemory, lessThan(50 * 1024 * 1024));
});
```

## Отладка тестов

### 1. Логирование
```dart
test('should log operations', () async {
  final logs = <String>[];
  
  // Перехватываем логи
  developer.log = (String message, {String? name}) {
    logs.add(message);
  };
  
  await repository.performOperation();
  
  expect(logs, contains('Operation completed'));
});
```

### 2. Визуализация
```dart
testWidgets('should display correctly', (tester) async {
  await tester.pumpWidget(MyWidget());
  
  // Делаем скриншот для визуальной проверки
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('my_widget.png'),
  );
});
```

## Лучшие практики

### 1. Организация
- Группируйте связанные тесты
- Используйте описательные имена
- Следуйте принципу DRY

### 2. Надежность
- Избегайте flaky тестов
- Используйте детерминированные данные
- Очищайте состояние между тестами

### 3. Производительность
- Запускайте тесты параллельно
- Используйте моки для медленных операций
- Оптимизируйте время выполнения

### 4. Поддержка
- Обновляйте тесты при изменении кода
- Документируйте сложные тесты
- Регулярно рефакторите тесты

## Метрики качества

### 1. Покрытие кода
- Общее покрытие: >80%
- Покрытие критических путей: 100%
- Покрытие новых функций: 100%

### 2. Время выполнения
- Unit тесты: <30 секунд
- Widget тесты: <2 минуты
- Integration тесты: <5 минут

### 3. Надежность
- Flaky тесты: <1%
- Успешность CI: >95%
- Время восстановления: <30 минут

## Будущие улучшения

### 1. Автоматизация
- Автоматическая генерация тестов
- AI-assisted test generation
- Predictive test maintenance

### 2. Расширенное покрытие
- Accessibility тесты
- Security тесты
- Load тесты

### 3. Интеграция
- E2E тесты с Appium
- Visual regression тесты
- Performance monitoring 