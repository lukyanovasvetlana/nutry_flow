import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Типы бейджей
enum NutryBadgeType {
  primary,
  secondary,
  success,
  warning,
  error,
  info,
  neutral,
}

/// Размеры бейджей
enum NutryBadgeSize {
  small,
  medium,
  large,
}

/// Компонент Badge/Chip для NutryFlow
/// Используется для отображения меток, статусов, категорий
class NutryBadge extends StatelessWidget {
  /// Текст бейджа
  final String label;

  /// Тип бейджа
  final NutryBadgeType type;

  /// Размер бейджа
  final NutryBadgeSize size;

  /// Иконка слева от текста
  final IconData? leadingIcon;

  /// Иконка справа от текста (обычно для удаления)
  final IconData? trailingIcon;

  /// Обработчик нажатия на trailing иконку
  final VoidCallback? onDismiss;

  /// Обработчик нажатия на весь бейдж
  final VoidCallback? onTap;

  /// Кастомный цвет фона
  final Color? backgroundColor;

  /// Кастомный цвет текста
  final Color? textColor;

  /// Показывать ли как outline (только граница)
  final bool outline;

  const NutryBadge({
    super.key,
    required this.label,
    this.type = NutryBadgeType.primary,
    this.size = NutryBadgeSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.onDismiss,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.outline = false,
  });

  /// Бейдж с основным стилем
  factory NutryBadge.primary({
    required String label,
    NutryBadgeSize size = NutryBadgeSize.medium,
    IconData? leadingIcon,
    IconData? trailingIcon,
    VoidCallback? onDismiss,
    VoidCallback? onTap,
    bool outline = false,
  }) {
    return NutryBadge(
      label: label,
      type: NutryBadgeType.primary,
      size: size,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      onDismiss: onDismiss,
      onTap: onTap,
      outline: outline,
    );
  }

  /// Бейдж успеха
  factory NutryBadge.success({
    required String label,
    NutryBadgeSize size = NutryBadgeSize.medium,
    IconData? leadingIcon,
    VoidCallback? onTap,
    bool outline = false,
  }) {
    return NutryBadge(
      label: label,
      type: NutryBadgeType.success,
      size: size,
      leadingIcon: leadingIcon,
      onTap: onTap,
      outline: outline,
    );
  }

  /// Бейдж предупреждения
  factory NutryBadge.warning({
    required String label,
    NutryBadgeSize size = NutryBadgeSize.medium,
    IconData? leadingIcon,
    VoidCallback? onTap,
    bool outline = false,
  }) {
    return NutryBadge(
      label: label,
      type: NutryBadgeType.warning,
      size: size,
      leadingIcon: leadingIcon,
      onTap: onTap,
      outline: outline,
    );
  }

  /// Бейдж ошибки
  factory NutryBadge.error({
    required String label,
    NutryBadgeSize size = NutryBadgeSize.medium,
    IconData? leadingIcon,
    VoidCallback? onTap,
    bool outline = false,
  }) {
    return NutryBadge(
      label: label,
      type: NutryBadgeType.error,
      size: size,
      leadingIcon: leadingIcon,
      onTap: onTap,
      outline: outline,
    );
  }

  /// Бейдж информации
  factory NutryBadge.info({
    required String label,
    NutryBadgeSize size = NutryBadgeSize.medium,
    IconData? leadingIcon,
    VoidCallback? onTap,
    bool outline = false,
  }) {
    return NutryBadge(
      label: label,
      type: NutryBadgeType.info,
      size: size,
      leadingIcon: leadingIcon,
      onTap: onTap,
      outline: outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = _SpacingHelper();
    final borders = context.borders;
    final typography = _TypographyHelper();

    final (bgColor, textColor, borderColor) = _getColors(context);

    return Semantics(
      label: label,
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borders.full),
        child: Container(
          padding: _getPadding(spacing),
          decoration: BoxDecoration(
            color: outline ? Colors.transparent : bgColor,
            borderRadius: BorderRadius.circular(borders.full),
            border: Border.all(
              color: borderColor,
              width: outline ? borders.thin : 0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: _getIconSize(spacing),
                  color: textColor,
                ),
                SizedBox(width: spacing.xs),
              ],
              Text(
                label,
                style: _getTextStyle(typography, textColor),
              ),
              if (trailingIcon != null || onDismiss != null) ...[
                SizedBox(width: spacing.xs),
                GestureDetector(
                  onTap: onDismiss,
                  child: Icon(
                    trailingIcon ?? Icons.close,
                    size: _getIconSize(spacing),
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  (Color, Color, Color) _getColors(BuildContext context) {
    final colors = context.colors;

    if (backgroundColor != null && textColor != null) {
      return (backgroundColor!, textColor!, textColor!);
    }

    Color bgColor;
    Color textColor;
    Color borderColor;

    switch (type) {
      case NutryBadgeType.primary:
        bgColor = outline ? Colors.transparent : colors.primary;
        textColor = outline ? colors.primary : colors.onPrimary;
        borderColor = colors.primary;
        break;
      case NutryBadgeType.secondary:
        bgColor = outline ? Colors.transparent : colors.secondary;
        textColor = outline ? colors.secondary : colors.onSecondary;
        borderColor = colors.secondary;
        break;
      case NutryBadgeType.success:
        bgColor = outline ? Colors.transparent : colors.success;
        textColor = outline ? colors.success : colors.onSuccess;
        borderColor = colors.success;
        break;
      case NutryBadgeType.warning:
        bgColor = outline ? Colors.transparent : colors.warning;
        textColor = outline ? colors.warning : colors.onWarning;
        borderColor = colors.warning;
        break;
      case NutryBadgeType.error:
        bgColor = outline ? Colors.transparent : colors.error;
        textColor = outline ? colors.error : colors.onError;
        borderColor = colors.error;
        break;
      case NutryBadgeType.info:
        bgColor = outline ? Colors.transparent : colors.info;
        textColor = outline ? colors.info : colors.onInfo;
        borderColor = colors.info;
        break;
      case NutryBadgeType.neutral:
        bgColor = outline ? Colors.transparent : colors.surfaceVariant;
        textColor = outline ? colors.onSurfaceVariant : colors.onSurface;
        borderColor = colors.outline;
        break;
    }

    return (bgColor, textColor, borderColor);
  }

  EdgeInsetsGeometry _getPadding(_SpacingHelper spacing) {
    switch (size) {
      case NutryBadgeSize.small:
        return EdgeInsets.symmetric(
          horizontal: spacing.sm,
          vertical: spacing.xs,
        );
      case NutryBadgeSize.medium:
        return EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        );
      case NutryBadgeSize.large:
        return EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        );
    }
  }

  double _getIconSize(_SpacingHelper spacing) {
    switch (size) {
      case NutryBadgeSize.small:
        return spacing.iconSmall;
      case NutryBadgeSize.medium:
        return spacing.iconMedium;
      case NutryBadgeSize.large:
        return spacing.iconLarge;
    }
  }

  TextStyle _getTextStyle(_TypographyHelper typography, Color textColor) {
    double fontSize;
    FontWeight fontWeight;

    switch (size) {
      case NutryBadgeSize.small:
        fontSize = typography.labelSmall;
        fontWeight = typography.medium;
        break;
      case NutryBadgeSize.medium:
        fontSize = typography.labelMedium;
        fontWeight = typography.medium;
        break;
      case NutryBadgeSize.large:
        fontSize = typography.labelLarge;
        fontWeight = typography.semiBold;
        break;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
    );
  }
}

class _SpacingHelper {
  final double xs = DesignTokens.spacing.xs;
  final double sm = DesignTokens.spacing.sm;
  final double md = DesignTokens.spacing.md;
  final double lg = DesignTokens.spacing.lg;
  final double iconSmall = DesignTokens.spacing.iconSmall;
  final double iconMedium = DesignTokens.spacing.iconMedium;
  final double iconLarge = DesignTokens.spacing.iconLarge;
}

class _TypographyHelper {
  final double labelSmall = DesignTokens.typography.labelSmall;
  final double labelMedium = DesignTokens.typography.labelMedium;
  final double labelLarge = DesignTokens.typography.labelLarge;
  final FontWeight medium = DesignTokens.typography.medium;
  final FontWeight semiBold = DesignTokens.typography.semiBold;
}
}


