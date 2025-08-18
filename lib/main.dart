import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/welcome_screen_redesigned.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/enhanced_registration_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/enhanced_login_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/profile_info_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/goals_setup_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/forgot_password_screen.dart';
import 'package:nutry_flow/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/health_articles_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/developer_analytics_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/ab_testing_screen.dart';
import 'package:nutry_flow/screens/theme_demo_screen.dart';

import 'package:nutry_flow/features/onboarding/presentation/bloc/goals_setup_bloc.dart';
import 'package:nutry_flow/features/onboarding/di/onboarding_dependencies.dart';
import 'package:nutry_flow/features/profile/di/profile_dependencies.dart';
import 'package:nutry_flow/features/nutrition/di/nutrition_dependencies.dart';
import 'package:nutry_flow/features/menu/di/menu_dependencies.dart';
import 'package:nutry_flow/features/meal_plan/di/meal_plan_dependencies.dart';
import 'package:nutry_flow/features/grocery_list/di/grocery_dependencies.dart';
import 'package:nutry_flow/features/calendar/di/calendar_dependencies.dart';
import 'package:nutry_flow/features/exercise/di/exercise_dependencies.dart';
import 'package:nutry_flow/features/analytics/di/analytics_dependencies.dart';
import 'package:nutry_flow/features/auth/di/auth_dependencies.dart';
import 'package:nutry_flow/shared/theme/theme_manager.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/local_cache_service.dart';
import 'package:nutry_flow/core/services/notification_service.dart';
import 'package:nutry_flow/core/services/monitoring_service.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:nutry_flow/features/analytics/presentation/utils/persona_analytics_tracker.dart';
import 'package:nutry_flow/config/supabase_config.dart';
import 'package:nutry_flow/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Загрузка переменных окружения (если файл существует)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('⚠️ .env file not found, using demo mode');
  }

  // Проверяем демо-режим
  print('🔵 Main: SupabaseConfig.isDemo = ${SupabaseConfig.isDemo}');
  print('🔵 Main: SupabaseConfig.url = ${SupabaseConfig.url}');
  print('🔵 Main: SupabaseConfig.anonKey = ${SupabaseConfig.anonKey}');

  // Проверяем, что демо-режим действительно работает
  if (SupabaseConfig.isDemo) {
    print('🔵 Main: ✅ Demo mode is ACTIVE');
  } else {
    print('🔵 Main: ❌ Demo mode is NOT active');
  }

  // Инициализация Supabase
  await SupabaseService.instance.initialize();

  // Инициализация локального кэша
  await LocalCacheService.instance.initialize();

  // Инициализация сервиса уведомлений
  await NotificationService.instance.initialize();

  // Инициализация сервиса мониторинга
  await MonitoringService.instance.initialize();

  // Инициализация сервиса A/B тестирования
  await ABTestingService.instance.initialize();

  // Инициализация персоны аналитика
  await PersonaAnalyticsTracker.instance.initialize();

  // Инициализация зависимостей
  print('🔵 Main: Initializing OnboardingDependencies...');
  await OnboardingDependencies.instance.initialize();
  print('🔵 Main: OnboardingDependencies initialized');

  // Проверяем, что OnboardingDependencies в демо-режиме
  final isDemo = OnboardingDependencies.instance.isDemo;
  print('🔵 Main: OnboardingDependencies.isDemo = $isDemo');
  if (isDemo) {
    print('🔵 Main: ✅ OnboardingDependencies is in demo mode');
  } else {
    print('🔵 Main: ❌ OnboardingDependencies is NOT in demo mode');
  }
  await ProfileDependencies.instance.initialize();
  NutritionDependencies.initialize();
  await MenuDependencies.instance.initialize();
  await MealPlanDependencies.instance.initialize();
  await GroceryDependencies.instance.initialize();
  await CalendarDependencies.instance.initialize();
  // await ActivityDependencies.instance.initialize();
  ExerciseDependencies.initialize();
  await AnalyticsDependencies.instance.initialize();
  await AuthDependencies.instance.initialize();

  // Инициализация менеджера тем
  await ThemeManager().initialize();

  runApp(const NutryFlowApp());
}

class NutryFlowApp extends StatelessWidget {
  const NutryFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager(),
      builder: (context, child) {
        // Получаем текущую тему
        final currentTheme = ThemeManager().currentTheme;
        final lightTheme = ThemeManager().lightTheme;
        final darkTheme = ThemeManager().darkTheme;

        // Используем AnimatedSwitcher для плавного перехода между темами
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: MaterialApp(
            key: ValueKey('app-${currentTheme.name}'),
            title: 'NutryFlow',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: currentTheme,
            routes: {
              '/': (context) => const SplashScreen(),
              '/welcome': (context) => Theme(
                    data: ThemeData.light(),
                    child: const WelcomeScreenRedesigned(),
                  ),
              '/registration': (context) => Theme(
                    data: ThemeData.light(),
                    child: const EnhancedRegistrationScreen(),
                  ),
              '/login': (context) => Theme(
                    data: ThemeData.light(),
                    child: const EnhancedLoginScreen(),
                  ),
              '/profile-info': (context) => Theme(
                    data: ThemeData.light(),
                    child: const ProfileInfoScreen(),
                  ),
              '/goals-setup': (context) => Theme(
                    data: ThemeData.light(),
                    child: BlocProvider<GoalsSetupBloc>(
                      create: (context) {
                        final bloc = OnboardingDependencies.instance
                            .createGoalsSetupBloc();
                        // Автоматически инициализируем цели при создании BLoC
                        bloc.add(InitializeGoals());
                        return bloc;
                      },
                      child: const GoalsSetupView(),
                    ),
                  ),
              '/dashboard': (context) => const AppContainer(),
              '/onboarding': (context) => Theme(
                    data: ThemeData.light(),
                    child: BlocProvider<GoalsSetupBloc>(
                      create: (context) {
                        final bloc = OnboardingDependencies.instance
                            .createGoalsSetupBloc();
                        // Автоматически инициализируем цели при создании BLoC
                        bloc.add(InitializeGoals());
                        return bloc;
                      },
                      child: const GoalsSetupView(),
                    ),
                  ),
              '/app': (context) => const AppContainer(),
              '/analytics': (context) => Scaffold(
                    body: const AnalyticsScreen(),
                  ),
              '/health-articles': (context) => Scaffold(
                    body: const HealthArticlesScreen(),
                  ),
              '/developer-analytics': (context) => Scaffold(
                    body: const DeveloperAnalyticsScreen(),
                  ),
              '/ab-testing': (context) => Scaffold(
                    body: const ABTestingScreen(),
                  ),
              '/profile-settings': (context) => Scaffold(
                    body: const ProfileSettingsScreen(),
                  ),
              '/forgot-password': (context) => Theme(
                    data: ThemeData.light(),
                    child: Scaffold(
                      body: const ForgotPasswordScreen(),
                    ),
                  ),
              '/theme-demo': (context) => const ThemeDemoScreen(),
            },
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
