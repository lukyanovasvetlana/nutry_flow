import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class NutrySaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? width;
  final bool isLoading;

  const NutrySaveButton({
    super.key,
    required this.onPressed,
    this.text = 'Сохранить',
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dynamicPrimary,
          foregroundColor: Colors.white,
          minimumSize:
              Size(double.infinity, DesignTokens.spacing.buttonHeightLarge),
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.borders.full),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: DesignTokens.typography.bodyLargeStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
