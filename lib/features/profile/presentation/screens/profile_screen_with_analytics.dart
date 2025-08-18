import 'package:flutter/material.dart';
import 'package:nutry_flow/features/analytics/presentation/mixins/persona_analytics_mixin.dart';
import 'package:nutry_flow/features/profile/domain/entities/user_profile.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

/// Экран профиля с интеграцией персоны аналитика
class ProfileScreenWithAnalytics extends StatefulWidget {
  final UserProfile userProfile;

  const ProfileScreenWithAnalytics({
    super.key,
    required this.userProfile,
  });

  @override
  State<ProfileScreenWithAnalytics> createState() =>
      _ProfileScreenWithAnalyticsState();
}

class _ProfileScreenWithAnalyticsState extends State<ProfileScreenWithAnalytics>
    with PersonaAnalyticsMixin {
  late UserProfile _currentProfile;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.userProfile;

    // Инициализируем аналитику при загрузке экрана
    _initializeAnalytics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Отслеживаем просмотр экрана
    trackScreenView(
      screenName: 'profile_screen',
      additionalData: {
        'user_id': _currentProfile.id,
        'user_persona': _getUserPersona(),
      },
    );
  }

  /// Инициализация аналитики
  Future<void> _initializeAnalytics() async {
    try {
      // Аналитика инициализируется через миксин
      // Профиль будет установлен при первом отслеживании
    } catch (e) {}
  }

  /// Получение персоны пользователя
  String _getUserPersona() {
    if (_currentProfile.fitnessGoals.contains('weight_loss') &&
        _currentProfile.activityLevel == ActivityLevel.sedentary) {
      return 'beginner_weight_loss';
    } else if (_currentProfile.fitnessGoals.contains('muscle_gain') &&
        _currentProfile.activityLevel == ActivityLevel.veryActive) {
      return 'advanced_fitness';
    } else if (_currentProfile.dietaryPreferences
        .contains(DietaryPreference.vegetarian)) {
      return 'health_conscious';
    } else if (_currentProfile.healthConditions.isNotEmpty) {
      return 'health_management';
    } else if (_currentProfile.activityLevel == ActivityLevel.extremelyActive) {
      return 'athlete';
    } else {
      return 'general_wellness';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicSurface,
        title: Text('Профиль',
            style: TextStyle(color: AppColors.dynamicTextPrimary)),
        actions: [
          createTrackedIconButton(
            buttonName: 'edit_profile',
            icon: Icon(Icons.edit, color: AppColors.dynamicTextPrimary),
            onPressed: _editProfile,
            additionalData: {
              'user_id': _currentProfile.id,
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поиск по профилю
            createTrackedSearchField(
              searchCategory: 'profile_search',
              controller: _searchController,
              onSearch: _handleSearch,
              hintText: 'Поиск в профиле...',
              additionalData: {
                'user_id': _currentProfile.id,
              },
            ),
            SizedBox(height: 24),

            // Основная информация
            _buildBasicInfoSection(),
            SizedBox(height: 24),

            // Физические характеристики
            _buildPhysicalInfoSection(),
            SizedBox(height: 24),

            // Цели и предпочтения
            _buildGoalsSection(),
            SizedBox(height: 24),

            // Действия
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  /// Секция основной информации
  Widget _buildBasicInfoSection() {
    return Card(
      color: AppColors.dynamicCard,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Основная информация',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.dynamicTextPrimary,
                  ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Имя', _currentProfile.fullName),
            _buildInfoRow('Email', _currentProfile.email),
            if (_currentProfile.phone != null)
              _buildInfoRow('Телефон', _currentProfile.phone!),
            if (_currentProfile.dateOfBirth != null)
              _buildInfoRow(
                  'Дата рождения', _currentProfile.dateOfBirth!.toString()),
            if (_currentProfile.gender != null)
              _buildInfoRow('Пол', _currentProfile.gender!.name),
          ],
        ),
      ),
    );
  }

  /// Секция физической информации
  Widget _buildPhysicalInfoSection() {
    return Card(
      color: AppColors.dynamicCard,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Физические характеристики',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.dynamicTextPrimary,
                  ),
            ),
            SizedBox(height: 16),
            if (_currentProfile.height != null)
              _buildInfoRow('Рост', '${_currentProfile.height} см'),
            if (_currentProfile.weight != null)
              _buildInfoRow('Вес', '${_currentProfile.weight} кг'),
            if (_currentProfile.height != null &&
                _currentProfile.weight != null)
              _buildInfoRow(
                  'ИМТ',
                  (_currentProfile.weight! /
                          ((_currentProfile.height! / 100) *
                              (_currentProfile.height! / 100)))
                      .toStringAsFixed(1)),
            if (_currentProfile.activityLevel != null)
              _buildInfoRow(
                  'Уровень активности', _currentProfile.activityLevel!.name),
          ],
        ),
      ),
    );
  }

  /// Секция целей
  Widget _buildGoalsSection() {
    return Card(
      color: AppColors.dynamicCard,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Цели и предпочтения',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.dynamicTextPrimary,
                  ),
            ),
            SizedBox(height: 16),
            if (_currentProfile.fitnessGoals.isNotEmpty)
              _buildInfoRow(
                  'Цели фитнеса', _currentProfile.fitnessGoals.join(', ')),
            if (_currentProfile.dietaryPreferences.isNotEmpty)
              _buildInfoRow(
                  'Диетические предпочтения',
                  _currentProfile.dietaryPreferences
                      .map((p) => p.name)
                      .join(', ')),
            if (_currentProfile.allergies.isNotEmpty)
              _buildInfoRow('Аллергии', _currentProfile.allergies.join(', ')),
            if (_currentProfile.healthConditions.isNotEmpty)
              _buildInfoRow('Состояния здоровья',
                  _currentProfile.healthConditions.join(', ')),
            if (_currentProfile.targetWeight != null)
              _buildInfoRow(
                  'Целевой вес', '${_currentProfile.targetWeight} кг'),
            if (_currentProfile.targetCalories != null)
              _buildInfoRow(
                  'Целевые калории', '${_currentProfile.targetCalories} ккал'),
          ],
        ),
      ),
    );
  }

  /// Секция действий
  Widget _buildActionsSection() {
    return Card(
      color: AppColors.dynamicCard,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Действия',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.dynamicTextPrimary,
                  ),
            ),
            SizedBox(height: 16),
            createTrackedElevatedButton(
              buttonName: 'update_weight',
              text: 'Обновить вес',
              onPressed: _updateWeight,
              additionalData: {
                'user_id': _currentProfile.id,
                'current_weight': _currentProfile.weight,
              },
            ),
            SizedBox(height: 8),
            createTrackedElevatedButton(
              buttonName: 'update_goals',
              text: 'Обновить цели',
              onPressed: _updateGoals,
              additionalData: {
                'user_id': _currentProfile.id,
                'current_goals': _currentProfile.fitnessGoals,
              },
            ),
            SizedBox(height: 8),
            createTrackedElevatedButton(
              buttonName: 'view_progress',
              text: 'Посмотреть прогресс',
              onPressed: _viewProgress,
              additionalData: {
                'user_id': _currentProfile.id,
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Создание строки информации
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.dynamicTextPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.dynamicTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  /// Обработка поиска
  void _handleSearch(String searchTerm) {
    trackSearch(
      searchTerm: searchTerm,
      searchCategory: 'profile_search',
      additionalData: {
        'user_id': _currentProfile.id,
        'search_results_count':
            0, // Здесь будет реальное количество результатов
      },
    );

    // Здесь будет логика поиска по профилю
  }

  /// Редактирование профиля
  void _editProfile() {
    trackFeatureUsage(
      featureName: 'profile_editing',
      action: 'start_edit',
      parameters: {
        'user_id': _currentProfile.id,
        'edit_section': 'full_profile',
      },
    );

    // Здесь будет навигация к экрану редактирования
  }

  /// Обновление веса
  void _updateWeight() {
    trackFeatureUsage(
      featureName: 'weight_tracking',
      action: 'update_weight',
      parameters: {
        'user_id': _currentProfile.id,
        'current_weight': _currentProfile.weight,
      },
    );

    // Здесь будет диалог обновления веса
  }

  /// Обновление целей
  void _updateGoals() {
    trackFeatureUsage(
      featureName: 'goal_tracking',
      action: 'update_goals',
      parameters: {
        'user_id': _currentProfile.id,
        'current_goals': _currentProfile.fitnessGoals,
      },
    );

    // Здесь будет диалог обновления целей
  }

  /// Просмотр прогресса
  void _viewProgress() {
    trackFeatureUsage(
      featureName: 'progress_tracking',
      action: 'view_progress',
      parameters: {
        'user_id': _currentProfile.id,
      },
    );

    // Здесь будет навигация к экрану прогресса
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
