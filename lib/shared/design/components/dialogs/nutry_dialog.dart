import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';
import '../buttons/nutry_button.dart';

/// Типы диалогов
enum NutryDialogType {
  info,
  warning,
  error,
  success,
  confirmation,
}

/// Компонент Modal/Dialog для NutryFlow
class NutryDialog {
  /// Показать информационный диалог
  static Future<bool?> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    IconData? icon,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      type: NutryDialogType.info,
      buttonText: buttonText ?? 'OK',
      icon: icon ?? Icons.info_outline,
    );
  }

  /// Показать диалог подтверждения
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      type: NutryDialogType.confirmation,
      confirmText: confirmText ?? 'Подтвердить',
      cancelText: cancelText ?? 'Отмена',
      icon: icon ?? Icons.help_outline,
    );
  }

  /// Показать диалог предупреждения
  static Future<bool?> showWarning(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    IconData? icon,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      type: NutryDialogType.warning,
      buttonText: buttonText ?? 'OK',
      icon: icon ?? Icons.warning_amber_rounded,
    );
  }

  /// Показать диалог ошибки
  static Future<bool?> showError(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    IconData? icon,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      type: NutryDialogType.error,
      buttonText: buttonText ?? 'OK',
      icon: icon ?? Icons.error_outline,
    );
  }

  /// Показать диалог успеха
  static Future<bool?> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    IconData? icon,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      type: NutryDialogType.success,
      buttonText: buttonText ?? 'OK',
      icon: icon ?? Icons.check_circle_outline,
    );
  }

  static Future<bool?> _show(
    BuildContext context, {
    required String title,
    required String message,
    required NutryDialogType type,
    String? buttonText,
    String? confirmText,
    String? cancelText,
    IconData? icon,
  }) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final borders = context.borders;

    final (iconColor, backgroundColor) = _getDialogStyle(type, colors);

    return showDialog<bool>(
      context: context,
      barrierDismissible: type != NutryDialogType.confirmation,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borders.lg),
        ),
        child: Container(
          padding: EdgeInsets.all(spacing.lg),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(borders.lg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с иконкой
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: iconColor,
                      size: spacing.iconLarge,
                    ),
                    SizedBox(width: spacing.md),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: typography.titleLargeStyle.copyWith(
                        color: colors.onSurface,
                        fontWeight: typography.semiBold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.md),
              // Сообщение
              Text(
                message,
                style: typography.bodyMediumStyle.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: spacing.xl),
              // Кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (type == NutryDialogType.confirmation) ...[
                    NutryButton.outline(
                      text: cancelText ?? 'Отмена',
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    SizedBox(width: spacing.md),
                    NutryButton.primary(
                      text: confirmText ?? 'Подтвердить',
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ] else ...[
                    NutryButton.primary(
                      text: buttonText ?? 'OK',
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static (Color, Color) _getDialogStyle(
    NutryDialogType type,
    dynamic colors,
  ) {
    switch (type) {
      case NutryDialogType.info:
        return (colors.info, colors.info.withValues(alpha: 0.1));
      case NutryDialogType.warning:
        return (colors.warning, colors.warning.withValues(alpha: 0.1));
      case NutryDialogType.error:
        return (colors.error, colors.error.withValues(alpha: 0.1));
      case NutryDialogType.success:
        return (colors.success, colors.success.withValues(alpha: 0.1));
      case NutryDialogType.confirmation:
        return (colors.primary, colors.primary.withValues(alpha: 0.1));
    }
  }
}
