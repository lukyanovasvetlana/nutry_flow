# 📅 Calendar Feature

## 📋 Обзор

Модуль Calendar отвечает за управление календарем событий, планирование тренировок и отслеживание важных дат.

## 🏗️ Архитектура

### Domain Layer
- **Entities**: `CalendarEvent`
- **Repositories**: `CalendarRepository`
- **Use Cases**: `CreateCalendarEventUsecase`, `GetCalendarEventsUsecase`, `UpdateCalendarEventUsecase`

### Data Layer
- **Services**: `CalendarService`
- **Repositories**: `CalendarRepositoryImpl`

### Presentation Layer
- **Screens**: `CalendarScreen`
- **Bloc**: `CalendarBloc`

## 🚀 Основные функции

### 1. Управление событиями
- Создание календарных событий
- Редактирование существующих событий
- Удаление событий
- Категоризация событий

### 2. Планирование тренировок
- Планирование тренировочных сессий
- Напоминания о тренировках
- Интеграция с календарем устройства

### 3. Просмотр расписания
- Месячный вид календаря
- Недельный вид
- Дневной вид
- Фильтрация по типам событий

### 4. Уведомления
- Напоминания о предстоящих событиях
- Push-уведомления
- Email-напоминания

## 📱 Экраны

### CalendarScreen
Главный экран календаря с отображением событий и возможностью их управления.

## 🧪 Тестирование

### Unit Tests
```bash
flutter test test/features/calendar/data/services/calendar_service_test.dart
```

### Widget Tests
```bash
flutter test test/features/calendar/presentation/screens/calendar_screen_test.dart
```

### Integration Tests
```bash
flutter test integration_test/calendar_integration_test.dart
```

## 🔧 Использование

### Создание события
```dart
final calendarService = CalendarService();
final event = CalendarEvent(
  title: 'Тренировка',
  description: 'Утренняя пробежка',
  startTime: DateTime.now(),
  endTime: DateTime.now().add(Duration(hours: 1)),
  type: EventType.workout,
);
await calendarService.createEvent(event);
```

### Получение событий
```dart
final events = await calendarService.getEventsForDate(DateTime.now());
```

### Обновление события
```dart
event.title = 'Обновленная тренировка';
await calendarService.updateEvent(event);
```

## ⚠️ Обработка ошибок

- **Конфликты времени**: Проверка пересечений событий
- **Ошибки синхронизации**: Retry механизм
- **Неверные данные**: Валидация времени и дат

## 🚀 Планы развития

- [ ] Интеграция с Google Calendar
- [ ] Синхронизация с Apple Calendar
- [ ] Повторяющиеся события
- [ ] Цветовая кодировка событий
- [ ] Экспорт в iCal формат

## 🔗 Связанные фичи

- **Activity**: Планирование тренировок
- **Notifications**: Напоминания о событиях
- **Profile**: Персональные настройки календаря

---

**Версия**: 1.0.0  
**Последнее обновление**: $(date)  
**Статус**: ✅ Готово к использованию
