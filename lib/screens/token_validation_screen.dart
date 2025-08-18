import 'package:flutter/material.dart';
import '../shared/design/tokens/design_tokens.dart';
import '../shared/design/utils/token_validator.dart';
import '../shared/design/components/cards/nutry_card.dart';
import '../shared/design/components/buttons/nutry_button.dart';

/// Экран валидации дизайн-токенов
/// Показывает результаты валидации и позволяет интерактивно проверять токены
class TokenValidationScreen extends StatefulWidget {
  const TokenValidationScreen({super.key});

  @override
  State<TokenValidationScreen> createState() => _TokenValidationScreenState();
}

class _TokenValidationScreenState extends State<TokenValidationScreen> {
  ValidationResult? _validationResult;
  bool _isValidating = false;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _validateTokens();
  }

  Future<void> _validateTokens() async {
    setState(() {
      _isValidating = true;
    });

    try {
      final result = TokenValidator.validateAllTokens();
      setState(() {
        _validationResult = result;
        _isValidating = false;
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка валидации: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Валидация дизайн-токенов',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isValidating ? null : _validateTokens,
            tooltip: 'Обновить валидацию',
          ),
        ],
      ),
      body: _isValidating
          ? _buildLoadingState()
          : _validationResult != null
              ? _buildValidationResults()
              : _buildErrorState(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Проверка дизайн-токенов...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки результатов',
            style: DesignTokens.typography.titleMediumStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте обновить страницу',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          NutryButton.primary(
            onPressed: _validateTokens,
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationResults() {
    final result = _validationResult!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(result),
          const SizedBox(height: 16),
          _buildCategoryFilter(),
          const SizedBox(height: 16),
          _buildDetailedResults(result),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ValidationResult result) {
    return NutryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isValid ? Icons.check_circle : Icons.error,
                color: result.isValid
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                result.isValid ? 'Валидация пройдена' : 'Найдены проблемы',
                style: DesignTokens.typography.titleMediumStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow('Ошибки', result.errors.length, Colors.red),
          _buildStatRow(
              'Предупреждения', result.warnings.length, Colors.orange),
          _buildStatRow(
              'Рекомендации', result.recommendations.length, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            count.toString(),
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return NutryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Фильтр по категориям',
            style: DesignTokens.typography.titleMediumStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip('all', 'Все'),
              _buildFilterChip('errors', 'Ошибки'),
              _buildFilterChip('warnings', 'Предупреждения'),
              _buildFilterChip('recommendations', 'Рекомендации'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : 'all';
        });
      },
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: DesignTokens.typography.bodySmallStyle.copyWith(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildDetailedResults(ValidationResult result) {
    final items = <Widget>[];

    if (_selectedCategory == 'all' || _selectedCategory == 'errors') {
      if (result.errors.isNotEmpty) {
        items.add(_buildSectionHeader('🚨 Критические ошибки', Colors.red));
        items.addAll(
            result.errors.map((error) => _buildIssueItem(error, Colors.red)));
        items.add(const SizedBox(height: 16));
      }
    }

    if (_selectedCategory == 'all' || _selectedCategory == 'warnings') {
      if (result.warnings.isNotEmpty) {
        items.add(_buildSectionHeader('⚠️ Предупреждения', Colors.orange));
        items.addAll(result.warnings
            .map((warning) => _buildIssueItem(warning, Colors.orange)));
        items.add(const SizedBox(height: 16));
      }
    }

    if (_selectedCategory == 'all' || _selectedCategory == 'recommendations') {
      if (result.recommendations.isNotEmpty) {
        items.add(_buildSectionHeader('💡 Рекомендации', Colors.blue));
        items.addAll(result.recommendations
            .map((rec) => _buildIssueItem(rec, Colors.blue)));
        items.add(const SizedBox(height: 16));
      }
    }

    if (items.isEmpty) {
      items.add(
        Center(
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Нет проблем для отображения',
                style: DesignTokens.typography.titleMediumStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Все токены соответствуют стандартам',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: items);
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: DesignTokens.typography.titleMediumStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueItem(String issue, Color color) {
    return NutryCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                issue,
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
