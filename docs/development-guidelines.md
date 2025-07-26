# Руководство по Разработке NutryFlow

## 1. Общие Принципы

### 1.1 Архитектурные Принципы
- **SOLID Principles**: Строгое следование принципам SOLID
- **Clean Architecture**: Разделение на слои (presentation, domain, data)
- **Feature-First**: Организация кода по функциональным возможностям
- **Dependency Injection**: Использование GetIt для управления зависимостями
- **Single Responsibility**: Каждый класс должен иметь одну ответственность

### 1.2 Принципы Кодирования
- **DRY (Don't Repeat Yourself)**: Избегать дублирования кода
- **KISS (Keep It Simple, Stupid)**: Простота и читаемость кода
- **YAGNI (You Aren't Gonna Need It)**: Не добавлять функциональность заранее
- **Fail Fast**: Быстрое обнаружение и обработка ошибок

## 2. Стандарты Кодирования

### 2.1 Именование

#### Файлы и Папки
```
✅ Правильно:
- user_repository.dart
- nutrition_bloc.dart
- auth_service.dart
- user_profile_page.dart

❌ Неправильно:
- UserRepository.dart
- nutritionBloc.dart
- authservice.dart
- userprofilepage.dart
```

#### Классы
```dart
✅ Правильно:
class UserRepository {}
class NutritionBloc {}
class AuthService {}
class UserProfilePage {}

❌ Неправильно:
class userRepository {}
class nutrition_bloc {}
class authservice {}
```

#### Переменные и Методы
```dart
✅ Правильно:
String userName;
int caloriesCount;
void getUserData() {}
bool isValidEmail() {}

❌ Неправильно:
String UserName;
int CaloriesCount;
void get_user_data() {}
bool IsValidEmail() {}
```

#### Константы
```dart
✅ Правильно:
static const String API_BASE_URL = 'https://api.example.com';
static const int MAX_RETRY_ATTEMPTS = 3;

❌ Неправильно:
static const String apiBaseUrl = 'https://api.example.com';
static const int maxRetryAttempts = 3;
```

### 2.2 Структура Классов

#### Порядок Членов Класса
```dart
class ExampleClass {
  // 1. Константы
  static const String CONSTANT = 'value';
  
  // 2. Статические переменные
  static int staticVariable = 0;
  
  // 3. Поля класса
  final String requiredField;
  String? optionalField;
  
  // 4. Конструкторы
  const ExampleClass({
    required this.requiredField,
    this.optionalField,
  });
  
  // 5. Геттеры
  String get displayName => 'Example: $requiredField';
  
  // 6. Методы (публичные, затем приватные)
  void publicMethod() {
    _privateMethod();
  }
  
  void _privateMethod() {
    // Реализация
  }
}
```

### 2.3 Комментарии

#### Документация Классов
```dart
/// Сервис для работы с аутентификацией пользователей.
/// 
/// Предоставляет методы для регистрации, входа и выхода пользователей,
/// а также управления сессиями.
class AuthService {
  /// Регистрирует нового пользователя в системе.
  /// 
  /// [email] - email пользователя
  /// [password] - пароль пользователя (минимум 8 символов)
  /// 
  /// Возвращает [AuthResult] с результатом операции.
  /// 
  /// Выбрасывает [AuthException] при ошибке регистрации.
  Future<AuthResult> registerUser({
    required String email,
    required String password,
  }) async {
    // Реализация
  }
}
```

#### Inline Комментарии
```dart
// ✅ Хорошо: объясняет "почему", а не "что"
// Пропускаем валидацию для тестовых пользователей
if (user.isTestUser) return true;

// ❌ Плохо: очевидно из кода
// Проверяем, является ли пользователь тестовым
if (user.isTestUser) return true;
```

## 3. Архитектурные Паттерны

### 3.1 BLoC Pattern

#### Структура BLoC
```dart
// Events
abstract class NutritionEvent extends Equatable {
  const NutritionEvent();
}

class LoadNutritionData extends NutritionEvent {
  final DateTime date;
  
  const LoadNutritionData(this.date);
  
  @override
  List<Object?> get props => [date];
}

class AddFoodItem extends NutritionEvent {
  final FoodItem foodItem;
  
  const AddFoodItem(this.foodItem);
  
  @override
  List<Object?> get props => [foodItem];
}

// States
abstract class NutritionState extends Equatable {
  const NutritionState();
}

class NutritionInitial extends NutritionState {
  @override
  List<Object?> get props => [];
}

class NutritionLoading extends NutritionState {
  @override
  List<Object?> get props => [];
}

class NutritionLoaded extends NutritionState {
  final List<FoodItem> foodItems;
  final NutritionSummary summary;
  
  const NutritionLoaded({
    required this.foodItems,
    required this.summary,
  });
  
  @override
  List<Object?> get props => [foodItems, summary];
}

class NutritionError extends NutritionState {
  final String message;
  
  const NutritionError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final GetNutritionData _getNutritionData;
  final AddFoodItem _addFoodItem;
  
  NutritionBloc({
    required GetNutritionData getNutritionData,
    required AddFoodItem addFoodItem,
  }) : _getNutritionData = getNutritionData,
       _addFoodItem = addFoodItem,
       super(NutritionInitial()) {
    on<LoadNutritionData>(_onLoadNutritionData);
    on<AddFoodItem>(_onAddFoodItem);
  }
  
  Future<void> _onLoadNutritionData(
    LoadNutritionData event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    
    final result = await _getNutritionData(NoParams());
    
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (nutritionData) => emit(NutritionLoaded(
        foodItems: nutritionData.foodItems,
        summary: nutritionData.summary,
      )),
    );
  }
  
  Future<void> _onAddFoodItem(
    AddFoodItem event,
    Emitter<NutritionState> emit,
  ) async {
    final result = await _addFoodItem(event.foodItem);
    
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (_) => add(LoadNutritionData(DateTime.now())),
    );
  }
}
```

### 3.2 Repository Pattern

#### Интерфейс Репозитория
```dart
abstract class NutritionRepository {
  Future<Either<Failure, List<FoodItem>>> getNutritionData();
  Future<Either<Failure, void>> addFoodItem(FoodItem foodItem);
  Future<Either<Failure, void>> updateFoodItem(FoodItem foodItem);
  Future<Either<Failure, void>> deleteFoodItem(String id);
}
```

#### Реализация Репозитория
```dart
class NutritionRepositoryImpl implements NutritionRepository {
  final NutritionDataSource dataSource;
  final NetworkInfo networkInfo;
  
  NutritionRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<FoodItem>>> getNutritionData() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getNutritionData();
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('Нет подключения к интернету'));
    }
  }
  
  @override
  Future<Either<Failure, void>> addFoodItem(FoodItem foodItem) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.addFoodItem(foodItem);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('Нет подключения к интернету'));
    }
  }
}
```

### 3.3 Use Case Pattern

```dart
class GetNutritionData implements UseCase<List<FoodItem>, NoParams> {
  final NutritionRepository repository;
  
  GetNutritionData(this.repository);
  
  @override
  Future<Either<Failure, List<FoodItem>>> call(NoParams params) async {
    return await repository.getNutritionData();
  }
}

class AddFoodItem implements UseCase<void, FoodItem> {
  final NutritionRepository repository;
  
  AddFoodItem(this.repository);
  
  @override
  Future<Either<Failure, void>> call(FoodItem params) async {
    return await repository.addFoodItem(params);
  }
}
```

## 4. Обработка Ошибок

### 4.1 Иерархия Ошибок
```dart
// Базовый класс для ошибок
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Конкретные типы ошибок
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}
```

### 4.2 Обработка в BLoC
```dart
Future<void> _onLoadNutritionData(
  LoadNutritionData event,
  Emitter<NutritionState> emit,
) async {
  emit(NutritionLoading());
  
  final result = await _getNutritionData(NoParams());
  
  result.fold(
    (failure) {
      String errorMessage;
      
      if (failure is ServerFailure) {
        errorMessage = 'Ошибка сервера: ${failure.message}';
      } else if (failure is NetworkFailure) {
        errorMessage = 'Проверьте подключение к интернету';
      } else {
        errorMessage = 'Неизвестная ошибка: ${failure.message}';
      }
      
      emit(NutritionError(errorMessage));
    },
    (nutritionData) => emit(NutritionLoaded(
      foodItems: nutritionData.foodItems,
      summary: nutritionData.summary,
    )),
  );
}
```

## 5. Тестирование

### 5.1 Unit Tests

#### Тестирование Use Cases
```dart
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
      final tFoodItems = [
        FoodItem(
          id: '1',
          name: 'Apple',
          calories: 52,
          protein: 0.3,
          carbs: 14,
          fats: 0.2,
        ),
      ];
      
      when(mockRepository.getNutritionData())
          .thenAnswer((_) async => Right(tFoodItems));
      
      // act
      final result = await useCase(NoParams());
      
      // assert
      expect(result, Right(tFoodItems));
      verify(mockRepository.getNutritionData());
      verifyNoMoreInteractions(mockRepository);
    });
    
    test('should return failure when repository fails', () async {
      // arrange
      when(mockRepository.getNutritionData())
          .thenAnswer((_) async => Left(ServerFailure('Server error')));
      
      // act
      final result = await useCase(NoParams());
      
      // assert
      expect(result, Left(ServerFailure('Server error')));
      verify(mockRepository.getNutritionData());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
```

#### Тестирование BLoC
```dart
void main() {
  group('NutritionBloc', () {
    late MockGetNutritionData mockGetNutritionData;
    late MockAddFoodItem mockAddFoodItem;
    late NutritionBloc bloc;
    
    setUp(() {
      mockGetNutritionData = MockGetNutritionData();
      mockAddFoodItem = MockAddFoodItem();
      bloc = NutritionBloc(
        getNutritionData: mockGetNutritionData,
        addFoodItem: mockAddFoodItem,
      );
    });
    
    tearDown(() {
      bloc.close();
    });
    
    test('initial state should be NutritionInitial', () {
      expect(bloc.state, NutritionInitial());
    });
    
    blocTest<NutritionBloc, NutritionState>(
      'emits [NutritionLoading, NutritionLoaded] when LoadNutritionData is added',
      build: () {
        when(mockGetNutritionData(any))
            .thenAnswer((_) async => Right([FoodItem(id: '1', name: 'Apple', calories: 52, protein: 0.3, carbs: 14, fats: 0.2)]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadNutritionData(DateTime.now())),
      expect: () => [
        NutritionLoading(),
        isA<NutritionLoaded>(),
      ],
    );
  });
}
```

### 5.2 Widget Tests
```dart
void main() {
  group('NutritionCard', () {
    testWidgets('should display nutrition information', (tester) async {
      // arrange
      final foodItem = FoodItem(
        id: '1',
        name: 'Apple',
        calories: 52,
        protein: 0.3,
        carbs: 14,
        fats: 0.2,
      );
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: NutritionCard(foodItem: foodItem),
        ),
      );
      
      // assert
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('52 kcal'), findsOneWidget);
      expect(find.text('0.3g protein'), findsOneWidget);
      expect(find.text('14g carbs'), findsOneWidget);
      expect(find.text('0.2g fats'), findsOneWidget);
    });
    
    testWidgets('should call onTap when tapped', (tester) async {
      // arrange
      bool tapped = false;
      final foodItem = FoodItem(
        id: '1',
        name: 'Apple',
        calories: 52,
        protein: 0.3,
        carbs: 14,
        fats: 0.2,
      );
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: NutritionCard(
            foodItem: foodItem,
            onTap: () => tapped = true,
          ),
        ),
      );
      
      await tester.tap(find.byType(Card));
      
      // assert
      expect(tapped, true);
    });
  });
}
```

## 6. Производительность

### 6.1 Оптимизация Виджетов
```dart
// ✅ Хорошо: использование const конструкторов
class NutritionCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback? onTap;
  
  const NutritionCard({
    super.key,
    required this.foodItem,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(foodItem.name),
        subtitle: Text('${foodItem.calories} kcal'),
        onTap: onTap,
      ),
    );
  }
}

// ❌ Плохо: создание объектов в build
class NutritionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Apple'), // Хардкод
        subtitle: Text('52 kcal'), // Хардкод
      ),
    );
  }
}
```

### 6.2 Кэширование
```dart
// Кэширование изображений
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  
  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
```

## 7. Безопасность

### 7.1 Валидация Данных
```dart
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email обязателен';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль обязателен';
    }
    
    if (value.length < 8) {
      return 'Пароль должен содержать минимум 8 символов';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Пароль должен содержать заглавную букву';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Пароль должен содержать цифру';
    }
    
    return null;
  }
}
```

### 7.2 Безопасное Хранение
```dart
class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
```

## 8. Линтинг и Форматирование

### 8.1 analysis_options.yaml
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Общие правила
    - always_declare_return_types
    - avoid_empty_else
    - avoid_print
    - avoid_unused_constructor_parameters
    - await_only_futures
    - camel_case_types
    - cancel_subscriptions
    - close_sinks
    - comment_references
    - constant_identifier_names
    - control_flow_in_finally
    - directives_ordering
    - empty_catches
    - empty_constructor_bodies
    - empty_statements
    - hash_and_equals
    - implementation_imports
    - library_names
    - library_prefixes
    - non_constant_identifier_names
    - package_api_docs
    - package_names
    - package_prefixed_library_names
    - prefer_const_constructors
    - prefer_final_fields
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_typing_uninitialized_variables
    - slash_for_doc_comments
    - test_types_in_equals
    - throw_in_finally
    - type_init_formals
    - unnecessary_brace_in_string_interps
    - unnecessary_getters_setters
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_statements
    - unrelated_type_equality_checks
    - use_rethrow_when_possible
    - valid_regexps

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore
```

### 8.2 Автоматическое Форматирование
```bash
# Форматирование кода
flutter format lib/

# Анализ кода
flutter analyze

# Запуск тестов
flutter test
```

## 9. Git Workflow

### 9.1 Commit Messages
```
feat: добавить функциональность отслеживания воды
fix: исправить ошибку в расчете калорий
docs: обновить документацию API
style: форматировать код согласно стандартам
refactor: рефакторинг сервиса аутентификации
test: добавить тесты для NutritionBloc
chore: обновить зависимости
```

### 9.2 Branch Naming
```
feature/nutrition-tracking
feature/water-balance
bugfix/calorie-calculation
hotfix/critical-auth-issue
refactor/bloc-architecture
```

## 10. Документация

### 10.1 README.md
```markdown
# NutryFlow

Мобильное приложение для управления питанием и здоровым образом жизни.

## Установка

1. Клонируйте репозиторий
2. Установите зависимости: `flutter pub get`
3. Настройте переменные окружения
4. Запустите приложение: `flutter run`

## Архитектура

Проект использует Clean Architecture с BLoC для управления состоянием.

## Тестирование

```bash
flutter test
```

## Сборка

```bash
flutter build apk
flutter build ios
```
```

Это руководство по разработке обеспечивает единообразие кода, лучшие практики и стандарты качества для проекта NutryFlow. 