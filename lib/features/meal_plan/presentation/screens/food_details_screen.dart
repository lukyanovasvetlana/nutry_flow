import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'nutrition_edit_screen.dart';

class FoodDetailsScreen extends StatefulWidget {
  final String foodName;
  final String mealType;

  const FoodDetailsScreen({
    super.key,
    required this.foodName,
    required this.mealType,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

enum _AllergenSelection {
  allowed,
  blocked,
  unknown,
}

class _AllergenItem {
  final String label;
  final IconData icon;

  const _AllergenItem(this.label, this.icon);
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  final TextEditingController _quantityController =
      TextEditingController(text: '100');
  final TextEditingController _unitController =
      TextEditingController(text: 'г');
  final GlobalKey _unitKey = GlobalKey();
  bool _showAllergens = false;

  static const List<String> _unitOptions = ['г', 'мл'];
  static const List<_AllergenItem> _allergens = [
    _AllergenItem('Молоко', Icons.local_drink),
    _AllergenItem('Яйца', Icons.egg),
    _AllergenItem('Глютен', Icons.bakery_dining),
    _AllergenItem('Моллюски', Icons.set_meal),
    _AllergenItem('Лактоза', Icons.icecream),
    _AllergenItem('Кунжут', Icons.grass),
    _AllergenItem('Рыба', Icons.set_meal),
    _AllergenItem('Соя', Icons.spa),
    _AllergenItem('Орехи', Icons.nature),
    _AllergenItem('Арахис', Icons.nature_people),
  ];
  final Map<String, _AllergenSelection> _allergenSelections = {};

  final Map<String, num> _nutritionPer100 = const {
    'calories': 393,
    'fat': 20,
    'carbs': 46,
    'protein': 6,
  };

  @override
  void dispose() {
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  double get _portion {
    final value =
        double.tryParse(_quantityController.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      return 100;
    }
    return value;
  }

  num _scaledValue(num base) => base * _portion / 100;

  String _formatNum(num value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.foodName,
          style: DesignTokens.typography.titleMediumStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/food_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.dynamicBackground.withValues(alpha: 0.9),
                    AppColors.dynamicBackground.withValues(alpha: 0.82),
                    AppColors.dynamicBackground.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(DesignTokens.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPortionStack(),
                SizedBox(height: DesignTokens.spacing.md),
                _buildSaveButton(),
                SizedBox(height: DesignTokens.spacing.md),
                _buildAllergensButton(),
                if (_showAllergens) ...[
                  SizedBox(height: DesignTokens.spacing.md),
                  _buildAllergensDropdown(),
                ],
                SizedBox(height: DesignTokens.spacing.lg),
                _buildNutritionSection(),
                SizedBox(height: DesignTokens.spacing.lg),
                _buildNutritionEditSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortionStack() {
    return Column(
      children: [
        _buildPortionCard(
          child: InkWell(
            onTap: _showQuantityCalculator,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _quantityController.text,
                style: DesignTokens.typography.titleMediumStyle.copyWith(
                  color: AppColors.dynamicTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        _buildUnitCard(),
      ],
    );
  }

  Widget _buildPortionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dynamicPrimary.withValues(alpha: 0.2),
        ),
        boxShadow: DesignTokens.shadows.md,
      ),
      child: child,
    );
  }

  Widget _buildUnitCard() {
    return KeyedSubtree(
      key: _unitKey,
      child: _buildPortionCard(
        child: Row(
          children: [
            Icon(
              Icons.list_alt,
              color: AppColors.dynamicPrimary,
              size: 18,
            ),
            SizedBox(width: DesignTokens.spacing.sm),
            Expanded(
              child: InkWell(
                onTap: _showUnitMenu,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _unitController.text,
                          style:
                              DesignTokens.typography.bodyLargeStyle.copyWith(
                            color: AppColors.dynamicTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.dynamicTextSecondary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop({
            'mealType': widget.mealType,
            'foodName': widget.foodName,
            'quantity': _portion,
            'unit': _unitController.text.trim().isEmpty
                ? 'г'
                : _unitController.text.trim(),
            'calories': _scaledValue(_nutritionPer100['calories'] ?? 0),
            'fat': _scaledValue(_nutritionPer100['fat'] ?? 0),
            'carbs': _scaledValue(_nutritionPer100['carbs'] ?? 0),
            'protein': _scaledValue(_nutritionPer100['protein'] ?? 0),
          });
        },
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
        child: Text(
          'Сохранить',
          style: DesignTokens.typography.bodyLargeStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAllergensButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            _showAllergens = !_showAllergens;
          });
        },
        child: Text(
          _showAllergens ? 'Скрыть аллергены' : 'Показать аллергены',
          style: DesignTokens.typography.bodyMediumStyle.copyWith(
            color: AppColors.dynamicPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAllergensDropdown() {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacing.md),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
        border: Border.all(
          color: AppColors.dynamicBorder.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: _allergens.map(_buildAllergenRow).toList(),
      ),
    );
  }

  Widget _buildAllergenRow(_AllergenItem item) {
    final selection =
        _allergenSelections[item.label] ?? _AllergenSelection.unknown;
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.spacing.sm),
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing.md,
        vertical: DesignTokens.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
        border: Border.all(
          color: AppColors.dynamicBorder.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.dynamicSurface.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: AppColors.dynamicPrimary,
              size: 18,
            ),
          ),
          SizedBox(width: DesignTokens.spacing.sm),
          Expanded(
            child: Text(
              item.label,
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildAllergenChoiceButton(
            icon: Icons.check,
            isSelected: selection == _AllergenSelection.allowed,
            color: AppColors.dynamicPrimary,
            onTap: () => _setAllergenSelection(
              item.label,
              _AllergenSelection.allowed,
            ),
          ),
          SizedBox(width: DesignTokens.spacing.xs),
          _buildAllergenChoiceButton(
            icon: Icons.close,
            isSelected: selection == _AllergenSelection.blocked,
            color: AppColors.dynamicError,
            onTap: () => _setAllergenSelection(
              item.label,
              _AllergenSelection.blocked,
            ),
          ),
          SizedBox(width: DesignTokens.spacing.xs),
          _buildAllergenChoiceButton(
            icon: Icons.help_outline,
            isSelected: selection == _AllergenSelection.unknown,
            color: AppColors.dynamicWarning,
            onTap: () => _setAllergenSelection(
              item.label,
              _AllergenSelection.unknown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergenChoiceButton({
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color:
              isSelected ? color.withValues(alpha: 0.16) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? color : AppColors.dynamicBorder,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? color : AppColors.dynamicTextSecondary,
        ),
      ),
    );
  }

  void _setAllergenSelection(String label, _AllergenSelection selection) {
    setState(() {
      _allergenSelections[label] = selection;
    });
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Питательная ценность',
          style: DesignTokens.typography.headlineSmallStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        _buildNutritionRow(
          label: 'Порция',
          value:
              '${_formatNum(_portion)} ${_unitController.text.trim().isEmpty ? 'г' : _unitController.text.trim()}',
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        _buildProgressBar(),
        SizedBox(height: DesignTokens.spacing.sm),
        Text(
          'в порции',
          style: DesignTokens.typography.bodySmallStyle.copyWith(
            color: AppColors.dynamicTextSecondary,
          ),
        ),
        SizedBox(height: DesignTokens.spacing.sm),
        _buildNutritionRow(
          label: 'Энергетическая ценность',
          value:
              '${_formatNum(_scaledValue(_nutritionPer100['calories'] ?? 0))} ккал',
        ),
        _buildNutritionRow(
          label: 'Жир',
          value: '${_formatNum(_scaledValue(_nutritionPer100['fat'] ?? 0))}г',
        ),
        _buildNutritionRow(
          label: 'Углеводы',
          value: '${_formatNum(_scaledValue(_nutritionPer100['carbs'] ?? 0))}г',
        ),
        _buildNutritionRow(
          label: 'Белок',
          value:
              '${_formatNum(_scaledValue(_nutritionPer100['protein'] ?? 0))}г',
        ),
      ],
    );
  }

  Widget _buildNutritionRow({required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.dynamicBorder.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: (_portion / 100).clamp(0.1, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.dynamicBorder.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionEditSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Является ли эта информация точной и актуальной?',
          style: DesignTokens.typography.bodySmallStyle.copyWith(
            color: AppColors.dynamicTextSecondary,
          ),
        ),
        SizedBox(height: DesignTokens.spacing.xxxl),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NutritionEditScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.dynamicPrimary),
              minimumSize: Size(
                double.infinity,
                DesignTokens.spacing.buttonHeightLarge,
              ),
              padding: EdgeInsets.symmetric(vertical: DesignTokens.spacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.borders.full),
              ),
            ),
            child: Text(
              'Изменить пищевую ценность',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showUnitMenu() async {
    final renderBox = _unitKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (renderBox == null || overlay == null) return;

    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final left = position.dx;
    final top = position.dy + renderBox.size.height;
    final right = overlay.size.width - left - renderBox.size.width;
    final bottom = overlay.size.height - top;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      color: AppColors.dynamicCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
      ),
      items: _unitOptions
          .map(
            (unit) => PopupMenuItem<String>(
              value: unit,
              child: Text(
                unit,
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );

    if (selected != null && mounted) {
      setState(() {
        _unitController.text = selected;
      });
    }
  }

  Future<void> _showQuantityCalculator() async {
    String buffer = '0';

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.dynamicBackground,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.borders.xl),
        ),
      ),
      builder: (context) {
        final sheetHeight = MediaQuery.of(context).size.height * 0.45;
        return StatefulBuilder(
          builder: (context, setModalState) {
            void append(String value) {
              setModalState(() {
                final isDecimal = value == ',' || value == '.';
                if (isDecimal) {
                  if (buffer.contains(',') || buffer.contains('.')) return;
                  if (buffer == '0') {
                    buffer = '0,';
                    return;
                  }
                }

                if (buffer == '0') {
                  buffer = value;
                } else {
                  buffer += value;
                }
              });
            }

            void remove() {
              setModalState(() {
                if (buffer.length <= 1) {
                  buffer = '0';
                } else {
                  buffer = buffer.substring(0, buffer.length - 1);
                }
              });
            }

            void clear() {
              setModalState(() {
                buffer = '0';
              });
            }

            return SafeArea(
              top: false,
              child: SizedBox(
                height: sheetHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing.lg,
                    vertical: DesignTokens.spacing.md,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 4,
                        margin:
                            EdgeInsets.only(bottom: DesignTokens.spacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.dynamicBorder.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Text(
                        buffer,
                        style:
                            DesignTokens.typography.headlineLargeStyle.copyWith(
                          color: AppColors.dynamicTextPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacing.md),
                      Expanded(
                        child: _buildCalculatorGrid(
                          onDigit: append,
                          onBackspace: remove,
                          onClear: clear,
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(buffer),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dynamicPrimary,
                            foregroundColor: Colors.white,
                            minimumSize: Size(
                              double.infinity,
                              DesignTokens.spacing.buttonHeightLarge,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: DesignTokens.spacing.sm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                DesignTokens.borders.full,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Готово',
                            style:
                                DesignTokens.typography.bodyLargeStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        _quantityController.text = result;
      });
    }
  }

  Widget _buildCalculatorGrid({
    required void Function(String) onDigit,
    required VoidCallback onBackspace,
    required VoidCallback onClear,
  }) {
    Widget buildKey(String label, {String? letters, VoidCallback? onTap}) {
      return InkWell(
        onTap: onTap ?? () => onDigit(label),
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.dynamicCard.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(DesignTokens.borders.md),
            border: Border.all(
              color: AppColors.dynamicBorder.withValues(alpha: 0.2),
            ),
            boxShadow: DesignTokens.shadows.xs,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: DesignTokens.typography.titleMediumStyle.copyWith(
                  color: AppColors.dynamicTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (letters != null)
                Text(
                  letters,
                  style: DesignTokens.typography.labelSmallStyle.copyWith(
                    color: AppColors.dynamicTextSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    Widget buildBackspace() {
      return InkWell(
        onTap: onBackspace,
        onLongPress: onClear,
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.dynamicCard.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(DesignTokens.borders.md),
            border: Border.all(
              color: AppColors.dynamicBorder.withValues(alpha: 0.2),
            ),
            boxShadow: DesignTokens.shadows.xs,
          ),
          child: Icon(
            Icons.backspace_outlined,
            color: AppColors.dynamicTextPrimary,
          ),
        ),
      );
    }

    final keys = [
      () => buildKey('1'),
      () => buildKey('2', letters: 'ABC'),
      () => buildKey('3', letters: 'DEF'),
      () => buildKey('4', letters: 'GHI'),
      () => buildKey('5', letters: 'JKL'),
      () => buildKey('6', letters: 'MNO'),
      () => buildKey('7', letters: 'PQRS'),
      () => buildKey('8', letters: 'TUV'),
      () => buildKey('9', letters: 'WXYZ'),
      () => buildKey(',', onTap: () => onDigit(',')),
      () => buildKey('0'),
      buildBackspace,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = DesignTokens.spacing.sm;
        final totalVSpacing = spacing * 3;
        final totalHSpacing = spacing * 2;
        final itemHeight = (constraints.maxHeight - totalVSpacing) / 4;
        final itemWidth = (constraints.maxWidth - totalHSpacing) / 3;
        final aspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: keys.length,
          itemBuilder: (context, index) => keys[index](),
        );
      },
    );
  }
}
