import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Domain
import 'package:nutry_flow/features/exercise/domain/repositories/exercise_repository.dart';

// Data
import 'package:nutry_flow/features/exercise/data/repositories/exercise_repository_impl.dart';
import 'package:nutry_flow/features/exercise/data/services/exercise_service.dart';

// Use Cases
import 'package:nutry_flow/features/exercise/domain/usecases/get_all_exercises_usecase.dart';
import 'package:nutry_flow/features/exercise/domain/usecases/get_exercise_by_id_usecase.dart';
import 'package:nutry_flow/features/exercise/domain/usecases/get_exercises_by_category_usecase.dart';
import 'package:nutry_flow/features/exercise/domain/usecases/save_exercise_usecase.dart';
import 'package:nutry_flow/features/exercise/domain/usecases/delete_exercise_usecase.dart';

// Presentation
import 'package:nutry_flow/features/exercise/presentation/bloc/exercise_bloc.dart';

/// Extension для доступа к зависимостям Exercise
extension ExerciseDependencies on GetIt {
  static GetIt get instance => GetIt.instance;

  static Future<void> initialize() async {
    // Инициализация будет выполнена через @module аннотацию
  }

  static void reset() {
    // Сброс зависимостей
  }
}

@module
abstract class ExerciseModule {
  // Services
  @lazySingleton
  ExerciseService get exerciseService => ExerciseService();

  // Repositories
  @lazySingleton
  ExerciseRepository get exerciseRepository => ExerciseRepositoryImpl();

  // Use Cases
  @lazySingleton
  GetAllExercisesUseCase get getAllExercisesUseCase =>
      GetAllExercisesUseCase(exerciseRepository);

  @lazySingleton
  GetExerciseByIdUseCase get getExerciseByIdUseCase =>
      GetExerciseByIdUseCase(exerciseRepository);

  @lazySingleton
  GetExercisesByCategoryUseCase get getExercisesByCategoryUseCase =>
      GetExercisesByCategoryUseCase(exerciseRepository);

  @lazySingleton
  SaveExerciseUseCase get saveExerciseUseCase =>
      SaveExerciseUseCase(exerciseRepository);

  @lazySingleton
  DeleteExerciseUseCase get deleteExerciseUseCase =>
      DeleteExerciseUseCase(exerciseRepository);

  // BLoC
  @lazySingleton
  ExerciseBloc get exerciseBloc => ExerciseBloc(
        getAllExercisesUseCase: getAllExercisesUseCase,
        getExercisesByCategoryUseCase: getExercisesByCategoryUseCase,
        saveExerciseUseCase: saveExerciseUseCase,
        deleteExerciseUseCase: deleteExerciseUseCase,
      );
}
