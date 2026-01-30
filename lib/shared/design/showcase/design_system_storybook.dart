import 'package:flutter/material.dart';
import '../tokens/design_tokens.dart';
import '../../theme/theme_manager.dart';
import '../components/buttons/nutry_button.dart';
import '../components/cards/nutry_card.dart';
import '../components/forms/nutry_input.dart';
import '../components/forms/nutry_form.dart';
import '../components/loading/modern_loading_states.dart';
import '../components/animations/nutry_animations.dart';
import '../components/badges/nutry_badge.dart';
import '../components/tooltips/nutry_tooltip.dart';
import '../components/toast/nutry_toast.dart';
import '../components/dialogs/nutry_dialog.dart';
import '../components/tabs/nutry_tabs.dart';
import '../components/progress/nutry_progress.dart';

/// Визуальный Storybook для дизайн-системы NutryFlow
/// Показывает все компоненты, их варианты и состояния
class DesignSystemStorybook extends StatefulWidget {
  const DesignSystemStorybook({super.key});

  @override
  State<DesignSystemStorybook> createState() => _DesignSystemStorybookState();
}

class _DesignSystemStorybookState extends State<DesignSystemStorybook> {
  int _selectedTab = 0;
  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Design System Storybook'),
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_themeManager.themeIcon),
            onPressed: () {
              _themeManager.toggleTheme();
              setState(() {});
            },
            tooltip: _themeManager.themeDescription,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      'Цвета',
      'Типографика',
      'Кнопки',
      'Карточки',
      'Бейджи',
      'Формы',
      'Загрузка',
      'Анимации',
      'Tooltip',
      'Toast',
      'Dialog',
      'Tabs',
      'Progress',
      'Токены',
    ];

    return Container(
      color: context.colors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _selectedTab == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tabs[index],
                  style: context.typography.bodyMediumStyle.copyWith(
                    color: isSelected
                        ? context.colors.onPrimary
                        : context.colors.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildColorsSection();
      case 1:
        return _buildTypographySection();
      case 2:
        return _buildButtonsSection();
      case 3:
        return _buildCardsSection();
      case 4:
        return _buildBadgesSection();
      case 5:
        return _buildFormsSection();
      case 6:
        return _buildLoadingSection();
      case 7:
        return _buildAnimationsSection();
      case 8:
        return _buildTooltipSection();
      case 9:
        return _buildToastSection();
      case 10:
        return _buildDialogSection();
      case 11:
        return _buildTabsSection();
      case 12:
        return _buildProgressSection();
      case 13:
        return _buildTokensSection();
      default:
        return const SizedBox();
    }
  }

  Widget _buildColorsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Основные цвета'),
          SizedBox(height: context.spacing.md),
          _buildColorGrid([
            ('Primary', context.colors.primary),
            ('Secondary', context.colors.secondary),
            ('Accent', context.colors.accent),
            ('Error', context.colors.error),
            ('Success', context.colors.success),
            ('Warning', context.colors.warning),
            ('Info', context.colors.info),
          ]),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Системные цвета'),
          SizedBox(height: context.spacing.md),
          _buildColorGrid([
            ('Background', context.colors.background),
            ('Surface', context.colors.surface),
            ('Surface Variant', context.colors.surfaceVariant),
            ('Outline', context.colors.outline),
          ]),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Текстовые цвета'),
          SizedBox(height: context.spacing.md),
          _buildColorGrid([
            ('On Primary', context.colors.onPrimary),
            ('On Surface', context.colors.onSurface),
            ('On Surface Variant', context.colors.onSurfaceVariant),
            ('On Background', context.colors.onBackground),
          ]),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Цвета питания'),
          SizedBox(height: context.spacing.md),
          _buildColorGrid([
            ('Protein', context.colors.protein),
            ('Carbs', context.colors.carbs),
            ('Fats', context.colors.fats),
            ('Water', context.colors.water),
            ('Fiber', context.colors.fiber),
          ]),
        ],
      ),
    );
  }

  Widget _buildColorGrid(List<(String, Color)> colors) {
    return Wrap(
      spacing: context.spacing.md,
      runSpacing: context.spacing.md,
      children: colors.map((item) {
        final (name, color) = item;
        return _buildColorCard(name, color);
      }).toList(),
    );
  }

  Widget _buildColorCard(String name, Color color) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(context.spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.borders.md),
        border: Border.all(
          color: context.colors.outline,
          width: 1,
        ),
        boxShadow: context.shadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(context.borders.sm),
              border: Border.all(
                color: context.colors.outline,
                width: 1,
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          Text(
            name,
            style: context.typography.bodyMediumStyle.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.spacing.xs),
          Text(
            '#${color.value.toRadixString(16).toUpperCase().substring(2)}',
            style: context.typography.bodySmallStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Text(
            'RGB(${color.red}, ${color.green}, ${color.blue})',
            style: context.typography.bodySmallStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypographySection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Display'),
          _buildTypographyExample('Display Large', context.typography.displayLargeStyle),
          _buildTypographyExample('Display Medium', context.typography.displayMediumStyle),
          _buildTypographyExample('Display Small', context.typography.displaySmallStyle),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Headline'),
          _buildTypographyExample('Headline Large', context.typography.headlineLargeStyle),
          _buildTypographyExample('Headline Medium', context.typography.headlineMediumStyle),
          _buildTypographyExample('Headline Small', context.typography.headlineSmallStyle),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Title'),
          _buildTypographyExample('Title Large', context.typography.titleLargeStyle),
          _buildTypographyExample('Title Medium', context.typography.titleMediumStyle),
          _buildTypographyExample('Title Small', context.typography.titleSmallStyle),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Body'),
          _buildTypographyExample('Body Large', context.typography.bodyLargeStyle),
          _buildTypographyExample('Body Medium', context.typography.bodyMediumStyle),
          _buildTypographyExample('Body Small', context.typography.bodySmallStyle),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Label'),
          _buildTypographyExample('Label Large', context.typography.labelLargeStyle),
          _buildTypographyExample('Label Medium', context.typography.labelMediumStyle),
          _buildTypographyExample('Label Small', context.typography.labelSmallStyle),
        ],
      ),
    );
  }

  Widget _buildTypographyExample(String name, TextStyle style) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: context.typography.bodySmallStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.xs),
          Text(
            'Пример текста: The quick brown fox jumps over the lazy dog',
            style: style.copyWith(color: context.colors.onSurface),
          ),
          Text(
            '${style.fontSize}px / ${style.fontWeight} / ${style.height}',
            style: context.typography.bodySmallStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Primary Buttons'),
          SizedBox(height: context.spacing.md),
          NutryButton.primary(text: 'Primary Button'),
          SizedBox(height: context.spacing.sm),
          NutryButton.primary(text: 'With Icon', icon: Icons.add),
          SizedBox(height: context.spacing.sm),
          NutryButton.primary(text: 'Loading', isLoading: true),
          SizedBox(height: context.spacing.sm),
          NutryButton.primary(text: 'Disabled', onPressed: null),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Secondary Buttons'),
          SizedBox(height: context.spacing.md),
          NutryButton.secondary(text: 'Secondary Button'),
          SizedBox(height: context.spacing.sm),
          NutryButton.secondary(text: 'With Icon', icon: Icons.star),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Outline Buttons'),
          SizedBox(height: context.spacing.md),
          NutryButton.outline(text: 'Outline Button'),
          SizedBox(height: context.spacing.sm),
          NutryButton.outline(text: 'With Icon', icon: Icons.favorite),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Destructive Buttons'),
          SizedBox(height: context.spacing.md),
          NutryButton.destructive(text: 'Delete'),
          SizedBox(height: context.spacing.sm),
          NutryButton.destructive(text: 'Remove', icon: Icons.delete),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Sizes'),
          SizedBox(height: context.spacing.md),
          NutryButton.primary(text: 'Small', size: NutryButtonSize.small),
          SizedBox(height: context.spacing.sm),
          NutryButton.primary(text: 'Medium', size: NutryButtonSize.medium),
          SizedBox(height: context.spacing.sm),
          NutryButton.primary(text: 'Large', size: NutryButtonSize.large),
        ],
      ),
    );
  }

  Widget _buildCardsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Basic Card'),
          SizedBox(height: context.spacing.md),
          NutryCard(
            title: 'Заголовок карточки',
            subtitle: 'Подзаголовок карточки',
            icon: Icons.star,
            child: Text(
              'Содержимое карточки. Здесь может быть любой контент.',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Card Variants'),
          SizedBox(height: context.spacing.md),
          NutryCard.primary(
            title: 'Primary Card',
            child: Text(
              'Основная карточка',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          NutryCard.accent(
            title: 'Accent Card',
            child: Text(
              'Акцентная карточка',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          NutryCard.success(
            title: 'Success Card',
            child: Text(
              'Карточка успеха',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          NutryCard.warning(
            title: 'Warning Card',
            child: Text(
              'Предупреждающая карточка',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          NutryCard.error(
            title: 'Error Card',
            child: Text(
              'Карточка ошибки',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Gradient Cards'),
          SizedBox(height: context.spacing.md),
          NutryGradientCard.primary(
            title: 'Primary Gradient',
            child: Text(
              'Карточка с основным градиентом',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onPrimary,
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          NutryGradientCard.secondary(
            title: 'Secondary Gradient',
            child: Text(
              'Карточка с вторичным градиентом',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onPrimary,
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          NutryGradientCard.accent(
            title: 'Accent Gradient',
            child: Text(
              'Карточка с акцентным градиентом',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onPrimary,
              ),
            ),
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Card States'),
          SizedBox(height: context.spacing.md),
          NutryCard(
            title: 'Loading Card',
            isLoading: true,
            child: const SizedBox(),
          ),
          SizedBox(height: context.spacing.sm),
          NutryCard(
            title: 'Empty Card',
            isEmpty: true,
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Primary Badges'),
          SizedBox(height: context.spacing.md),
          Wrap(
            spacing: context.spacing.sm,
            runSpacing: context.spacing.sm,
            children: [
              NutryBadge.primary(label: 'Primary'),
              NutryBadge.primary(label: 'With Icon', leadingIcon: Icons.star),
              NutryBadge.primary(
                label: 'Dismissible',
                trailingIcon: Icons.close,
                onDismiss: () {},
              ),
              NutryBadge.primary(label: 'Outline', outline: true),
            ],
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Status Badges'),
          SizedBox(height: context.spacing.md),
          Wrap(
            spacing: context.spacing.sm,
            runSpacing: context.spacing.sm,
            children: [
              NutryBadge.success(label: 'Success'),
              NutryBadge.warning(label: 'Warning'),
              NutryBadge.error(label: 'Error'),
              NutryBadge.info(label: 'Info'),
            ],
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Sizes'),
          SizedBox(height: context.spacing.md),
          Wrap(
            spacing: context.spacing.sm,
            runSpacing: context.spacing.sm,
            children: [
              NutryBadge.primary(label: 'Small', size: NutryBadgeSize.small),
              NutryBadge.primary(label: 'Medium', size: NutryBadgeSize.medium),
              NutryBadge.primary(label: 'Large', size: NutryBadgeSize.large),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormsSection() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Input Fields'),
          SizedBox(height: context.spacing.md),
          NutryInput.text(
            label: 'Текстовое поле',
            controller: TextEditingController(),
            hint: 'Введите текст',
          ),
          SizedBox(height: context.spacing.md),
          NutryInput.email(
            label: 'Email',
            controller: emailController,
            hint: 'Введите email',
          ),
          SizedBox(height: context.spacing.md),
          NutryInput.password(
            label: 'Пароль',
            controller: passwordController,
            hint: 'Введите пароль',
          ),
          SizedBox(height: context.spacing.md),
          NutryInput.search(
            hint: 'Поиск...',
            controller: TextEditingController(),
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Form Example'),
          SizedBox(height: context.spacing.md),
          NutryForm.login(
            onSubmit: () {},
            children: [
              NutryInput.email(
                label: 'Email',
                controller: emailController,
              ),
              SizedBox(height: context.spacing.md),
              NutryInput.password(
                label: 'Пароль',
                controller: passwordController,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Loading Indicators'),
          SizedBox(height: context.spacing.xl),
          Center(
            child: ModernLoadingIndicator(
              size: 64,
              message: 'Загружаем данные...',
            ),
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Skeleton Loading'),
          SizedBox(height: context.spacing.md),
          const StatsCardSkeleton(),
          SizedBox(height: context.spacing.md),
          const RecipeCardSkeleton(),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Error State'),
          SizedBox(height: context.spacing.md),
          ErrorStateWidget(
            title: 'Ошибка загрузки',
            message: 'Не удалось загрузить данные. Проверьте подключение к интернету.',
            onRetry: () {},
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Empty State'),
          SizedBox(height: context.spacing.md),
          EmptyStateWidget(
            title: 'Нет данных',
            message: 'Здесь пока ничего нет. Добавьте первый элемент.',
            actionText: 'Добавить',
            onAction: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pulse Animation'),
          SizedBox(height: context.spacing.md),
          Center(
            child: NutryAnimations.pulse(
              isPulsing: true,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Shimmer Effect'),
          SizedBox(height: context.spacing.md),
          NutryAnimations.shimmer(
            isLoading: true,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(context.borders.md),
              ),
            ),
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Animated Icon'),
          SizedBox(height: context.spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NutryAnimations.animatedIcon(
                icon: Icons.favorite,
                isActive: true,
              ),
              SizedBox(width: context.spacing.md),
              NutryAnimations.animatedIcon(
                icon: Icons.favorite,
                isActive: false,
              ),
            ],
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Animated Progress'),
          SizedBox(height: context.spacing.md),
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(context.borders.xs),
            ),
            child: Stack(
              children: [
                NutryAnimations.animatedProgress(
                  progress: 65,
                  maxProgress: 100,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokensSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Spacing Tokens'),
          SizedBox(height: context.spacing.md),
          _buildTokenRow('xs', '${context.spacing.xs}px'),
          _buildTokenRow('sm', '${context.spacing.sm}px'),
          _buildTokenRow('md', '${context.spacing.md}px'),
          _buildTokenRow('lg', '${context.spacing.lg}px'),
          _buildTokenRow('xl', '${context.spacing.xl}px'),
          _buildTokenRow('xxl', '${context.spacing.xxl}px'),
          _buildTokenRow('xxxl', '${context.spacing.xxxl}px'),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Border Radius'),
          SizedBox(height: context.spacing.md),
          _buildTokenRow('xs', '${context.borders.xs}px'),
          _buildTokenRow('sm', '${context.borders.sm}px'),
          _buildTokenRow('md', '${context.borders.md}px'),
          _buildTokenRow('lg', '${context.borders.lg}px'),
          _buildTokenRow('xl', '${context.borders.xl}px'),
          _buildTokenRow('full', '${context.borders.full}px'),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Shadows'),
          SizedBox(height: context.spacing.md),
          _buildShadowExample('xs', context.shadows.xs),
          _buildShadowExample('sm', context.shadows.sm),
          _buildShadowExample('md', context.shadows.md),
          _buildShadowExample('lg', context.shadows.lg),
          _buildShadowExample('xl', context.shadows.xl),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Animations'),
          SizedBox(height: context.spacing.md),
          _buildTokenRow('fast', '${context.animations.fast.inMilliseconds}ms'),
          _buildTokenRow('normal', '${context.animations.normal.inMilliseconds}ms'),
          _buildTokenRow('slow', '${context.animations.slow.inMilliseconds}ms'),
          _buildTokenRow('slower', '${context.animations.slower.inMilliseconds}ms'),
        ],
      ),
    );
  }

  Widget _buildTokenRow(String name, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: context.typography.bodyMediumStyle.copyWith(
              color: context.colors.onSurface,
            ),
          ),
          Text(
            value,
            style: context.typography.bodyMediumStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowExample(String name, List<BoxShadow> shadows) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: context.typography.bodySmallStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.xs),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(context.borders.md),
              boxShadow: shadows,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: context.typography.headlineSmallStyle.copyWith(
        color: context.colors.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTooltipSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Tooltips'),
          SizedBox(height: context.spacing.xl),
          Wrap(
            spacing: context.spacing.md,
            runSpacing: context.spacing.md,
            children: [
              NutryTooltip(
                message: 'Это подсказка для кнопки',
                child: NutryButton.primary(text: 'Наведите курсор'),
              ),
              NutryTooltip(
                message: 'Информационная подсказка',
                position: TooltipPosition.below,
                child: Icon(Icons.info, size: 32),
              ),
              Icon(Icons.help)
                  .withTooltip('Подсказка через extension метод'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToastSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Toast Notifications'),
          SizedBox(height: context.spacing.xl),
          NutryButton.primary(
            text: 'Success Toast',
            onPressed: () {
              NutryToast.showSuccess(context, 'Операция выполнена успешно!');
            },
          ),
          SizedBox(height: context.spacing.md),
          NutryButton.destructive(
            text: 'Error Toast',
            onPressed: () {
              NutryToast.showError(context, 'Произошла ошибка');
            },
          ),
          SizedBox(height: context.spacing.md),
          NutryButton.outline(
            text: 'Warning Toast',
            onPressed: () {
              NutryToast.showWarning(context, 'Внимание! Проверьте данные');
            },
          ),
          SizedBox(height: context.spacing.md),
          NutryButton.secondary(
            text: 'Info Toast',
            onPressed: () {
              NutryToast.showInfo(context, 'Полезная информация');
            },
          ),
          SizedBox(height: context.spacing.md),
          NutryButton.secondary(
            text: 'Toast with Action',
            onPressed: () {
              NutryToast.showSuccess(
                context,
                'Данные сохранены',
                actionLabel: 'Отменить',
                onAction: () {
                  NutryToast.show(context, 'Действие отменено');
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDialogSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Dialogs'),
          SizedBox(height: context.spacing.xl),
          NutryButton.primary(
            text: 'Info Dialog',
            onPressed: () {
              NutryDialog.showInfo(
                context,
                title: 'Информация',
                message: 'Это информационное сообщение',
              );
            },
          ),
          SizedBox(height: context.spacing.md),
          NutryButton.primary(
            text: 'Success Dialog',
            onPressed: () {
              NutryDialog.showSuccess(
                context,
                title: 'Успех',
                message: 'Операция выполнена успешно!',
              );
            },
          ),
          SizedBox(height: context.spacing.md),
          NutryButton.outline(
            text: 'Warning Dialog',
            onPressed: () {
              NutryDialog.showWarning(
                context,
                title: 'Внимание',
                message: 'Пожалуйста, проверьте введенные данные',
              );
            },
          ),
          SizedBox(height: context.spacing.md),
          NutryButton.destructive(
            text: 'Error Dialog',
            onPressed: () {
              NutryDialog.showError(
                context,
                title: 'Ошибка',
                message: 'Что-то пошло не так',
              );
            },
          ),
          SizedBox(height: context.spacing.md),
          NutryButton.secondary(
            text: 'Confirmation Dialog',
            onPressed: () async {
              final result = await NutryDialog.showConfirmation(
                context,
                title: 'Подтверждение',
                message: 'Вы уверены, что хотите выполнить это действие?',
              );
              if (result == true) {
                NutryToast.showSuccess(context, 'Действие подтверждено');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabsSection() {
    return SizedBox(
      height: 600,
      child: NutryTabs(
        tabs: [
          NutryTab(
            label: 'Вкладка 1',
            icon: Icons.home,
            content: Center(
              child: Text(
                'Содержимое первой вкладки',
                style: context.typography.bodyLargeStyle.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ),
          ),
          NutryTab(
            label: 'Вкладка 2',
            icon: Icons.favorite,
            badge: '3',
            content: Center(
              child: Text(
                'Содержимое второй вкладки',
                style: context.typography.bodyLargeStyle.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ),
          ),
          NutryTab(
            label: 'Вкладка 3',
            icon: Icons.settings,
            content: Center(
              child: Text(
                'Содержимое третьей вкладки',
                style: context.typography.bodyLargeStyle.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Linear Progress'),
          SizedBox(height: context.spacing.md),
          NutryProgress.linear(
            value: 0.3,
            showPercentage: true,
            label: 'Загрузка',
          ),
          SizedBox(height: context.spacing.md),
          NutryProgress.linear(
            value: 0.65,
            showPercentage: true,
            label: 'Синхронизация',
          ),
          SizedBox(height: context.spacing.md),
          NutryProgress.linear(
            value: 0.9,
            showPercentage: true,
            color: context.colors.success,
          ),
          SizedBox(height: context.spacing.xl),
          _buildSectionTitle('Circular Progress'),
          SizedBox(height: context.spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NutryProgress.circular(
                value: 0.3,
                showPercentage: true,
              ),
              NutryProgress.circular(
                value: 0.65,
                showPercentage: true,
                label: 'Загрузка',
              ),
              NutryProgress.circular(
                value: 0.9,
                showPercentage: true,
                color: context.colors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

