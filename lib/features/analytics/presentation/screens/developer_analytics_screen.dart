import 'package:flutter/material.dart';
import 'package:nutry_flow/core/services/monitoring_service.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';
import 'dart:developer' as developer;

class DeveloperAnalyticsScreen extends StatefulWidget {
  const DeveloperAnalyticsScreen({super.key});

  @override
  State<DeveloperAnalyticsScreen> createState() => _DeveloperAnalyticsScreenState();
}

class _DeveloperAnalyticsScreenState extends State<DeveloperAnalyticsScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _analyticsData = {};
  Map<String, dynamic> _performanceData = {};
  Map<String, dynamic> _errorData = {};

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Имитируем загрузку данных аналитики
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _analyticsData = {
          'total_events': 1250,
          'active_users': 342,
          'sessions_today': 89,
          'goal_achievements': 23,
          'workouts_completed': 156,
          'meals_logged': 892,
        };

        _performanceData = {
          'app_start_time': 2.3,
          'screen_load_time': 1.8,
          'api_response_time': 450,
          'memory_usage': 45.2,
          'ui_response_time': 120,
        };

        _errorData = {
          'total_errors': 12,
          'api_errors': 5,
          'ui_errors': 3,
          'database_errors': 2,
          'network_errors': 2,
        };
      });
    } catch (e) {
      developer.log('Failed to load analytics data: $e', name: 'DeveloperAnalyticsScreen');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика разработчика'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalyticsData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalyticsData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Общая аналитика'),
                    _buildAnalyticsCards(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Производительность'),
                    _buildPerformanceCards(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Ошибки'),
                    _buildErrorCards(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Действия'),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppStyles.headline6.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnalyticsCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          'Общие события',
          _analyticsData['total_events']?.toString() ?? '0',
          Icons.analytics,
          Colors.blue,
        ),
        _buildMetricCard(
          'Активные пользователи',
          _analyticsData['active_users']?.toString() ?? '0',
          Icons.people,
          Colors.green,
        ),
        _buildMetricCard(
          'Сеансы сегодня',
          _analyticsData['sessions_today']?.toString() ?? '0',
          Icons.today,
          Colors.orange,
        ),
        _buildMetricCard(
          'Достижения целей',
          _analyticsData['goal_achievements']?.toString() ?? '0',
          Icons.emoji_events,
          Colors.purple,
        ),
        _buildMetricCard(
          'Завершенные тренировки',
          _analyticsData['workouts_completed']?.toString() ?? '0',
          Icons.fitness_center,
          Colors.red,
        ),
        _buildMetricCard(
          'Записанные приемы пищи',
          _analyticsData['meals_logged']?.toString() ?? '0',
          Icons.restaurant,
          Colors.teal,
        ),
      ],
    );
  }

  Widget _buildPerformanceCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          'Время запуска (с)',
          _performanceData['app_start_time']?.toString() ?? '0',
          Icons.timer,
          Colors.indigo,
        ),
        _buildMetricCard(
          'Загрузка экрана (с)',
          _performanceData['screen_load_time']?.toString() ?? '0',
          Icons.speed,
          Colors.cyan,
        ),
        _buildMetricCard(
          'API ответ (мс)',
          _performanceData['api_response_time']?.toString() ?? '0',
          Icons.api,
          Colors.amber,
        ),
        _buildMetricCard(
          'Использование памяти (%)',
          _performanceData['memory_usage']?.toString() ?? '0',
          Icons.memory,
          Colors.deepOrange,
        ),
        _buildMetricCard(
          'UI отклик (мс)',
          _performanceData['ui_response_time']?.toString() ?? '0',
          Icons.touch_app,
          Colors.lime,
        ),
      ],
    );
  }

  Widget _buildErrorCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          'Всего ошибок',
          _errorData['total_errors']?.toString() ?? '0',
          Icons.error,
          Colors.red,
        ),
        _buildMetricCard(
          'API ошибки',
          _errorData['api_errors']?.toString() ?? '0',
          Icons.api,
          Colors.orange,
        ),
        _buildMetricCard(
          'UI ошибки',
          _errorData['ui_errors']?.toString() ?? '0',
          Icons.bug_report,
          Colors.yellow,
        ),
        _buildMetricCard(
          'Ошибки БД',
          _errorData['database_errors']?.toString() ?? '0',
          Icons.storage,
          Colors.purple,
        ),
        _buildMetricCard(
          'Сетевые ошибки',
          _errorData['network_errors']?.toString() ?? '0',
          Icons.wifi,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppStyles.headline5.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppStyles.caption.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          'Отследить тестовое событие',
          Icons.send,
          Colors.blue,
          () => _trackTestEvent(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Отследить ошибку',
          Icons.error_outline,
          Colors.red,
          () => _trackTestError(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Отследить производительность',
          Icons.speed,
          Colors.green,
          () => _trackTestPerformance(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Отследить достижение цели',
          Icons.emoji_events,
          Colors.orange,
          () => _trackTestGoalAchievement(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Отследить тренировку',
          Icons.fitness_center,
          Colors.purple,
          () => _trackTestWorkout(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Отследить прием пищи',
          Icons.restaurant,
          Colors.teal,
          () => _trackTestMeal(),
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<void> _trackTestEvent() async {
    try {
      await MonitoringService.instance.trackEvent(
        eventName: 'test_event',
        parameters: {
          'test_parameter': 'test_value',
          'timestamp': DateTime.now().toIso8601String(),
        },
        screenName: 'developer_analytics_screen',
      );

      _showSnackBar('Тестовое событие отслежено успешно', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании события: $e', Colors.red);
    }
  }

  Future<void> _trackTestError() async {
    try {
      await MonitoringService.instance.trackError(
        error: 'Test error for monitoring',
        stackTrace: StackTrace.current,
        screenName: 'developer_analytics_screen',
        actionName: 'test_error_button',
        additionalData: {
          'test_error': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      _showSnackBar('Тестовая ошибка отслежена успешно', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании ошибки: $e', Colors.red);
    }
  }

  Future<void> _trackTestPerformance() async {
    try {
      await MonitoringService.instance.trackAppPerformance();

      _showSnackBar('Производительность отслежена успешно', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании производительности: $e', Colors.red);
    }
  }

  Future<void> _trackTestGoalAchievement() async {
    try {
      await MonitoringService.instance.trackGoalAchievement(
        goalName: 'Тестовая цель',
        goalType: 'weight_loss',
        progress: 75.0,
        additionalData: {
          'test_goal': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      _showSnackBar('Достижение цели отслежено успешно', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании достижения цели: $e', Colors.red);
    }
  }

  Future<void> _trackTestWorkout() async {
    try {
      await MonitoringService.instance.trackWorkout(
        workoutType: 'cardio',
        durationMinutes: 30,
        caloriesBurned: 250,
        workoutName: 'Тестовая тренировка',
        additionalData: {
          'test_workout': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      _showSnackBar('Тренировка отслежена успешно', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании тренировки: $e', Colors.red);
    }
  }

  Future<void> _trackTestMeal() async {
    try {
      await MonitoringService.instance.trackMeal(
        mealType: 'breakfast',
        calories: 350,
        protein: 15.0,
        fat: 12.0,
        carbs: 45.0,
        mealName: 'Тестовый завтрак',
        additionalData: {
          'test_meal': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      _showSnackBar('Прием пищи отслежен успешно', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании приема пищи: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 