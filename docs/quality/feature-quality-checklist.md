# Чеклист качества кода для фичи

## 📚 Техническая документация

### ✅ Документация API и компонентов

- [ ] **Классы и сервисы** имеют описание назначения
- [ ] **Публичные методы** имеют JSDoc/DartDoc комментарии
- [ ] **Параметры методов** описаны с типами и ограничениями
- [ ] **Исключения** документированы (что может выбросить)
- [ ] **Примеры использования** приведены в документации

```dart
/// Сервис для работы с аналитикой Firebase
/// 
/// Предоставляет методы для отслеживания пользовательских событий,
/// производительности приложения и бизнес-метрик.
/// 
/// Пример использования:
/// ```dart
/// await AnalyticsService.instance.initialize();
/// AnalyticsService.instance.logEvent(name: 'button_tap');
/// ```
class AnalyticsService {
  /// Отслеживает тренировку пользователя
  /// 
  /// [workoutType] - тип тренировки (cardio, strength, yoga)
  /// [durationMinutes] - продолжительность в минутах (1-300)
  /// [caloriesBurned] - сожженные калории (должно быть > 0)
  /// 
  /// Throws [ArgumentError] если параметры невалидны
  Future<void> logWorkout({
    required String workoutType,
    required int durationMinutes,
    required int caloriesBurned,
  }) async {
    // реализация...
  }
}
```

### ✅ Архитектурная документация

- [ ] **README.md** для сложных фич (архитектура, установка, использование)
- [ ] **Диаграммы компонентов** для сложных взаимодействий
- [ ] **Паттерны и принципы** объяснены и обоснованы
- [ ] **Зависимости** документированы
- [ ] **Конфигурация** описана

### ✅ Интеграционная документация

- [ ] **Инструкции по подключению** к другим системам
- [ ] **Примеры конфигурации** (файлы настроек)
- [ ] **Troubleshooting** частых проблем
- [ ] **Migration guide** при breaking changes
- [ ] **Performance considerations** и лучшие практики

## 🧪 Покрытие тестами

### ✅ Unit тесты (минимум 80% покрытия)

- [ ] **Все публичные методы** покрыты тестами
- [ ] **Happy path** сценарии протестированы
- [ ] **Edge cases** и граничные условия
- [ ] **Валидация параметров** (null, пустые строки, невалидные значения)
- [ ] **Обработка ошибок** и исключений

```dart
group('AnalyticsService Tests', () {
  test('should track workout with valid parameters', () {
    expect(() {
      AnalyticsUtils.trackWorkout(
        workoutType: 'cardio',
        durationMinutes: 30,
        caloriesBurned: 200,
      );
    }, returnsNormally);
  });

  test('should throw error for invalid duration', () {
    expect(() {
      AnalyticsUtils.trackWorkout(
        workoutType: 'cardio',
        durationMinutes: -5, // Невалидное значение
        caloriesBurned: 200,
      );
    }, throwsArgumentError);
  });
});
```

### ✅ Integration тесты

- [ ] **Взаимодействие между компонентами** протестировано
- [ ] **API интеграции** проверены
- [ ] **Database операции** покрыты тестами
- [ ] **Network requests** замокированы и протестированы
- [ ] **User flows** основных сценариев

### ✅ Widget/UI тесты

- [ ] **Виджеты рендерятся** без ошибок
- [ ] **User interactions** (tap, scroll, input) работают
- [ ] **State management** корректно обновляет UI
- [ ] **Navigation** между экранами работает
- [ ] **Accessibility** соблюдено

```dart
testWidgets('Dashboard screen should display analytics', (tester) async {
  await tester.pumpWidget(const DashboardScreen());
  
  expect(find.text('Аналитика питания'), findsOneWidget);
  expect(find.byType(StatsOverview), findsOneWidget);
  
  await tester.tap(find.text('Продукты'));
  await tester.pump();
  
  expect(find.byType(ProductsChart), findsOneWidget);
});
```

## 🔍 Дополнительные проверки качества

### ✅ Code Review чеклист

- [ ] **Код читабелен** и понятен без комментариев
- [ ] **Naming conventions** соблюдены
- [ ] **SOLID принципы** не нарушены
- [ ] **DRY принцип** соблюден (нет дублирования кода)
- [ ] **Magic numbers** вынесены в константы
- [ ] **Error handling** реализован правильно

### ✅ Performance

- [ ] **Нет memory leaks** (проверено в профайлере)
- [ ] **Асинхронные операции** не блокируют UI
- [ ] **Database queries** оптимизированы
- [ ] **Image loading** ленивое где возможно
- [ ] **Bundle size** не увеличился критично

### ✅ Security

- [ ] **Пользовательские данные** не логируются
- [ ] **API keys** не хардкодятся
- [ ] **Input validation** на клиенте и сервере
- [ ] **XSS защита** где применимо
- [ ] **HTTPS** используется для всех запросов

## 🚀 Автоматизация проверок

### ✅ CI/CD Pipeline

```yaml
# .github/workflows/quality-check.yml
name: Quality Check

on: [pull_request]

jobs:
  quality_check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Install dependencies
        run: flutter pub get
        
      - name: Run linter
        run: flutter analyze
        
      - name: Run tests with coverage
        run: flutter test --coverage
        
      - name: Check coverage threshold
        run: |
          lcov --summary coverage/lcov.info | grep -Po '(?<=lines......: )\d+(?=\.\d+%)' > coverage_percent.txt
          COVERAGE=$(cat coverage_percent.txt)
          if [ $COVERAGE -lt 80 ]; then
            echo "Coverage $COVERAGE% is below threshold 80%"
            exit 1
          fi
          
      - name: Check documentation
        run: dart doc --validate-links
```

### ✅ Pre-commit hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze
        language: system
        files: \.dart$
        
      - id: flutter-test
        name: Flutter Test
        entry: flutter test
        language: system
        files: \.dart$
        
      - id: documentation-check
        name: Documentation Check
        entry: scripts/check_documentation.sh
        language: script
        files: \.dart$
```

## 📊 Метрики качества

### ✅ KPI для команды

1. **Test Coverage**: > 80%
2. **Documentation Coverage**: > 90% публичных API
3. **Code Review Approval**: 100% (обязательный reviewer)
4. **Bug Escape Rate**: < 5% (баги в продакшене)
5. **Technical Debt Ratio**: < 20%

### ✅ Инструменты мониторинга

- **SonarQube** - статический анализ кода
- **CodeClimate** - maintainability score  
- **Codecov** - coverage tracking
- **Dependabot** - security vulnerabilities
- **Lighthouse** - performance metrics

## 🎯 Практические примеры

### ❌ Плохо (без документации и тестов)

```dart
class UserService {
  Future<User> getUser(String id) async {
    // что-то делает...
    return user;
  }
}
```

**Проблемы:**
- Неясно что делает метод
- Нет валидации параметров  
- Не понятно что может пойти не так
- Нет тестов

### ✅ Хорошо (с документацией и тестами)

```dart
/// Сервис для работы с пользователями
class UserService {
  /// Получает пользователя по ID
  /// 
  /// [id] - уникальный идентификатор пользователя (не должен быть пустым)
  /// 
  /// Returns [User] объект с данными пользователя
  /// 
  /// Throws [ArgumentError] если [id] пустой или null
  /// Throws [UserNotFoundException] если пользователь не найден
  /// Throws [NetworkException] при проблемах с сетью
  /// 
  /// Example:
  /// ```dart
  /// final user = await userService.getUser('user123');
  /// print(user.name);
  /// ```
  Future<User> getUser(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
    
    try {
      final response = await _api.getUser(id);
      return User.fromJson(response.data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw UserNotFoundException('User with id $id not found');
    }
  }
}

// Тесты
group('UserService Tests', () {
  test('should return user for valid ID', () async {
    final user = await userService.getUser('valid_id');
    expect(user.id, equals('valid_id'));
  });

  test('should throw ArgumentError for empty ID', () {
    expect(
      () => userService.getUser(''),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('should throw UserNotFoundException for invalid ID', () {
    expect(
      () => userService.getUser('invalid_id'),
      throwsA(isA<UserNotFoundException>()),
    );
  });
});
```

## 🏆 Заключение

**Техническая документация и тесты - это не overhead, а инвестиция в:**

1. **Скорость разработки** - меньше времени на понимание кода
2. **Качество продукта** - меньше багов, лучший UX
3. **Maintainability** - легче добавлять фичи и исправлять баги
4. **Team velocity** - новые разработчики быстрее включаются
5. **Business confidence** - стабильная работа продукта

**ROI от качественного кода:**
- **76% экономии времени** на разработке
- **90% снижения** критических багов
- **50% ускорения** онбординга новых разработчиков
- **100% confidence** при деплое в продакшн

**Помните:** Качество кода - это не то, что можно "добавить потом". Это основа, которая закладывается с первой строчки кода!
