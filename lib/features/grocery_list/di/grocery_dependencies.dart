import '../data/repositories/grocery_repository_impl.dart';
import '../domain/repositories/grocery_repository.dart';
import '../domain/usecases/get_grocery_items_usecase.dart';
import '../../onboarding/data/services/supabase_service.dart';

/// Контейнер зависимостей для grocery_list фичи
class GroceryDependencies {
  static GroceryDependencies? _instance;

  // Сервисы
  late final SupabaseService _supabaseService;

  // Репозитории
  late final GroceryRepository _groceryRepository;

  // Use Cases
  late final GetGroceryItemsUseCase _getGroceryItemsUseCase;

  GroceryDependencies._();

  /// Получает singleton экземпляр
  static GroceryDependencies get instance {
    _instance ??= GroceryDependencies._();
    return _instance!;
  }

  /// Инициализирует все зависимости
  Future<void> initialize() async {
    // Инициализация сервисов
    _supabaseService = SupabaseService.instance;
    // Инициализация репозиториев
    _groceryRepository = GroceryRepositoryImpl(
      _supabaseService,
    );

    // Инициализация Use Cases
    _getGroceryItemsUseCase = GetGroceryItemsUseCase(_groceryRepository);
  }

  // Геттеры для доступа к зависимостям

  GroceryRepository get groceryRepository => _groceryRepository;
  GetGroceryItemsUseCase get getGroceryItemsUseCase => _getGroceryItemsUseCase;

  /// Очищает singleton для тестирования
  static void reset() {
    _instance = null;
  }
}
