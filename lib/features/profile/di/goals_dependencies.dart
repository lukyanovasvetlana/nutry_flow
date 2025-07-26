import 'package:get_it/get_it.dart';

import '../data/repositories/mock_goals_repository.dart';
import '../domain/repositories/goals_repository.dart';
import '../domain/usecases/create_goal_usecase.dart';
import '../domain/usecases/get_goals_usecase.dart';
import '../domain/usecases/track_progress_usecase.dart';
import '../presentation/bloc/goals_bloc.dart';

class GoalsDependencies {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> init() async {
    print('🎯 GoalsDependencies: Initializing goals dependencies...');

    try {
      // Repository
      if (!_getIt.isRegistered<GoalsRepository>()) {
        _getIt.registerLazySingleton<GoalsRepository>(
          () => MockGoalsRepository(),
        );
        print('🎯 GoalsDependencies: MockGoalsRepository registered');
      }

      // Use Cases
      if (!_getIt.isRegistered<CreateGoalUseCase>()) {
        _getIt.registerLazySingleton<CreateGoalUseCase>(
          () => CreateGoalUseCase(_getIt<GoalsRepository>()),
        );
        print('🎯 GoalsDependencies: CreateGoalUseCase registered');
      }

      if (!_getIt.isRegistered<GetGoalsUseCase>()) {
        _getIt.registerLazySingleton<GetGoalsUseCase>(
          () => GetGoalsUseCase(_getIt<GoalsRepository>()),
        );
        print('🎯 GoalsDependencies: GetGoalsUseCase registered');
      }

      if (!_getIt.isRegistered<TrackProgressUseCase>()) {
        _getIt.registerLazySingleton<TrackProgressUseCase>(
          () => TrackProgressUseCase(_getIt<GoalsRepository>()),
        );
        print('🎯 GoalsDependencies: TrackProgressUseCase registered');
      }

      // BLoC
      if (!_getIt.isRegistered<GoalsBloc>()) {
        _getIt.registerFactory<GoalsBloc>(
          () => GoalsBloc(
            createGoalUseCase: _getIt<CreateGoalUseCase>(),
            getGoalsUseCase: _getIt<GetGoalsUseCase>(),
            trackProgressUseCase: _getIt<TrackProgressUseCase>(),
          ),
        );
        print('🎯 GoalsDependencies: GoalsBloc registered');
      }

      print('🎯 GoalsDependencies: All goals dependencies initialized successfully');
    } catch (e) {
      print('🎯 GoalsDependencies: Error initializing dependencies: $e');
      rethrow;
    }
  }

  static void dispose() {
    print('🎯 GoalsDependencies: Disposing goals dependencies...');
    
    if (_getIt.isRegistered<GoalsBloc>()) {
      _getIt.unregister<GoalsBloc>();
    }
    if (_getIt.isRegistered<TrackProgressUseCase>()) {
      _getIt.unregister<TrackProgressUseCase>();
    }
    if (_getIt.isRegistered<GetGoalsUseCase>()) {
      _getIt.unregister<GetGoalsUseCase>();
    }
    if (_getIt.isRegistered<CreateGoalUseCase>()) {
      _getIt.unregister<CreateGoalUseCase>();
    }
    if (_getIt.isRegistered<GoalsRepository>()) {
      _getIt.unregister<GoalsRepository>();
    }

    print('🎯 GoalsDependencies: Goals dependencies disposed');
  }
} 