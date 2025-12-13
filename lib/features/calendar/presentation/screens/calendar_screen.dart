import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../../domain/entities/calendar_event.dart';
import '../../data/services/calendar_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int selectedDay = DateTime.now().day;
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<CalendarEvent> events = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final fetched = CalendarService.getMockEvents();
      setState(() {
        events = fetched;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  List<CalendarEvent> get eventsForSelectedDay {
    return events
        .where((e) =>
            e.dateTime.year == selectedMonth.year &&
            e.dateTime.month == selectedMonth.month &&
            e.dateTime.day == selectedDay)
        .toList();
  }

  Map<int, List<CalendarEvent>> get eventsByDay {
    final map = <int, List<CalendarEvent>>{};
    for (final e in events) {
      if (e.dateTime.year == selectedMonth.year &&
          e.dateTime.month == selectedMonth.month) {
        map.putIfAbsent(e.dateTime.day, () => []).add(e);
      }
    }
    return map;
  }

  String _monthName(int month) {
    const months = [
      '',
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ];
    return months[month];
  }

  String _weekdayName(int weekday) {
    const weekdays = [
      '',
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье'
    ];
    return weekdays[weekday];
  }

  Color _categoryColor(String category) {
    if (category == 'Зелёные') return context.success;
    if (category == 'Злаки') return context.nutritionCarbs;
    if (category == 'Фрукты') return context.tertiary;
    return context.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Календарь',
          style: TextStyle(
            color: context.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: context.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Text('Ошибка: $error',
                        style: TextStyle(color: context.onSurface)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // Карточки-статистика
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.restaurant_menu,
                                label: 'Планирование\nпитания',
                                count: events
                                    .where((e) => e.category == 'Meal Planning')
                                    .length,
                                color: context.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.directions_run,
                                label: 'Физическая\nактивность',
                                count: events
                                    .where((e) =>
                                        e.category == 'Physical Activities')
                                    .length,
                                color: context.warning,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.event,
                                label: 'Встречи\nи события',
                                count: events
                                    .where((e) => e.category == 'Appointments')
                                    .length,
                                color: context.tertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Фильтры и селектор месяца
                        Row(
                          children: [
                            // Селектор месяца
                            Flexible(
                              flex: 2,
                              child: PopupMenuButton<int>(
                                onSelected: (month) {
                                  setState(() {
                                    selectedMonth =
                                        DateTime(selectedMonth.year, month);
                                  });
                                },
                                itemBuilder: (context) =>
                                    List.generate(12, (index) {
                                  final month = index + 1;
                                  final isSelected =
                                      month == selectedMonth.month;
                                  return PopupMenuItem<int>(
                                    value: month,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _monthName(month),
                                            style: TextStyle(
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              color: isSelected
                                                  ? context.primary
                                                  : context.onSurface,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(Icons.check,
                                              color: context.primary, size: 18),
                                      ],
                                    ),
                                  );
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: context.surface,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: context.outline),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          _monthName(selectedMonth.month),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: context.onSurface,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.keyboard_arrow_down,
                                          color: context.onSurfaceVariant,
                                          size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Селектор года
                            Flexible(
                              flex: 1,
                              child: PopupMenuButton<int>(
                                onSelected: (year) {
                                  setState(() {
                                    selectedMonth =
                                        DateTime(year, selectedMonth.month);
                                  });
                                },
                                itemBuilder: (context) {
                                  final currentYear = DateTime.now().year;
                                  final years = List.generate(
                                      5, (index) => currentYear - 1 + index);
                                  return years.map((year) {
                                    final isSelected =
                                        year == selectedMonth.year;
                                    return PopupMenuItem<int>(
                                      value: year,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              year.toString(),
                                              style: TextStyle(
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: isSelected
                                                    ? context.primary
                                                    : context.onSurface,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(Icons.check,
                                                color: context.primary,
                                                size: 18),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: context.surface,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: context.outline),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedMonth.year.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: context.onSurface,
                                        ),
                                      ),
                                      Icon(Icons.keyboard_arrow_down,
                                          color: context.onSurfaceVariant,
                                          size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Кнопка добавления события
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add,
                                    color: context.onPrimary, size: 18),
                                onPressed: () {},
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(
                                    minWidth: 28, minHeight: 28),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Чекбоксы-фильтры
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterChip(
                                label: 'Планирование питания',
                                color: context.primary,
                                isSelected: true,
                              ),
                              const SizedBox(width: 8),
                              _FilterChip(
                                label: 'Физическая активность',
                                color: context.warning,
                                isSelected: true,
                              ),
                              const SizedBox(width: 8),
                              _FilterChip(
                                label: 'Встречи',
                                color: context.tertiary,
                                isSelected: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Календарная сетка
                        _CalendarGrid(
                          selectedDay: selectedDay,
                          selectedMonth: selectedMonth,
                          onSelect: (day) => setState(() => selectedDay = day),
                          eventsByDay: eventsByDay,
                        ),
                        const SizedBox(height: 24),
                        // Schedule Details
                        Text(
                          'Детали расписания',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: context.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (eventsForSelectedDay.isEmpty)
                          Text('Нет событий на этот день',
                              style:
                                  TextStyle(color: context.onSurfaceVariant)),
                        ...eventsForSelectedDay.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _EventCard(
                                category: e.category,
                                categoryColor: _categoryColor(e.category),
                                title: e.title,
                                date:
                                    '${_weekdayName(e.dateTime.weekday)}, ${e.dateTime.day} ${_monthName(e.dateTime.month)} ${e.dateTime.year}',
                                time: TimeOfDay.fromDateTime(e.dateTime)
                                    .format(context),
                                location: e.location ?? '',
                                note: e.note ?? '',
                              ),
                            )),
                        const SizedBox(height: 32),
                        // Footer
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Copyright © 2024 Peterdraw',
                                style: TextStyle(
                                  color: context.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _FooterLink(
                                        text: 'Политика конфиденциальности'),
                                    Text(' · ',
                                        style: TextStyle(
                                            color: context.onSurfaceVariant)),
                                    _FooterLink(text: 'Условия использования'),
                                    Text(' · ',
                                        style: TextStyle(
                                            color: context.onSurfaceVariant)),
                                    _FooterLink(text: 'Контакты'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _SocialIcon(
                                      icon: Icons.facebook,
                                      color: context.info),
                                  _SocialIcon(
                                      icon: Icons.message, color: context.info),
                                  _SocialIcon(
                                      icon: Icons.camera_alt,
                                      color: context.nutritionProtein),
                                  _SocialIcon(
                                      icon: Icons.play_arrow,
                                      color: context.error),
                                  _SocialIcon(
                                      icon: Icons.link, color: context.primary),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dynamicShadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dynamicTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.dynamicTextSecondary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;

  const _FilterChip({
    required this.label,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final int selectedDay;
  final DateTime selectedMonth;
  final ValueChanged<int> onSelect;
  final Map<int, List<CalendarEvent>> eventsByDay;

  const _CalendarGrid({
    required this.selectedDay,
    required this.selectedMonth,
    required this.onSelect,
    required this.eventsByDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dynamicShadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб']
                .map((day) => SizedBox(
                      width: 32,
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            6,
            (week) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  7,
                  (day) {
                    // Вычисляем первый день месяца и количество дней в месяце
                    final firstDayOfMonth =
                        DateTime(selectedMonth.year, selectedMonth.month, 1);
                    final lastDayOfMonth = DateTime(
                        selectedMonth.year, selectedMonth.month + 1, 0);
                    final daysInMonth = lastDayOfMonth.day;

                    // Вычисляем день недели для первого дня месяца (1 = понедельник, 7 = воскресенье)
                    final firstWeekday = firstDayOfMonth.weekday;

                    // Вычисляем номер дня в месяце
                    final dayInMonth = week * 7 + day - (firstWeekday - 1) + 1;

                    if (dayInMonth < 1 || dayInMonth > daysInMonth) {
                      return const SizedBox(width: 32);
                    }

                    final hasEvent =
                        eventsByDay[dayInMonth]?.isNotEmpty ?? false;
                    final isSelected = dayInMonth == selectedDay;

                    return GestureDetector(
                      onTap: () => onSelect(dayInMonth),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.primary.withValues(alpha: 0.1)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: context.primary, width: 1.5)
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              dayInMonth.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? context.primary
                                    : context.onSurface,
                              ),
                            ),
                            if (hasEvent)
                              Positioned(
                                bottom: 4,
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: context.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final String title;
  final String date;
  final String time;
  final String location;
  final String note;

  const _EventCard({
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: categoryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _EventInfoRow(icon: Icons.calendar_today, text: date),
          const SizedBox(height: 8),
          _EventInfoRow(icon: Icons.access_time, text: time),
          const SizedBox(height: 8),
          _EventInfoRow(icon: Icons.location_on, text: location),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.outlineVariant),
            ),
            child: Text(
              note,
              style: TextStyle(
                fontSize: 13,
                color: context.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.primary,
                  side: BorderSide(color: context.primary),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Редактировать'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: context.primary,
                  backgroundColor: context.primary.withValues(alpha: 0.1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Удалить'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EventInfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: context.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: context.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SocialIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, size: 20),
      color: color,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }
}
