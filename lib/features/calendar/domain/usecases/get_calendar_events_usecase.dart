import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';
import '../../../onboarding/domain/repositories/auth_repository.dart';

/// Результат получения событий календаря
class GetCalendarEventsResult {
  final List<CalendarEvent> events;
  final String? error;
  final bool isSuccess;

  const GetCalendarEventsResult.success(this.events)
      : error = null,
        isSuccess = true;

  const GetCalendarEventsResult.failure(this.error)
      : events = const [],
        isSuccess = false;
}

/// Use case для получения событий календаря
class GetCalendarEventsUseCase {
  final CalendarRepository _repository;
  final AuthRepository _authRepository;

  const GetCalendarEventsUseCase(
    this._repository,
    this._authRepository,
  );

  /// Получает все события пользователя
  Future<GetCalendarEventsResult> execute({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? searchQuery,
    bool? onlyToday,
    bool? onlyUpcoming,
    bool? onlyOverdue,
    int? upcomingDays,
  }) async {
    try {
      // Проверяем аутентификацию
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        return const GetCalendarEventsResult.failure(
            'Пользователь не аутентифицирован');
      }

      List<CalendarEvent> events;

      // Выбираем подходящий метод получения событий
      if (onlyToday == true) {
        events = await _repository.getTodayEvents();
      } else if (onlyUpcoming == true) {
        events = await _repository.getUpcomingEvents(upcomingDays ?? 7);
      } else if (onlyOverdue == true) {
        events = await _repository.getOverdueEvents();
      } else if (searchQuery != null && searchQuery.isNotEmpty) {
        events = await _repository.searchEvents(searchQuery);
      } else if (category != null && category.isNotEmpty) {
        events = await _repository.getEventsByCategory(category);
      } else if (startDate != null && endDate != null) {
        events = await _repository.getEventsByDateRange(startDate, endDate);
      } else {
        events = await _repository.getAllEvents();
      }

      // Дополнительная фильтрация если нужно
      if (category != null && category.isNotEmpty && onlyToday != true) {
        events = events.where((e) => e.category == category).toList();
      }

      // Сортировка по дате
      events.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      return GetCalendarEventsResult.success(events);
    } catch (e) {
      return GetCalendarEventsResult.failure(
          'Ошибка при получении событий: ${e.toString()}');
    }
  }
}
