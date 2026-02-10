import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/components/cards/nutry_card.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class AdditionalTracker extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onDismiss;
  final VoidCallback? onAdd;
  final bool showAddButton;
  final Color? color;

  const AdditionalTracker({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onDismiss,
    this.onAdd,
    this.showAddButton = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.dynamicInfo;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return NutryCard(
      margin: EdgeInsets.zero,
      onTap: onAdd,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isLightTheme ? cardColor.withValues(alpha: 0.08) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cardColor.withValues(alpha: isLightTheme ? 0.6 : 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: isLightTheme ? 0.3 : 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: cardColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicOnSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style:
                          DesignTokens.typography.headlineSmallStyle.copyWith(
                        color: AppColors.dynamicOnSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (showAddButton && onAdd != null)
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(
                      alpha: isLightTheme ? 0.3 : 0.15,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: cardColor,
                  ),
                ),
              )
            else if (!showAddButton) ...[
              Icon(
                Icons.info_outline,
                color: AppColors.dynamicWarning,
                size: DesignTokens.spacing.iconSmall,
              ),
              SizedBox(width: DesignTokens.spacing.xs),
              if (onDismiss != null)
                GestureDetector(
                  onTap: onDismiss,
                  child: Icon(
                    Icons.close,
                    color: AppColors.dynamicTextSecondary,
                    size: DesignTokens.spacing.iconSmall,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
