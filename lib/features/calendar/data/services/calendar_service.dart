import '../../domain/entities/calendar_event.dart';

class CalendarService {
  static List<CalendarEvent> getMockEvents() {
    return [
      CalendarEvent(
        id: '1',
        userId: 'user1',
        category: 'Meal Planning',
        title: 'Завтрак',
        dateTime: DateTime.now().add(const Duration(hours: 8)),
        location: 'Дом',
        note: 'Овсянка с фруктами',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Добавьте больше моковых событий если нужно
    ];
  }
} 