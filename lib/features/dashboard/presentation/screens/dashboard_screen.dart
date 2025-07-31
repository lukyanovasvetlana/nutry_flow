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
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_styles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? userName;
  int selectedChartIndex = 0; // 0 - расходы, 1 - продукты, 2 - калории

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Гость';
    });
  }

  Future<void> _refreshData() async {
    await _loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          // Логотип и приветствие
                          _buildHeader(),
                          const SizedBox(height: 8),
                          
                          // Статистика сверху
                          StatsOverview(
                            selectedIndex: selectedChartIndex,
                            onCardTap: (index) {
                              setState(() {
                                selectedChartIndex = index;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          
                          // Диаграммы
                          _buildChartsSection(),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/Logo.png',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 0),
          Text(
            'Привет, ${userName ?? 'Гость'}!\nДавай начнем наш путь по улучшению здоровья',
            textAlign: TextAlign.center,
            style: AppStyles.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        // Гистограмма
        _buildMainChart(),
        const SizedBox(height: 8),
        
        // Круговая диаграмма
        _buildBreakdownChart(),
      ],
    );
  }

  Widget _buildMainChart() {
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

  Widget _buildBreakdownChart() {
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

  Widget _buildFloatingMenu() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.menu,
          color: AppColors.button,
          size: 24,
        ),
      ),
      onSelected: (String value) {
        switch (value) {
          case 'menu':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HealthyMenuScreen()),
            );
            break;
          case 'exercises':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExerciseScreenRedesigned()),
            );
            break;
          case 'health_articles':
            Navigator.pushNamed(context, '/health-articles');
            break;
          case 'analytics':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
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
              MaterialPageRoute(builder: (context) => const GroceryListScreen()),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'menu',
          child: ListTile(
            leading: Icon(Icons.restaurant, color: AppColors.button),
            title: Text('Меню'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'exercises',
          child: ListTile(
            leading: Icon(Icons.fitness_center, color: AppColors.button),
            title: Text('Упражнения'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'health_articles',
          child: ListTile(
            leading: Icon(Icons.article, color: AppColors.button),
            title: Text('Статьи о здоровье'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'analytics',
          child: ListTile(
            leading: Icon(Icons.analytics, color: AppColors.button),
            title: Text('Аналитика'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'developer_analytics',
          child: ListTile(
            leading: Icon(Icons.developer_mode, color: AppColors.button),
            title: Text('Аналитика разработчика'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'ab_testing',
          child: ListTile(
            leading: Icon(Icons.science, color: AppColors.button),
            title: Text('A/B Тестирование'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'grocery',
          child: ListTile(
            leading: Icon(Icons.shopping_cart, color: AppColors.button),
            title: Text('Список покупок'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person, color: AppColors.button),
            title: Text('Профиль'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
} 