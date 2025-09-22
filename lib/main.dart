import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nutry_flow/config/supabase_config.dart';
// import 'package:nutry_flow/core/services/firebase_service.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/welcome_screen_redesigned.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/enhanced_registration_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/enhanced_login_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/profile_info_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/goals_setup_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/forgot_password_screen.dart';
import 'package:nutry_flow/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:nutry_flow/app.dart';
import 'package:nutry_flow/shared/theme/theme_manager.dart';
import 'package:nutry_flow/features/onboarding/di/onboarding_dependencies.dart';

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

  // Инициализация Firebase временно отключена
  // print('🔥 Main: Initializing Firebase...');
  // try {
  //   await FirebaseService.instance.initialize();
  //   print('🔥 Main: Firebase initialized successfully');
  // } catch (e) {
  //   print('🔴 Main: Failed to initialize Firebase: $e');
  // }

  // Инициализация OnboardingDependencies
  print('🔵 Main: Initializing OnboardingDependencies...');
  try {
    await OnboardingDependencies.instance.initialize();
    print('🔵 Main: OnboardingDependencies initialized');
    print(
        '🔵 Main: OnboardingDependencies.isDemo = ${OnboardingDependencies.instance.isDemo}');
    print('🔵 Main: ✅ OnboardingDependencies is in demo mode');
  } catch (e) {
    print('🔴 Main: Failed to initialize OnboardingDependencies: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeManager _themeManager;

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeManager,
      builder: (context, child) {
        final currentTheme = _themeManager.currentTheme;

        return MaterialApp(
          title: 'NutryFlow',
          theme: _themeManager.lightTheme,
          darkTheme: _themeManager.darkTheme,
          themeMode: currentTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
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
                  child: const GoalsSetupScreen(),
                ),
            '/forgot-password': (context) => Theme(
                  data: ThemeData.light(),
                  child: const ForgotPasswordScreen(),
                ),
            '/profile-settings': (context) => Theme(
                  data: ThemeData.light(),
                  child: const ProfileSettingsScreen(),
                ),
            '/app': (context) => const AppContainer(),
          },
        );
      },
    );
  }
}
