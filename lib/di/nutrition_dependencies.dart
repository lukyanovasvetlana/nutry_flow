import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:nutry_flow/features/nutrition/data/repositories/nutrition_repository_impl.dart';
import 'package:nutry_flow/features/nutrition/data/services/nutrition_api_service.dart';
import 'package:nutry_flow/features/nutrition/data/services/nutrition_cache_service.dart';
import 'package:nutry_flow/features/nutrition/domain/repositories/nutrition_repository.dart';
import 'package:nutry_flow/features/nutrition/domain/usecases/add_food_entry_usecase.dart';
import 'package:nutry_flow/features/nutrition/domain/usecases/get_nutrition_diary_usecase.dart';
import 'package:nutry_flow/features/nutrition/domain/usecases/search_food_items_usecase.dart';
import 'package:nutry_flow/features/nutrition/presentation/bloc/food_entry_cubit.dart';
import 'package:nutry_flow/features/nutrition/presentation/bloc/nutrition_diary_cubit.dart';
import 'package:nutry_flow/features/nutrition/presentation/bloc/nutrition_search_cubit.dart';

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
    _getIt.registerLazySingleton<NutritionApiService>(
      () => NutritionApiService(
        Supabase.instance.client,
      ),
    );

    _getIt.registerLazySingletonAsync<NutritionCacheService>(
      () async {
        final prefs = await SharedPreferences.getInstance();
        return NutritionCacheService(prefs);
      },
    );
  }

  static void _registerRepositories() {
    _getIt.registerLazySingleton<NutritionRepository>(
      () => NutritionRepositoryImpl(
        _getIt<NutritionApiService>(),
        _getIt<NutritionCacheService>(),
      ),
    );
  }

  static void _registerUseCases() {
    _getIt.registerLazySingleton<AddFoodEntryUseCase>(
      () => AddFoodEntryUseCase(
        _getIt<NutritionRepository>(),
      ),
    );

    _getIt.registerLazySingleton<SearchFoodItemsUseCase>(
      () => SearchFoodItemsUseCase(
        _getIt<NutritionRepository>(),
      ),
    );

    _getIt.registerLazySingleton<GetNutritionDiaryUseCase>(
      () => GetNutritionDiaryUseCase(
        _getIt<NutritionRepository>(),
      ),
    );
  }

  static void _registerBlocs() {
    _getIt.registerFactory<NutritionSearchCubit>(
      () => NutritionSearchCubit(
        _getIt<SearchFoodItemsUseCase>(),
      ),
    );

    _getIt.registerFactory<FoodEntryCubit>(
      () => FoodEntryCubit(
        _getIt<AddFoodEntryUseCase>(),
      ),
    );

    _getIt.registerFactory<NutritionDiaryCubit>(
      () => NutritionDiaryCubit(
        _getIt<GetNutritionDiaryUseCase>(),
      ),
    );
  }

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

  static void dispose() {
    if (_getIt.isRegistered<NutritionSearchCubit>()) {
      _getIt<NutritionSearchCubit>().close();
    }
    if (_getIt.isRegistered<FoodEntryCubit>()) {
      _getIt<FoodEntryCubit>().close();
    }
    if (_getIt.isRegistered<NutritionDiaryCubit>()) {
      _getIt<NutritionDiaryCubit>().close();
    }

    _getIt.reset();
  }
}
