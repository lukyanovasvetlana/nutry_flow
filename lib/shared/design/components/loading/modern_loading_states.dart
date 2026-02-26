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
                    color: context.colors.onPrimary,
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
              color: context.colors.onSurfaceVariant,
              fontWeight: DesignTokens.typography.medium,
            ),
          ),
        ],
      ],
    );
  }
}

/// Скелетон для элемента списка
class ListItemSkeleton extends StatefulWidget {
  final bool showAvatar;
  final bool showTrailing;

  const ListItemSkeleton({
    super.key,
    this.showAvatar = true,
    this.showTrailing = false,
  });

  @override
  State<ListItemSkeleton> createState() => _ListItemSkeletonState();
}

class _ListItemSkeletonState extends State<ListItemSkeleton>
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
    _shimmerAnimation =
        Tween<double>(begin: -1.0, end: 1.0).animate(_shimmerController);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing.md,
        vertical: DesignTokens.spacing.sm,
      ),
      child: Row(
        children: [
          if (widget.showAvatar) ...[
            _buildShimmerBox(48, 48, borderRadius: DesignTokens.borders.full),
            SizedBox(width: DesignTokens.spacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerBox(200, 16),
                SizedBox(height: DesignTokens.spacing.xs),
                _buildShimmerBox(150, 12),
              ],
            ),
          ),
          if (widget.showTrailing) ...[
            SizedBox(width: DesignTokens.spacing.sm),
            _buildShimmerBox(24, 24, borderRadius: DesignTokens.borders.full),
          ],
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
            borderRadius: BorderRadius.circular(
              borderRadius ?? DesignTokens.borders.sm,
            ),
            gradient: LinearGradient(
              colors: [
                context.colors.outline.withValues(alpha: 0.1),
                context.colors.outline.withValues(alpha: 0.3),
                context.colors.outline.withValues(alpha: 0.1),
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

/// Скелетон для профиля пользователя
class ProfileSkeleton extends StatefulWidget {
  const ProfileSkeleton({super.key});

  @override
  State<ProfileSkeleton> createState() => _ProfileSkeletonState();
}

class _ProfileSkeletonState extends State<ProfileSkeleton>
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
    _shimmerAnimation =
        Tween<double>(begin: -1.0, end: 1.0).animate(_shimmerController);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacing.lg),
      child: Column(
        children: [
          // Аватар
          _buildShimmerBox(100, 100, borderRadius: DesignTokens.borders.full),
          SizedBox(height: DesignTokens.spacing.md),
          // Имя
          _buildShimmerBox(200, 24),
          SizedBox(height: DesignTokens.spacing.sm),
          // Email
          _buildShimmerBox(180, 16),
          SizedBox(height: DesignTokens.spacing.xl),
          // Поля формы
          ...List.generate(
              5,
              (index) => Padding(
                    padding: EdgeInsets.only(bottom: DesignTokens.spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(100, 12),
                        SizedBox(height: DesignTokens.spacing.xs),
                        _buildShimmerBox(double.infinity, 48,
                            borderRadius: DesignTokens.borders.md),
                      ],
                    ),
                  )),
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
            borderRadius: BorderRadius.circular(
              borderRadius ?? DesignTokens.borders.sm,
            ),
            gradient: LinearGradient(
              colors: [
                context.colors.outline.withValues(alpha: 0.1),
                context.colors.outline.withValues(alpha: 0.3),
                context.colors.outline.withValues(alpha: 0.1),
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

/// Скелетон для карточки упражнения
class ExerciseCardSkeleton extends StatefulWidget {
  const ExerciseCardSkeleton({super.key});

  @override
  State<ExerciseCardSkeleton> createState() => _ExerciseCardSkeletonState();
}

class _ExerciseCardSkeletonState extends State<ExerciseCardSkeleton>
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
    _shimmerAnimation =
        Tween<double>(begin: -1.0, end: 1.0).animate(_shimmerController);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(DesignTokens.spacing.md),
      padding: EdgeInsets.all(DesignTokens.spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        boxShadow: DesignTokens.shadows.sm,
      ),
      child: Row(
        children: [
          // Изображение
          _buildShimmerBox(80, 80, borderRadius: DesignTokens.borders.md),
          SizedBox(width: DesignTokens.spacing.md),
          // Контент
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerBox(150, 18),
                SizedBox(height: DesignTokens.spacing.xs),
                _buildShimmerBox(200, 14),
                SizedBox(height: DesignTokens.spacing.sm),
                Row(
                  children: [
                    _buildShimmerBox(60, 20,
                        borderRadius: DesignTokens.borders.full),
                    SizedBox(width: DesignTokens.spacing.sm),
                    _buildShimmerBox(60, 20,
                        borderRadius: DesignTokens.borders.full),
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
            borderRadius: BorderRadius.circular(
              borderRadius ?? DesignTokens.borders.sm,
            ),
            gradient: LinearGradient(
              colors: [
                context.colors.outline.withValues(alpha: 0.1),
                context.colors.outline.withValues(alpha: 0.3),
                context.colors.outline.withValues(alpha: 0.1),
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

/// Скелетон для таблицы
class TableSkeleton extends StatefulWidget {
  final int rowCount;
  final int columnCount;

  const TableSkeleton({
    super.key,
    this.rowCount = 5,
    this.columnCount = 4,
  });

  @override
  State<TableSkeleton> createState() => _TableSkeletonState();
}

class _TableSkeletonState extends State<TableSkeleton>
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
    _shimmerAnimation =
        Tween<double>(begin: -1.0, end: 1.0).animate(_shimmerController);
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
      child: Column(
        children: [
          // Заголовок
          Row(
            children: List.generate(
              widget.columnCount,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.all(DesignTokens.spacing.sm),
                  child: _buildShimmerBox(double.infinity, 20),
                ),
              ),
            ),
          ),
          // Строки
          ...List.generate(
            widget.rowCount,
            (index) => Row(
              children: List.generate(
                widget.columnCount,
                (colIndex) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(DesignTokens.spacing.sm),
                    child: _buildShimmerBox(double.infinity, 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
            gradient: LinearGradient(
              colors: [
                context.colors.outline.withValues(alpha: 0.1),
                context.colors.outline.withValues(alpha: 0.3),
                context.colors.outline.withValues(alpha: 0.1),
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
        color: context.colors.surface,
        borderRadius:
            BorderRadius.circular(DesignTokens.borders.cardRadius.toDouble()),
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

  Widget _buildShimmerBox(double width, double height,
      {bool isCircle = false}) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: isCircle
                ? BorderRadius.circular(height / 2)
                : BorderRadius.circular(DesignTokens.borders.sm.toDouble()),
            gradient: LinearGradient(
              colors: [
                context.colors.outline.withValues(alpha: 0.1),
                context.colors.outline.withValues(alpha: 0.3),
                context.colors.outline.withValues(alpha: 0.1),
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
      separatorBuilder: (context, index) =>
          SizedBox(height: DesignTokens.spacing.md),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius:
            BorderRadius.circular(DesignTokens.borders.cardRadius.toDouble()),
        boxShadow: DesignTokens.shadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение
          _buildShimmerBox(double.infinity, 200,
              borderRadius: DesignTokens.borders.lg),

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
                    _buildShimmerBox(60, 24,
                        borderRadius: DesignTokens.borders.full),
                    SizedBox(width: DesignTokens.spacing.sm),
                    _buildShimmerBox(80, 24,
                        borderRadius: DesignTokens.borders.full),
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
            borderRadius:
                BorderRadius.circular(borderRadius ?? DesignTokens.borders.sm),
            gradient: LinearGradient(
              colors: [
                context.colors.outline.withValues(alpha: 0.1),
                context.colors.outline.withValues(alpha: 0.3),
                context.colors.outline.withValues(alpha: 0.1),
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
      backgroundColor: context.colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLogo) ...[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(DesignTokens.borders.xl.toDouble()),
                  boxShadow: DesignTokens.shadows.lg,
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(DesignTokens.borders.xl.toDouble()),
                  child: Image.asset(
                    'assets/images/logo.png',
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
                color: context.colors.error.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(DesignTokens.borders.full.toDouble()),
              ),
              child: Icon(
                icon,
                size: 40,
                color: context.colors.error,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.typography.headlineSmall,
                fontWeight: DesignTokens.typography.semiBold,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.typography.bodyMedium,
                color: context.colors.onSurfaceVariant,
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
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing.lg,
                    vertical: DesignTokens.spacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        DesignTokens.borders.buttonRadius.toDouble()),
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
                gradient: context.colors.secondaryGradient.scale(0.3),
                borderRadius:
                    BorderRadius.circular(DesignTokens.borders.full.toDouble()),
              ),
              child: Icon(
                icon,
                size: 60,
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.typography.headlineMedium,
                fontWeight: DesignTokens.typography.semiBold,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.typography.bodyLarge,
                color: context.colors.onSurfaceVariant,
                height: DesignTokens.typography.lineHeightLoose,
              ),
            ),
            if (actionText != null && onAction != null) ...[
              SizedBox(height: DesignTokens.spacing.xl),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing.xl,
                    vertical: DesignTokens.spacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        DesignTokens.borders.buttonRadius.toDouble()),
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
      colors: colors.map((color) => color.withValues(alpha: opacity)).toList(),
      stops: stops,
      begin: begin,
      end: end,
    );
  }
}
