import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class ProfileSelectionField<T> extends StatefulWidget {
  final String label;
  final T? value;
  final String? displayText;
  final VoidCallback onTap;
  final String? Function(T?)? validator;
  final String? hint;

  const ProfileSelectionField({
    super.key,
    required this.label,
    required this.value,
    required this.displayText,
    required this.onTap,
    this.validator,
    this.hint,
  });

  @override
  State<ProfileSelectionField<T>> createState() => _ProfileSelectionFieldState<T>();
}

class _ProfileSelectionFieldState<T> extends State<ProfileSelectionField<T>> {
  final GlobalKey<FormFieldState<T>> _fieldKey = GlobalKey<FormFieldState<T>>();

  @override
  void didUpdateWidget(ProfileSelectionField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Обновляем значение FormField при изменении value
    if (oldWidget.value != widget.value) {
      _fieldKey.currentState?.didChange(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        FormField<T>(
          key: _fieldKey,
          initialValue: widget.value,
          validator: widget.validator,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.dynamicCard,
                      border: Border.all(
                        color: field.hasError ? AppColors.dynamicError : AppColors.dynamicBorder,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.displayText ?? widget.hint ?? 'Выберите ${widget.label}',
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.displayText != null
                                  ? AppColors.dynamicTextPrimary
                                  : AppColors.dynamicTextSecondary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.dynamicTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: AppColors.dynamicError,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
