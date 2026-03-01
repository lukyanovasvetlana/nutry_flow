import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutry_flow/shared/design/components/buttons/nutry_save_button.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

final NumberFormat _kilojoulesFormat = NumberFormat('0.#');

String _formatKilojoules(String caloriesText) {
  final normalized = caloriesText.replaceAll(',', '.');
  final value = double.tryParse(normalized) ?? 0;
  final kilojoules = value * 4.184;
  return _kilojoulesFormat.format(kilojoules);
}

String _formatCalories(String caloriesText) {
  final normalized = caloriesText.replaceAll(',', '.');
  final value = double.tryParse(normalized) ?? 0;
  return _kilojoulesFormat.format(value);
}

class NutritionEditScreen extends StatefulWidget {
  const NutritionEditScreen({super.key});

  @override
  State<NutritionEditScreen> createState() => _NutritionEditScreenState();
}

class _NutritionEditScreenState extends State<NutritionEditScreen> {
  final String _portionValue = '100';
  String _caloriesValue = '0';
  String _portionUnit = 'г';
  bool _isCaloriesError = false;
  final Map<int, String> _nutritionValues = {};
  final Set<int> _activeFields = {};
  final Set<int> _errorFields = {};
  bool _showKilojoulesMain = false;

  static const _items = <_NutritionItem>[
    _NutritionItem('Граммы', Icons.straighten, AppColors.orange),
    _NutritionItem('Калории', Icons.local_fire_department, AppColors.orange),
    _NutritionItem('Всего жиров (граммы)', Icons.water_drop, AppColors.orange),
    _NutritionItem(
      'Насыщенные жиры (граммы)',
      Icons.water_drop,
      AppColors.orange,
    ),
    _NutritionItem('Транс-жиры', Icons.water_drop, AppColors.orange),
    _NutritionItem(
      'Мононенасыщенные жиры (граммы)',
      Icons.water_drop,
      AppColors.orange,
    ),
    _NutritionItem(
      'Полиненасыщенные жиры (граммы)',
      Icons.water_drop,
      AppColors.orange,
    ),
    _NutritionItem('Всего углеводов (граммы)', Icons.grain, AppColors.yellow),
    _NutritionItem('Сахар (граммы)', Icons.cake, AppColors.yellow),
    _NutritionItem(
      'Диетическая клетчатка (граммы)',
      Icons.eco,
      AppColors.green,
    ),
    _NutritionItem('Белок (граммы)', Icons.fitness_center, AppColors.purple),
    _NutritionItem('Натрий (миллиграммы)', Icons.opacity, AppColors.blue),
    _NutritionItem(
        'Холестерин (миллиграммы)', Icons.bubble_chart, AppColors.blue),
    _NutritionItem('Калий (миллиграммы)', Icons.bubble_chart, AppColors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Изменить пищевую ценность',
          style: DesignTokens.typography.titleMediumStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing.lg,
            vertical: DesignTokens.spacing.md,
          ),
          itemBuilder: (context, index) {
            if (index == _items.length) {
              return NutrySaveButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            }

            String? label;
            if (index == 0) {
              label = 'РАЗМЕР ПОРЦИИ';
            } else if (index == 1) {
              label = 'ЭНЕРГЕТИЧЕСКАЯ ЦЕННОСТЬ';
            } else if (index == 2) {
              label = 'ЖИРЫ';
            } else if (index == 7) {
              label = 'УГЛЕВОДЫ';
            } else if (index == 10) {
              label = 'БЕЛОК';
            }

            final caloriesDisplay = _formatCalories(_caloriesValue);
            final kilojoulesDisplay = _formatKilojoules(_caloriesValue);
            final mainValue =
                _showKilojoulesMain ? kilojoulesDisplay : caloriesDisplay;
            final mainUnit = _showKilojoulesMain ? 'кДж' : 'кал';
            final conversionValue =
                _showKilojoulesMain ? caloriesDisplay : kilojoulesDisplay;
            final conversionUnit = _showKilojoulesMain ? 'кал' : 'кДж';

            final isEditableField = _isEditableField(index);
            final unitForField = _unitForIndex(index);
            final fieldValue = _nutritionValues[index] ?? '0';

            final content = index == 0
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _NutritionValueBox(
                          color: _items[index].color,
                          value: _portionValue,
                        ),
                        SizedBox(width: DesignTokens.spacing.sm),
                        Expanded(
                          child: _NutritionCard(
                            item: _items[index],
                            titleOverride:
                                _portionUnit == 'г' ? 'Граммы' : 'Миллилитры',
                            trailing: _buildUnitMenuButton(_items[index].color),
                          ),
                        ),
                      ],
                    ),
                  )
                : _NutritionCard(
                    item: _items[index],
                    subtitleValue: index == 1
                        ? mainValue
                        : isEditableField && _activeFields.contains(index)
                            ? fieldValue
                            : null,
                    subtitleUnitText: index == 1
                        ? mainUnit
                        : isEditableField && _activeFields.contains(index)
                            ? unitForField
                            : null,
                    onSubtitleTap: index == 1
                        ? _showCaloriesCalculator
                        : isEditableField && _activeFields.contains(index)
                            ? () => _showNutritionCalculator(index)
                            : null,
                    isError: index == 1
                        ? _isCaloriesError
                        : _errorFields.contains(index),
                    hideDefaultTrailing: index == 1
                        ? _isCaloriesError
                        : _errorFields.contains(index),
                    onTap: index == 1
                        ? null
                        : () {
                            _validateActiveFields(index);
                            if (isEditableField) {
                              _activateField(index);
                            }
                          },
                    trailing: index == 1 && !_isCaloriesError
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                _caloriesValue = '0';
                                _isCaloriesError = true;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    _items[index].color.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: _items[index].color,
                              ),
                            ),
                          )
                        : isEditableField &&
                                _activeFields.contains(index) &&
                                !_errorFields.contains(index)
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    _nutritionValues[index] = '0';
                                    _errorFields.add(index);
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _items[index]
                                        .color
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: _items[index].color,
                                  ),
                                ),
                              )
                            : null,
                  );

            final contentWithConversion = index == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      content,
                      SizedBox(height: DesignTokens.spacing.xs),
                      Row(
                        children: [
                          Text(
                            '= $conversionValue $conversionUnit',
                            style: DesignTokens.typography.titleMediumStyle
                                .copyWith(
                              color: AppColors.dynamicTextSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showKilojoulesMain = !_showKilojoulesMain;
                              });
                            },
                            child: Text(
                              'Поменять ед.',
                              style: DesignTokens.typography.titleMediumStyle
                                  .copyWith(
                                color: AppColors.dynamicPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : content;

            if (label == null) {
              return contentWithConversion;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: DesignTokens.typography.bodyMediumStyle.copyWith(
                    color: AppColors.dynamicTextSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: DesignTokens.spacing.xs),
                contentWithConversion,
              ],
            );
          },
          separatorBuilder: (_, index) => SizedBox(
            height: index == _items.length - 1
                ? DesignTokens.spacing.lg
                : DesignTokens.spacing.md,
          ),
          itemCount: _items.length + 1,
        ),
      ),
    );
  }

  Widget _buildUnitMenuButton(Color color) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _portionUnit = value;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'г',
          child: Text(
            'граммы',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'мл',
          child: Text(
            'миллилитры',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      color: AppColors.dynamicCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add,
          size: 20,
          color: color,
        ),
      ),
    );
  }

  Future<void> _showCaloriesCalculator() async {
    await _showNumberCalculator(
      initialValue: _caloriesValue,
      onSubmit: (value) {
        _caloriesValue = value;
        _isCaloriesError = _isZeroValue(value);
      },
    );
  }

  void _activateField(int index) {
    setState(() {
      _activeFields.add(index);
      _nutritionValues.putIfAbsent(index, () => '0');
    });
    _showNutritionCalculator(index);
  }

  Future<void> _showNutritionCalculator(int index) async {
    await _showNumberCalculator(
      initialValue: _nutritionValues[index] ?? '0',
      onSubmit: (value) {
        _nutritionValues[index] = value;
        if (_isZeroValue(value)) {
          _errorFields.add(index);
        } else {
          _errorFields.remove(index);
        }
      },
    );
  }

  Future<void> _showNumberCalculator({
    required String initialValue,
    required void Function(String) onSubmit,
  }) async {
    String buffer = initialValue;

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
                      SizedBox(height: DesignTokens.spacing.sm),
                      Expanded(
                        child: _buildCalculatorGrid(
                          onDigit: append,
                          onBackspace: remove,
                          onClear: clear,
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacing.sm),
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
        onSubmit(result);
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

  bool _isZeroValue(String value) {
    final normalized = value.replaceAll(',', '.').trim();
    if (normalized.isEmpty) return true;
    final parsed = double.tryParse(normalized) ?? 0;
    return parsed == 0;
  }

  void _validateActiveFields(int tappedIndex) {
    if (_isZeroValue(_caloriesValue)) {
      _isCaloriesError = true;
    }
    for (final index in _activeFields) {
      if (index == tappedIndex) continue;
      final value = _nutritionValues[index] ?? '0';
      if (_isZeroValue(value)) {
        _errorFields.add(index);
      }
    }
  }

  bool _isEditableField(int index) {
    return index >= 2;
  }

  String? _unitForIndex(int index) {
    final title = _items[index].title.toLowerCase();
    if (title.contains('миллиграммы')) {
      return 'мг';
    }
    if (title.contains('граммы')) {
      return 'г';
    }
    return null;
  }
}

class _NutritionValueBox extends StatelessWidget {
  final Color color;
  final String value;

  const _NutritionValueBox({
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        value,
        style: DesignTokens.typography.bodyMediumStyle.copyWith(
          color: AppColors.dynamicTextPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NutritionItem {
  final String title;
  final IconData icon;
  final Color color;

  const _NutritionItem(this.title, this.icon, this.color);
}

class _NutritionCard extends StatelessWidget {
  final _NutritionItem item;
  final Widget? trailing;
  final String? titleOverride;
  final String? subtitleValue;
  final String? subtitleUnitText;
  final VoidCallback? onSubtitleTap;
  final VoidCallback? onTap;
  final bool isError;
  final bool hideDefaultTrailing;

  const _NutritionCard({
    required this.item,
    this.trailing,
    this.titleOverride,
    this.subtitleValue,
    this.subtitleUnitText,
    this.onSubtitleTap,
    this.onTap,
    this.isError = false,
    this.hideDefaultTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final borderColor = isError
        ? AppColors.dynamicError
        : item.color.withValues(alpha: isLightTheme ? 0.6 : 0.2);
    final backgroundColor = isError
        ? AppColors.dynamicError.withValues(alpha: 0.12)
        : AppColors.dynamicCard;

    final content = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isError
                ? AppColors.dynamicError.withValues(alpha: 0.2)
                : item.color.withValues(alpha: isLightTheme ? 0.3 : 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            item.icon,
            color: isError ? AppColors.dynamicError : item.color,
            size: 24,
          ),
        ),
        SizedBox(width: DesignTokens.spacing.md),
        Expanded(
          child: subtitleValue != null && titleOverride == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style:
                              DesignTokens.typography.labelSmallStyle.copyWith(
                            color: AppColors.dynamicTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isError)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Обязательно',
                              style: DesignTokens.typography.labelSmallStyle
                                  .copyWith(
                                color: AppColors.dynamicError,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: DesignTokens.spacing.xs),
                    InkWell(
                      onTap: onSubtitleTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            subtitleValue ?? '0',
                            style: DesignTokens.typography.titleMediumStyle
                                .copyWith(
                              color: AppColors.dynamicOnSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (subtitleUnitText != null) ...[
                            SizedBox(width: DesignTokens.spacing.xs),
                            Text(
                              subtitleUnitText!,
                              style: DesignTokens.typography.titleMediumStyle
                                  .copyWith(
                                color: AppColors.dynamicTextSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                )
              : Text(
                  titleOverride ?? item.title,
                  style: DesignTokens.typography.bodyMediumStyle.copyWith(
                    color: AppColors.dynamicOnSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
        trailing ?? const SizedBox.shrink(),
      ],
    );

    final decorated = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: isError ? 2 : 1,
        ),
        boxShadow: DesignTokens.shadows.md,
      ),
      child: content,
    );

    if (onTap == null) return decorated;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: decorated,
    );
  }
}
