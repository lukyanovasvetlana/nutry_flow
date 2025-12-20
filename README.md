# NutryFlow 🥗

Мобильное приложение для управления питанием и здоровым образом жизни, построенное на Flutter с использованием Clean Architecture.

## 🚀 Быстрый старт для разработчиков

### Экспресс-настройка (5 минут)

```bash
# Клонируйте репозиторий
git clone https://github.com/your-org/nutry_flow.git
cd nutry_flow

# Запустите автоматическую настройку
./scripts/setup_developer_environment.sh
```

📖 **Подробное руководство**: [QUICK_START_DEVELOPER.md](QUICK_START_DEVELOPER.md)

## 🏗️ Архитектура

Проект использует **Clean Architecture** с разделением на слои:

- **Presentation Layer**: BLoC для управления состоянием
- **Domain Layer**: Use Cases и Entities
- **Data Layer**: Repositories и Data Sources

### Структура проекта

```
lib/
├── features/          # Функциональные модули
│   ├── auth/         # Аутентификация
│   ├── onboarding/   # Онбординг
│   ├── dashboard/    # Дашборд
│   ├── nutrition/    # Питание
│   ├── activity/     # Активность
│   └── profile/      # Профиль
├── core/             # Общие компоненты
├── shared/           # Общие виджеты и темы
└── config/           # Конфигурация
```

## 🛠️ Технологии

- **Flutter** 3.16.0+
- **Dart** 3.2.0+
- **BLoC** для управления состоянием
- **GetIt** для dependency injection
- **Supabase** для backend
- **Firebase** для аналитики и push-уведомлений

## 📱 Функциональность

- ✅ Аутентификация пользователей
- ✅ Онбординг и настройка целей
- ✅ Отслеживание питания
- ✅ Планирование тренировок
- ✅ Аналитика и отчеты
- ✅ Push-уведомления
- ✅ Темная/светлая тема

## 🧪 Тестирование

```bash
# Все тесты
flutter test

# С покрытием
flutter test --coverage

# Конкретный тест
flutter test test/features/auth/auth_bloc_test.dart
```

## 📚 Документация

- **Руководство разработчика**: [docs/developer-onboarding-guide.md](docs/developer-onboarding-guide.md)
- **Быстрый старт**: [QUICK_START_DEVELOPER.md](QUICK_START_DEVELOPER.md)
- **Добавление разработчика** (для администраторов): [docs/ADD_DEVELOPER.md](docs/ADD_DEVELOPER.md)
- **Доступ к репозиторию**: [docs/REPOSITORY_ACCESS.md](docs/REPOSITORY_ACCESS.md)
- **Стандарты кодирования**: [docs/development-guidelines.md](docs/development-guidelines.md)
- **Архитектура**: [docs/architecture.md](docs/architecture.md)
- **Scrum процессы**: [docs/scrum/](docs/scrum/)

## 🚀 Разработка

```bash
# Запуск приложения
flutter run

# Сборка для продакшена
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
```

## 🤝 Участие в разработке

1. Создайте ветку для новой функциональности
2. Внесите изменения
3. Напишите тесты
4. Создайте Pull Request
5. Пройдите code review

## 📞 Поддержка

- **Tech Lead**: [tech.lead@company.com]
- **Scrum Master**: [scrum.master@company.com]
- **Slack**: #nutryflow-dev
- **Discord**: #development

---

**Версия**: 1.0.0  
**Лицензия**: MIT  
**Поддержка**: dev-team@company.com
