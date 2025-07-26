import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';
import '../../../onboarding/domain/repositories/auth_repository.dart';

/// Результат создания события календаря
class CreateCalendarEventResult {
  final CalendarEvent? event;
  final String? error;
  final bool isSuccess;
  
  const CreateCalendarEventResult.success(this.event) 
      : error = null, isSuccess = true;
  
  const CreateCalendarEventResult.failure(this.error) 
      : event = null, isSuccess = false;
}

/// Use case для создания событий календаря
class CreateCalendarEventUseCase {
  final CalendarRepository _repository;
  final AuthRepository _authRepository;
  
  const CreateCalendarEventUseCase(
    this._repository,
    this._authRepository,
  );
  
  /// Создает новое событие с валидацией
  Future<CreateCalendarEventResult> execute(CalendarEvent event) async {
    try {
      // Проверяем аутентификацию
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        return const CreateCalendarEventResult.failure(
          'Пользователь не аутентифицирован'
        );
      }
      
      // Валидация события
      final validationError = _validateEvent(event);
      if (validationError != null) {
        return CreateCalendarEventResult.failure(validationError);
      }
      
      // Проверка на конфликты времени
      final conflictError = await _checkTimeConflicts(event);
      if (conflictError != null) {
        return CreateCalendarEventResult.failure(conflictError);
      }
      
      // Создание события
      final createdEvent = await _repository.createEvent(event);
      
      return CreateCalendarEventResult.success(createdEvent);
      
    } catch (e) {
      return CreateCalendarEventResult.failure(
        'Ошибка при создании события: ${e.toString()}'
      );
    }
  }
  
  /// Валидация события
  String? _validateEvent(CalendarEvent event) {
    if (event.title.isEmpty) {
      return 'Название события не может быть пустым';
    }
    
    if (event.title.length < 3) {
      return 'Название события должно содержать минимум 3 символа';
    }
    
    if (event.dateTime.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Нельзя создать событие в прошлом';
    }
    
    if (event.endDateTime != null && event.endDateTime!.isBefore(event.dateTime)) {
      return 'Время окончания не может быть раньше времени начала';
    }
    
    if (event.endDateTime != null && 
        event.endDateTime!.difference(event.dateTime).inDays > 365) {
      return 'Событие не может длиться более года';
    }
    
    return null;
  }
  
  /// Проверка конфликтов времени
  Future<String?> _checkTimeConflicts(CalendarEvent newEvent) async {
    try {
      // Получаем события на тот же день
      final dayStart = DateTime(newEvent.dateTime.year, newEvent.dateTime.month, newEvent.dateTime.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      
      final existingEvents = await _repository.getEventsByDateRange(dayStart, dayEnd);
      
      // Проверяем пересечения времени
      for (final event in existingEvents) {
        if (_eventsOverlap(newEvent, event)) {
          return 'Событие пересекается с "${event.title}" в ${_formatTime(event.dateTime)}';
        }
      }
      
      return null;
    } catch (e) {
      // Не блокируем создание события из-за ошибки проверки конфликтов
      return null;
    }
  }
  
  /// Проверяет пересечение двух событий
  bool _eventsOverlap(CalendarEvent event1, CalendarEvent event2) {
    final start1 = event1.dateTime;
    final end1 = event1.endDateTime ?? event1.dateTime.add(const Duration(hours: 1));
    
    final start2 = event2.dateTime;
    final end2 = event2.endDateTime ?? event2.dateTime.add(const Duration(hours: 1));
    
    return start1.isBefore(end2) && end1.isAfter(start2);
  }
  
  /// Форматирует время для отображения
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 