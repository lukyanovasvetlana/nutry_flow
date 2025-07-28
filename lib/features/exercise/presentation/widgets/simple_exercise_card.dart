import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class SimpleExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const SimpleExerciseCard({
    Key? key,
    required this.exercise,
    this.onTap,
  }) : super(key: key);

  @override
  State<SimpleExerciseCard> createState() => _SimpleExerciseCardState();
}

class _SimpleExerciseCardState extends State<SimpleExerciseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    switch (widget.exercise.category) {
      case 'Ноги':
        return DesignTokens.colors.nutritionProtein;
      case 'Спина':
        return DesignTokens.colors.nutritionCarbs;
      case 'Грудь':
        return DesignTokens.colors.nutritionFats;
      case 'Плечи':
        return DesignTokens.colors.nutritionCarbs;
      case 'Руки':
        return DesignTokens.colors.nutritionFats;
      case 'Пресс':
        return DesignTokens.colors.nutritionProtein;
      case 'Кардио':
        return DesignTokens.colors.nutritionWater;
      case 'Растяжка':
        return DesignTokens.colors.nutritionFiber;
      default:
        return DesignTokens.colors.nutritionProtein;
    }
  }

  IconData _getExerciseIcon() {
    switch (widget.exercise.iconName) {
      case 'directions_run':
        return Icons.directions_run;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'sports_gymnastics':
        return Icons.sports_gymnastics;
      case 'sports_martial_arts':
        return Icons.sports_martial_arts;
      default:
        return Icons.fitness_center;
    }
  }

  String _getQuickInfo() {
    if (widget.exercise.duration != null) {
      return widget.exercise.duration!;
    }
    return '${widget.exercise.sets} × ${widget.exercise.reps}';
  }

  Color _getDifficultyColor() {
    switch (widget.exercise.difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return DesignTokens.colors.nutritionProtein; // Розовый цвет как для ног
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Material(
              elevation: _isPressed ? 8 : 2,
              borderRadius: BorderRadius.circular(20),
              color: context.colors.surface,
              shadowColor: context.colors.shadow.withValues(alpha: 0.1),
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Category color indicator
                      Container(
                        width: 4,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Exercise icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getCategoryColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getExerciseIcon(),
                          color: _getCategoryColor(),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Exercise info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.exercise.name,
                              style: context.typography.bodyLargeStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.colors.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    widget.exercise.category,
                                    style: context.typography.bodySmallStyle.copyWith(
                                      color: context.colors.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Quick info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _getQuickInfo(),
                            style: context.typography.bodyLargeStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.exercise.duration != null ? 'время' : 'подходы',
                            style: context.typography.bodySmallStyle.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 