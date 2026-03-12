import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Общий виджет выбора даты рождения (День — Месяц — Год)
/// с кнопками «Отмена» и «Готово», как на экране профиля.
class DatePickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime) onDateSelected;
  final Color? accentColor;

  const DatePickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.accentColor,
  });

  /// Показать bottom sheet с выбором даты
  static Future<void> show(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required void Function(DateTime) onDateSelected,
    Color? accentColor,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DatePickerBottomSheet(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        onDateSelected: onDateSelected,
        accentColor: accentColor,
      ),
    );
  }

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;
  late List<int> availableDays;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;
  int selectedDayIndex = 0;
  int selectedMonthIndex = 0;
  int selectedYearIndex = 0;

  Color get _accentColor => widget.accentColor ?? AppColors.dynamicPrimary;

  static const List<String> _monthNames = [
    'Янв',
    'Фев',
    'Мар',
    'Апр',
    'Май',
    'Июн',
    'Июл',
    'Авг',
    'Сен',
    'Окт',
    'Ноя',
    'Дек',
  ];

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDate.day;
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year.clamp(
      widget.firstDate.year,
      widget.lastDate.year,
    );
    availableDays = _getDaysInMonth(selectedYear, selectedMonth);
    if (selectedDay > availableDays.length) {
      selectedDay = availableDays.length;
    }
    if (selectedDay < 1 && availableDays.isNotEmpty) {
      selectedDay = 1;
    }

    final dayIndex = availableDays.indexOf(selectedDay);
    selectedDayIndex =
        dayIndex >= 0 && dayIndex < availableDays.length ? dayIndex : 0;
    dayController = FixedExtentScrollController(initialItem: selectedDayIndex);

    selectedMonthIndex = (selectedMonth - 1).clamp(0, 11);
    monthController = FixedExtentScrollController(
      initialItem: selectedMonthIndex,
    );

    final years = _getYears();
    final yearIndex = years.indexOf(selectedYear);
    selectedYearIndex =
        yearIndex >= 0 && yearIndex < years.length ? yearIndex : 0;
    yearController = FixedExtentScrollController(
      initialItem: selectedYearIndex,
    );
  }

  List<int> _getYears() {
    return List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    );
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  List<int> _getDaysInMonth(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  void _updateDays() {
    final newDays = _getDaysInMonth(selectedYear, selectedMonth);
    if (newDays.length != availableDays.length ||
        !newDays.contains(selectedDay)) {
      setState(() {
        availableDays = newDays;
        if (selectedDay > availableDays.length) {
          selectedDay = availableDays.length;
        }
        final dayIndex = availableDays.indexOf(selectedDay);
        if (dayIndex >= 0 && dayIndex < availableDays.length) {
          selectedDayIndex = dayIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              dayController.jumpToItem(dayIndex);
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final years = _getYears();
    final months = List.generate(12, (index) => index + 1);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Отмена',
                    style: TextStyle(color: AppColors.dynamicTextSecondary),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Выберите дату рождения',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _accentColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final selectedDate =
                        DateTime(selectedYear, selectedMonth, selectedDay);
                    if (selectedDate.isAfter(widget.lastDate) ||
                        selectedDate.isBefore(widget.firstDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Выбранная дата вне допустимого диапазона',
                          ),
                        ),
                      );
                      return;
                    }
                    widget.onDateSelected(selectedDate);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Готово',
                    style: TextStyle(
                      color: _accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: _accentColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: _accentColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: availableDays.isEmpty
                          ? const Center(child: Text('Нет данных'))
                          : CupertinoPicker(
                              scrollController: dayController,
                              itemExtent: 40,
                              diameterRatio: 1.0,
                              useMagnifier: true,
                              magnification: 1.0,
                              onSelectedItemChanged: (index) {
                                if (index >= 0 &&
                                    index < availableDays.length) {
                                  setState(() {
                                    selectedDay = availableDays[index];
                                    selectedDayIndex = index;
                                  });
                                }
                              },
                              children: availableDays.asMap().entries.map(
                                (entry) {
                                  final index = entry.key;
                                  final day = entry.value;
                                  final isSelected = index == selectedDayIndex;
                                  return Center(
                                    child: Text(
                                      day.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? _accentColor
                                            : AppColors.dynamicTextPrimary,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                    ),
                    Expanded(
                      child: months.isEmpty
                          ? const Center(child: Text('Нет данных'))
                          : CupertinoPicker(
                              scrollController: monthController,
                              itemExtent: 40,
                              diameterRatio: 1.0,
                              useMagnifier: true,
                              magnification: 1.0,
                              onSelectedItemChanged: (index) {
                                if (index >= 0 && index < months.length) {
                                  setState(() {
                                    selectedMonth = months[index];
                                    selectedMonthIndex = index;
                                    _updateDays();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        final dayIndex =
                                            availableDays.indexOf(selectedDay);
                                        if (dayIndex >= 0 &&
                                            dayIndex < availableDays.length) {
                                          selectedDayIndex = dayIndex;
                                          dayController.jumpToItem(dayIndex);
                                        }
                                      }
                                    });
                                  });
                                }
                              },
                              children: months.asMap().entries.map((entry) {
                                final index = entry.key;
                                final month = entry.value;
                                final isSelected = index == selectedMonthIndex;
                                return Center(
                                  child: Text(
                                    _monthNames[month - 1],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? _accentColor
                                          : AppColors.dynamicTextPrimary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    Expanded(
                      child: years.isEmpty
                          ? const Center(child: Text('Нет данных'))
                          : CupertinoPicker(
                              scrollController: yearController,
                              itemExtent: 40,
                              diameterRatio: 1.0,
                              useMagnifier: true,
                              magnification: 1.0,
                              onSelectedItemChanged: (index) {
                                if (index >= 0 && index < years.length) {
                                  setState(() {
                                    selectedYear = years[index];
                                    selectedYearIndex = index;
                                    _updateDays();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        final dayIndex =
                                            availableDays.indexOf(selectedDay);
                                        if (dayIndex >= 0 &&
                                            dayIndex < availableDays.length) {
                                          selectedDayIndex = dayIndex;
                                          dayController.jumpToItem(dayIndex);
                                        }
                                      }
                                    });
                                  });
                                }
                              },
                              children: years.asMap().entries.map((entry) {
                                final index = entry.key;
                                final year = entry.value;
                                final isSelected = index == selectedYearIndex;
                                return Center(
                                  child: Text(
                                    year.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? _accentColor
                                          : AppColors.dynamicTextPrimary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
