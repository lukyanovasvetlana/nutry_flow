import '../entities/calendar_event.dart';

/// Интерфейс репозитория для работы с событиями календаря
abstract class CalendarRepository {
  /// Получает все события пользователя
  Future<List<CalendarEvent>> getAllEvents();

  /// Получает события за определенный период
  Future<List<CalendarEvent>> getEventsByDateRange(
      DateTime startDate, DateTime endDate);

  /// Получает события по категории
  Future<List<CalendarEvent>> getEventsByCategory(String category);

  /// Получает событие по ID
  Future<CalendarEvent?> getEventById(String id);

  /// Создает новое событие
  Future<CalendarEvent> createEvent(CalendarEvent event);

  /// Обновляет существующее событие
  Future<CalendarEvent> updateEvent(CalendarEvent event);

  /// Удаляет событие
  Future<bool> deleteEvent(String id);

  /// Отмечает событие как выполненное
  Future<CalendarEvent> markEventAsCompleted(String id, bool isCompleted);

  /// Получает события на сегодня
  Future<List<CalendarEvent>> getTodayEvents();

  /// Получает предстоящие события
  Future<List<CalendarEvent>> getUpcomingEvents(int days);

  /// Получает просроченные события
  Future<List<CalendarEvent>> getOverdueEvents();

  /// Ищет события по тексту
  Future<List<CalendarEvent>> searchEvents(String query);
}
