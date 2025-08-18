import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Domain
import '../domain/repositories/nutrition_repository.dart';
import '../domain/usecases/add_food_entry_usecase.dart';
import '../domain/usecases/search_food_items_usecase.dart';
import '../domain/usecases/get_nutrition_diary_usecase.dart';

// Data
import '../data/repositories/nutrition_repository_impl.dart';
import '../data/services/nutrition_api_service.dart';
import '../data/services/nutrition_cache_service.dart';

// Presentation
import '../presentation/bloc/nutrition_search_cubit.dart';
import '../presentation/bloc/food_entry_cubit.dart';
import '../presentation/bloc/nutrition_diary_cubit.dart';

class NutritionDependencies {
  static final GetIt _getIt = GetIt.instance;

  static void initialize() {
    register();
  }

  static void register() {
    _registerServices();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();
  }

  static void _registerServices() {
    // API Service
    _getIt.registerLazySingleton<NutritionApiService>(
      () => NutritionApiService(
        Supabase.instance.client,
      ),
    );

    // Cache Service
    _getIt.registerLazySingletonAsync<NutritionCacheService>(
      () async {
        final prefs = await SharedPreferences.getInstance();
        return NutritionCacheService(prefs);
      },
    );
  }

  static void _registerRepositories() {
    // Repository Implementation
    _getIt.registerLazySingleton<NutritionRepository>(
      () => NutritionRepositoryImpl(
        _getIt<NutritionApiService>(),
        _getIt<NutritionCacheService>(),
      ),
    );
  }

  static void _registerUseCases() {
    // Add Food Entry Use Case
    _getIt.registerLazySingleton<AddFoodEntryUseCase>(
      () => AddFoodEntryUseCase(
        _getIt<NutritionRepository>(),
      ),
    );

    // Search Food Items Use Case
    _getIt.registerLazySingleton<SearchFoodItemsUseCase>(
      () => SearchFoodItemsUseCase(
        _getIt<NutritionRepository>(),
      ),
    );

    // Get Nutrition Diary Use Case
    _getIt.registerLazySingleton<GetNutritionDiaryUseCase>(
      () => GetNutritionDiaryUseCase(
        _getIt<NutritionRepository>(),
      ),
    );
  }

  static void _registerBlocs() {
    // Nutrition Search Cubit
    _getIt.registerFactory<NutritionSearchCubit>(
      () => NutritionSearchCubit(
        _getIt<SearchFoodItemsUseCase>(),
      ),
    );

    // Food Entry Cubit
    _getIt.registerFactory<FoodEntryCubit>(
      () => FoodEntryCubit(
        _getIt<AddFoodEntryUseCase>(),
      ),
    );

    // Nutrition Diary Cubit
    _getIt.registerFactory<NutritionDiaryCubit>(
      () => NutritionDiaryCubit(
        _getIt<GetNutritionDiaryUseCase>(),
      ),
    );
  }

  // Getters for easy access
  static NutritionSearchCubit get nutritionSearchCubit =>
      _getIt<NutritionSearchCubit>();
  static FoodEntryCubit get foodEntryCubit => _getIt<FoodEntryCubit>();
  static NutritionDiaryCubit get nutritionDiaryCubit =>
      _getIt<NutritionDiaryCubit>();

  static NutritionRepository get nutritionRepository =>
      _getIt<NutritionRepository>();
  static NutritionApiService get nutritionApiService =>
      _getIt<NutritionApiService>();
  static NutritionCacheService get nutritionCacheService =>
      _getIt<NutritionCacheService>();

  // Cleanup method
  static void dispose() {
    // Dispose BLoCs
    if (_getIt.isRegistered<NutritionSearchCubit>()) {
      _getIt<NutritionSearchCubit>().close();
    }
    if (_getIt.isRegistered<FoodEntryCubit>()) {
      _getIt<FoodEntryCubit>().close();
    }
    if (_getIt.isRegistered<NutritionDiaryCubit>()) {
      _getIt<NutritionDiaryCubit>().close();
    }

    // Unregister all dependencies
    _getIt.reset();
  }
}
