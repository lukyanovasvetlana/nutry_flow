import 'package:flutter/material.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../exercise/presentation/screens/exercise_screen_redesigned.dart';

/// Улучшенный компонент обзора статистики
/// Создан UX/UI дизайнером для лучшего пользовательского опыта
class EnhancedStatsOverview extends StatefulWidget {
  final Function(int) onCardTap;
  final int selectedIndex;
  
  const EnhancedStatsOverview({
    super.key,
    required this.onCardTap,
    required this.selectedIndex,
  });

  @override
  State<EnhancedStatsOverview> createState() => _EnhancedStatsOverviewState();
}

class _EnhancedStatsOverviewState extends State<EnhancedStatsOverview>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: DesignTokens.animations.normal,
      vsync: this,
    );

    // Создаем контроллеры для каждой карточки
    _cardControllers = List.generate(3, (index) => 
      AnimationController(
        duration: DesignTokens.animations.fast,
        vsync: this,
      )
    );

    // Создаем анимации масштабирования для каждой карточки
    _cardAnimations = _cardControllers.map((controller) =>
      Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: controller, curve: DesignTokens.animations.easeInOut)
      )
    ).toList();

    // Запускаем появление карточек с задержкой
    _animateCardsIn();
  }

  void _animateCardsIn() async {
    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(milliseconds: 100 * i));
      if (mounted) {
        _cardControllers[i].forward();
        _cardControllers[i].reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Row(
        children: [
          _buildStatCard(
            index: 0,
            title: 'Расходы',
            value: '₽11,300',
            change: '+20%',
            changePositive: true,
            color: DesignTokens.colors.primary,
            icon: Icons.account_balance_wallet_rounded,
            gradient: DesignTokens.colors.primaryGradient,
          ),
          SizedBox(width: DesignTokens.spacing.sm),
          _buildStatCard(
            index: 1,
            title: 'Продукты',
            value: '40',
            change: '+10.2%',
            changePositive: true,
            color: DesignTokens.colors.accent,
            icon: Icons.shopping_basket_rounded,
            gradient: DesignTokens.colors.accentGradient,
          ),
          SizedBox(width: DesignTokens.spacing.sm),
          _buildStatCard(
            index: 2,
            title: 'Калории',
            value: '21.6к',
            change: '-5.1%',
            changePositive: false,
            color: DesignTokens.colors.secondary,
            icon: Icons.local_fire_department_rounded,
            gradient: DesignTokens.colors.secondaryGradient,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required int index,
    required String title,
    required String value,
    required String change,
    required bool changePositive,
    required Color color,
    required IconData icon,
    required LinearGradient gradient,
  }) {
    final isSelected = widget.selectedIndex == index;
    
    return Expanded(
      child: AnimatedBuilder(
        animation: _cardAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _cardAnimations[index].value,
            child: GestureDetector(
              onTapDown: (_) => _cardControllers[index].forward(),
              onTapUp: (_) {
                _cardControllers[index].reverse();
                widget.onCardTap(index);
              },
              onTapCancel: () => _cardControllers[index].reverse(),
              child: AnimatedContainer(
                duration: DesignTokens.animations.normal,
                curve: DesignTokens.animations.easeInOut,
                decoration: BoxDecoration(
                  gradient: isSelected ? gradient : null,
                  color: isSelected ? null : DesignTokens.colors.surface,
                  borderRadius: DesignTokens.borders.cardRadius,
                  boxShadow: isSelected 
                      ? DesignTokens.shadows.lg
                      : DesignTokens.shadows.sm,
                  border: isSelected 
                      ? null 
                      : Border.all(
                          color: DesignTokens.colors.outline.withValues(alpha: 0.1),
                          width: DesignTokens.borders.thin,
                        ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(DesignTokens.spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка и изменение
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(DesignTokens.spacing.sm),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? DesignTokens.colors.onPrimary.withValues(alpha: 0.2)
                                  : color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
                            ),
                            child: Icon(
                              icon,
                              size: DesignTokens.spacing.iconMedium,
                              color: isSelected 
                                  ? DesignTokens.colors.onPrimary
                                  : color,
                            ),
                          ),
                          _buildChangeIndicator(change, changePositive, isSelected),
                        ],
                      ),
                      
                      SizedBox(height: DesignTokens.spacing.md),
                      
                      // Значение
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: DesignTokens.typography.headlineSmall,
                          fontWeight: DesignTokens.typography.bold,
                          color: isSelected 
                              ? DesignTokens.colors.onPrimary
                              : DesignTokens.colors.onSurface,
                        ),
                      ),
                      
                      SizedBox(height: DesignTokens.spacing.xs),
                      
                      // Заголовок
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: DesignTokens.typography.bodySmall,
                          fontWeight: DesignTokens.typography.medium,
                          color: isSelected 
                              ? DesignTokens.colors.onPrimary.withValues(alpha: 0.8)
                              : DesignTokens.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChangeIndicator(String change, bool isPositive, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing.sm,
        vertical: DesignTokens.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: isSelected 
            ? DesignTokens.colors.onPrimary.withValues(alpha: 0.2)
            : (isPositive 
                ? DesignTokens.colors.success.withValues(alpha: 0.1)
                : DesignTokens.colors.error.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(DesignTokens.borders.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: DesignTokens.spacing.iconSmall,
            color: isSelected 
                ? DesignTokens.colors.onPrimary
                : (isPositive 
                    ? DesignTokens.colors.success
                    : DesignTokens.colors.error),
          ),
          SizedBox(width: DesignTokens.spacing.xs),
          Text(
            change,
            style: TextStyle(
              fontSize: DesignTokens.typography.labelSmall,
              fontWeight: DesignTokens.typography.semiBold,
              color: isSelected 
                  ? DesignTokens.colors.onPrimary
                  : (isPositive 
                      ? DesignTokens.colors.success
                      : DesignTokens.colors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Улучшенная карточка приветствия с персонализацией
class EnhancedWelcomeCard extends StatefulWidget {
  final String? userName;
  
  const EnhancedWelcomeCard({
    super.key,
    this.userName,
  });

  @override
  State<EnhancedWelcomeCard> createState() => _EnhancedWelcomeCardState();
}

class _EnhancedWelcomeCardState extends State<EnhancedWelcomeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: DesignTokens.animations.slow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: DesignTokens.animations.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: DesignTokens.animations.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentHour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;
    
    if (currentHour < 12) {
      greeting = 'Доброе утро';
      greetingIcon = Icons.wb_sunny_rounded;
    } else if (currentHour < 17) {
      greeting = 'Добрый день';
      greetingIcon = Icons.wb_cloudy_rounded;
    } else {
      greeting = 'Добрый вечер';
      greetingIcon = Icons.nights_stay_rounded;
    }

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: DesignTokens.spacing.md),
          padding: EdgeInsets.all(DesignTokens.spacing.lg),
          decoration: BoxDecoration(
            gradient: DesignTokens.colors.primaryGradient,
            borderRadius: DesignTokens.borders.cardRadius,
            boxShadow: DesignTokens.shadows.lg,
          ),
          child: Row(
            children: [
              // Аватар пользователя
              Container(
                width: DesignTokens.spacing.avatarMedium,
                height: DesignTokens.spacing.avatarMedium,
                decoration: BoxDecoration(
                  color: DesignTokens.colors.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.borders.full),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignTokens.borders.full),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              SizedBox(width: DesignTokens.spacing.md),
              
              // Приветствие и имя
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          greetingIcon,
                          size: DesignTokens.spacing.iconSmall,
                          color: DesignTokens.colors.onPrimary.withValues(alpha: 0.8),
                        ),
                        SizedBox(width: DesignTokens.spacing.xs),
                        Text(
                          greeting,
                          style: TextStyle(
                            fontSize: DesignTokens.typography.bodyMedium,
                            color: DesignTokens.colors.onPrimary.withValues(alpha: 0.8),
                            fontWeight: DesignTokens.typography.medium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: DesignTokens.spacing.xs),
                    Text(
                      widget.userName ?? 'Гость',
                      style: TextStyle(
                        fontSize: DesignTokens.typography.headlineSmall,
                        fontWeight: DesignTokens.typography.bold,
                        color: DesignTokens.colors.onPrimary,
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacing.xs),
                    Text(
                      'Готовы к новому дню здорового питания?',
                      style: TextStyle(
                        fontSize: DesignTokens.typography.bodySmall,
                        color: DesignTokens.colors.onPrimary.withValues(alpha: 0.7),
                        fontWeight: DesignTokens.typography.regular,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Кнопка настроек
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/profile-settings'),
                icon: Icon(
                  Icons.settings_rounded,
                  color: DesignTokens.colors.onPrimary.withValues(alpha: 0.8),
                  size: DesignTokens.spacing.iconMedium,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: DesignTokens.colors.onPrimary.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
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

/// Быстрые действия для дашборда
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: DesignTokens.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Быстрые действия',
            style: TextStyle(
              fontSize: DesignTokens.typography.titleLarge,
              fontWeight: DesignTokens.typography.semiBold,
              color: DesignTokens.colors.onSurface,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.md),
          Row(
            children: [
              _buildActionCard(
                title: 'Добавить блюдо',
                icon: Icons.add_circle_outline_rounded,
                color: DesignTokens.colors.primary,
                onTap: () => Navigator.pushNamed(context, '/healthy-menu'),
              ),
              SizedBox(width: DesignTokens.spacing.sm),
              _buildActionCard(
                title: 'Планы питания',
                icon: Icons.calendar_today_rounded,
                color: DesignTokens.colors.secondary,
                onTap: () => Navigator.pushNamed(context, '/meal-plan'),
              ),
              SizedBox(width: DesignTokens.spacing.sm),
              _buildActionCard(
                title: 'Тренировки',
                icon: Icons.fitness_center_rounded,
                color: DesignTokens.colors.accent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExerciseScreenRedesigned()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(DesignTokens.spacing.md),
          decoration: BoxDecoration(
            color: DesignTokens.colors.surface,
            borderRadius: DesignTokens.borders.cardRadius,
            boxShadow: DesignTokens.shadows.sm,
            border: Border.all(
              color: DesignTokens.colors.outline.withValues(alpha: 0.1),
              width: DesignTokens.borders.thin,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(DesignTokens.spacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: DesignTokens.spacing.iconLarge,
                ),
              ),
              SizedBox(height: DesignTokens.spacing.sm),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: DesignTokens.typography.bodySmall,
                  fontWeight: DesignTokens.typography.medium,
                  color: DesignTokens.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 