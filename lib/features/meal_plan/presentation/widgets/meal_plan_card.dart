import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class MealPlanCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String articleId;

  const MealPlanCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to article details using articleId.
        },
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.dynamicCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.dynamicBorder.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.dynamicShadow.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 100,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(DesignTokens.spacing.md),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DesignTokens.typography.bodyMediumStyle.copyWith(
                    color: AppColors.dynamicTextPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
