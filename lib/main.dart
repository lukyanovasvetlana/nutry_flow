import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nutry_flow/config/supabase_config.dart';
import 'package:nutry_flow/core/services/firebase_service.dart';
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
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Загрузка переменных окружения (если файл существует)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    developer.log('⚠️ .env file not found, using demo mode', name: 'Main');
  }

  // Проверяем демо-режим
  developer.log('🔵 Main: SupabaseConfig.isDemo = ${SupabaseConfig.isDemo}',
      name: 'Main');
  developer.log('🔵 Main: SupabaseConfig.url = ${SupabaseConfig.url}',
      name: 'Main');
  developer.log(
      '🔵 Main: SupabaseConfig.anonKey = ${SupabaseConfig.anonKey}',
      name: 'Main');

  // Проверяем, что демо-режим действительно работает
  if (SupabaseConfig.isDemo) {
    developer.log('🔵 Main: ✅ Demo mode is ACTIVE', name: 'Main');
  } else {
    developer.log('🔵 Main: ❌ Demo mode is NOT active', name: 'Main');
  }

  // Инициализация Firebase
  developer.log('🔥 Main: Initializing Firebase...', name: 'Main');
  try {
    await FirebaseService.instance.initialize();
    developer.log('🔥 Main: Firebase initialized successfully', name: 'Main');
  } catch (e) {
    developer.log('🔴 Main: Failed to initialize Firebase: $e', name: 'Main');
    // Продолжаем работу приложения даже если Firebase не инициализировался
  }

  // Инициализация OnboardingDependencies
  developer.log('🔵 Main: Initializing OnboardingDependencies...',
      name: 'Main');
  try {
    await OnboardingDependencies.instance.initialize();
    developer.log('🔵 Main: OnboardingDependencies initialized', name: 'Main');
    developer.log(
        '🔵 Main: OnboardingDependencies.isDemo = ${OnboardingDependencies.instance.isDemo}',
        name: 'Main');
    developer.log('🔵 Main: ✅ OnboardingDependencies is in demo mode',
        name: 'Main');
  } catch (e) {
    developer.log('🔴 Main: Failed to initialize OnboardingDependencies: $e',
        name: 'Main');
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
