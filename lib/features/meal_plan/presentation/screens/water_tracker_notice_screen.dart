import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/auth/auth_session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackerNoticeScreen extends StatefulWidget {
  final String imageAssetPath;

  const WaterTrackerNoticeScreen({
    super.key,
    this.imageAssetPath = 'assets/images/water_green.jpg',
  });

  @override
  State<WaterTrackerNoticeScreen> createState() =>
      _WaterTrackerNoticeScreenState();
}

class _WaterTrackerNoticeScreenState extends State<WaterTrackerNoticeScreen> {
  int _selectedPlanIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _pricingSectionKey = GlobalKey();
  bool _showStickyCta = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateStickyCtaVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateStickyCtaVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateStickyCtaVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateStickyCtaVisibility() {
    final context = _pricingSectionKey.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + box.size.height;
    final screenHeight = MediaQuery.of(this.context).size.height;
    final isVisible = bottom > 0 && top < screenHeight;
    final shouldShow = !isVisible;

    if (shouldShow != _showStickyCta && mounted) {
      setState(() {
        _showStickyCta = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(
                DesignTokens.spacing.lg,
                DesignTokens.spacing.lg,
                DesignTokens.spacing.lg,
                DesignTokens.spacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: DesignTokens.spacing.xl),
                  _buildPromoBanner(),
                  SizedBox(height: DesignTokens.spacing.xl),
                  Text(
                    'Отслеживайте ежедневное потребление воды',
                    style: DesignTokens.typography.titleLargeStyle.copyWith(
                      color: AppColors.dynamicTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacing.md),
                  _buildWaterImage(),
                  SizedBox(height: DesignTokens.spacing.md),
                  Text(
                    'Поддержание надлежащей гидратации является ключом к достижению ваших целей, а отслеживание потребления воды является важным шагом в этом процессе. Трекер воды в Premium помогает вам в этом, предлагая практичный способ записи количества воды, которое вы потребляете в течение дня.',
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacing.xl),
                  Text(
                    'Другие функции в NutryFlow Premium',
                    style: DesignTokens.typography.titleLargeStyle.copyWith(
                      color: AppColors.dynamicTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacing.lg),
                  _buildFeatureList(),
                  SizedBox(height: DesignTokens.spacing.xl),
                  Text(
                    'Подпишитесь прямо сейчас и откройте дополнительные функции, чтобы быстрее достичь успеха',
                    style: DesignTokens.typography.titleLargeStyle.copyWith(
                      color: AppColors.dynamicTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: DesignTokens.spacing.xl),
                  _buildPremiumGoalsCard(),
                  SizedBox(height: DesignTokens.spacing.xl),
                  _buildPricingSection(),
                  SizedBox(height: DesignTokens.spacing.xl),
                  Text(
                    'Условия Использования и Политика Конфиденциальности',
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: DesignTokens.spacing.sm),
                  Text(
                    '*Подписка NutryFlow Premium будет оплачена с вашего аккаунта Apple и продлевается автоматически, если её не отменить как минимум за 24 часа до окончания периода. Подписка продлевается по той же цене и с тем же типом, что и ранее приобретённые. Управлять подпиской можно в вашем аккаунте Apple.',
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      fontSize: 11,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: DesignTokens.spacing.sm,
              right: DesignTokens.spacing.sm,
              child: _buildCloseButton(context),
            ),
            if (_showStickyCta)
              Positioned(
                left: DesignTokens.spacing.lg,
                right: DesignTokens.spacing.lg,
                bottom: DesignTokens.spacing.lg,
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _scrollToPricingSection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                      child: const Text('Получить Premium'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.dynamicShadow.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.close,
            color: Colors.black,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacing.lg),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dynamicBorder.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Сэкономьте на Premium и достигните своей цели',
                  style: DesignTokens.typography.titleMediumStyle.copyWith(
                    color: AppColors.dynamicTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: DesignTokens.spacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _scrollToPricingSection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dynamicYellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Получить Premium'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: DesignTokens.spacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400&q=80',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        widget.imageAssetPath,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Умный сканер еды: ускорьте регистрацию блюд, делая фото продуктов и получая точную питательную ценность.',
      'Умный ассистент: записывайте приемы пищи в два раза быстрее, чем регистрация еды вручную.',
      'Разработанные диетологами планы питания: получите доступ ко всем доступным планам питания.',
      'План питания: планируйте заранее, создавая свои собственные планы питания, чтобы быть организованными и ответственными.',
      'Копируйте продукты: экономьте время, копируя продукты в несколько приемов пищи и дней.',
      'Индивидуальные приемы пищи: создавайте индивидуальные типы приема пищи, чтобы записывать свое питание.',
      'Запись рецептов: прямо в ваш дневник всего парой нажатий.',
    ];

    return Column(
      children: features
          .map((feature) => Padding(
                padding: EdgeInsets.only(bottom: DesignTokens.spacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.dynamicSuccess.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.dynamicSuccess,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: DesignTokens.spacing.sm),
                    Expanded(
                      child: Text(
                        feature,
                        style: DesignTokens.typography.bodyMediumStyle.copyWith(
                          color: AppColors.dynamicTextPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPremiumGoalsCard() {
    final backgroundColor = AppColors.dynamicOrange.withValues(alpha: 0.12);
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dynamicOrange.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Станьте ближе к цели с Premium',
            style: DesignTokens.typography.titleMediumStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.sm),
          Text(
            'Проанализировав миллионы журналов, мы обнаружили, что пользователи Premium в 3 раза ближе к своему целевому весу и сохраняют мотивацию в два раза дольше, добавляя функции Premium в свой распорядок дня.',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: AppColors.dynamicTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    final backgroundColor = AppColors.dynamicOrange.withValues(alpha: 0.12);
    return Column(
      key: _pricingSectionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(DesignTokens.spacing.lg),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.dynamicOrange.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Достигните своих целей за меньшие деньги',
                style: DesignTokens.typography.titleMediumStyle.copyWith(
                  color: AppColors.dynamicTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: DesignTokens.spacing.sm),
              Text(
                'Экономьте на 3- или 12-месячной подписке. Поторопитесь, это предложение доступно только на этой странице.',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicTextSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: DesignTokens.spacing.lg),
        _buildPricingOption(
          title: '12 месяцев',
          price: '2 390,00 ₽',
          oldPrice: '3 990,00 ₽',
          badge: 'Ограниченное предложение',
          isSelected: _selectedPlanIndex == 0,
          onTap: () => setState(() => _selectedPlanIndex = 0),
        ),
        SizedBox(height: DesignTokens.spacing.md),
        _buildPricingOption(
          title: '3 месяца',
          price: '1 290,00 ₽',
          oldPrice: '1 850,00 ₽',
          isSelected: _selectedPlanIndex == 1,
          onTap: () => setState(() => _selectedPlanIndex = 1),
        ),
        SizedBox(height: DesignTokens.spacing.md),
        _buildPricingOption(
          title: '1 месяц',
          price: '925,00 ₽',
          isSelected: _selectedPlanIndex == 2,
          onTap: () => setState(() => _selectedPlanIndex = 2),
        ),
        SizedBox(height: DesignTokens.spacing.md),
        Text(
          'Мы рекомендуем наш 3-месячный план, поскольку он предлагает баланс доступности и приверженности целям, чтобы помочь вам достичь их. Постоянное отслеживание и прогресс в течение трех месяцев даст вам импульс, необходимый для достижения успеха в долгосрочной перспективе.',
          style: DesignTokens.typography.bodySmallStyle.copyWith(
            color: AppColors.dynamicTextSecondary,
            height: 1.5,
          ),
        ),
        SizedBox(height: DesignTokens.spacing.lg),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showSubscriptionSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(_getSelectedPlanCtaText()),
          ),
        ),
        SizedBox(height: DesignTokens.spacing.md),
        Center(
          child: TextButton(
            onPressed: _showRestorePurchasesSheet,
            child: Text(
              'Восстановить покупку',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicSuccess,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSubscriptionSheet() {
    final plan = _getSelectedPlanInfo();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SubscriptionSheet(
        title: plan.title,
        price: plan.price,
      ),
    );
  }

  String _getSelectedPlanCtaText() {
    switch (_selectedPlanIndex) {
      case 1:
        return 'Получить план на 3 мес.';
      case 2:
        return 'Получить план на 1 мес.';
      default:
        return 'Получить план на 12 мес.';
    }
  }

  _PlanInfo _getSelectedPlanInfo() {
    switch (_selectedPlanIndex) {
      case 1:
        return const _PlanInfo(
          title: 'Подписка на 3 месяца',
          price: '1 290,00 руб. за 3 мес',
        );
      case 2:
        return const _PlanInfo(
          title: 'Подписка на 1 месяц',
          price: '925,00 руб. за мес',
        );
      default:
        return const _PlanInfo(
          title: 'Годовая Подписка',
          price: '2 390,00 руб. в год',
        );
    }
  }

  void _showRestorePurchasesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _RestorePurchasesSheet(),
    );
  }

  Future<void> _scrollToPricingSection() async {
    final context = _pricingSectionKey.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  Widget _buildPricingOption({
    required String title,
    required String price,
    String? oldPrice,
    String? badge,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final highlightColor = AppColors.dynamicSuccess;
    final borderColor = isSelected
        ? highlightColor
        : AppColors.dynamicBorder.withValues(alpha: 0.4);
    final backgroundColor = isSelected
        ? highlightColor.withValues(alpha: 0.2)
        : AppColors.dynamicCard;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.all(DesignTokens.spacing.lg),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: highlightColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: DesignTokens.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DesignTokens.typography.bodyLargeStyle.copyWith(
                        color: AppColors.dynamicTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacing.xs),
                    Row(
                      children: [
                        Text(
                          price,
                          style:
                              DesignTokens.typography.bodyLargeStyle.copyWith(
                            color: AppColors.dynamicTextPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (oldPrice != null) ...[
                          SizedBox(width: DesignTokens.spacing.sm),
                          Text(
                            oldPrice,
                            style:
                                DesignTokens.typography.bodySmallStyle.copyWith(
                              color: AppColors.dynamicTextSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (badge != null) ...[
                      SizedBox(height: DesignTokens.spacing.sm),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing.md,
                          vertical: DesignTokens.spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: highlightColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge,
                          style:
                              DesignTokens.typography.bodySmallStyle.copyWith(
                            color: highlightColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanInfo {
  final String title;
  final String price;

  const _PlanInfo({required this.title, required this.price});
}

class _SubscriptionSheet extends StatelessWidget {
  final String title;
  final String price;

  const _SubscriptionSheet({
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final email = AuthSessionStore.lastEmail ?? 'user@example.com';
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          DesignTokens.spacing.lg,
          DesignTokens.spacing.md,
          DesignTokens.spacing.lg,
          DesignTokens.spacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.dynamicBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'App Store',
                  style: DesignTokens.typography.titleMediumStyle.copyWith(
                    color: AppColors.dynamicTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.dynamicTextSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(DesignTokens.spacing.lg),
              decoration: BoxDecoration(
                color: AppColors.dynamicCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.dynamicBorder.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.dynamicSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: AppColors.dynamicPrimary,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: DesignTokens.spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: DesignTokens.typography.bodyLargeStyle
                                  .copyWith(
                                color: AppColors.dynamicTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: DesignTokens.spacing.xs),
                            Text(
                              'NutryFlow',
                              style: DesignTokens.typography.bodySmallStyle
                                  .copyWith(
                                color: AppColors.dynamicTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacing.sm,
                          vertical: DesignTokens.spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.dynamicPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '13+',
                          style:
                              DesignTokens.typography.labelSmallStyle.copyWith(
                            color: AppColors.dynamicPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacing.md),
                  Text(
                    price,
                    style: DesignTokens.typography.titleMediumStyle.copyWith(
                      color: AppColors.dynamicTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacing.md),
                  Text(
                    'Отменить подписку можно в разделе «Настройки» > «Аккаунт Apple» в любой момент, но не менее чем за день до даты продления. Подписка будет возобновляться автоматически, пока вы её не отмените.',
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: AppColors.dynamicTextSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacing.md),
                  Text(
                    'Аккаунт: $email',
                    style: DesignTokens.typography.bodySmallStyle.copyWith(
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: DesignTokens.spacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const _SubscriptionAuthSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Подписаться',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionAuthSheet extends StatefulWidget {
  const _SubscriptionAuthSheet();

  @override
  State<_SubscriptionAuthSheet> createState() => _SubscriptionAuthSheetState();
}

class _SubscriptionAuthSheetState extends State<_SubscriptionAuthSheet> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isPasswordVisible = false;
  String _email = 'user@example.com';

  @override
  void initState() {
    super.initState();
    _email = AuthSessionStore.lastEmail ?? 'user@example.com';
    _emailController.text = _email;
    final storedPassword = AuthSessionStore.lastPassword ?? '';
    _passwordController.text = storedPassword;
    _isButtonEnabled = storedPassword.trim().isNotEmpty;
    _loadProfileEmail();
  }

  Future<void> _loadProfileEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final profileEmail = prefs.getString('userEmail');
    if (!mounted || profileEmail == null || profileEmail.isEmpty) {
      return;
    }
    setState(() {
      _email = profileEmail;
      _emailController.text = profileEmail;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final sheetBackground =
        isDarkTheme ? AppColors.dynamicCard : const Color(0xFFF9F4F2);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          DesignTokens.spacing.lg,
          DesignTokens.spacing.md,
          DesignTokens.spacing.lg,
          DesignTokens.spacing.lg,
        ),
        decoration: BoxDecoration(
          color: sheetBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'App Store',
                  style: DesignTokens.typography.titleMediumStyle.copyWith(
                    color: AppColors.dynamicTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.dynamicTextSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: DesignTokens.spacing.lg),
            Text(
              'Вход в аккаунт',
              style: DesignTokens.typography.titleLargeStyle.copyWith(
                color: AppColors.dynamicTextPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacing.sm),
            Text(
              'Войдите в свой аккаунт для доступа к подписке',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacing.xl),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                labelStyle: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicTextSecondary,
                ),
                floatingLabelStyle:
                    DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicTextPrimary,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.dynamicBorder.withValues(alpha: 0.6),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.button,
                    width: 2,
                  ),
                ),
                filled: false,
              ),
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextPrimary,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.lg),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              onChanged: (value) {
                setState(() {
                  _isButtonEnabled = value.trim().isNotEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Пароль',
                prefixIcon: const Icon(Icons.lock_outline),
                labelStyle: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicTextSecondary,
                ),
                floatingLabelStyle:
                    DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicTextPrimary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.dynamicTextSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.dynamicBorder.withValues(alpha: 0.6),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.button,
                    width: 2,
                  ),
                ),
                filled: false,
              ),
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextPrimary,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  disabledBackgroundColor:
                      AppColors.dynamicBorder.withValues(alpha: 0.4),
                  disabledForegroundColor:
                      AppColors.dynamicTextSecondary.withValues(alpha: 0.7),
                ),
                child: const Text(
                  'Подтвердить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: DesignTokens.spacing.md),
          ],
        ),
      ),
    );
  }
}

class _RestorePurchasesSheet extends StatefulWidget {
  const _RestorePurchasesSheet();

  @override
  State<_RestorePurchasesSheet> createState() => _RestorePurchasesSheetState();
}

class _RestorePurchasesSheetState extends State<_RestorePurchasesSheet> {
  bool _isLoading = false;
  bool _isSuccess = false;

  Future<void> _restorePurchases() async {
    setState(() {
      _isLoading = true;
      _isSuccess = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          DesignTokens.spacing.lg,
          DesignTokens.spacing.md,
          DesignTokens.spacing.lg,
          DesignTokens.spacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.dynamicCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Восстановить покупки',
                  style: DesignTokens.typography.titleMediumStyle.copyWith(
                    color: AppColors.dynamicTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.dynamicTextSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: DesignTokens.spacing.md),
            Text(
              'Если вы уже приобретали подписку, восстановите покупки, чтобы вернуть доступ к Premium.',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.lg),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(DesignTokens.spacing.lg),
              decoration: BoxDecoration(
                color: AppColors.dynamicSurfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.dynamicPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restore,
                      color: AppColors.dynamicPrimary,
                    ),
                  ),
                  SizedBox(width: DesignTokens.spacing.md),
                  Expanded(
                    child: Text(
                      _isSuccess
                          ? 'Покупки восстановлены. Premium снова доступен.'
                          : 'Готово к восстановлению',
                      style: DesignTokens.typography.bodyMediumStyle.copyWith(
                        color: _isSuccess
                            ? AppColors.dynamicSuccess
                            : AppColors.dynamicTextPrimary,
                        fontWeight:
                            _isSuccess ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: DesignTokens.spacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _restorePurchases,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  disabledBackgroundColor:
                      AppColors.dynamicBorder.withValues(alpha: 0.4),
                  disabledForegroundColor:
                      AppColors.dynamicTextSecondary.withValues(alpha: 0.7),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Восстановить покупки'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
