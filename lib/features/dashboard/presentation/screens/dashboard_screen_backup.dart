import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/stats_overview.dart';
import '../widgets/expense_chart.dart';
import '../widgets/expense_breakdown_chart.dart';
import '../widgets/products_chart.dart';
import '../widgets/products_breakdown_chart.dart';
import '../widgets/calories_chart.dart';
import '../widgets/calories_breakdown_chart.dart';

import '../../../grocery_list/presentation/screens/grocery_list_screen.dart';
import '../../../menu/presentation/screens/healthy_menu_screen.dart';
import '../../../exercise/presentation/screens/exercise_screen_redesigned.dart';
import '../../../analytics/presentation/screens/analytics_screen.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/design/components/cards/nutry_card.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/domain/repositories/profile_repository.dart';
import '../../../profile/data/repositories/sync_mock_profile_repository.dart';
import '../../../profile/data/services/sync_mock_profile_service.dart';
import '../../../../shared/theme/theme_manager.dart';
import '../../../analytics/presentation/mixins/analytics_mixin.dart';
import '../../../analytics/presentation/utils/analytics_utils.dart';

/// Главный экран дашборда приложения Nutry Flow
/// 
/// Предоставляет пользователю обзор ключевых метрик, быстрый доступ к основным функциям
/// и персонализированную информацию на основе профиля пользователя.
/// 
/// Основные компоненты:
/// - Приветствие и информация о пользователе
/// - Обзор статистики (графики, диаграммы)
/// - Быстрое меню навигации
/// - Интеграция с аналитикой для отслеживания действий
/// 
/// Пример использования:
/// ```dart
/// // С репозиторием по умолчанию (SyncMockProfileRepository)
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => const DashboardScreen()),
/// );
/// 
/// // С кастомным репозиторием
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => DashboardScreen(
///       profileRepository: CustomProfileRepository(),
///     ),
///   ),
/// );
/// ```
class DashboardScreen extends StatefulWidget {
  /// Репозиторий для работы с профилями пользователей
  final ProfileRepository profileRepository;

  /// Создает экран дашборда
  /// 
  /// [profileRepository] - репозиторий для работы с профилями (по умолчанию SyncMockProfileRepository)
  /// [key] - ключ виджета для управления состоянием
  DashboardScreen({
    super.key,
    this.profileRepository = const SyncMockProfileRepository(SyncMockProfileService()),
  });

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
  /// если не найден - использует MockProfileService для демо-режима.
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

                   // Если нет локального профиля, используем переданный репозиторий для демо-режима
             final profile = await widget.profileRepository.getCurrentUserProfile();

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoadingProfile = false;
        });
        
        // Отслеживаем загрузку демо-профиля
        trackEvent('profile_loaded', parameters: {
          'profile_source': 'mock_service',
          'has_name': profile?.firstName?.isNotEmpty ?? false,
          'has_email': profile?.email?.isNotEmpty ?? false,
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
                          SizedBox(height: _getResponsiveSpacing(constraints.maxWidth)),
                          // Логотип и приветствие
                          _buildHeader(),
                          SizedBox(height: _getResponsiveSpacing(constraints.maxWidth)),

                          // Статистика сверху
                          NutryCard(
                            backgroundColor: AppColors.dynamicCard,
                            child: StatsOverview(
                              selectedIndex: selectedChartIndex,
                              onCardTap: (index) {
                                // Отслеживаем изменение выбранного графика
                                trackUIInteraction(
                                  elementType: AnalyticsUtils.elementTypeCard,
                                  elementName: 'stats_overview_card',
                                  action: AnalyticsUtils.actionSelect,
                                  additionalData: {
                                    'chart_index': index,
                                    'previous_index': selectedChartIndex,
                                    'chart_type': _getChartType(index),
                                  },
                                );
                                
                                setState(() {
                                  selectedChartIndex = index;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: _getResponsiveSpacing(constraints.maxWidth)),

                          // Диаграммы
                          _buildChartsSection(),
                          SizedBox(height: _getResponsiveSpacing(constraints.maxWidth)),
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
    if (screenWidth < 600) return 16.0;      // Мобильные устройства
    if (screenWidth < 900) return 24.0;      // Планшеты
    if (screenWidth < 1200) return 32.0;     // Маленькие десктопы
    return 48.0;                             // Большие экраны
  }

  /// Возвращает вертикальные отступы в зависимости от размера экрана
  /// 
  /// [screenWidth] - ширина экрана в пикселях
  /// 
  /// Returns вертикальные отступы между элементами
  double _getResponsiveSpacing(double screenWidth) {
    if (screenWidth < 600) return 16.0;      // Мобильные устройства
    if (screenWidth < 900) return 20.0;      // Планшеты
    if (screenWidth < 1200) return 24.0;     // Маленькие десктопы
    return 32.0;                             // Большие экраны
  }

  /// Возвращает позицию плавающего меню снизу в зависимости от размера экрана
  /// 
  /// Returns позиция снизу для плавающего меню
  double _getResponsiveBottomPosition() {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 600) return 16.0;     // Маленькие экраны
    if (screenHeight < 900) return 20.0;     // Средние экраны
    return 24.0;                             // Большие экраны
  }

  /// Возвращает позицию плавающего меню справа в зависимости от размера экрана
  /// 
  /// Returns позиция справа для плавающего меню
  double _getResponsiveRightPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return 16.0;      // Мобильные устройства
    if (screenWidth < 900) return 20.0;      // Планшеты
    return 24.0;                             // Десктопы
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
        final isMediumScreen = constraints.maxWidth < 900;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                  decoration: BoxDecoration(
                    color: AppColors.dynamicPrimary,
                    borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
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
                          : DesignTokens.typography.headlineLargeStyle
                        ).copyWith(
                          color: AppColors.dynamicTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isSmallScreen) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Ваш персональный помощник по питанию',
                          style: DesignTokens.typography.bodyMediumStyle.copyWith(
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

  /// Строит секцию с графиками и диаграммами
  /// 
  /// Включает:
  /// - Заголовок "Аналитика питания"
  /// - Основную диаграмму (стоимость/продукты/калории)
  /// - Круговую диаграмму для детализации
  /// 
  /// Returns виджет секции с графиками
  Widget _buildChartsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isMediumScreen = constraints.maxWidth < 900;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Аналитика питания',
              style: (isSmallScreen 
                ? DesignTokens.typography.titleMediumStyle 
                : DesignTokens.typography.titleLargeStyle
              ).copyWith(
                color: AppColors.dynamicTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),

            // Основная диаграмма в зависимости от выбранной карточки
            _buildChartCard(
              title: _getChartTitle(),
              icon: _getChartIcon(),
              color: _getChartColor(),
              child: _getChartWidget(),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),

            // Круговая диаграмма для детализации
            _buildChartCard(
              title: _getBreakdownChartTitle(),
              icon: _getBreakdownChartIcon(),
              color: _getBreakdownChartColor(),
              child: _getBreakdownChartWidget(),
            ),
          ],
        );
      },
    );
  }

    /// Возвращает заголовок для основного графика на основе выбранного индекса
  /// 
  /// [selectedChartIndex] определяет тип отображаемого графика:
  /// - 0: "Стоимость" - график расходов на питание
  /// - 1: "Продукты" - график потребления продуктов
  /// - 2: "Калории" - график калорийности
  /// 
  /// Returns заголовок графика
  String _getChartTitle() {
    switch (selectedChartIndex) {
      case 0:
        return 'Стоимость';
      case 1:
        return 'Продукты';
      case 2:
        return 'Калории';
      default:
        return 'Аналитика';
      }
    }

  /// Возвращает тип графика для аналитики на основе индекса
  /// 
  /// [index] определяет тип графика:
  /// - 0: "expenses" - расходы на питание
  /// - 1: "products" - потребление продуктов
  /// - 2: "calories" - калорийность
  /// 
  /// Returns строковый идентификатор типа графика
  String _getChartType(int index) {
    switch (index) {
      case 0:
        return 'expenses';
      case 1:
        return 'products';
      case 2:
        return 'calories';
      default:
        return 'unknown';
    }
  }

  IconData _getChartIcon() {
    switch (selectedChartIndex) {
      case 0:
        return Icons.account_balance_wallet;
      case 1:
        return Icons.shopping_basket;
      case 2:
        return Icons.local_fire_department;
      default:
        return Icons.analytics;
    }
  }

  Color _getChartColor() {
    switch (selectedChartIndex) {
      case 0:
        return AppColors.dynamicGreen;
      case 1:
        return AppColors.dynamicYellow;
      case 2:
        return AppColors.dynamicOrange;
      default:
        return AppColors.dynamicPrimary;
    }
  }

  Widget _getChartWidget() {
    switch (selectedChartIndex) {
      case 0:
        return const ExpenseChart();
      case 1:
        return const ProductsChart();
      case 2:
        return const CaloriesChart();
      default:
        return const ExpenseChart();
    }
  }

  /// Возвращает заголовок для круговой диаграммы детализации
  /// 
  /// [selectedChartIndex] определяет тип детализации:
  /// - 0: "Детализация расходов" - разбивка по категориям трат
  /// - 1: "Категории продуктов" - распределение по типам продуктов
  /// - 2: "Распределение калорий" - разбивка по макронутриентам
  /// 
  /// Returns заголовок для диаграммы детализации
  String _getBreakdownChartTitle() {
    switch (selectedChartIndex) {
      case 0:
        return 'Детализация расходов';
      case 1:
        return 'Категории продуктов';
      case 2:
        return 'Распределение калорий';
      default:
        return 'Детализация';
    }
  }

  /// Возвращает иконку для круговой диаграммы детализации
  /// 
  /// [selectedChartIndex] определяет тип иконки:
  /// - 0: Icons.pie_chart - для детализации расходов
  /// - 1: Icons.category - для категорий продуктов
  /// - 2: Icons.donut_large - для распределения калорий
  /// 
  /// Returns иконка для диаграммы детализации
  IconData _getBreakdownChartIcon() {
    switch (selectedChartIndex) {
      case 0:
        return Icons.pie_chart;
      case 1:
        return Icons.category;
      case 2:
        return Icons.donut_large;
      default:
        return Icons.analytics;
    }
  }

  /// Возвращает цвет для круговой диаграммы детализации
  /// 
  /// [selectedChartIndex] определяет цветовую схему:
  /// - 0: AppColors.dynamicInfo - синий для расходов
  /// - 1: AppColors.dynamicGray - серый для продуктов
  /// - 2: AppColors.dynamicError - красный для калорий
  /// 
  /// Returns цвет для диаграммы детализации
  Color _getBreakdownChartColor() {
    switch (selectedChartIndex) {
      case 0:
        return AppColors.dynamicInfo;
      case 1:
        return AppColors.dynamicGray;
      case 2:
        return AppColors.dynamicError;
      default:
        return AppColors.dynamicSecondary;
    }
  }

  /// Возвращает виджет круговой диаграммы детализации
  /// 
  /// [selectedChartIndex] определяет тип диаграммы:
  /// - 0: ExpenseBreakdownChart - детализация расходов
  /// - 1: ProductsBreakdownChart - категории продуктов
  /// - 2: CaloriesBreakdownChart - распределение калорий
  /// 
  /// Returns виджет диаграммы детализации
  Widget _getBreakdownChartWidget() {
    switch (selectedChartIndex) {
      case 0:
        return const ExpenseBreakdownChart();
      case 1:
        return const ProductsBreakdownChart();
      case 2:
        return const CaloriesBreakdownChart();
      default:
        return const ExpenseBreakdownChart();
    }
  }

  /// Строит карточку с графиком или диаграммой
  /// 
  /// [title] - заголовок карточки
  /// [icon] - иконка для карточки
  /// [color] - основной цвет карточки
  /// [child] - виджет графика/диаграммы
  /// 
  /// Включает:
  /// - Заголовок с иконкой
  /// - Контейнер для графика (адаптивная высота)
  /// - Стилизацию в соответствии с дизайн-системой
  /// 
  /// Returns карточку с графиком
  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isMediumScreen = constraints.maxWidth < 900;
        
        return NutryCard(
          backgroundColor: AppColors.dynamicCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: isSmallScreen ? 16 : 20,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: Text(
                      title,
                      style: (isSmallScreen 
                        ? DesignTokens.typography.titleSmallStyle 
                        : DesignTokens.typography.titleMediumStyle
                      ).copyWith(
                        color: AppColors.dynamicTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              SizedBox(
                height: isSmallScreen ? 200 : (isMediumScreen ? 250 : 300),
                child: child,
              ),
            ],
          ),
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
        
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.dynamicSurface,
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
            boxShadow: [
              BoxShadow(
                color: AppColors.dynamicShadow.withOpacity(0.2),
                blurRadius: isSmallScreen ? 12 : 16,
                offset: Offset(0, isSmallScreen ? 6 : 8),
              ),
            ],
          ),
          child: PopupMenuButton<String>(
            icon: Container(
              padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
              decoration: BoxDecoration(
                color: AppColors.dynamicPrimary,
                borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
              ),
              child: Icon(
                Icons.menu,
                color: AppColors.dynamicOnPrimary,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
        onSelected: (String value) {
          // Отслеживаем нажатие на элемент меню
          trackUIInteraction(
            elementType: AnalyticsUtils.elementTypeList,
            elementName: 'dashboard_menu_item',
            action: AnalyticsUtils.actionSelect,
            additionalData: {'menu_item': value},
          );

          switch (value) {
            case 'menu':
              trackNavigation(
                fromScreen: AnalyticsUtils.screenDashboard,
                toScreen: 'healthy_menu_screen',
                navigationMethod: 'push',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HealthyMenuScreen()),
              );
              break;
            case 'exercises':
              trackNavigation(
                fromScreen: AnalyticsUtils.screenDashboard,
                toScreen: 'exercise_screen',
                navigationMethod: 'push',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExerciseScreenRedesigned()),
              );
              break;
            case 'health_articles':
              trackNavigation(
                fromScreen: AnalyticsUtils.screenDashboard,
                toScreen: AnalyticsUtils.screenHealthArticles,
                navigationMethod: 'push_named',
              );
              Navigator.pushNamed(context, '/health-articles');
              break;
            case 'analytics':
              trackNavigation(
                fromScreen: AnalyticsUtils.screenDashboard,
                toScreen: AnalyticsUtils.screenAnalytics,
                navigationMethod: 'push',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnalyticsScreen()),
              );
              break;
            case 'developer_analytics':
              trackNavigation(
                fromScreen: AnalyticsUtils.screenDashboard,
                toScreen: 'developer_analytics_screen',
                navigationMethod: 'push_named',
              );
              Navigator.pushNamed(context, '/developer-analytics');
              break;
            case 'ab_testing':
              trackNavigation(
                fromScreen: AnalyticsUtils.screenDashboard,
                toScreen: AnalyticsUtils.screenABTesting,
                navigationMethod: 'push_named',
              );
              Navigator.pushNamed(context, '/ab-testing');
              break;
            case 'profile':
              trackNavigation(
                fromScreen: AnalyticsUtils.screenDashboard,
                toScreen: AnalyticsUtils.screenProfileSettings,
                navigationMethod: 'push_named',
              );
              Navigator.pushNamed(context, '/profile-settings');
              break;
            case 'grocery':
              trackNavigation(
                fromScreen: AnalyticsUtils.screenDashboard,
                toScreen: 'grocery_list_screen',
                navigationMethod: 'push',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GroceryListScreen()),
              );
              break;
          }
        },
        itemBuilder: (context) => [
          _buildMenuItem(
              'menu', 'Меню', Icons.restaurant, AppColors.dynamicPrimary),
          _buildMenuItem('exercises', 'Упражнения', Icons.fitness_center,
              AppColors.dynamicSecondary),
          _buildMenuItem('health_articles', 'Статьи о здоровье', Icons.article,
              AppColors.dynamicTertiary),
          _buildMenuItem(
              'analytics', 'Аналитика', Icons.analytics, AppColors.dynamicInfo),
          _buildMenuItem('developer_analytics', 'Аналитика разработчика',
              Icons.developer_mode, AppColors.dynamicWarning),
          _buildMenuItem('ab_testing', 'A/B Тестирование', Icons.science,
              AppColors.dynamicSuccess),
          _buildMenuItem('grocery', 'Список покупок', Icons.shopping_cart,
              AppColors.dynamicNutritionWater),
          _buildMenuItem('profile', 'Профиль', Icons.person,
              AppColors.dynamicNutritionFiber),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, String title, IconData icon, Color color) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: DesignTokens.typography.bodyLargeStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
