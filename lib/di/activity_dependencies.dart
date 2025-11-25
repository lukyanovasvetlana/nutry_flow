import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Domain
import 'package:nutry_flow/features/activity/domain/repositories/exercise_repository.dart';
import 'package:nutry_flow/features/activity/domain/repositories/workout_repository.dart';
import 'package:nutry_flow/features/activity/domain/repositories/activity_repository.dart';

// Data
import 'package:nutry_flow/features/activity/data/repositories/exercise_repository_impl.dart';
import 'package:nutry_flow/features/activity/data/repositories/workout_repository_impl.dart';
import 'package:nutry_flow/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:nutry_flow/features/activity/data/services/supabase_exercise_service.dart';
import 'package:nutry_flow/features/activity/data/services/supabase_workout_service.dart';
import 'package:nutry_flow/features/activity/data/services/activity_tracking_service.dart';

// Use Cases
import 'package:nutry_flow/features/activity/domain/usecases/exercise_usecases.dart';
import 'package:nutry_flow/features/activity/domain/usecases/workout_usecases.dart';
import 'package:nutry_flow/features/activity/domain/usecases/activity_usecases.dart';

// Presentation
import 'package:nutry_flow/features/activity/presentation/bloc/exercise_bloc.dart';
import 'package:nutry_flow/features/activity/presentation/bloc/workout_bloc.dart';
import 'package:nutry_flow/features/activity/presentation/bloc/activity_bloc.dart';

/// Extension для доступа к зависимостям Activity
extension ActivityDependencies on GetIt {
  static GetIt get instance => GetIt.instance;

  static Future<void> initialize() async {
    // Инициализация будет выполнена через @module аннотацию
  }

  static void reset() {
    // Сброс зависимостей
  }
}

@module
abstract class ActivityModule {
  // Services
  @lazySingleton
  SupabaseExerciseService get supabaseExerciseService =>
      SupabaseExerciseService();

  @lazySingleton
  SupabaseWorkoutService get supabaseWorkoutService => SupabaseWorkoutService();

  @lazySingleton
  ActivityTrackingService get activityTrackingService =>
      ActivityTrackingService();

  // Repositories
  @lazySingleton
  ExerciseRepository get exerciseRepository =>
      ExerciseRepositoryImpl(supabaseExerciseService);

  @lazySingleton
  WorkoutRepository get workoutRepository =>
      WorkoutRepositoryImpl(supabaseWorkoutService);

  @lazySingleton
  ActivityRepository get activityRepository =>
      ActivityRepositoryImpl(activityTrackingService);

  // Exercise Use Cases
  @lazySingleton
  GetExercisesUseCase get getExercisesUseCase =>
      GetExercisesUseCase(exerciseRepository);

  @lazySingleton
  GetExerciseByIdUseCase get getExerciseByIdUseCase =>
      GetExerciseByIdUseCase(exerciseRepository);

  @lazySingleton
  SearchExercisesUseCase get searchExercisesUseCase =>
      SearchExercisesUseCase(exerciseRepository);

  @lazySingleton
  FilterExercisesByCategoryUseCase get filterExercisesByCategoryUseCase =>
      FilterExercisesByCategoryUseCase(exerciseRepository);

  @lazySingleton
  FilterExercisesByDifficultyUseCase get filterExercisesByDifficultyUseCase =>
      FilterExercisesByDifficultyUseCase(exerciseRepository);

  @lazySingleton
  GetFavoriteExercisesUseCase get getFavoriteExercisesUseCase =>
      GetFavoriteExercisesUseCase(exerciseRepository);

  @lazySingleton
  ToggleFavoriteExerciseUseCase get toggleFavoriteExerciseUseCase =>
      ToggleFavoriteExerciseUseCase(exerciseRepository);

  @lazySingleton
  GetExerciseCategoriesUseCase get getExerciseCategoriesUseCase =>
      GetExerciseCategoriesUseCase(exerciseRepository);

  @lazySingleton
  GetExerciseDifficultiesUseCase get getExerciseDifficultiesUseCase =>
      GetExerciseDifficultiesUseCase(exerciseRepository);

  // Workout Use Cases
  @lazySingleton
  GetUserWorkoutsUseCase get getUserWorkoutsUseCase =>
      GetUserWorkoutsUseCase(workoutRepository);

  @lazySingleton
  GetWorkoutByIdUseCase get getWorkoutByIdUseCase =>
      GetWorkoutByIdUseCase(workoutRepository);

  @lazySingleton
  GetWorkoutTemplatesUseCase get getWorkoutTemplatesUseCase =>
      GetWorkoutTemplatesUseCase(workoutRepository);

  @lazySingleton
  CreateWorkoutUseCase get createWorkoutUseCase =>
      CreateWorkoutUseCase(workoutRepository);

  @lazySingleton
  UpdateWorkoutUseCase get updateWorkoutUseCase =>
      UpdateWorkoutUseCase(workoutRepository);

  @lazySingleton
  DeleteWorkoutUseCase get deleteWorkoutUseCase =>
      DeleteWorkoutUseCase(workoutRepository);

  @lazySingleton
  SaveWorkoutAsTemplateUseCase get saveWorkoutAsTemplateUseCase =>
      SaveWorkoutAsTemplateUseCase(workoutRepository);

  @lazySingleton
  SearchWorkoutsUseCase get searchWorkoutsUseCase =>
      SearchWorkoutsUseCase(workoutRepository);

  @lazySingleton
  FilterWorkoutsByDifficultyUseCase get filterWorkoutsByDifficultyUseCase =>
      FilterWorkoutsByDifficultyUseCase(workoutRepository);

  // Activity Use Cases
  @lazySingleton
  StartActivitySessionUseCase get startActivitySessionUseCase =>
      StartActivitySessionUseCase(activityRepository);

  @lazySingleton
  UpdateActivitySessionUseCase get updateActivitySessionUseCase =>
      UpdateActivitySessionUseCase(activityRepository);

  @lazySingleton
  CompleteActivitySessionUseCase get completeActivitySessionUseCase =>
      CompleteActivitySessionUseCase(activityRepository);

  @lazySingleton
  GetCurrentSessionUseCase get getCurrentSessionUseCase =>
      GetCurrentSessionUseCase(activityRepository);

  @lazySingleton
  GetUserSessionsUseCase get getUserSessionsUseCase =>
      GetUserSessionsUseCase(activityRepository);

  @lazySingleton
  GetSessionByIdUseCase get getSessionByIdUseCase =>
      GetSessionByIdUseCase(activityRepository);

  @lazySingleton
  GetDailyStatsUseCase get getDailyStatsUseCase =>
      GetDailyStatsUseCase(activityRepository);

  @lazySingleton
  GetWeeklyStatsUseCase get getWeeklyStatsUseCase =>
      GetWeeklyStatsUseCase(activityRepository);

  @lazySingleton
  GetMonthlyStatsUseCase get getMonthlyStatsUseCase =>
      GetMonthlyStatsUseCase(activityRepository);

  @lazySingleton
  UpdateDailyStatsUseCase get updateDailyStatsUseCase =>
      UpdateDailyStatsUseCase(activityRepository);

  @lazySingleton
  GetActivityAnalyticsUseCase get getActivityAnalyticsUseCase =>
      GetActivityAnalyticsUseCase(activityRepository);

  @lazySingleton
  GetTotalWorkoutsUseCase get getTotalWorkoutsUseCase =>
      GetTotalWorkoutsUseCase(activityRepository);

  @lazySingleton
  GetTotalDurationUseCase get getTotalDurationUseCase =>
      GetTotalDurationUseCase(activityRepository);

  @lazySingleton
  GetTotalCaloriesBurnedUseCase get getTotalCaloriesBurnedUseCase =>
      GetTotalCaloriesBurnedUseCase(activityRepository);

  // BLoCs
  @lazySingleton
  ExerciseBloc get exerciseBloc => ExerciseBloc(
        getExercisesUseCase,
        searchExercisesUseCase,
        filterExercisesByCategoryUseCase,
        filterExercisesByDifficultyUseCase,
        getFavoriteExercisesUseCase,
        toggleFavoriteExerciseUseCase,
        getExerciseCategoriesUseCase,
        getExerciseDifficultiesUseCase,
      );

  @lazySingleton
  WorkoutBloc get workoutBloc => WorkoutBloc(
        getUserWorkoutsUseCase,
        getWorkoutTemplatesUseCase,
        createWorkoutUseCase,
        updateWorkoutUseCase,
        deleteWorkoutUseCase,
        saveWorkoutAsTemplateUseCase,
        searchWorkoutsUseCase,
        filterWorkoutsByDifficultyUseCase,
      );

  @lazySingleton
  ActivityBloc get activityBloc => ActivityBloc(
        startActivitySessionUseCase,
        updateActivitySessionUseCase,
        completeActivitySessionUseCase,
        getCurrentSessionUseCase,
        getUserSessionsUseCase,
        getDailyStatsUseCase,
        getWeeklyStatsUseCase,
        getMonthlyStatsUseCase,
        getActivityAnalyticsUseCase,
      );
}
