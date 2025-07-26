# 🏗️ Реализация Clean Architecture в NutryFlow

## 📋 Обзор

Данная документация описывает реализацию Clean Architecture в фиче `onboarding` как образец для всех остальных фич приложения.

## 🎯 Что было улучшено

### 1. ✅ **Добавлены интерфейсы репозиториев в Domain слой**

```dart
// lib/features/onboarding/domain/repositories/user_goals_repository.dart
abstract class UserGoalsRepository {
  Future<UserGoals> saveUserGoals(UserGoals goals, String userId);
  Future<UserGoals?> getUserGoals(String userId);
  Future<UserGoals> updateUserGoals(UserGoals goals, String userId);
  Future<bool> deleteUserGoals(String userId);
}
```

**Преимущества:**
- Определяет контракт для работы с данными
- Обеспечивает независимость от конкретной реализации
- Упрощает тестирование через моки

### 2. ✅ **Созданы Use Cases для бизнес-логики**

```dart
// lib/features/onboarding/domain/usecases/save_user_goals_usecase.dart
class SaveUserGoalsUseCase {
  Future<SaveUserGoalsResult> execute(UserGoals goals) async {
    // Валидация целей
    if (!goals.isValid) {
      return SaveUserGoalsResult.failure(goals.validationError);
    }
    
    // Получение текущего пользователя
    final currentUser = await _authRepository.getCurrentUser();
    if (currentUser == null) {
      return SaveUserGoalsResult.failure('Пользователь не аутентифицирован');
    }
    
    // Дополнительная бизнес-валидация
    final validationError = _validateBusinessRules(goals);
    if (validationError != null) {
      return SaveUserGoalsResult.failure(validationError);
    }
    
    // Сохранение целей
    final savedGoals = await _userGoalsRepository.saveUserGoals(goals, currentUser.id);
    return SaveUserGoalsResult.success(savedGoals);
  }
}
```

**Преимущества:**
- Инкапсулирует бизнес-логику
- Обеспечивает валидацию данных
- Легко тестируется изолированно

### 3. ✅ **Вынесены сервисы в Data слой**

#### Supabase Service
```dart
// lib/features/onboarding/data/services/supabase_service.dart
class SupabaseService {
  Future<List<Map<String, dynamic>>> insertData(String table, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> selectData(String table, {String? column, dynamic value});
  Future<List<Map<String, dynamic>>> updateData(String table, Map<String, dynamic> data, String column, dynamic value);
  Future<List<Map<String, dynamic>>> deleteData(String table, String column, dynamic value);
}
```

#### Local Storage Service
```dart
// lib/features/onboarding/data/services/local_storage_service.dart
class LocalStorageService {
  Future<bool> saveUserGoals(Map<String, dynamic> goals, String userId);
  Map<String, dynamic>? getUserGoals(String userId);
  Future<bool> deleteUserGoals(String userId);
}
```

**Преимущества:**
- Инкапсулирует работу с внешними API
- Обеспечивает кэширование данных
- Легко заменяется для тестирования

### 4. ✅ **Реализованы репозитории с кэшированием**

```dart
// lib/features/onboarding/data/repositories/user_goals_repository_impl.dart
class UserGoalsRepositoryImpl implements UserGoalsRepository {
  @override
  Future<UserGoals> saveUserGoals(UserGoals goals, String userId) async {
    try {
      // Сохранение в Supabase
      final response = await _supabaseService.insertData(_tableName, data);
      
      // Кэширование в локальном хранилище
      await _localStorageService.saveUserGoals(goals.toJson(), userId);
      
      return goals;
    } catch (e) {
      // Fallback к локальному сохранению
      await _localStorageService.saveUserGoals(goals.toJson(), userId);
      rethrow;
    }
  }
}
```

**Преимущества:**
- Реализует паттерн Repository
- Обеспечивает работу в offline режиме
- Автоматическое кэширование

### 5. ✅ **Обновлен BLoC для использования Use Cases**

```dart
// lib/features/onboarding/presentation/bloc/goals_setup_bloc.dart
class GoalsSetupBloc extends Bloc<GoalsSetupEvent, GoalsSetupState> {
  final SaveUserGoalsUseCase _saveUserGoalsUseCase;
  final GetUserGoalsUseCase _getUserGoalsUseCase;

  void _onSaveGoals(SaveGoals event, Emitter<GoalsSetupState> emit) async {
    if (state is GoalsSetupLoaded) {
      emit(GoalsSetupSaving());
      
      final result = await _saveUserGoalsUseCase.execute(currentState.goals);
      
      if (result.isSuccess) {
        emit(GoalsSetupSaved(result.goals!));
      } else {
        emit(GoalsSetupError(result.error!));
      }
    }
  }
}
```

**Преимущества:**
- Использует Use Cases вместо прямого доступа к репозиториям
- Четкое разделение ответственности
- Легко тестируется

### 6. ✅ **Добавлен Dependency Injection**

```dart
// lib/features/onboarding/di/onboarding_dependencies.dart
class OnboardingDependencies {
  Future<void> initialize() async {
    // Инициализация сервисов
    _supabaseService = SupabaseService.instance;
    _localStorageService = await LocalStorageService.create();
    
    // Инициализация репозиториев
    _userGoalsRepository = UserGoalsRepositoryImpl(_supabaseService, _localStorageService);
    _authRepository = AuthRepositoryImpl(_supabaseService);
    
    // Инициализация Use Cases
    _saveUserGoalsUseCase = SaveUserGoalsUseCase(_userGoalsRepository, _authRepository);
    _getUserGoalsUseCase = GetUserGoalsUseCase(_userGoalsRepository, _authRepository);
  }
  
  GoalsSetupBloc createGoalsSetupBloc() {
    return GoalsSetupBloc(_saveUserGoalsUseCase, _getUserGoalsUseCase);
  }
}
```

**Преимущества:**
- Централизованное управление зависимостями
- Легкая замена реализаций
- Упрощает тестирование

## 📊 Архитектурная диаграмма

```
┌─────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────────┤
│  GoalsSetupScreen → GoalsSetupBloc → GoalsSetupState/Event     │
│                           ↓                                     │
│                    Uses Use Cases                               │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  SaveUserGoalsUseCase ← → UserGoalsRepository (Interface)      │
│  GetUserGoalsUseCase  ← → AuthRepository (Interface)           │
│                   ↑                                             │
│            UserGoals (Entity)                                   │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│  UserGoalsRepositoryImpl → SupabaseService                     │
│  AuthRepositoryImpl      → LocalStorageService                 │
│                           ↓                                     │
│                   External APIs                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 🧪 Тестирование

### Пример тестирования Use Case:

```dart
void main() {
  group('SaveUserGoalsUseCase', () {
    late MockUserGoalsRepository mockRepository;
    late MockAuthRepository mockAuthRepository;
    late SaveUserGoalsUseCase useCase;

    setUp(() {
      mockRepository = MockUserGoalsRepository();
      mockAuthRepository = MockAuthRepository();
      useCase = SaveUserGoalsUseCase(mockRepository, mockAuthRepository);
    });

    test('should save goals successfully', () async {
      // Arrange
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => User(id: 'user1', email: 'test@test.com'));
      
      // Act
      final result = await useCase.execute(validGoals);
      
      // Assert
      expect(result.isSuccess, true);
      verify(mockRepository.saveUserGoals(validGoals, 'user1')).called(1);
    });
  });
}
```

## 📝 Следующие шаги

1. **Применить к другим фичам**: Использовать эту структуру для других фич
2. **Добавить интеграционные тесты**: Тестировать взаимодействие между слоями
3. **Улучшить error handling**: Добавить более детальную обработку ошибок
4. **Добавить логирование**: Для отслеживания работы приложения

## 🎯 Результат

Теперь фича `onboarding` полностью соответствует принципам Clean Architecture:

- ✅ Четкое разделение слоев
- ✅ Инверсия зависимостей
- ✅ Независимость от фреймворков
- ✅ Легкое тестирование
- ✅ Простота поддержки и расширения

Эта архитектура обеспечивает масштабируемость, поддерживаемость и тестируемость кода. 