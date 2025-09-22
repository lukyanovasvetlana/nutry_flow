# 🔐 Auth Feature

## Обзор

Auth - это система аутентификации и авторизации для приложения NutryFlow, обеспечивающая безопасный доступ пользователей к функциям приложения.

## Архитектура

### Структура папок
```
lib/features/auth/
├── data/
│   ├── models/
│   │   └── user.dart                    # Модель пользователя
│   ├── repositories/
│   │   └── auth_repository_impl.dart    # Реализация репозитория
│   └── services/
│       └── auth_service.dart            # Сервис аутентификации
├── domain/
│   ├── entities/
│   │   └── user_entity.dart             # Сущность пользователя
│   ├── repositories/
│   │   └── auth_repository.dart         # Интерфейс репозитория
│   └── usecases/
│       ├── login_usecase.dart           # Вход в систему
│       ├── register_usecase.dart        # Регистрация
│       └── logout_usecase.dart          # Выход из системы
├── presentation/
│   ├── screens/
│   │   ├── login_screen.dart            # Экран входа
│   │   ├── register_screen.dart         # Экран регистрации
│   │   └── forgot_password_screen.dart  # Восстановление пароля
│   └── widgets/
│       └── auth_form_widget.dart        # Форма аутентификации
└── di/
    └── auth_dependencies.dart           # Dependency Injection
```

## Основные компоненты

### 1. AuthService
Центральный сервис для аутентификации:
- Вход в систему
- Регистрация
- Выход из системы
- Восстановление пароля
- Управление сессией

### 2. User Entity
Модель пользователя с полями:
- `id` - уникальный идентификатор
- `email` - email адрес
- `firstName` - имя
- `lastName` - фамилия
- `createdAt` - дата создания
- `isEmailVerified` - статус верификации

### 3. AuthRepository
Интерфейс для работы с данными аутентификации:
```dart
abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String firstName, String lastName);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<UserEntity?> getCurrentUser();
}
```

## Использование

### Вход в систему
```dart
final authService = AuthService();
try {
  final user = await authService.login('user@example.com', 'password');
  // Пользователь успешно вошел в систему
} catch (e) {
  // Обработка ошибки
}
```

### Регистрация
```dart
try {
  final user = await authService.register(
    'user@example.com',
    'password',
    'John',
    'Doe',
  );
  // Пользователь успешно зарегистрирован
} catch (e) {
  // Обработка ошибки
}
```

### Выход из системы
```dart
await authService.logout();
```

### Проверка текущего пользователя
```dart
final currentUser = await authService.getCurrentUser();
if (currentUser != null) {
  // Пользователь аутентифицирован
}
```

## Навигация

### Маршруты
- `/login` - экран входа
- `/register` - экран регистрации
- `/forgot-password` - восстановление пароля

### Пример навигации
```dart
// Переход к экрану входа
Navigator.pushNamed(context, '/login');

// Переход к экрану регистрации
Navigator.pushNamed(context, '/register');
```

## Валидация

### Email валидация
```dart
bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}
```

### Password валидация
```dart
bool isValidPassword(String password) {
  return password.length >= 8;
}
```

## Безопасность

### Хеширование паролей
- Пароли хешируются на сервере
- Используется bcrypt для хеширования
- Соль генерируется автоматически

### JWT токены
- Access токены для аутентификации
- Refresh токены для обновления
- Автоматическое обновление токенов

### HTTPS
- Все запросы выполняются по HTTPS
- Сертификаты проверяются автоматически

## Тестирование

### Unit тесты
```bash
flutter test test/features/auth/
```

### Покрытие тестами
- ✅ AuthService - 2 теста
- ❌ Widgets - требуются тесты
- ❌ Use cases - требуются тесты

### Тестовые данные
```dart
// Тестовый пользователь
const testUser = UserEntity(
  id: 'test-id',
  email: 'test@example.com',
  firstName: 'Test',
  lastName: 'User',
  createdAt: DateTime.now(),
  isEmailVerified: true,
);
```

## Обработка ошибок

### Типы ошибок
- `InvalidCredentialsException` - неверные учетные данные
- `UserNotFoundException` - пользователь не найден
- `EmailAlreadyExistsException` - email уже существует
- `NetworkException` - ошибка сети
- `ValidationException` - ошибка валидации

### Пример обработки
```dart
try {
  await authService.login(email, password);
} on InvalidCredentialsException {
  showError('Неверный email или пароль');
} on NetworkException {
  showError('Ошибка сети. Проверьте подключение');
} catch (e) {
  showError('Произошла неизвестная ошибка');
}
```

## Зависимости

- `supabase` - Backend as a Service
- `shared_preferences` - локальное хранение токенов
- `dio` - HTTP клиент
- `flutter/material.dart` - UI компоненты

## Конфигурация

### Supabase настройка
```dart
// В main.dart
Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### Environment variables
```dart
// .env файл
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Известные проблемы

1. **Token refresh** - нет автоматического обновления токенов
2. **Offline support** - нет поддержки офлайн режима
3. **Biometric auth** - нет биометрической аутентификации

## Планы развития

- [ ] Добавить биометрическую аутентификацию
- [ ] Реализовать двухфакторную аутентификацию
- [ ] Добавить социальные сети (Google, Apple)
- [ ] Улучшить offline support
- [ ] Добавить remember me функциональность

## Связанные фичи

- **Profile** - профиль пользователя
- **Onboarding** - первичная настройка
- **Dashboard** - главный экран после входа
