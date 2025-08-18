import '../data/repositories/meal_plan_repository_impl.dart';
import '../domain/repositories/meal_plan_repository.dart';
import '../domain/usecases/get_meal_plan_usecase.dart';
import '../../onboarding/data/services/supabase_service.dart';
import '../../onboarding/domain/repositories/auth_repository.dart';
import '../../onboarding/data/repositories/auth_repository_impl.dart';

/// Контейнер зависимостей для meal_plan фичи
class MealPlanDependencies {
  static MealPlanDependencies? _instance;

  // Сервисы
  late final SupabaseService _supabaseService;

  // Репозитории
  late final MealPlanRepository _mealPlanRepository;
  late final AuthRepository _authRepository;

  // Use Cases
  late final GetMealPlanUseCase _getMealPlanUseCase;

  MealPlanDependencies._();

  /// Получает singleton экземпляр
  static MealPlanDependencies get instance {
    _instance ??= MealPlanDependencies._();
    return _instance!;
  }

  /// Инициализирует все зависимости
  Future<void> initialize() async {
    // Инициализация сервисов
    _supabaseService = SupabaseService.instance;

    // Инициализация репозиториев
    _mealPlanRepository = MealPlanRepositoryImpl(
      _supabaseService,
    );

    _authRepository = AuthRepositoryImpl(_supabaseService);

    // Инициализация Use Cases
    _getMealPlanUseCase = GetMealPlanUseCase(
      _mealPlanRepository,
      _authRepository,
    );
  }

  // Геттеры для доступа к зависимостям

  MealPlanRepository get mealPlanRepository => _mealPlanRepository;
  GetMealPlanUseCase get getMealPlanUseCase => _getMealPlanUseCase;

  /// Очищает singleton для тестирования
  static void reset() {
    _instance = null;
  }
}
