import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Карточка NutryFlow - основной контейнер для контента
class NutryCard extends StatelessWidget {
  /// Содержимое карточки
  final Widget child;

  /// Заголовок карточки (опционально)
  final String? title;

  /// Подзаголовок карточки (опционально)
  final String? subtitle;

  /// Иконка карточки (опционально)
  final IconData? icon;

  /// Цвет карточки
  final Color? backgroundColor;

  /// Цвет границы
  final Color? borderColor;

  /// Ширина границы
  final double? borderWidth;

  /// Радиус скругления
  final double? borderRadius;

  /// Отступы внутри карточки
  final EdgeInsetsGeometry? padding;

  /// Отступы снаружи карточки
  final EdgeInsetsGeometry? margin;

  /// Тень карточки
  final List<BoxShadow>? shadow;

  /// Высота карточки
  final double? height;

  /// Ширина карточки
  final double? width;

  /// Обработчик нажатия
  final VoidCallback? onTap;

  /// Состояние загрузки
  final bool isLoading;

  /// Виджет для состояния загрузки
  final Widget? loadingWidget;

  /// Виджет для пустого состояния
  final Widget? emptyWidget;

  /// Показывать ли пустое состояние
  final bool isEmpty;

  const NutryCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.margin,
    this.shadow,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  });

  /// Карточка с основным стилем
  const NutryCard.primary({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  })  : backgroundColor = null,
        borderColor = null,
        borderWidth = null,
        borderRadius = null,
        shadow = null;

  /// Карточка с акцентным стилем
  const NutryCard.accent({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  })  : backgroundColor = const Color(0xFFFFF3C4),
        borderColor = const Color(0xFFFFCB65),
        borderWidth = 1.0,
        borderRadius = 16.0,
        shadow = null;

  /// Карточка с успешным стилем
  const NutryCard.success({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  })  : backgroundColor = const Color(0x1A4CAF50),
        borderColor = const Color(0xFF4CAF50),
        borderWidth = 1.0,
        borderRadius = 16.0,
        shadow = null;

  /// Карточка с предупреждающим стилем
  const NutryCard.warning({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  })  : backgroundColor = const Color(0x1AFFA000),
        borderColor = const Color(0xFFFFA000),
        borderWidth = 1.0,
        borderRadius = 16.0,
        shadow = null;

  /// Карточка с ошибочным стилем
  const NutryCard.error({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  })  : backgroundColor = const Color(0x1AE53935),
        borderColor = const Color(0xFFE53935),
        borderWidth = 1.0,
        borderRadius = 16.0,
        shadow = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.all(DesignTokens.spacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? DesignTokens.colors.surface,
        borderRadius: BorderRadius.circular(
          borderRadius ?? 16.0,
        ),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? DesignTokens.borders.thin,
              )
            : null,
        boxShadow: shadow ?? DesignTokens.shadows.md,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? 16.0,
          ),
          child: Padding(
            padding:
                padding ?? EdgeInsets.all(DesignTokens.spacing.cardPadding),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? _buildLoadingState();
    }

    if (isEmpty) {
      return emptyWidget ?? _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || icon != null) _buildHeader(context),
        child,
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacing.sm),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: DesignTokens.colors.primary,
              size: DesignTokens.spacing.iconMedium,
            ),
            SizedBox(width: DesignTokens.spacing.sm),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: DesignTokens.typography.titleMediumStyle.copyWith(
                      color: DesignTokens.colors.onSurface,
                      fontWeight: DesignTokens.typography.semiBold,
                    ),
                  ),
                if (subtitle != null) ...[
                  SizedBox(height: DesignTokens.spacing.xs),
                  Text(
                    subtitle!,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: DesignTokens.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: DesignTokens.colors.outline,
            borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
          ),
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        Container(
          height: 16,
          decoration: BoxDecoration(
            color: DesignTokens.colors.outline,
            borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
          ),
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        Container(
          height: 16,
          width: 100,
          decoration: BoxDecoration(
            color: DesignTokens.colors.outline,
            borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_outlined,
          size: DesignTokens.spacing.iconXLarge,
          color: DesignTokens.colors.onSurfaceVariant,
        ),
        SizedBox(height: DesignTokens.spacing.md),
        Text(
          'Нет данных',
          style: DesignTokens.typography.titleMediumStyle.copyWith(
            color: DesignTokens.colors.onSurfaceVariant,
          ),
        ),
        SizedBox(height: DesignTokens.spacing.xs),
        Text(
          'Здесь пока ничего нет',
          style: DesignTokens.typography.bodyMediumStyle.copyWith(
            color: DesignTokens.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Карточка с градиентом
class NutryGradientCard extends StatelessWidget {
  /// Содержимое карточки
  final Widget child;

  /// Градиент карточки
  final LinearGradient? gradient;

  /// Остальные параметры как у NutryCard
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final bool isEmpty;

  const NutryGradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  });

  /// Карточка с основным градиентом
  const NutryGradientCard.primary({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  }) : gradient = const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  /// Карточка с вторичным градиентом
  const NutryGradientCard.secondary({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  }) : gradient = const LinearGradient(
          colors: [Color(0xFFC2E66E), Color(0xFFE8F5E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  /// Карточка с акцентным градиентом
  const NutryGradientCard.accent({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  }) : gradient = const LinearGradient(
          colors: [Color(0xFFFFCB65), Color(0xFFFFF3C4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.all(DesignTokens.spacing.md),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding:
                padding ?? EdgeInsets.all(DesignTokens.spacing.cardPadding),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? _buildLoadingState();
    }

    if (isEmpty) {
      return emptyWidget ?? _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || icon != null) _buildHeader(context),
        child,
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacing.sm),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: DesignTokens.colors.onPrimary,
              size: DesignTokens.spacing.iconMedium,
            ),
            SizedBox(width: DesignTokens.spacing.sm),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: DesignTokens.typography.titleMediumStyle.copyWith(
                      color: DesignTokens.colors.onPrimary,
                      fontWeight: DesignTokens.typography.semiBold,
                    ),
                  ),
                if (subtitle != null) ...[
                  SizedBox(height: DesignTokens.spacing.xs),
                  Text(
                    subtitle!,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color:
                          DesignTokens.colors.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: DesignTokens.colors.onPrimary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
          ),
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        Container(
          height: 16,
          decoration: BoxDecoration(
            color: DesignTokens.colors.onPrimary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
          ),
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        Container(
          height: 16,
          width: 100,
          decoration: BoxDecoration(
            color: DesignTokens.colors.onPrimary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_outlined,
          size: DesignTokens.spacing.iconXLarge,
          color: DesignTokens.colors.onPrimary.withValues(alpha: 0.8),
        ),
        SizedBox(height: DesignTokens.spacing.md),
        Text(
          'Нет данных',
          style: DesignTokens.typography.titleMediumStyle.copyWith(
            color: DesignTokens.colors.onPrimary,
          ),
        ),
        SizedBox(height: DesignTokens.spacing.xs),
        Text(
          'Здесь пока ничего нет',
          style: DesignTokens.typography.bodyMediumStyle.copyWith(
            color: DesignTokens.colors.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
