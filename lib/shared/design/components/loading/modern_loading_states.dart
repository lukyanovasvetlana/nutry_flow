import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Современные состояния загрузки для NutryFlow
/// Создано UX/UI дизайнером для улучшения пользовательского опыта

/// Основной компонент загрузки с анимацией
class ModernLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final String? message;

  const ModernLoadingIndicator({
    super.key,
    this.size = 48.0,
    this.color,
    this.message,
  });

  @override
  State<ModernLoadingIndicator> createState() => _ModernLoadingIndicatorState();
}

class _ModernLoadingIndicatorState extends State<ModernLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: DesignTokens.animations.slower,
      vsync: this,
    )..repeat();
    
    _scaleController = AnimationController(
      duration: DesignTokens.animations.normal,
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_rotationController);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: DesignTokens.animations.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    gradient: DesignTokens.colors.primaryGradient,
                    borderRadius: BorderRadius.circular(widget.size / 2),
                    boxShadow: DesignTokens.shadows.md,
                  ),
                  child: Icon(
                    Icons.restaurant_rounded,
                    color: DesignTokens.colors.onPrimary,
                    size: widget.size * 0.5,
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          SizedBox(height: DesignTokens.spacing.md),
          Text(
            widget.message!,
            style: TextStyle(
              fontSize: DesignTokens.typography.bodyMedium,
              color: DesignTokens.colors.onSurfaceVariant,
              fontWeight: DesignTokens.typography.medium,
            ),
          ),
        ],
      ],
    );
  }
}

/// Скелетон для карточки статистики
class StatsCardSkeleton extends StatefulWidget {
  const StatsCardSkeleton({super.key});

  @override
  State<StatsCardSkeleton> createState() => _StatsCardSkeletonState();
}

class _StatsCardSkeletonState extends State<StatsCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: DesignTokens.animations.slower,
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(_shimmerController);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacing.md),
      decoration: BoxDecoration(
        color: DesignTokens.colors.surface,
        borderRadius: DesignTokens.borders.cardRadius,
        boxShadow: DesignTokens.shadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmerBox(32, 32, isCircle: true),
              SizedBox(width: DesignTokens.spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(80, 16),
                    SizedBox(height: DesignTokens.spacing.xs),
                    _buildShimmerBox(60, 12),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacing.md),
          _buildShimmerBox(double.infinity, 24),
          SizedBox(height: DesignTokens.spacing.sm),
          _buildShimmerBox(120, 16),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, {bool isCircle = false}) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: isCircle 
                ? BorderRadius.circular(height / 2)
                : BorderRadius.circular(DesignTokens.borders.sm),
            gradient: LinearGradient(
              colors: [
                DesignTokens.colors.outline.withOpacity(0.1),
                DesignTokens.colors.outline.withOpacity(0.3),
                DesignTokens.colors.outline.withOpacity(0.1),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
              end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
            ),
          ),
        );
      },
    );
  }
}

/// Скелетон для списка рецептов
class RecipeListSkeleton extends StatelessWidget {
  final int itemCount;

  const RecipeListSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(DesignTokens.spacing.md),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: DesignTokens.spacing.md),
      itemBuilder: (context, index) => const RecipeCardSkeleton(),
    );
  }
}

/// Скелетон для карточки рецепта
class RecipeCardSkeleton extends StatefulWidget {
  const RecipeCardSkeleton({super.key});

  @override
  State<RecipeCardSkeleton> createState() => _RecipeCardSkeletonState();
}

class _RecipeCardSkeletonState extends State<RecipeCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: DesignTokens.animations.slower,
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(_shimmerController);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.colors.surface,
        borderRadius: DesignTokens.borders.cardRadius,
        boxShadow: DesignTokens.shadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение
          _buildShimmerBox(double.infinity, 200, borderRadius: DesignTokens.borders.lg),
          
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                _buildShimmerBox(200, 20),
                SizedBox(height: DesignTokens.spacing.sm),
                
                // Описание
                _buildShimmerBox(double.infinity, 16),
                SizedBox(height: DesignTokens.spacing.xs),
                _buildShimmerBox(150, 16),
                
                SizedBox(height: DesignTokens.spacing.md),
                
                // Теги и время
                Row(
                  children: [
                    _buildShimmerBox(60, 24, borderRadius: DesignTokens.borders.full),
                    SizedBox(width: DesignTokens.spacing.sm),
                    _buildShimmerBox(80, 24, borderRadius: DesignTokens.borders.full),
                    const Spacer(),
                    _buildShimmerBox(40, 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, {double? borderRadius}) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? DesignTokens.borders.sm),
            gradient: LinearGradient(
              colors: [
                DesignTokens.colors.outline.withOpacity(0.1),
                DesignTokens.colors.outline.withOpacity(0.3),
                DesignTokens.colors.outline.withOpacity(0.1),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
              end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
            ),
          ),
        );
      },
    );
  }
}

/// Полноэкранная загрузка с брендингом
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final bool showLogo;

  const FullScreenLoading({
    super.key,
    this.message,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLogo) ...[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignTokens.borders.xl),
                  boxShadow: DesignTokens.shadows.lg,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignTokens.borders.xl),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.spacing.xl),
            ],
            
            ModernLoadingIndicator(
              size: 64,
              message: message ?? 'Загружаем ваши данные...',
            ),
          ],
        ),
      ),
    );
  }
}

/// Компонент для отображения ошибки с возможностью повтора
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: DesignTokens.colors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignTokens.borders.full),
              ),
              child: Icon(
                icon,
                size: 40,
                color: DesignTokens.colors.error,
              ),
            ),
            
            SizedBox(height: DesignTokens.spacing.lg),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.typography.headlineSmall,
                fontWeight: DesignTokens.typography.semiBold,
                color: DesignTokens.colors.onSurface,
              ),
            ),
            
            SizedBox(height: DesignTokens.spacing.sm),
            
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.typography.bodyMedium,
                color: DesignTokens.colors.onSurfaceVariant,
                height: DesignTokens.typography.lineHeightLoose,
              ),
            ),
            
            if (onRetry != null) ...[
              SizedBox(height: DesignTokens.spacing.xl),
              
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Попробовать снова'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.colors.primary,
                  foregroundColor: DesignTokens.colors.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing.lg,
                    vertical: DesignTokens.spacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: DesignTokens.borders.buttonRadius,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Пустое состояние с призывом к действию
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: DesignTokens.colors.secondaryGradient.scale(0.3),
                borderRadius: BorderRadius.circular(DesignTokens.borders.full),
              ),
              child: Icon(
                icon,
                size: 60,
                color: DesignTokens.colors.primary,
              ),
            ),
            
            SizedBox(height: DesignTokens.spacing.xl),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.typography.headlineMedium,
                fontWeight: DesignTokens.typography.semiBold,
                color: DesignTokens.colors.onSurface,
              ),
            ),
            
            SizedBox(height: DesignTokens.spacing.md),
            
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.typography.bodyLarge,
                color: DesignTokens.colors.onSurfaceVariant,
                height: DesignTokens.typography.lineHeightLoose,
              ),
            ),
            
            if (actionText != null && onAction != null) ...[
              SizedBox(height: DesignTokens.spacing.xl),
              
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.colors.primary,
                  foregroundColor: DesignTokens.colors.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing.xl,
                    vertical: DesignTokens.spacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: DesignTokens.borders.buttonRadius,
                  ),
                ),
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Расширение для LinearGradient
extension LinearGradientExtension on LinearGradient {
  LinearGradient scale(double opacity) {
    return LinearGradient(
      colors: colors.map((color) => color.withOpacity(opacity)).toList(),
      stops: stops,
      begin: begin,
      end: end,
    );
  }
} 