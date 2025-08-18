import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';
import '../../tokens/theme_tokens.dart';

/// Типы чекбоксов
enum NutryCheckboxType {
  standard,
  switch_,
  radio,
  custom,
}

/// Размеры чекбоксов
enum NutryCheckboxSize {
  small,
  medium,
  large,
}

/// Состояния чекбокса
enum NutryCheckboxState {
  normal,
  checked,
  indeterminate,
  disabled,
  error,
}

/// Универсальный компонент чекбокса для NutryFlow
class NutryCheckbox extends StatefulWidget {
  /// Подпись чекбокса
  final String? label;

  /// Подсказка
  final String? subtitle;

  /// Подсказка для ошибки
  final String? errorText;

  /// Подсказка для помощи
  final String? helperText;

  /// Тип чекбокса
  final NutryCheckboxType type;

  /// Размер чекбокса
  final NutryCheckboxSize size;

  /// Значение чекбокса
  final bool? value;

  /// Обработчик изменения
  final ValueChanged<bool?>? onChanged;

  /// Отключено
  final bool enabled;

  /// Показывать ли иконку
  final bool showIcon;

  /// Иконка чекбокса
  final IconData? icon;

  /// Ширина чекбокса
  final double? width;

  /// Высота чекбокса
  final double? height;

  /// Отступы
  final EdgeInsetsGeometry? padding;

  /// Отступы снаружи
  final EdgeInsetsGeometry? margin;

  const NutryCheckbox({
    super.key,
    this.label,
    this.subtitle,
    this.errorText,
    this.helperText,
    this.type = NutryCheckboxType.standard,
    this.size = NutryCheckboxSize.medium,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.showIcon = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  /// Фабричный метод для стандартного чекбокса
  factory NutryCheckbox.standard({
    required String label,
    bool? value,
    ValueChanged<bool?>? onChanged,
    NutryCheckboxSize size = NutryCheckboxSize.medium,
    bool enabled = true,
    String? subtitle,
  }) {
    return NutryCheckbox(
      label: label,
      value: value,
      onChanged: onChanged,
      type: NutryCheckboxType.standard,
      size: size,
      enabled: enabled,
      subtitle: subtitle,
    );
  }

  /// Фабричный метод для switch
  factory NutryCheckbox.switch_({
    required String label,
    bool? value,
    ValueChanged<bool?>? onChanged,
    NutryCheckboxSize size = NutryCheckboxSize.medium,
    bool enabled = true,
    String? subtitle,
  }) {
    return NutryCheckbox(
      label: label,
      value: value,
      onChanged: onChanged,
      type: NutryCheckboxType.switch_,
      size: size,
      enabled: enabled,
      subtitle: subtitle,
    );
  }

  /// Фабричный метод для радио-кнопки
  factory NutryCheckbox.radio({
    required String label,
    bool? value,
    ValueChanged<bool?>? onChanged,
    NutryCheckboxSize size = NutryCheckboxSize.medium,
    bool enabled = true,
    String? subtitle,
  }) {
    return NutryCheckbox(
      label: label,
      value: value,
      onChanged: onChanged,
      type: NutryCheckboxType.radio,
      size: size,
      enabled: enabled,
      subtitle: subtitle,
    );
  }

  @override
  State<NutryCheckbox> createState() => _NutryCheckboxState();
}

class _NutryCheckboxState extends State<NutryCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin ?? EdgeInsets.only(bottom: DesignTokens.spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCheckboxField(),
          if (widget.errorText != null) _buildErrorText(),
          if (widget.helperText != null) _buildHelperText(),
        ],
      ),
    );
  }

  Widget _buildCheckboxField() {
    final state = _getCurrentState();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.enabled ? _toggleValue : null,
        borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.all(DesignTokens.spacing.sm),
          child: Row(
            children: [
              _buildCheckbox(state),
              SizedBox(width: DesignTokens.spacing.sm),
              Expanded(
                child: _buildLabel(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(NutryCheckboxState state) {
    switch (widget.type) {
      case NutryCheckboxType.standard:
        return _buildStandardCheckbox(state);
      case NutryCheckboxType.switch_:
        return _buildSwitch(state);
      case NutryCheckboxType.radio:
        return _buildRadio(state);
      case NutryCheckboxType.custom:
        return _buildCustomCheckbox(state);
    }
  }

  Widget _buildStandardCheckbox(NutryCheckboxState state) {
    final isChecked = widget.value == true;
    final isIndeterminate = widget.value == null;

    return Container(
      width: _getCheckboxSize(),
      height: _getCheckboxSize(),
      decoration: BoxDecoration(
        color: _getCheckboxFillColor(state),
        borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
        border: Border.all(
          color: _getCheckboxBorderColor(state),
          width: 2,
        ),
      ),
      child: isChecked || isIndeterminate
          ? Icon(
              isIndeterminate ? Icons.remove : Icons.check,
              color: _getCheckboxIconColor(state),
              size: _getCheckboxIconSize(),
            )
          : null,
    );
  }

  Widget _buildSwitch(NutryCheckboxState state) {
    final isChecked = widget.value == true;

    return AnimatedContainer(
      duration: DesignTokens.animations.fast,
      width: _getSwitchWidth(),
      height: _getSwitchHeight(),
      decoration: BoxDecoration(
        color: _getSwitchTrackColor(state, isChecked),
        borderRadius: BorderRadius.circular(_getSwitchHeight() / 2),
      ),
      child: AnimatedAlign(
        duration: DesignTokens.animations.fast,
        alignment: isChecked ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: _getSwitchThumbSize(),
          height: _getSwitchThumbSize(),
          margin: EdgeInsets.all(DesignTokens.spacing.xs),
          decoration: BoxDecoration(
            color: _getSwitchThumbColor(state),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.shadow.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(NutryCheckboxState state) {
    final isChecked = widget.value == true;

    return Container(
      width: _getCheckboxSize(),
      height: _getCheckboxSize(),
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: _getCheckboxBorderColor(state),
          width: 2,
        ),
      ),
      child: isChecked
          ? Container(
              margin: EdgeInsets.all(DesignTokens.spacing.xs),
              decoration: BoxDecoration(
                color: _getCheckboxIconColor(state),
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }

  Widget _buildCustomCheckbox(NutryCheckboxState state) {
    final isChecked = widget.value == true;

    return Container(
      width: _getCheckboxSize(),
      height: _getCheckboxSize(),
      decoration: BoxDecoration(
        color: _getCheckboxFillColor(state),
        borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
        border: Border.all(
          color: _getCheckboxBorderColor(state),
          width: 2,
        ),
      ),
      child: isChecked
          ? Icon(
              Icons.check,
              color: _getCheckboxIconColor(state),
              size: _getCheckboxIconSize(),
            )
          : null,
    );
  }

  Widget _buildLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: context.onSurface,
              fontWeight: DesignTokens.typography.medium,
            ),
          ),
        if (widget.subtitle != null) ...[
          SizedBox(height: DesignTokens.spacing.xs),
          Text(
            widget.subtitle!,
            style: DesignTokens.typography.bodySmallStyle.copyWith(
              color: context.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: EdgeInsets.only(top: DesignTokens.spacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: context.error,
            size: DesignTokens.spacing.iconSmall,
          ),
          SizedBox(width: DesignTokens.spacing.xs),
          Expanded(
            child: Text(
              widget.errorText!,
              style: DesignTokens.typography.bodySmallStyle.copyWith(
                color: context.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperText() {
    return Padding(
      padding: EdgeInsets.only(top: DesignTokens.spacing.xs),
      child: Text(
        widget.helperText!,
        style: DesignTokens.typography.bodySmallStyle.copyWith(
          color: context.onSurfaceVariant,
        ),
      ),
    );
  }

  NutryCheckboxState _getCurrentState() {
    if (!widget.enabled) return NutryCheckboxState.disabled;
    if (widget.errorText != null) return NutryCheckboxState.error;
    if (widget.value == true) return NutryCheckboxState.checked;
    if (widget.value == null) return NutryCheckboxState.indeterminate;
    return NutryCheckboxState.normal;
  }

  Color _getCheckboxFillColor(NutryCheckboxState state) {
    if (!widget.enabled) {
      return context.surfaceVariant;
    }

    switch (state) {
      case NutryCheckboxState.checked:
      case NutryCheckboxState.indeterminate:
        return context.primary;
      case NutryCheckboxState.error:
        return context.error;
      default:
        return context.surface;
    }
  }

  Color _getCheckboxBorderColor(NutryCheckboxState state) {
    if (!widget.enabled) {
      return context.outline;
    }

    switch (state) {
      case NutryCheckboxState.checked:
      case NutryCheckboxState.indeterminate:
        return context.primary;
      case NutryCheckboxState.error:
        return context.error;
      default:
        return context.outline;
    }
  }

  Color _getCheckboxIconColor(NutryCheckboxState state) {
    if (!widget.enabled) {
      return context.onSurfaceVariant;
    }

    switch (state) {
      case NutryCheckboxState.checked:
      case NutryCheckboxState.indeterminate:
        return context.onPrimary;
      case NutryCheckboxState.error:
        return context.onError;
      default:
        return context.onSurface;
    }
  }

  Color _getSwitchTrackColor(NutryCheckboxState state, bool isChecked) {
    if (!widget.enabled) {
      return context.surfaceVariant;
    }

    if (isChecked) {
      return context.primary.withValues(alpha: 0.5);
    }

    switch (state) {
      case NutryCheckboxState.error:
        return context.error.withValues(alpha: 0.5);
      default:
        return context.outline;
    }
  }

  Color _getSwitchThumbColor(NutryCheckboxState state) {
    if (!widget.enabled) {
      return context.onSurfaceVariant;
    }

    switch (state) {
      case NutryCheckboxState.checked:
        return context.primary;
      case NutryCheckboxState.error:
        return context.error;
      default:
        return context.surface;
    }
  }

  double _getCheckboxSize() {
    switch (widget.size) {
      case NutryCheckboxSize.small:
        return 16.0;
      case NutryCheckboxSize.large:
        return 24.0;
      default:
        return 20.0;
    }
  }

  double _getCheckboxIconSize() {
    switch (widget.size) {
      case NutryCheckboxSize.small:
        return 12.0;
      case NutryCheckboxSize.large:
        return 18.0;
      default:
        return 14.0;
    }
  }

  double _getSwitchWidth() {
    switch (widget.size) {
      case NutryCheckboxSize.small:
        return 32.0;
      case NutryCheckboxSize.large:
        return 48.0;
      default:
        return 40.0;
    }
  }

  double _getSwitchHeight() {
    switch (widget.size) {
      case NutryCheckboxSize.small:
        return 16.0;
      case NutryCheckboxSize.large:
        return 24.0;
      default:
        return 20.0;
    }
  }

  double _getSwitchThumbSize() {
    switch (widget.size) {
      case NutryCheckboxSize.small:
        return 12.0;
      case NutryCheckboxSize.large:
        return 18.0;
      default:
        return 14.0;
    }
  }

  void _toggleValue() {
    final newValue = widget.value == true ? false : true;
    widget.onChanged?.call(newValue);
  }
}
