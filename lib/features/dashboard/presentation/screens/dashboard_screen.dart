import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../grocery_list/presentation/screens/grocery_list_screen.dart';
import '../../../menu/presentation/screens/healthy_menu_screen.dart';
import '../../../analytics/presentation/screens/analytics_screen.dart';
import 'expense_structure_screen.dart';
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
            // Плавающая иконка меню
            Positioned(
              bottom: _getResponsiveBottomPosition(),
              right: _getResponsiveRightPosition(),
              child: _buildFloatingMenu(),
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

  /// Возвращает позицию плавающего меню снизу в зависимости от размера экрана
  ///
  /// Returns позиция снизу для плавающего меню
  double _getResponsiveBottomPosition() {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 600) return 16.0; // Маленькие экраны
    if (screenHeight < 900) return 20.0; // Средние экраны
    return 24.0; // Большие экраны
  }

  /// Возвращает позицию плавающего меню справа в зависимости от размера экрана
  ///
  /// Returns позиция справа для плавающего меню
  double _getResponsiveRightPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return 16.0; // Мобильные устройства
    if (screenWidth < 900) return 20.0; // Планшеты
    return 24.0; // Десктопы
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

  /// Строит плавающее меню быстрого доступа
  ///
  /// Включает:
  /// - Кнопку меню с иконкой и тенью
  /// - PopupMenuButton с основными разделами приложения
  /// - Отслеживание аналитики для всех действий
  /// - Навигацию к соответствующим экранам
  ///
  /// Пункты меню:
  /// - menu: Здоровое меню
  /// - exercises: Упражнения
  /// - health_articles: Статьи о здоровье
  /// - analytics: Аналитика
  /// - grocery_list: Список покупок
  ///
  /// Returns плавающее меню с навигацией
  Widget _buildFloatingMenu() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: (0.7 + (0.3 * value.clamp(0.0, 1.0))).clamp(0.1, 2.0),
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value.clamp(0.0, 1.0))),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.dynamicSurface,
                      borderRadius:
                          BorderRadius.circular(isSmallScreen ? 20 : 24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dynamicShadow.withOpacity(0.2),
                          blurRadius: isSmallScreen ? 24 : 32,
                          offset: const Offset(0, 12),
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.dynamicShadow.withOpacity(0.15),
                          blurRadius: isSmallScreen ? 12 : 16,
                          offset: const Offset(0, 6),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.dynamicPrimary.withOpacity(0.1),
                          blurRadius: isSmallScreen ? 8 : 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: PopupMenuButton<String>(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(isSmallScreen ? 16 : 20),
                      ),
                      color: AppColors.dynamicSurface,
                      icon: _buildAnimatedMenuIcon(isSmallScreen),
                      // Добавляем красивые стили для меню
                      constraints: BoxConstraints(
                        minWidth: isSmallScreen ? 200 : 250,
                        maxWidth: isSmallScreen ? 280 : 320,
                      ),
                      position: PopupMenuPosition.under,
                      offset: const Offset(0, 8),
                      // Добавляем анимацию появления
                      child: null,
                      onSelected: (String value) {
                        // Отслеживаем нажатие на элемент меню (временно отключено)
                        // trackUIInteraction(
                        //   elementType: AnalyticsUtils.elementTypeList,
                        //   elementName: 'dashboard_menu_item',
                        //   action: AnalyticsUtils.actionSelect,
                        //   additionalData: {'menu_item': value},
                        // );

                        switch (value) {
                          case 'menu':
                            // trackNavigation(
                            //   fromScreen: AnalyticsUtils.screenDashboard,
                            //   toScreen: 'healthy_menu_screen',
                            //   navigationMethod: 'push',
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HealthyMenuScreen()),
                            );
                            break;
                          case 'health_articles':
                            // trackNavigation(
                            //   fromScreen: AnalyticsUtils.screenDashboard,
                            //   toScreen: AnalyticsUtils.screenHealthArticles,
                            //   navigationMethod: 'push_named',
                            // );
                            Navigator.pushNamed(context, '/health-articles');
                            break;
                          case 'analytics':
                            // trackNavigation(
                            //   fromScreen: AnalyticsUtils.screenDashboard,
                            //   toScreen: AnalyticsUtils.screenExpenseStructure,
                            //   navigationMethod: 'push',
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ExpenseStructureScreen()),
                            );
                            break;
                          case 'grocery_list':
                            // trackNavigation(
                            //   fromScreen: AnalyticsUtils.screenDashboard,
                            //   toScreen: AnalyticsUtils.screenGroceryList,
                            //   navigationMethod: 'push',
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GroceryListScreen()),
                            );
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        _buildMenuItem(
                          value: 'menu',
                          icon: Icons.restaurant_menu,
                          label: 'Здоровое меню',
                          color: AppColors.dynamicPrimary,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildMenuItem(
                          value: 'health_articles',
                          icon: Icons.article,
                          label: 'Статьи о здоровье',
                          color: AppColors.dynamicInfo,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildMenuItem(
                          value: 'analytics',
                          icon: Icons.account_balance_wallet,
                          label: 'Питание и калории',
                          color: AppColors.dynamicWarning,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildMenuItem(
                          value: 'grocery_list',
                          icon: Icons.shopping_cart,
                          label: 'Список покупок',
                          color: AppColors.dynamicError,
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Строит анимированную иконку меню с hover эффектами
  Widget _buildAnimatedMenuIcon(bool isSmallScreen) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(
                begin: 0.0, end: isHovered ? 1.0 : 0.0), // ignore: dead_code
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 1.0 + (0.1 * value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: AppColors.dynamicPrimary,
                    borderRadius:
                        BorderRadius.circular(isSmallScreen ? 14 : 18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dynamicPrimary.withOpacity(0.3),
                        blurRadius:
                            (12 + (8 * value.clamp(0.0, 1.0))).clamp(4.0, 20.0),
                        offset: Offset(0,
                            (6 + (4 * value.clamp(0.0, 1.0))).clamp(2.0, 10.0)),
                        spreadRadius:
                            (2 + (2 * value.clamp(0.0, 1.0))).clamp(0.0, 4.0),
                      ),
                      BoxShadow(
                        color: AppColors.dynamicPrimary.withOpacity(0.2),
                        blurRadius:
                            (6 + (4 * value.clamp(0.0, 1.0))).clamp(2.0, 10.0),
                        offset: Offset(0,
                            (3 + (2 * value.clamp(0.0, 1.0))).clamp(1.0, 5.0)),
                        spreadRadius:
                            (1 + (1 * value.clamp(0.0, 1.0))).clamp(0.0, 2.0),
                      ),
                      BoxShadow(
                        color: AppColors.dynamicPrimary.withOpacity(0.1),
                        blurRadius:
                            (4 + (2 * value.clamp(0.0, 1.0))).clamp(2.0, 6.0),
                        offset: Offset(0,
                            (2 + (1 * value.clamp(0.0, 1.0))).clamp(1.0, 3.0)),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: value * 0.05,
                    child: Icon(
                      Icons.menu,
                      color: AppColors.dynamicOnPrimary,
                      size: isSmallScreen ? 22 : 26,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Строит красивый пункт меню с иконкой и текстом
  PopupMenuEntry<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    required Color color,
    required bool isSmallScreen,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: isSmallScreen ? 8 : 12,
      ),
      // Добавляем кастомные стили для пункта меню
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: isSmallScreen ? 18 : 20,
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.dynamicTextPrimary,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.dynamicTextSecondary,
            size: isSmallScreen ? 14 : 16,
          ),
        ],
      ),
    );
  }
}
