import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/welcome_screen_redesigned.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/enhanced_registration_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/enhanced_login_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/profile_info_screen.dart';

import 'package:nutry_flow/features/onboarding/presentation/screens/forgot_password_screen.dart';
import 'package:nutry_flow/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/developer_analytics_screen.dart';
import 'package:nutry_flow/features/analytics/presentation/screens/ab_testing_screen.dart';
import 'package:nutry_flow/screens/theme_demo_screen.dart';
import 'package:nutry_flow/app.dart';
import 'dart:developer' as developer;

/// Класс для управления навигацией и роутингом приложения
class AppRouter {
  bool _isInitialized = false;
  late final GoRouter _router;

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;

  /// Получение экземпляра роутера
  GoRouter get router => _router;

  /// Инициализация роутера
  Future<void> initialize() async {
    if (_isInitialized) {
      developer.log('⚠️ AppRouter: Already initialized', name: 'app_router');
      return;
    }

    try {
      developer.log('🗺️ AppRouter: Initializing router...',
          name: 'app_router');

      _router = GoRouter(
        initialLocation: '/',
        debugLogDiagnostics: true,
        routes: _buildRoutes(),
        errorBuilder: _buildErrorPage,
        redirect: _handleRedirect,
      );

      _isInitialized = true;
      developer.log('✅ AppRouter: Router initialized successfully',
          name: 'app_router');
    } catch (e) {
      developer.log(r'❌ AppRouter: Initialization failed: $e',
          name: 'app_router');
      developer.log(r'❌ Stack trace: $stackTrace', name: 'app_router');
      rethrow;
    }
  }

  /// Построение маршрутов
  List<RouteBase> _buildRoutes() {
    return [
      // Главный маршрут
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding маршруты
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => Theme(
          data: ThemeData.light(),
          child: const WelcomeScreenRedesigned(),
        ),
      ),

      GoRoute(
        path: '/registration',
        name: 'registration',
        builder: (context, state) => Theme(
          data: ThemeData.light(),
          child: const EnhancedRegistrationScreen(),
        ),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => Theme(
          data: ThemeData.light(),
          child: const EnhancedLoginScreen(),
        ),
      ),

      GoRoute(
        path: '/profile-info',
        name: 'profile-info',
        builder: (context, state) => Theme(
          data: ThemeData.light(),
          child: const ProfileInfoScreen(),
        ),
      ),

      GoRoute(
        path: '/goals-setup',
        name: 'goals-setup',
        builder: (context, state) => Theme(
          data: ThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: Text('Goals Setup Screen - Placeholder'),
            ),
          ),
        ),
      ),

      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => Theme(
          data: ThemeData.light(),
          child: const ForgotPasswordScreen(),
        ),
      ),

      // Основные маршруты приложения
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const AppContainer(),
      ),

      GoRoute(
        path: '/app',
        name: 'app',
        builder: (context, state) => const AppContainer(),
      ),

      // Analytics маршруты
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const Scaffold(
          body: AnalyticsScreen(),
        ),
      ),

      GoRoute(
        path: '/developer-analytics',
        name: 'developer-analytics',
        builder: (context, state) => const Scaffold(
          body: DeveloperAnalyticsScreen(),
        ),
      ),

      GoRoute(
        path: '/ab-testing',
        name: 'ab-testing',
        builder: (context, state) => const Scaffold(
          body: ABTestingScreen(),
        ),
      ),

      // Profile маршруты
      GoRoute(
        path: '/profile-settings',
        name: 'profile-settings',
        builder: (context, state) => const Scaffold(
          body: ProfileSettingsScreen(),
        ),
      ),

      // Theme demo маршрут
      GoRoute(
        path: '/theme-demo',
        name: 'theme-demo',
        builder: (context, state) => const ThemeDemoScreen(),
      ),
    ];
  }

  /// Обработка редиректов
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    // Здесь можно добавить логику для проверки аутентификации
    // и других условий для редиректов

    final isAuthenticated = _checkAuthentication();
    final isOnboarding = _isOnboardingRoute(state.uri.path);

    // Если пользователь не аутентифицирован и пытается попасть в защищенные маршруты
    if (!isAuthenticated && !isOnboarding) {
      return '/welcome';
    }

    // Если пользователь аутентифицирован и пытается попасть в onboarding
    if (isAuthenticated && isOnboarding) {
      return '/dashboard';
    }

    return null; // Нет редиректа
  }

  /// Проверка аутентификации (заглушка)
  bool _checkAuthentication() {
    // TODO: Реализовать проверку аутентификации
    return false;
  }

  /// Проверка, является ли маршрут частью onboarding
  bool _isOnboardingRoute(String location) {
    final onboardingRoutes = [
      '/welcome',
      '/registration',
      '/login',
      '/profile-info',
      '/goals-setup',
      '/forgot-password'
    ];
    return onboardingRoutes.contains(location);
  }

  /// Построение страницы ошибки
  Widget _buildErrorPage(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ошибка'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Страница не найдена',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Маршрут: ${state.uri.path}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    );
  }

  /// Создание главного приложения с роутером
  Widget createApp() {
    if (!_isInitialized) {
      throw StateError(
          'AppRouter is not initialized. Call initialize() first.');
    }

    return MaterialApp.router(
      title: 'NutryFlow',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }

  /// Навигация к маршруту
  void navigateTo(String route, {Object? extra}) {
    if (!_isInitialized) {
      developer.log('⚠️ AppRouter: Router not initialized', name: 'app_router');
      return;
    }

    _router.push(route, extra: extra);
  }

  /// Замена текущего маршрута
  void replaceRoute(String route, {Object? extra}) {
    if (!_isInitialized) {
      developer.log('⚠️ AppRouter: Router not initialized', name: 'app_router');
      return;
    }

    _router.replace(route, extra: extra);
  }

  /// Возврат назад
  void goBack() {
    if (!_isInitialized) {
      developer.log('⚠️ AppRouter: Router not initialized', name: 'app_router');
      return;
    }

    if (_router.canPop()) {
      _router.pop();
    }
  }

  /// Очистка ресурсов
  Future<void> dispose() async {
    if (!_isInitialized) return;

    developer.log('🧹 AppRouter: Disposing...', name: 'app_router');
    // GoRouter не требует явной очистки
    _isInitialized = false;
    developer.log('✅ AppRouter: Disposed successfully', name: 'app_router');
  }
}
