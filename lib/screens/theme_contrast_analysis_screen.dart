import 'package:flutter/material.dart';
import '../shared/design/tokens/design_tokens.dart';
import '../shared/design/tokens/theme_tokens.dart';
import '../shared/design/utils/theme_analyzer.dart';
import '../shared/design/components/cards/nutry_card.dart';
import '../shared/design/components/buttons/nutry_button.dart';

/// Экран для анализа проблем с контрастностью в темах
class ThemeContrastAnalysisScreen extends StatefulWidget {
  const ThemeContrastAnalysisScreen({super.key});

  @override
  State<ThemeContrastAnalysisScreen> createState() =>
      _ThemeContrastAnalysisScreenState();
}

class _ThemeContrastAnalysisScreenState
    extends State<ThemeContrastAnalysisScreen> {
  ComparativeAnalysisResult? _analysisResult;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _analyzeThemes();
  }

  void _analyzeThemes() {
    setState(() {
      _isAnalyzing = true;
    });

    // Анализируем темы
    final result = ThemeAnalyzer.analyzeBothThemes();

    setState(() {
      _analysisResult = result;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Анализ контрастности тем',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: context.onSurface,
          ),
        ),
        backgroundColor: context.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: context.onSurface,
            ),
            onPressed: _analyzeThemes,
          ),
        ],
      ),
      body: _isAnalyzing
          ? _buildLoadingState()
          : _analysisResult != null
              ? _buildAnalysisResults()
              : _buildErrorState(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.primary,
          ),
          SizedBox(height: DesignTokens.spacing.lg),
          Text(
            'Анализируем контрастность тем...',
            style: DesignTokens.typography.bodyLargeStyle.copyWith(
              color: context.onSurface,
            ),
          ),
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
            color: context.error,
          ),
          SizedBox(height: DesignTokens.spacing.lg),
          Text(
            'Ошибка при анализе тем',
            style: DesignTokens.typography.titleMediumStyle.copyWith(
              color: context.onSurface,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.md),
          NutryButton.primary(
            text: 'Повторить анализ',
            onPressed: _analyzeThemes,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final result = _analysisResult!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(DesignTokens.spacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(result),
          SizedBox(height: DesignTokens.spacing.lg),
          if (result.lightTheme.hasIssues) ...[
            _buildIssuesCard('Светлая тема', result.lightTheme, Colors.orange),
            SizedBox(height: DesignTokens.spacing.lg),
          ],
          if (result.darkTheme.hasIssues) ...[
            _buildIssuesCard('Темная тема', result.darkTheme, Colors.red),
            SizedBox(height: DesignTokens.spacing.lg),
          ],
          if (!result.hasIssues) ...[
            _buildSuccessCard(),
            SizedBox(height: DesignTokens.spacing.lg),
          ],
          _buildRecommendationsCard(result),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ComparativeAnalysisResult result) {
    return NutryCard(
      title: 'Общая статистика',
      subtitle: 'Результаты анализа контрастности',
      child: Column(
        children: [
          _buildStatRow(
            'Светлая тема',
            '${result.lightTheme.failingPairs}/${result.lightTheme.totalPairs} проблем',
            result.lightTheme.hasIssues ? Colors.orange : Colors.green,
          ),
          SizedBox(height: DesignTokens.spacing.sm),
          _buildStatRow(
            'Темная тема',
            '${result.darkTheme.failingPairs}/${result.darkTheme.totalPairs} проблем',
            result.darkTheme.hasIssues ? Colors.red : Colors.green,
          ),
          SizedBox(height: DesignTokens.spacing.md),
          Container(
            padding: EdgeInsets.all(DesignTokens.spacing.sm),
            decoration: BoxDecoration(
              color: result.hasIssues
                  ? context.errorContainer
                  : context.successContainer,
              borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
            ),
            child: Row(
              children: [
                Icon(
                  result.hasIssues ? Icons.warning : Icons.check_circle,
                  color: result.hasIssues
                      ? context.onErrorContainer
                      : context.onSuccessContainer,
                ),
                SizedBox(width: DesignTokens.spacing.sm),
                Expanded(
                  child: Text(
                    result.hasIssues
                        ? 'Найдены проблемы с контрастностью'
                        : 'Все тесты контрастности пройдены',
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: result.hasIssues
                          ? context.onErrorContainer
                          : context.onSuccessContainer,
                      fontWeight: DesignTokens.typography.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: DesignTokens.typography.bodyMediumStyle.copyWith(
            color: context.onSurface,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing.sm,
            vertical: DesignTokens.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
          ),
          child: Text(
            value,
            style: DesignTokens.typography.bodySmallStyle.copyWith(
              color: color,
              fontWeight: DesignTokens.typography.medium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIssuesCard(
      String themeName, ThemeAnalysisResult themeResult, Color severityColor) {
    return NutryCard(
      title: 'Проблемы в $themeName',
      subtitle: 'Найдены проблемы с контрастностью',
      child: Column(
        children: themeResult.issues.map(_buildIssueItem).toList(),
      ),
    );
  }

  Widget _buildIssueItem(ContrastIssue issue) {
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.spacing.sm),
      padding: EdgeInsets.all(DesignTokens.spacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceVariant,
        borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
        border: Border.all(
          color: context.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: context.error,
                size: 20,
              ),
              SizedBox(width: DesignTokens.spacing.sm),
              Expanded(
                child: Text(
                  issue.colorName,
                  style: DesignTokens.typography.bodyMediumStyle.copyWith(
                    color: context.onSurface,
                    fontWeight: DesignTokens.typography.medium,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: issue.contrastRatio < 3.0 ? Colors.red : Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  issue.contrastRatio.toStringAsFixed(2),
                  style: DesignTokens.typography.bodySmallStyle.copyWith(
                    color: Colors.white,
                    fontWeight: DesignTokens.typography.medium,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacing.xs),
          Text(
            issue.recommendation,
            style: DesignTokens.typography.bodySmallStyle.copyWith(
              color: context.onSurfaceVariant,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.xs),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: issue.foreground,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: context.outline),
                ),
              ),
              SizedBox(width: DesignTokens.spacing.xs),
              Text(
                'Foreground: #${issue.foreground.value.toRadixString(16).toUpperCase()}',
                style: DesignTokens.typography.bodySmallStyle.copyWith(
                  color: context.onSurfaceVariant,
                ),
              ),
              SizedBox(width: DesignTokens.spacing.md),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: issue.background,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: context.outline),
                ),
              ),
              SizedBox(width: DesignTokens.spacing.xs),
              Text(
                'Background: #${issue.background.value.toRadixString(16).toUpperCase()}',
                style: DesignTokens.typography.bodySmallStyle.copyWith(
                  color: context.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return NutryCard(
      title: 'Отличные новости!',
      subtitle: 'Все тесты контрастности пройдены',
      child: Container(
        padding: EdgeInsets.all(DesignTokens.spacing.md),
        decoration: BoxDecoration(
          color: context.successContainer,
          borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: context.onSuccessContainer,
              size: 32,
            ),
            SizedBox(width: DesignTokens.spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Темы соответствуют стандартам WCAG 2.1 AA',
                    style: DesignTokens.typography.bodyLargeStyle.copyWith(
                      color: context.onSuccessContainer,
                      fontWeight: DesignTokens.typography.medium,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacing.xs),
                  Text(
                    'Все цветовые пары имеют достаточную контрастность (>= 4.5)',
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: context.onSuccessContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(ComparativeAnalysisResult result) {
    return NutryCard(
      title: 'Рекомендации',
      subtitle: 'Как улучшить контрастность',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.hasIssues) ...[
            _buildRecommendationItem(
              Icons.contrast,
              'Увеличить контрастность',
              'Используйте более контрастные цветовые пары для лучшей читаемости',
            ),
            SizedBox(height: DesignTokens.spacing.sm),
            _buildRecommendationItem(
              Icons.color_lens,
              'Проверить цветовую палитру',
              'Убедитесь, что цвета соответствуют стандартам WCAG 2.1',
            ),
            SizedBox(height: DesignTokens.spacing.sm),
            _buildRecommendationItem(
              Icons.accessibility,
              'Тестировать доступность',
              'Регулярно проверяйте контрастность с помощью автоматических тестов',
            ),
          ] else ...[
            _buildRecommendationItem(
              Icons.verified,
              'Поддерживать качество',
              'Продолжайте следить за контрастностью при добавлении новых цветов',
            ),
            SizedBox(height: DesignTokens.spacing.sm),
            _buildRecommendationItem(
              Icons.auto_awesome,
              'Рассмотреть AAA стандарт',
              'Для еще лучшей доступности стремитесь к контрастности >= 7.0',
            ),
          ],
          SizedBox(height: DesignTokens.spacing.md),
          NutryButton.outline(
            text: 'Сгенерировать отчет',
            onPressed: () => _generateReport(result),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
      IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: context.primary,
          size: 20,
        ),
        SizedBox(width: DesignTokens.spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: context.onSurface,
                  fontWeight: DesignTokens.typography.medium,
                ),
              ),
              SizedBox(height: DesignTokens.spacing.xs),
              Text(
                description,
                style: DesignTokens.typography.bodySmallStyle.copyWith(
                  color: context.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _generateReport(ComparativeAnalysisResult result) {
    final report = ThemeAnalyzer.generateMarkdownReport(result);

    // В реальном приложении здесь можно сохранить отчет в файл
    // или отправить по email
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Отчет сгенерирован (${report.length} символов)',
          style: TextStyle(color: context.onPrimary),
        ),
        backgroundColor: context.primary,
      ),
    );
  }
}
