import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/theme/theme_manager.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  if (getIt.isRegistered<ThemeManager>()) {
    return;
  }

  final SharedPreferences preferences = await SharedPreferences.getInstance();

  getIt
    ..registerLazySingleton<SharedPreferences>(() => preferences)
    ..registerLazySingleton<ThemeManager>(ThemeManager.new);
}
