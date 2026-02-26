import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Типы Toast уведомлений
enum NutryToastType {
  success,
  error,
  warning,
  info,
  neutral,
}

/// Компонент Toast/Snackbar для NutryFlow
class NutryToast {
  /// Показать успешное уведомление
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _show(
      context,
      message,
      type: NutryToastType.success,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Показать уведомление об ошибке
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _show(
      context,
      message,
      type: NutryToastType.error,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Показать предупреждение
  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _show(
      context,
      message,
      type: NutryToastType.warning,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Показать информационное уведомление
  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _show(
      context,
      message,
      type: NutryToastType.info,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Показать нейтральное уведомление
  static void show(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _show(
      context,
      message,
      type: NutryToastType.neutral,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required NutryToastType type,
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final borders = context.borders;

    final (bgColor, textColor, icon) = _getToastStyle(type, colors);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: spacing.iconMedium),
              SizedBox(width: spacing.sm),
            ],
            Expanded(
              child: Text(
                message,
                style: typography.bodyMediumStyle.copyWith(
                  color: textColor,
                  fontWeight: typography.medium,
                ),
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              SizedBox(width: spacing.sm),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onAction();
                },
                child: Text(
                  actionLabel,
                  style: typography.labelMediumStyle.copyWith(
                    color: textColor,
                    fontWeight: typography.semiBold,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: bgColor,
        duration: duration ?? const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(spacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borders.md),
        ),
        elevation: context.shadows.md.first.blurRadius,
      ),
    );
  }

  static (Color, Color, IconData?) _getToastStyle(
    NutryToastType type,
    dynamic colors,
  ) {
    switch (type) {
      case NutryToastType.success:
        return (colors.success, colors.onSuccess, Icons.check_circle);
      case NutryToastType.error:
        return (colors.error, colors.onError, Icons.error);
      case NutryToastType.warning:
        return (colors.warning, colors.onWarning, Icons.warning);
      case NutryToastType.info:
        return (colors.info, colors.onInfo, Icons.info);
      case NutryToastType.neutral:
        return (colors.surfaceVariant, colors.onSurface, null);
    }
  }
}
