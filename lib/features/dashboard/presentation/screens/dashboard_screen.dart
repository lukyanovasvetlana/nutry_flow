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
import '../../../profile/data/services/profile_service.dart';
import '../../../../shared/theme/theme_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedChartIndex = 0;
  UserProfile? _userProfile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

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
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    }
  }

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
      body: Stack(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Логотип и приветствие
                        _buildHeader(),
                        const SizedBox(height: 24),

                        // Статистика сверху
                        NutryCard(
                          backgroundColor: AppColors.dynamicCard,
                          child: StatsOverview(
                            selectedIndex: selectedChartIndex,
                            onCardTap: (index) {
                              setState(() {
                                selectedChartIndex = index;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Диаграммы
                        _buildChartsSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Плавающая иконка меню
          Positioned(
            bottom: 20,
            right: 16,
            child: _buildFloatingMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dynamicPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.restaurant_menu,
                color: AppColors.dynamicOnPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(), // Приветствие по имени
                    style: DesignTokens.typography.headlineLargeStyle.copyWith(
                      color: AppColors.dynamicTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ваш персональный помощник по питанию',
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Аналитика питания',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Основная диаграмма в зависимости от выбранной карточки
        _buildChartCard(
          title: _getChartTitle(),
          icon: _getChartIcon(),
          color: _getChartColor(),
          child: _getChartWidget(),
        ),
        const SizedBox(height: 16),

        // Круговая диаграмма для детализации
        _buildChartCard(
          title: _getBreakdownChartTitle(),
          icon: _getBreakdownChartIcon(),
          color: _getBreakdownChartColor(),
          child: _getBreakdownChartWidget(),
        ),
      ],
    );
  }

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

  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return NutryCard(
      backgroundColor: AppColors.dynamicCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: DesignTokens.typography.titleMediumStyle.copyWith(
                  color: AppColors.dynamicTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height:
                300, // Увеличил с 250 до 300 для лучшего отображения увеличенных диаграмм
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingMenu() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.dynamicSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dynamicShadow.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.dynamicPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.menu,
            color: AppColors.dynamicOnPrimary,
            size: 24,
          ),
        ),
        onSelected: (String value) {
          switch (value) {
            case 'menu':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HealthyMenuScreen()),
              );
              break;
            case 'exercises':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExerciseScreenRedesigned()),
              );
              break;
            case 'health_articles':
              Navigator.pushNamed(context, '/health-articles');
              break;
            case 'analytics':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnalyticsScreen()),
              );
              break;
            case 'developer_analytics':
              Navigator.pushNamed(context, '/developer-analytics');
              break;
            case 'ab_testing':
              Navigator.pushNamed(context, '/ab-testing');
              break;
            case 'profile':
              Navigator.pushNamed(context, '/profile-settings');
              break;
            case 'grocery':
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
