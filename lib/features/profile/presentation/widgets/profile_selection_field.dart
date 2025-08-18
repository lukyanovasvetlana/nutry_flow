import 'package:flutter/material.dart';

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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
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
                      color: Colors.grey[50],
                      border: Border.all(
                        color: field.hasError ? Colors.red : Colors.grey[300]!,
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
                                  ? Colors.black87
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
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
                      style: const TextStyle(
                        color: Colors.red,
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
