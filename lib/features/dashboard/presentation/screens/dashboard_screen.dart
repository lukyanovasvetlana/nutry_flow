import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../analytics/presentation/screens/analytics_screen.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/data/services/profile_service.dart';
import '../../../../shared/theme/theme_manager.dart';
import '../../../analytics/presentation/mixins/analytics_mixin.dart';
import '../../../analytics/presentation/utils/analytics_utils.dart';

/// Экран дашборда NutryFlow
///
/// Отображает:
/// - Приветствие пользователя
/// - Статистику питания
/// - Диаграммы аналитики
/// - Быстрое меню для навигации
///
/// Использование:
/// ```dart
/// // Базовое использование
/// const DashboardScreen()
///
/// // С репозиторием по умолчанию (MockProfileService)
/// const DashboardScreen()
///
/// // С кастомным репозиторием
/// DashboardScreen(
///   profileRepository: CustomProfileRepository(),
/// )
/// ```
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

/// Состояние экрана дашборда
///
/// Управляет загрузкой профиля пользователя, отображением статистики
/// и интеграцией с аналитикой для отслеживания пользовательских действий.
class _DashboardScreenState extends State<DashboardScreen> with AnalyticsMixin {
  /// Индекс выбранного графика в статистике
  int selectedChartIndex = 0;

  /// Профиль текущего пользователя
  UserProfile? _userProfile;

  /// Флаг загрузки профиля пользователя
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    // Отслеживаем просмотр экрана дашборда
    trackScreenView(AnalyticsUtils.screenDashboard);
    _loadUserProfile();
  }

  /// Загружает профиль пользователя
  ///
  /// Сначала пытается загрузить профиль из локального хранилища (SharedPreferences),
  /// если не найден - использует переданный репозиторий для демо-режима.
  ///
  /// Отслеживает успешность загрузки профиля для аналитики.
  Future<void> _loadUserProfile() async {
    try {
      // Сначала пробуем загрузить из SharedPreferences (если пользователь регистрировался)
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName');
      final userLastName = prefs.getString('userLastName');

      if (userName != null && userName.isNotEmpty) {
        // Создаем локальный профиль из SharedPreferences
        final localProfile = UserProfile(
          id: 'local-user',
          firstName: userName,
          lastName: userLastName ?? '',
          email: prefs.getString('userEmail') ?? 'user@example.com',
          phone: null,
          dateOfBirth: null,
          gender: null,
          height: null,
          weight: null,
          activityLevel: null,
          avatarUrl: null,
          dietaryPreferences: const [],
          allergies: const [],
          healthConditions: const [],
          fitnessGoals: const [],
          targetWeight: null,
          targetCalories: null,
          targetProtein: null,
          targetCarbs: null,
          targetFat: null,
          foodRestrictions: null,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (mounted) {
          setState(() {
            _userProfile = localProfile;
            _isLoadingProfile = false;
          });

          // Отслеживаем успешную загрузку профиля
          trackEvent('profile_loaded', parameters: {
            'profile_source': 'local_storage',
            'has_name': localProfile.firstName.isNotEmpty,
            'has_email': localProfile.email.isNotEmpty,
          });
        }
        return;
      }

      // Если нет локального профиля, используем MockProfileService для демо-режима
      final profileService = MockProfileService();
      final profile = await profileService.getCurrentUserProfile();

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoadingProfile = false;
        });

        // Отслеживаем загрузку демо-профиля
        trackEvent('profile_loaded', parameters: {
          'profile_source': 'mock_service',
          'has_name': profile?.firstName.isNotEmpty ?? false,
          'has_email': profile?.email.isNotEmpty ?? false,
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });

        // Отслеживаем ошибку загрузки профиля
        trackError(
          errorType: 'profile_load_failed',
          errorMessage: e.toString(),
          additionalData: {'method': '_loadUserProfile'},
        );
      }
    }
  }

  /// Формирует персонализированное приветствие на основе времени суток и профиля пользователя
  ///
  /// Возвращает приветствие в зависимости от:
  /// - Времени суток (утро, день, вечер, ночь)
  /// - Наличия профиля пользователя
  /// - Имени пользователя
  ///
  /// Временные интервалы:
  /// - 5:00 - 11:59: "Доброе утро"
  /// - 12:00 - 16:59: "Добрый день"
  /// - 17:00 - 21:59: "Добрый вечер"
  /// - 22:00 - 4:59: "Добрый день" (или "Доброй ночи" в темной теме)
  ///
  /// Returns персонализированное приветствие
  String _getGreeting() {
    if (_isLoadingProfile) return 'Добро пожаловать!';
    if (_userProfile == null) return 'Добро пожаловать!';

    final firstName = _userProfile!.firstName;
    if (firstName.isNotEmpty) {
      final hour = DateTime.now().hour;
      final isDarkTheme = ThemeManager().isDarkMode;

      String timeGreeting;

      if (hour >= 5 && hour < 12) {
        timeGreeting = isDarkTheme ? 'Доброе утро' : 'Доброе утро';
      } else if (hour >= 12 && hour < 17) {
        timeGreeting = isDarkTheme ? 'Добрый вечер' : 'Добрый день';
      } else if (hour >= 17 && hour < 22) {
        timeGreeting = isDarkTheme ? 'Добрый вечер' : 'Добрый день';
      } else {
        timeGreeting = isDarkTheme ? 'Доброй ночи' : 'Добрый день';
      }

      return '$timeGreeting, $firstName!';
    }

    return 'Добро пожаловать!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _getResponsivePadding(constraints.maxWidth),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  _getResponsiveSpacing(constraints.maxWidth)),
                          // Логотип и приветствие
                          _buildHeader(),
                          SizedBox(
                              height:
                                  _getResponsiveSpacing(constraints.maxWidth)),

                          // Секция с аналитикой
                          const AnalyticsScreen(showAppBar: false),
                          SizedBox(
                              height:
                                  _getResponsiveSpacing(constraints.maxWidth)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Возвращает отступы в зависимости от размера экрана
  ///
  /// [screenWidth] - ширина экрана в пикселях
  ///
  /// Returns горизонтальные отступы для контента
  double _getResponsivePadding(double screenWidth) {
    if (screenWidth < 600) return 16.0; // Мобильные устройства
    if (screenWidth < 900) return 24.0; // Планшеты
    if (screenWidth < 1200) return 32.0; // Маленькие десктопы
    return 48.0; // Большие экраны
  }

  /// Возвращает вертикальные отступы в зависимости от размера экрана
  ///
  /// [screenWidth] - ширина экрана в пикселях
  ///
  /// Returns вертикальные отступы между элементами
  double _getResponsiveSpacing(double screenWidth) {
    if (screenWidth < 600) return 16.0; // Мобильные устройства
    if (screenWidth < 900) return 20.0; // Планшеты
    if (screenWidth < 1200) return 24.0; // Маленькие десктопы
    return 32.0; // Большие экраны
  }

  /// Строит заголовок экрана с логотипом и приветствием
  ///
  /// Включает:
  /// - Иконку ресторана с цветовым оформлением
  /// - Персонализированное приветствие
  /// - Подзаголовок с описанием функционала
  ///
  /// Returns виджет заголовка с приветствием
  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                  decoration: BoxDecoration(
                    color: AppColors.dynamicPrimary,
                    borderRadius:
                        BorderRadius.circular(isSmallScreen ? 10 : 12),
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: AppColors.dynamicOnPrimary,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(), // Приветствие по имени
                        style: (isSmallScreen
                                ? DesignTokens.typography.headlineMediumStyle
                                : DesignTokens.typography.headlineLargeStyle)
                            .copyWith(
                          color: AppColors.dynamicTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isSmallScreen) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Ваш персональный помощник по питанию',
                          style:
                              DesignTokens.typography.bodyMediumStyle.copyWith(
                            color: AppColors.dynamicTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Для маленьких экранов показываем подзаголовок на новой строке
            if (isSmallScreen) ...[
              const SizedBox(height: 8),
              Text(
                'Ваш персональный помощник по питанию',
                style: DesignTokens.typography.bodySmallStyle.copyWith(
                  color: AppColors.dynamicTextSecondary,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
