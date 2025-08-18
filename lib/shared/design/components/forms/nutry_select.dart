import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';
import '../../tokens/theme_tokens.dart';

/// Типы селектов
enum NutrySelectType {
  dropdown,
  searchable,
  multiSelect,
  chips,
}

/// Размеры селектов
enum NutrySelectSize {
  small,
  medium,
  large,
}

/// Состояния селекта
enum NutrySelectState {
  normal,
  focused,
  error,
  success,
  disabled,
  loading,
}

/// Опция для селекта
class NutrySelectOption<T> {
  final T value;
  final String label;
  final String? description;
  final IconData? icon;
  final bool isEnabled;

  const NutrySelectOption({
    required this.value,
    required this.label,
    this.description,
    this.icon,
    this.isEnabled = true,
  });

  @override
  String toString() => label;
}

/// Универсальный компонент селекта для NutryFlow
class NutrySelect<T> extends StatefulWidget {
  /// Подпись селекта
  final String? label;

  /// Подсказка
  final String? hint;

  /// Подсказка для ошибки
  final String? errorText;

  /// Подсказка для помощи
  final String? helperText;

  /// Тип селекта
  final NutrySelectType type;

  /// Размер селекта
  final NutrySelectSize size;

  /// Опции для выбора
  final List<NutrySelectOption<T>> options;

  /// Выбранное значение
  final T? value;

  /// Обработчик изменения
  final ValueChanged<T?>? onChanged;

  /// Обработчик поиска (для searchable типа)
  final ValueChanged<String>? onSearch;

  /// Отключено
  final bool enabled;

  /// Показывать ли иконку
  final bool showIcon;

  /// Иконка селекта
  final IconData? icon;

  /// Ширина селекта
  final double? width;

  /// Высота селекта
  final double? height;

  /// Отступы
  final EdgeInsetsGeometry? padding;

  /// Отступы снаружи
  final EdgeInsetsGeometry? margin;

  const NutrySelect({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.type = NutrySelectType.dropdown,
    this.size = NutrySelectSize.medium,
    required this.options,
    this.value,
    this.onChanged,
    this.onSearch,
    this.enabled = true,
    this.showIcon = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  /// Фабричный метод для простого dropdown
  factory NutrySelect.dropdown({
    required String label,
    required List<NutrySelectOption<T>> options,
    T? value,
    ValueChanged<T?>? onChanged,
    NutrySelectSize size = NutrySelectSize.medium,
    bool enabled = true,
  }) {
    return NutrySelect<T>(
      label: label,
      options: options,
      value: value,
      onChanged: onChanged,
      type: NutrySelectType.dropdown,
      size: size,
      enabled: enabled,
    );
  }

  /// Фабричный метод для поискового селекта
  factory NutrySelect.searchable({
    required String label,
    required List<NutrySelectOption<T>> options,
    T? value,
    ValueChanged<T?>? onChanged,
    ValueChanged<String>? onSearch,
    NutrySelectSize size = NutrySelectSize.medium,
    bool enabled = true,
  }) {
    return NutrySelect<T>(
      label: label,
      options: options,
      value: value,
      onChanged: onChanged,
      onSearch: onSearch,
      type: NutrySelectType.searchable,
      size: size,
      enabled: enabled,
    );
  }

  /// Фабричный метод для мульти-селекта
  factory NutrySelect.multiSelect({
    required String label,
    required List<NutrySelectOption<T>> options,
    List<T>? values,
    ValueChanged<List<T>?>? onChanged,
    NutrySelectSize size = NutrySelectSize.medium,
    bool enabled = true,
  }) {
    return NutrySelect<T>(
      label: label,
      options: options,
      value: values?.isNotEmpty == true ? values!.first : null,
      onChanged: (value) => onChanged?.call(value != null ? [value] : []),
      type: NutrySelectType.multiSelect,
      size: size,
      enabled: enabled,
    );
  }

  @override
  State<NutrySelect<T>> createState() => _NutrySelectState<T>();
}

class _NutrySelectState<T> extends State<NutrySelect<T>> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin ?? EdgeInsets.only(bottom: DesignTokens.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) _buildLabel(),
          _buildSelectField(),
          if (widget.errorText != null) _buildErrorText(),
          if (widget.helperText != null) _buildHelperText(),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacing.xs),
      child: Text(
        widget.label!,
        style: DesignTokens.typography.labelLargeStyle.copyWith(
          color: context.onSurface,
          fontWeight: DesignTokens.typography.medium,
        ),
      ),
    );
  }

  Widget _buildSelectField() {
    final state = _getCurrentState();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _getFillColor(state),
        borderRadius: BorderRadius.circular(DesignTokens.borders.inputRadius),
        border: Border.all(
          color: _getBorderColor(state),
          width: state == NutrySelectState.focused ? 2.0 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.enabled ? _toggleExpanded : null,
          borderRadius: BorderRadius.circular(DesignTokens.borders.inputRadius),
          child: Padding(
            padding: _getContentPadding(),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: _getIconColor(state),
                    size: _getIconSize(),
                  ),
                  SizedBox(width: DesignTokens.spacing.sm),
                ],
                Expanded(
                  child: _buildSelectContent(),
                ),
                if (widget.showIcon) ...[
                  SizedBox(width: DesignTokens.spacing.sm),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _getIconColor(state),
                    size: _getIconSize(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectContent() {
    final selectedOption = _getSelectedOption();

    if (selectedOption != null) {
      return Row(
        children: [
          if (selectedOption.icon != null) ...[
            Icon(
              selectedOption.icon,
              color: context.onSurface,
              size: _getIconSize(),
            ),
            SizedBox(width: DesignTokens.spacing.xs),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedOption.label,
                  style: DesignTokens.typography.bodyMediumStyle.copyWith(
                    color: context.onSurface,
                  ),
                ),
                if (selectedOption.description != null) ...[
                  SizedBox(height: DesignTokens.spacing.xs),
                  Text(
                    selectedOption.description!,
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: context.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    } else {
      return Text(
        widget.hint ?? 'Выберите опцию',
        style: DesignTokens.typography.bodyMediumStyle.copyWith(
          color: context.onSurfaceVariant,
        ),
      );
    }
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

  NutrySelectState _getCurrentState() {
    if (!widget.enabled) return NutrySelectState.disabled;
    if (widget.errorText != null) return NutrySelectState.error;
    if (_isExpanded) return NutrySelectState.focused;
    return NutrySelectState.normal;
  }

  Color _getFillColor(NutrySelectState state) {
    if (!widget.enabled) {
      return context.surfaceVariant;
    }

    switch (state) {
      case NutrySelectState.error:
        return context.errorContainer;
      case NutrySelectState.focused:
        return context.primaryContainer.withValues(alpha: 0.05);
      default:
        return context.surface;
    }
  }

  Color _getBorderColor(NutrySelectState state) {
    switch (state) {
      case NutrySelectState.error:
        return context.error;
      case NutrySelectState.focused:
        return context.primary;
      case NutrySelectState.disabled:
        return context.outline;
      default:
        return context.outline;
    }
  }

  Color _getIconColor(NutrySelectState state) {
    switch (state) {
      case NutrySelectState.error:
        return context.error;
      case NutrySelectState.focused:
        return context.primary;
      case NutrySelectState.disabled:
        return context.onSurfaceVariant;
      default:
        return context.onSurfaceVariant;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case NutrySelectSize.small:
        return DesignTokens.spacing.iconSmall;
      case NutrySelectSize.large:
        return DesignTokens.spacing.iconLarge;
      default:
        return DesignTokens.spacing.iconMedium;
    }
  }

  EdgeInsetsGeometry _getContentPadding() {
    final horizontal = DesignTokens.spacing.md;
    final vertical = widget.size == NutrySelectSize.large
        ? DesignTokens.spacing.md
        : DesignTokens.spacing.sm;

    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  NutrySelectOption<T>? _getSelectedOption() {
    if (widget.value == null) return null;
    return widget.options.firstWhere(
      (option) => option.value == widget.value,
      orElse: () => widget.options.first,
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
