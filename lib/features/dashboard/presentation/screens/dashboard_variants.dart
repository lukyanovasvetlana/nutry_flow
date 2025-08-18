import 'package:flutter/material.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';

/// Контрольный вариант дашборда (сетка)
class GridDashboardLayout extends StatelessWidget {
  const GridDashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                'Дашборд',
                style: AppStyles.headline4.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Сетка карточек
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildDashboardCard(
                      context,
                      'Питание',
                      Icons.restaurant,
                      AppColors.primary,
                      () => _trackNavigation('nutrition'),
                    ),
                    _buildDashboardCard(
                      context,
                      'Активность',
                      Icons.fitness_center,
                      AppColors.secondary,
                      () => _trackNavigation('activity'),
                    ),
                    _buildDashboardCard(
                      context,
                      'Цели',
                      Icons.track_changes,
                      Colors.orange,
                      () => _trackNavigation('goals'),
                    ),
                    _buildDashboardCard(
                      context,
                      'Прогресс',
                      Icons.trending_up,
                      Colors.green,
                      () => _trackNavigation('progress'),
                    ),
                    _buildDashboardCard(
                      context,
                      'План питания',
                      Icons.calendar_today,
                      Colors.purple,
                      () => _trackNavigation('meal_plan'),
                    ),
                    _buildDashboardCard(
                      context,
                      'Аналитика',
                      Icons.analytics,
                      Colors.blue,
                      () => _trackNavigation('analytics'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _trackNavigation(String section) {
    ABTestingService.instance.trackExperimentConversion(
      experimentName: 'dashboard_layout',
      variant: 'grid',
      conversionType: 'navigation',
      parameters: {
        'section': section,
        'layout_type': 'grid',
      },
    );
  }
}

/// Вариант A дашборда (список)
class ListDashboardLayout extends StatelessWidget {
  const ListDashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                'Главное меню',
                style: AppStyles.headline4.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Список элементов
              Expanded(
                child: ListView(
                  children: [
                    _buildListItem(
                      context,
                      'Питание и диета',
                      'Отслеживайте калории и планируйте питание',
                      Icons.restaurant,
                      AppColors.primary,
                      () => _trackNavigation('nutrition'),
                    ),
                    _buildListItem(
                      context,
                      'Фитнес и активность',
                      'Записывайте тренировки и достижения',
                      Icons.fitness_center,
                      AppColors.secondary,
                      () => _trackNavigation('activity'),
                    ),
                    _buildListItem(
                      context,
                      'Цели и прогресс',
                      'Устанавливайте цели и следите за прогрессом',
                      Icons.track_changes,
                      Colors.orange,
                      () => _trackNavigation('goals'),
                    ),
                    _buildListItem(
                      context,
                      'План питания',
                      'Создавайте персональные планы питания',
                      Icons.calendar_today,
                      Colors.purple,
                      () => _trackNavigation('meal_plan'),
                    ),
                    _buildListItem(
                      context,
                      'Аналитика и отчеты',
                      'Подробная аналитика вашего прогресса',
                      Icons.analytics,
                      Colors.blue,
                      () => _trackNavigation('analytics'),
                    ),
                    _buildListItem(
                      context,
                      'Настройки профиля',
                      'Управляйте настройками и предпочтениями',
                      Icons.settings,
                      Colors.grey,
                      () => _trackNavigation('settings'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppStyles.caption.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
      ),
    );
  }

  void _trackNavigation(String section) {
    ABTestingService.instance.trackExperimentConversion(
      experimentName: 'dashboard_layout',
      variant: 'list',
      conversionType: 'navigation',
      parameters: {
        'section': section,
        'layout_type': 'list',
      },
    );
  }
}

/// Вариант B дашборда (карточки)
class CardDashboardLayout extends StatelessWidget {
  const CardDashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                'Обзор',
                style: AppStyles.headline4.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Карточки
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildLargeCard(
                        context,
                        'Сегодняшний прогресс',
                        'Вы достигли 75% от дневной цели',
                        Icons.trending_up,
                        Colors.green,
                        '75%',
                        () => _trackNavigation('progress'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSmallCard(
                              context,
                              'Калории',
                              '1,200 / 1,600',
                              Icons.local_fire_department,
                              Colors.orange,
                              () => _trackNavigation('calories'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSmallCard(
                              context,
                              'Активность',
                              '45 мин',
                              Icons.fitness_center,
                              Colors.blue,
                              () => _trackNavigation('activity'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildLargeCard(
                        context,
                        'Следующий прием пищи',
                        'Обед через 2 часа',
                        Icons.restaurant,
                        AppColors.primary,
                        '14:00',
                        () => _trackNavigation('next_meal'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSmallCard(
                              context,
                              'Вода',
                              '6 / 8 стаканов',
                              Icons.water_drop,
                              Colors.cyan,
                              () => _trackNavigation('water'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSmallCard(
                              context,
                              'Сон',
                              '7.5 часов',
                              Icons.bedtime,
                              Colors.indigo,
                              () => _trackNavigation('sleep'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String value,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppStyles.caption.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                value,
                style: AppStyles.headline6.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppStyles.caption.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppStyles.body2.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _trackNavigation(String section) {
    ABTestingService.instance.trackExperimentConversion(
      experimentName: 'dashboard_layout',
      variant: 'card',
      conversionType: 'navigation',
      parameters: {
        'section': section,
        'layout_type': 'card',
      },
    );
  }
}
