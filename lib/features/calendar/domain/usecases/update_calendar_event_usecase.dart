import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';
import '../../../onboarding/domain/repositories/auth_repository.dart';

/// Результат обновления события календаря
class UpdateCalendarEventResult {
  final CalendarEvent? event;
  final String? error;
  final bool isSuccess;
  
  const UpdateCalendarEventResult.success(this.event) 
      : error = null, isSuccess = true;
  
  const UpdateCalendarEventResult.failure(this.error) 
      : event = null, isSuccess = false;
}

/// Use case для обновления событий календаря
class UpdateCalendarEventUseCase {
  final CalendarRepository _repository;
  final AuthRepository _authRepository;
  
  const UpdateCalendarEventUseCase(
    this._repository,
    this._authRepository,
  );
  
  /// Обновляет событие с валидацией
  Future<UpdateCalendarEventResult> execute(CalendarEvent event) async {
    try {
      // Проверяем аутентификацию
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        return const UpdateCalendarEventResult.failure(
          'Пользователь не аутентифицирован'
        );
      }
      
      // Проверяем существование события
      final existingEvent = await _repository.getEventById(event.id);
      if (existingEvent == null) {
        return const UpdateCalendarEventResult.failure(
          'Событие не найдено'
        );
      }
      
      // Валидация события
      final validationError = _validateEvent(event);
      if (validationError != null) {
        return UpdateCalendarEventResult.failure(validationError);
      }
      
      // Обновление события
      final updatedEvent = await _repository.updateEvent(event);
      
      return UpdateCalendarEventResult.success(updatedEvent);
      
    } catch (e) {
      return UpdateCalendarEventResult.failure(
        'Ошибка при обновлении события: ${e.toString()}'
      );
    }
  }
  
  /// Отмечает событие как выполненное/невыполненное
  Future<UpdateCalendarEventResult> markAsCompleted(String eventId, bool isCompleted) async {
    try {
      // Проверяем аутентификацию
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        return const UpdateCalendarEventResult.failure(
          'Пользователь не аутентифицирован'
        );
      }
      
      // Отмечаем событие
      final updatedEvent = await _repository.markEventAsCompleted(eventId, isCompleted);
      
      return UpdateCalendarEventResult.success(updatedEvent);
      
    } catch (e) {
      return UpdateCalendarEventResult.failure(
        'Ошибка при обновлении статуса события: ${e.toString()}'
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
    
    if (event.endDateTime != null && event.endDateTime!.isBefore(event.dateTime)) {
      return 'Время окончания не может быть раньше времени начала';
    }
    
    if (event.endDateTime != null && 
        event.endDateTime!.difference(event.dateTime).inDays > 365) {
      return 'Событие не может длиться более года';
    }
    
    return null;
  }
} 