# Фича Auth - Аутентификация пользователей

## 📋 Обзор

Фича Auth предоставляет полный цикл аутентификации пользователей в приложении Nutry Flow, включая регистрацию, вход, выход и управление паролями.

## 🏗️ Архитектура

### Структура фичи

```
lib/features/auth/
├── domain/           # Бизнес-логика
│   ├── entities/     # Сущности (User)
│   ├── usecases/     # Сценарии использования
│   └── repositories/ # Интерфейсы репозиториев
├── data/             # Реализация данных
│   ├── services/     # Сервисы (AuthService)
│   ├── models/       # Модели данных
│   ├── repositories/ # Реализации репозиториев
│   └── datasources/  # Источники данных
├── presentation/      # UI слой
│   ├── screens/      # Экраны аутентификации
│   ├── widgets/      # Переиспользуемые виджеты
│   └── bloc/         # Управление состоянием
└── di/               # Dependency Injection
```

### Основные компоненты

1. **User Entity** - основная сущность пользователя
2. **AuthService** - сервис для работы с аутентификацией
3. **Auth Screens** - экраны входа, регистрации, сброса пароля

## 🚀 Использование

### Базовые операции

#### Регистрация пользователя

```dart
import 'package:nutry_flow/features/auth/data/services/auth_service.dart';

final authService = AuthService();

try {
  final response = await authService.signUp(
    email: 'user@example.com',
    password: 'secure_password',
  );
  
  print('Пользователь зарегистрирован: ${response.user?.email}');
} catch (e) {
  print('Ошибка регистрации: $e');
}
```

#### Вход пользователя

```dart
try {
  final response = await authService.signIn(
    email: 'user@example.com',
    password: 'secure_password',
  );
  
  print('Пользователь вошел: ${response.user?.email}');
} catch (e) {
  print('Ошибка входа: $e');
}
```

#### Выход пользователя

```dart
try {
  await authService.signOut();
  print('Пользователь вышел из системы');
} catch (e) {
  print('Ошибка выхода: $e');
}
```

#### Сброс пароля

```dart
try {
  await authService.resetPassword('user@example.com');
  print('Ссылка для сброса пароля отправлена');
} catch (e) {
  print('Ошибка сброса пароля: $e');
}
```

### Получение текущего пользователя

```dart
final currentUser = authService.currentUser;

if (currentUser != null) {
  print('Текущий пользователь: ${currentUser.email}');
} else {
  print('Пользователь не авторизован');
}
```

### Подписка на изменения состояния аутентификации

```dart
authService.authStateChanges.listen((authState) {
  switch (authState.event) {
    case AuthChangeEvent.signedIn:
      print('Пользователь вошел в систему');
      break;
    case AuthChangeEvent.signedOut:
      print('Пользователь вышел из системы');
      break;
    case AuthChangeEvent.tokenRefreshed:
      print('Токен обновлен');
      break;
    default:
      print('Состояние аутентификации: ${authState.event}');
  }
});
```

## 🔧 Конфигурация

### Демо-режим

Фича поддерживает демо-режим для разработки и тестирования. В демо-режиме:

- Все операции аутентификации симулируются
- Не выполняются реальные API вызовы
- Создаются временные пользователи

Для включения демо-режима установите в конфигурации:

```dart
// config/supabase_config.dart
static const bool isDemo = true;
```

### Supabase интеграция

Для продакшн использования настройте Supabase:

1. Создайте проект в [Supabase Console](https://supabase.com)
2. Получите URL и API ключи
3. Настройте аутентификацию в проекте
4. Обновите конфигурацию:

```dart
// config/supabase_config.dart
static const String url = 'https://your-project.supabase.co';
static const String anonKey = 'your-anon-key';
```

## 🧪 Тестирование

### Unit тесты

```bash
# Запуск тестов для User entity
flutter test test/features/auth/domain/entities/user_test.dart

# Запуск тестов для AuthService
flutter test test/features/auth/data/services/auth_service_test.dart

# Запуск всех тестов фичи Auth
flutter test test/features/auth/
```

### Тестовые сценарии

- ✅ Создание пользователя с валидными данными
- ✅ Обработка пустых полей
- ✅ Специальные символы в email
- ✅ JSON сериализация/десериализация
- ✅ Демо-режим
- ✅ Обработка ошибок
- ✅ Edge cases (длинные строки, unicode)

## 📚 API Reference

### User Entity

```dart
class User {
  final String id;           // Уникальный идентификатор
  final String email;        // Email адрес
  final DateTime? createdAt; // Дата создания
  final DateTime? updatedAt; // Дата обновления
  
  // Конструктор
  User({required this.id, required this.email, ...});
  
  // JSON сериализация
  factory User.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### AuthService

```dart
class AuthService {
  // Регистрация
  Future<AuthResponse> signUp({required String email, required String password});
  
  // Вход
  Future<AuthResponse> signIn({required String email, required String password});
  
  // Выход
  Future<void> signOut();
  
  // Сброс пароля
  Future<void> resetPassword(String email);
  
  // Текущий пользователь
  User? get currentUser;
  
  // Поток изменений состояния
  Stream<AuthState> get authStateChanges;
}
```

## 🚨 Обработка ошибок

### Типы ошибок

1. **AuthException** - ошибки аутентификации
2. **NetworkException** - проблемы с сетью
3. **ValidationException** - ошибки валидации

### Пример обработки

```dart
try {
  await authService.signIn(email: email, password: password);
} on AuthException catch (e) {
  switch (e.message) {
    case 'Invalid login credentials':
      showError('Неверный email или пароль');
      break;
    case 'Email not confirmed':
      showError('Подтвердите email адрес');
      break;
    default:
      showError('Ошибка входа: ${e.message}');
  }
} on NetworkException catch (e) {
  showError('Проблемы с подключением к интернету');
} catch (e) {
  showError('Неизвестная ошибка: $e');
}
```

## 🔒 Безопасность

### Рекомендации

1. **Пароли** - минимум 8 символов, включая буквы и цифры
2. **Email валидация** - проверка формата на клиенте и сервере
3. **Rate limiting** - ограничение попыток входа
4. **HTTPS** - обязательное использование в продакшене
5. **Токены** - безопасное хранение и обновление

### GDPR и приватность

- Не логируем пароли и персональные данные
- Предоставляем возможность удаления аккаунта
- Соблюдаем принцип минимальной достаточности

## 📈 Мониторинг

### Метрики для отслеживания

- Количество регистраций/входов
- Успешность аутентификации
- Время ответа API
- Ошибки валидации
- Попытки сброса пароля

### Логирование

```dart
// Включение детального логирования
developer.log('🔐 AuthService: Attempting signin for $email', name: 'AuthService');
```

## 🚀 Планы развития

### Краткосрочные (1-2 месяца)

- [ ] Добавить двухфакторную аутентификацию
- [ ] Реализовать OAuth (Google, Apple)
- [ ] Добавить биометрическую аутентификацию

### Среднесрочные (3-6 месяцев)

- [ ] Интеграция с Active Directory
- [ ] Single Sign-On (SSO)
- [ ] Управление сессиями

### Долгосрочные (6+ месяцев)

- [ ] Multi-tenant архитектура
- [ ] Federation с внешними системами
- [ ] Advanced analytics и security

## 🤝 Вклад в разработку

### Code Review чеклист

- [ ] Документация для всех публичных методов
- [ ] Unit тесты с покрытием >80%
- [ ] Обработка ошибок и edge cases
- [ ] Безопасность (валидация, sanitization)
- [ ] Performance (async операции, кэширование)

### Стандарты кода

- Используйте `///` для документации
- Следуйте naming conventions
- Обрабатывайте все возможные ошибки
- Пишите тесты для новых фич

## 📞 Поддержка

### Полезные ссылки

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Dart Documentation](https://dart.dev/guides/language/language-tour)

### Команда

- **Product Owner**: [Имя]
- **Tech Lead**: [Имя]
- **QA Engineer**: [Имя]

---

*Последнее обновление: ${new Date().toLocaleDateString()}*
