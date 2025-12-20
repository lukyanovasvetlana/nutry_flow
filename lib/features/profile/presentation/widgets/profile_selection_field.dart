import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class ProfileSelectionField<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        FormField<T>(
          initialValue: value,
          validator: validator,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onTap,
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
                            displayText ?? hint ?? 'Выберите $label',
                            style: TextStyle(
                              fontSize: 14,
                              color: displayText != null
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
