import 'package:flutter/material.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';
import 'dart:developer' as developer;

class ABTestingScreen extends StatefulWidget {
  const ABTestingScreen({super.key});

  @override
  State<ABTestingScreen> createState() => _ABTestingScreenState();
}

class _ABTestingScreenState extends State<ABTestingScreen> {
  bool _isLoading = false;
  Map<String, String> _activeExperiments = {};
  Map<String, dynamic> _featureFlags = {};
  DateTime? _lastFetchTime;
  String _fetchStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadABTestingData();
  }

  Future<void> _loadABTestingData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Загружаем данные A/B тестирования
      final experiments = ABTestingService.instance.getAllActiveExperiments();
      final flags = ABTestingService.instance.getFeatureFlags();
      final lastFetch = ABTestingService.instance.getLastFetchTime();
      final status = ABTestingService.instance.getFetchStatus();

      setState(() {
        _activeExperiments = experiments;
        _featureFlags = flags;
        _lastFetchTime = lastFetch;
        _fetchStatus = _getFetchStatusString(status);
      });
    } catch (e) {
      developer.log('Failed to load A/B testing data: $e', name: 'ABTestingScreen');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getFetchStatusString(dynamic status) {
    switch (status) {
      case 0:
        return 'No Fetch Yet';
      case 1:
        return 'Success';
      case 2:
        return 'No Fetch Yet';
      case 3:
        return 'Error';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A/B Тестирование'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _forceUpdate,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadABTestingData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusSection(),
                    const SizedBox(height: 24),
                    _buildExperimentsSection(),
                    const SizedBox(height: 24),
                    _buildFeatureFlagsSection(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Статус конфигурации',
              style: AppStyles.headline6.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusRow('Статус загрузки', _fetchStatus),
            _buildStatusRow(
              'Последнее обновление',
              _lastFetchTime?.toString() ?? 'Неизвестно',
            ),
            _buildStatusRow(
              'Активных экспериментов',
              _activeExperiments.length.toString(),
            ),
            _buildStatusRow(
              'Флагов функций',
              _featureFlags.length.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.body2.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: AppStyles.body2.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperimentsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Активные эксперименты',
              style: AppStyles.headline6.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._activeExperiments.entries.map((entry) => _buildExperimentCard(
              entry.key,
              entry.value,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildExperimentCard(String experimentName, String variant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          Icons.science,
          color: _getVariantColor(variant),
        ),
        title: Text(
          _getExperimentDisplayName(experimentName),
          style: AppStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Вариант: $variant',
          style: AppStyles.caption.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.visibility),
          onPressed: () => _trackExperimentExposure(experimentName, variant),
        ),
      ),
    );
  }

  Widget _buildFeatureFlagsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Флаги функций',
              style: AppStyles.headline6.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_featureFlags.isEmpty)
              Text(
                'Нет активных флагов функций',
                style: AppStyles.body2.copyWith(
                  color: Colors.grey[600],
                ),
              )
            else
              ..._featureFlags.entries.map((entry) => _buildFeatureFlagCard(
                entry.key,
                entry.value,
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureFlagCard(String flagName, dynamic value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          value == true ? Icons.check_circle : Icons.cancel,
          color: value == true ? Colors.green : Colors.red,
        ),
        title: Text(
          _getFeatureFlagDisplayName(flagName),
          style: AppStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Статус: ${value == true ? 'Включено' : 'Отключено'}',
          style: AppStyles.caption.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Действия',
          style: AppStyles.headline6.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Принудительное обновление',
          Icons.refresh,
          Colors.blue,
          _forceUpdate,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Отследить конверсию цели',
          Icons.track_changes,
          Colors.green,
          () => _trackGoalConversion(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Отследить конверсию регистрации',
          Icons.person_add,
          Colors.orange,
          () => _trackRegistrationConversion(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Отследить конверсию покупки',
          Icons.shopping_cart,
          Colors.purple,
          () => _trackPurchaseConversion(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Тест флага функции',
          Icons.flag,
          Colors.teal,
          () => _testFeatureFlag(),
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

  Color _getVariantColor(String variant) {
    switch (variant) {
      case 'control':
        return Colors.grey;
      case 'variant_a':
        return Colors.blue;
      case 'variant_b':
        return Colors.green;
      case 'variant_c':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  String _getExperimentDisplayName(String experimentName) {
    switch (experimentName) {
      case 'welcome_screen':
        return 'Экран приветствия';
      case 'onboarding_flow':
        return 'Процесс онбординга';
      case 'dashboard_layout':
        return 'Макет дашборда';
      case 'meal_plan':
        return 'План питания';
      case 'workout':
        return 'Тренировки';
      case 'notification':
        return 'Уведомления';
      case 'color_scheme':
        return 'Цветовая схема';
      default:
        return experimentName;
    }
  }

  String _getFeatureFlagDisplayName(String flagName) {
    switch (flagName) {
      case 'premium_features':
        return 'Премиум функции';
      case 'social_features':
        return 'Социальные функции';
      case 'ai_recommendations':
        return 'AI рекомендации';
      default:
        return flagName;
    }
  }

  Future<void> _forceUpdate() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await ABTestingService.instance.forceUpdate();
      await _loadABTestingData();

      _showSnackBar('Конфигурация обновлена успешно', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при обновлении: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _trackExperimentExposure(String experimentName, String variant) async {
    try {
      await ABTestingService.instance.trackExperimentExposure(
        experimentName: experimentName,
        variant: variant,
        parameters: {
          'screen': 'ab_testing_screen',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      _showSnackBar('Показ эксперимента отслежен', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании: $e', Colors.red);
    }
  }

  Future<void> _trackGoalConversion() async {
    try {
      final experiments = ABTestingService.instance.getAllActiveExperiments();
      
      for (final entry in experiments.entries) {
        await ABTestingService.instance.trackExperimentConversion(
          experimentName: entry.key,
          variant: entry.value,
          conversionType: 'goal_achievement',
          parameters: {
            'goal_name': 'Тестовая цель',
            'goal_type': 'weight_loss',
            'progress': 75.0,
          },
        );
      }

      _showSnackBar('Конверсия цели отслежена', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании конверсии: $e', Colors.red);
    }
  }

  Future<void> _trackRegistrationConversion() async {
    try {
      final experiments = ABTestingService.instance.getAllActiveExperiments();
      
      for (final entry in experiments.entries) {
        await ABTestingService.instance.trackExperimentConversion(
          experimentName: entry.key,
          variant: entry.value,
          conversionType: 'registration',
          parameters: {
            'registration_method': 'email',
            'user_type': 'new',
          },
        );
      }

      _showSnackBar('Конверсия регистрации отслежена', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании конверсии: $e', Colors.red);
    }
  }

  Future<void> _trackPurchaseConversion() async {
    try {
      final experiments = ABTestingService.instance.getAllActiveExperiments();
      
      for (final entry in experiments.entries) {
        await ABTestingService.instance.trackExperimentConversion(
          experimentName: entry.key,
          variant: entry.value,
          conversionType: 'purchase',
          parameters: {
            'product_id': 'premium_subscription',
            'price': 9.99,
            'currency': 'USD',
          },
        );
      }

      _showSnackBar('Конверсия покупки отслежена', Colors.green);
    } catch (e) {
      _showSnackBar('Ошибка при отслеживании конверсии: $e', Colors.red);
    }
  }

  Future<void> _testFeatureFlag() async {
    try {
      final isPremiumEnabled = ABTestingService.instance.isFeatureEnabled('premium_features');
      final isSocialEnabled = ABTestingService.instance.isFeatureEnabled('social_features');
      final isAIEnabled = ABTestingService.instance.isFeatureEnabled('ai_recommendations');

      _showSnackBar(
        'Флаги: Premium=$isPremiumEnabled, Social=$isSocialEnabled, AI=$isAIEnabled',
        Colors.blue,
      );
    } catch (e) {
      _showSnackBar('Ошибка при проверке флагов: $e', Colors.red);
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