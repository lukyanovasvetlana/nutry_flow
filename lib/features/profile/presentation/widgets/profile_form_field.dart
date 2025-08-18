import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/theme/app_colors.dart';

class ProfileFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool enabled;
  final VoidCallback? onTap;

  const ProfileFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          obscureText: obscureText,
          maxLines: maxLines,
          enabled: enabled,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint ?? 'Введите $label',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.green, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          style: TextStyle(
            fontSize: 14,
            color: enabled ? Colors.black87 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
