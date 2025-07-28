import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/registration_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/login_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/profile_info_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/goals_setup_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/forgot_password_screen.dart';
import 'package:nutry_flow/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/health_articles_screen.dart';

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
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/local_cache_service.dart';
import 'package:nutry_flow/core/services/notification_service.dart';
import 'package:nutry_flow/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Supabase
  await SupabaseService.instance.initialize();
  
  // Инициализация локального кэша
  await LocalCacheService.instance.initialize();
  
  // Инициализация сервиса уведомлений
  await NotificationService.instance.initialize();
  
  // Инициализация GetIt
  
  // Инициализация зависимостей
  await OnboardingDependencies.instance.initialize();
  await ProfileDependencies.instance.initialize();
  NutritionDependencies.initialize();
  await MenuDependencies.instance.initialize();
  await MealPlanDependencies.instance.initialize();
  await GroceryDependencies.instance.initialize();
  await CalendarDependencies.instance.initialize();
  // await ActivityDependencies.instance.initialize();
  ExerciseDependencies.initialize();
  await AnalyticsDependencies.instance.initialize();
  
  runApp(const NutryFlowApp());
}

class NutryFlowApp extends StatelessWidget {
  const NutryFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutryFlow',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppColors.green,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        textTheme: Theme.of(context).textTheme,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile-info': (context) => const ProfileInfoScreen(),
        '/onboarding': (context) => BlocProvider<GoalsSetupBloc>(
          create: (context) {
            final bloc = OnboardingDependencies.instance.createGoalsSetupBloc();
            // Автоматически инициализируем цели при создании BLoC
            bloc.add(InitializeGoals());
            return bloc;
          },
          child: const GoalsSetupView(),
        ),
        '/app': (context) => const AppContainer(),
        '/analytics': (context) => Scaffold(
          body: const AnalyticsScreen(),
        ),
        '/health-articles': (context) => Scaffold(
          body: const HealthArticlesScreen(),
        ),

        '/profile-settings': (context) => Scaffold(
          body: const ProfileSettingsScreen(),
        ),
        '/forgot-password': (context) => Scaffold(
          body: const ForgotPasswordScreen(),
        ),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
