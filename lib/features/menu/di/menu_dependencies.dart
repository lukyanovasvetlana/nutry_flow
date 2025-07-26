import '../data/repositories/recipe_repository_impl.dart';
import '../domain/repositories/recipe_repository.dart';
import '../domain/usecases/get_all_recipes_usecase.dart';
import '../domain/usecases/save_recipe_usecase.dart';
import '../domain/usecases/delete_recipe_usecase.dart';
import '../../onboarding/data/services/supabase_service.dart';
import '../../onboarding/data/services/local_storage_service.dart';

/// Контейнер зависимостей для menu фичи
class MenuDependencies {
  static MenuDependencies? _instance;
  
  // Сервисы (переиспользуем из onboarding)
  late final SupabaseService _supabaseService;
  late final LocalStorageService _localStorageService;
  
  // Репозитории
  late final RecipeRepository _recipeRepository;
  
  // Use Cases
  late final GetAllRecipesUseCase _getAllRecipesUseCase;
  late final SaveRecipeUseCase _saveRecipeUseCase;
  late final DeleteRecipeUseCase _deleteRecipeUseCase;
  
  MenuDependencies._();
  
  /// Получает singleton экземпляр
  static MenuDependencies get instance {
    _instance ??= MenuDependencies._();
    return _instance!;
  }
  
  /// Инициализирует все зависимости
  Future<void> initialize() async {
    // Инициализация сервисов
    _supabaseService = SupabaseService.instance;
    _localStorageService = await LocalStorageService.create();
    
    // Инициализация репозиториев
    _recipeRepository = RecipeRepositoryImpl(
      _supabaseService,
      _localStorageService,
    );
    
    // Инициализация Use Cases
    _getAllRecipesUseCase = GetAllRecipesUseCase(_recipeRepository);
    _saveRecipeUseCase = SaveRecipeUseCase(_recipeRepository);
    _deleteRecipeUseCase = DeleteRecipeUseCase(_recipeRepository);
  }
  
  // Геттеры для доступа к зависимостям
  
  RecipeRepository get recipeRepository => _recipeRepository;
  GetAllRecipesUseCase get getAllRecipesUseCase => _getAllRecipesUseCase;
  SaveRecipeUseCase get saveRecipeUseCase => _saveRecipeUseCase;
  DeleteRecipeUseCase get deleteRecipeUseCase => _deleteRecipeUseCase;
  
  /// Очищает singleton для тестирования
  static void reset() {
    _instance = null;
  }
} 