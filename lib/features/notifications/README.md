# 🔔 Notifications Feature

## 📋 Обзор

Модуль Notifications отвечает за управление уведомлениями, настройки уведомлений и планирование напоминаний.

## 🏗️ Архитектура

### Domain Layer
- **Entities**: `NotificationPreferences`, `ScheduledNotification`
- **Repositories**: `NotificationRepository`

### Data Layer
- **Repositories**: `NotificationRepository`

### Presentation Layer
- **Screens**: `NotificationSettingsScreen`, `NotificationsScreen`, `ScheduledNotificationsScreen`
- **Bloc**: `NotificationBloc`

## 🚀 Основные функции

### 1. Управление уведомлениями
- Настройка типов уведомлений
- Включение/отключение уведомлений
- Время уведомлений
- Частота напоминаний

### 2. Планирование напоминаний
- Создание напоминаний о тренировках
- Напоминания о приемах пищи
- Напоминания о целях
- Повторяющиеся уведомления

### 3. Push-уведомления
- Локальные уведомления
- Удаленные push-уведомления
- Персонализированные сообщения
- Группировка уведомлений

### 4. Настройки уведомлений
- Персональные предпочтения
- Время тишины
- Звуки уведомлений
- Визуальные настройки

## 📱 Экраны

### NotificationsScreen
Главный экран уведомлений с историей и быстрыми настройками.

### NotificationSettingsScreen
Детальные настройки уведомлений и предпочтений.

### ScheduledNotificationsScreen
Управление запланированными уведомлениями.

## 🧪 Тестирование

### Unit Tests
```bash
flutter test test/features/notifications/data/repositories/notification_repository_test.dart
```

### Widget Tests
```bash
flutter test test/features/notifications/presentation/screens/notifications_screen_test.dart
```

### Integration Tests
```bash
flutter test integration_test/notifications_integration_test.dart
```

## 🔧 Использование

### Создание уведомления
```dart
final notificationService = NotificationService();
await notificationService.scheduleNotification(
  title: 'Время тренировки',
  body: 'Не забудьте о тренировке в 18:00',
  scheduledTime: DateTime.now().add(Duration(hours: 1)),
);
```

### Настройка предпочтений
```dart
final preferences = NotificationPreferences(
  workoutReminders: true,
  mealReminders: true,
  goalReminders: false,
  quietHours: TimeRange(start: 22, end: 8),
);
await notificationService.updatePreferences(preferences);
```

### Получение уведомлений
```dart
final notifications = await notificationService.getScheduledNotifications();
```

## ⚠️ Обработка ошибок

- **Разрешения**: Проверка разрешений на уведомления
- **Ошибки планирования**: Retry механизм
- **Неверные данные**: Валидация времени и параметров
- **Системные ограничения**: Обработка лимитов уведомлений

## 🚀 Планы развития

- [ ] Умные уведомления на основе активности
- [ ] Интеграция с календарем
- [ ] Голосовые уведомления
- [ ] Персонализация на основе времени
- [ ] A/B тестирование уведомлений

## 🔗 Связанные фичи

- **Activity**: Напоминания о тренировках
- **Nutrition**: Напоминания о приемах пищи
- **Calendar**: Интеграция с событиями
- **Profile**: Персональные настройки

---

**Версия**: 1.0.0  
**Последнее обновление**: $(date)  
**Статус**: ✅ Готово к использованию
