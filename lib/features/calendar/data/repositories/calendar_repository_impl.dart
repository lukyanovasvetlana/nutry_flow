import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../../onboarding/data/services/supabase_service.dart';

/// Реализация репозитория для работы с событиями календаря
class CalendarRepositoryImpl implements CalendarRepository {
  final SupabaseService _supabaseService;

  static const String _tableName = 'calendar_events';

  CalendarRepositoryImpl(
    this._supabaseService,
  );

  @override
  Future<List<CalendarEvent>> getAllEvents() async {
    try {
      final response = await _supabaseService.selectData(_tableName);

      final events = response.map(_mapToCalendarEvent).toList();

      // Кэшируем результат
      await _cacheEvents(events);

      return events;
    } catch (e) {
      // Fallback к кэшу
      return _getCachedEvents();
    }
  }

  @override
  Future<List<CalendarEvent>> getEventsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      // Здесь будет запрос с фильтрацией по дате
      final allEvents = await getAllEvents();

      return allEvents
          .where((event) =>
              event.dateTime
                  .isAfter(startDate.subtract(const Duration(days: 1))) &&
              event.dateTime.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    } catch (e) {
      throw Exception('Failed to get events by date range: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getEventsByCategory(String category) async {
    try {
      final response = await _supabaseService.selectData(
        _tableName,
        column: 'category',
        value: category,
      );

      return response.map(_mapToCalendarEvent).toList();
    } catch (e) {
      throw Exception('Failed to get events by category: $e');
    }
  }

  @override
  Future<CalendarEvent?> getEventById(String id) async {
    try {
      final response = await _supabaseService.selectData(
        _tableName,
        column: 'id',
        value: id,
      );

      if (response.isEmpty) return null;

      return _mapToCalendarEvent(response.first);
    } catch (e) {
      throw Exception('Failed to get event by id: $e');
    }
  }

  @override
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    try {
      final data = _mapFromCalendarEvent(event);

      final response = await _supabaseService.insertData(_tableName, data);

      if (response.isEmpty) {
        throw Exception('Failed to create event');
      }

      final createdEvent = _mapToCalendarEvent(response.first);

      // Обновляем кэш
      await _updateCacheAfterCreate(createdEvent);

      return createdEvent;
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  @override
  Future<CalendarEvent> updateEvent(CalendarEvent event) async {
    try {
      final data = _mapFromCalendarEvent(event);

      final response = await _supabaseService.updateData(
        _tableName,
        data,
        'id',
        event.id,
      );

      if (response.isEmpty) {
        throw Exception('Failed to update event');
      }

      final updatedEvent = _mapToCalendarEvent(response.first);

      // Обновляем кэш
      await _updateCacheAfterUpdate(updatedEvent);

      return updatedEvent;
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<bool> deleteEvent(String id) async {
    try {
      final response = await _supabaseService.deleteData(
        _tableName,
        'id',
        id,
      );

      if (response.isEmpty) {
        throw Exception('Failed to delete event');
      }

      // Удаляем из кэша
      await _removeFromCache(id);

      return true;
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  @override
  Future<CalendarEvent> markEventAsCompleted(
      String id, bool isCompleted) async {
    try {
      final response = await _supabaseService.updateData(
        _tableName,
        {
          'is_completed': isCompleted,
          'updated_at': DateTime.now().toIso8601String()
        },
        'id',
        id,
      );

      if (response.isEmpty) {
        throw Exception('Failed to mark event as completed');
      }

      final updatedEvent = _mapToCalendarEvent(response.first);

      // Обновляем кэш
      await _updateCacheAfterUpdate(updatedEvent);

      return updatedEvent;
    } catch (e) {
      throw Exception('Failed to mark event as completed: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getTodayEvents() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      return await getEventsByDateRange(startOfDay, endOfDay);
    } catch (e) {
      throw Exception('Failed to get today events: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getUpcomingEvents(int days) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(Duration(days: days));

      return await getEventsByDateRange(now, endDate);
    } catch (e) {
      throw Exception('Failed to get upcoming events: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getOverdueEvents() async {
    try {
      final allEvents = await getAllEvents();

      return allEvents.where((event) => event.isPastDue).toList();
    } catch (e) {
      throw Exception('Failed to get overdue events: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> searchEvents(String query) async {
    try {
      final allEvents = await getAllEvents();

      return allEvents
          .where((event) =>
              event.title.toLowerCase().contains(query.toLowerCase()) ||
              (event.description?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (event.location?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
          .toList();
    } catch (e) {
      throw Exception('Failed to search events: $e');
    }
  }

  // Приватные методы для работы с кэшем и маппингом

  CalendarEvent _mapToCalendarEvent(Map<String, dynamic> data) {
    return CalendarEvent.fromJson(data);
  }

  Map<String, dynamic> _mapFromCalendarEvent(CalendarEvent event) {
    return event.toJson();
  }

  Future<void> _cacheEvents(List<CalendarEvent> events) async {
    // Кэшируем события локально
    // Реализация зависит от структуры кэша
  }

  Future<List<CalendarEvent>> _getCachedEvents() async {
    // Получаем события из кэша
    // Возвращаем пустой список если кэш пуст
    return [];
  }

  Future<void> _updateCacheAfterCreate(CalendarEvent event) async {
    // Обновляем кэш после создания
  }

  Future<void> _updateCacheAfterUpdate(CalendarEvent event) async {
    // Обновляем кэш после обновления
  }

  Future<void> _removeFromCache(String eventId) async {
    // Удаляем из кэша
  }
}
