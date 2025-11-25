import 'package:nutry_flow/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:nutry_flow/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:nutry_flow/features/calendar/domain/usecases/get_calendar_events_usecase.dart';
import 'package:nutry_flow/features/calendar/domain/usecases/create_calendar_event_usecase.dart';
import 'package:nutry_flow/features/calendar/domain/usecases/update_calendar_event_usecase.dart';
import 'package:nutry_flow/features/onboarding/data/services/supabase_service.dart';
import 'package:nutry_flow/features/onboarding/domain/repositories/auth_repository.dart';
import 'package:nutry_flow/features/onboarding/data/repositories/auth_repository_impl.dart';

/// Контейнер зависимостей для calendar фичи
class CalendarDependencies {
  static CalendarDependencies? _instance;

  // Сервисы
  late final SupabaseService _supabaseService;

  // Репозитории
  late final CalendarRepository _calendarRepository;
  late final AuthRepository _authRepository;

  // Use Cases
  late final GetCalendarEventsUseCase _getCalendarEventsUseCase;
  late final CreateCalendarEventUseCase _createCalendarEventUseCase;
  late final UpdateCalendarEventUseCase _updateCalendarEventUseCase;

  CalendarDependencies._();

  /// Получает singleton экземпляр
  static CalendarDependencies get instance {
    _instance ??= CalendarDependencies._();
    return _instance!;
  }

  /// Инициализирует все зависимости
  Future<void> initialize() async {
    // Инициализация сервисов
    _supabaseService = SupabaseService.instance;

    // Инициализация репозиториев
    _calendarRepository = CalendarRepositoryImpl(
      _supabaseService,
    );

    _authRepository = AuthRepositoryImpl(_supabaseService);

    // Инициализация Use Cases
    _getCalendarEventsUseCase = GetCalendarEventsUseCase(
      _calendarRepository,
      _authRepository,
    );

    _createCalendarEventUseCase = CreateCalendarEventUseCase(
      _calendarRepository,
      _authRepository,
    );

    _updateCalendarEventUseCase = UpdateCalendarEventUseCase(
      _calendarRepository,
      _authRepository,
    );
  }

  // Геттеры для доступа к зависимостям

  CalendarRepository get calendarRepository => _calendarRepository;
  GetCalendarEventsUseCase get getCalendarEventsUseCase =>
      _getCalendarEventsUseCase;
  CreateCalendarEventUseCase get createCalendarEventUseCase =>
      _createCalendarEventUseCase;
  UpdateCalendarEventUseCase get updateCalendarEventUseCase =>
      _updateCalendarEventUseCase;

  /// Очищает singleton для тестирования
  static void reset() {
    _instance = null;
  }
}
