import 'package:get_it/get_it.dart';

import 'package:nutry_flow/features/profile/data/repositories/mock_goals_repository.dart';
import 'package:nutry_flow/features/profile/domain/repositories/goals_repository.dart';
import 'package:nutry_flow/features/profile/domain/usecases/create_goal_usecase.dart';
import 'package:nutry_flow/features/profile/domain/usecases/get_goals_usecase.dart';
import 'package:nutry_flow/features/profile/domain/usecases/track_progress_usecase.dart';
import 'package:nutry_flow/features/profile/presentation/bloc/goals_bloc.dart';

class GoalsDependencies {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> init() async {
    try {
      // Repository
      if (!_getIt.isRegistered<GoalsRepository>()) {
        _getIt.registerLazySingleton<GoalsRepository>(
          MockGoalsRepository.new,
        );
      }

      // Use Cases
      if (!_getIt.isRegistered<CreateGoalUseCase>()) {
        _getIt.registerLazySingleton<CreateGoalUseCase>(
          () => CreateGoalUseCase(_getIt<GoalsRepository>()),
        );
      }

      if (!_getIt.isRegistered<GetGoalsUseCase>()) {
        _getIt.registerLazySingleton<GetGoalsUseCase>(
          () => GetGoalsUseCase(_getIt<GoalsRepository>()),
        );
      }

      if (!_getIt.isRegistered<TrackProgressUseCase>()) {
        _getIt.registerLazySingleton<TrackProgressUseCase>(
          () => TrackProgressUseCase(_getIt<GoalsRepository>()),
        );
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
      }
    } catch (e) {
      rethrow;
    }
  }

  static void dispose() {
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
  }
}
