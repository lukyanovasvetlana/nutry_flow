import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/features/onboarding/data/services/supabase_service.dart';
import '../../domain/entities/calendar_event.dart';
import '../../data/services/calendar_service.dart';
import '../../di/calendar_dependencies.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

/// Ключи категорий событий (соответствуют CalendarEvent.category)
const _categoryMealPlanning = 'Meal Planning';
const _categoryPhysicalActivities = 'Physical Activities';
const _categoryAppointments = 'Appointments';

class _CalendarScreenState extends State<CalendarScreen> {
  int selectedDay = DateTime.now().day;
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<CalendarEvent> events = [];
  bool isLoading = true;
  String? error;

  /// Выбранные категории для фильтрации (пусто = показывать все)
  Set<String> selectedCategories = {
    _categoryMealPlanning,
    _categoryPhysicalActivities,
    _categoryAppointments,
  };

  /// Ключи для прокрутки к первому событию категории
  final _scrollToEventKeys = <String, GlobalKey>{
    _categoryMealPlanning: GlobalKey(),
    _categoryPhysicalActivities: GlobalKey(),
    _categoryAppointments: GlobalKey(),
  };

  /// Ключи для прокрутки к чипам фильтров
  final _filterChipKeys = <String, GlobalKey>{
    _categoryMealPlanning: GlobalKey(),
    _categoryPhysicalActivities: GlobalKey(),
    _categoryAppointments: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  /// Возвращает боковые отступы в зависимости от размера экрана (как на дашборде)
  double _getResponsivePadding(double screenWidth) {
    if (screenWidth < 600) return 16.0;
    if (screenWidth < 900) return 24.0;
    if (screenWidth < 1200) return 32.0;
    return 48.0;
  }

  /// Часы по умолчанию для приёмов пищи
  static const _mealTypeHours = {
    'Завтрак': 8,
    'Обед': 13,
    'Ужин': 19,
    'Перекус/Другое': 16,
  };

  /// Загружает записи о питании из SharedPreferences и конвертирует в CalendarEvent
  Future<List<CalendarEvent>> _loadMealEntriesAsEvents([DateTime? month]) async {
    final targetMonth = month ?? selectedMonth;
    final mealEvents = <CalendarEvent>[];
    final prefs = await SharedPreferences.getInstance();
    final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
    final userId = SupabaseService.instance.getCurrentUser()?.id ?? 'local';

    for (var day = 1; day <= lastDay; day++) {
      final date = DateTime(targetMonth.year, targetMonth.month, day);
      final dateKey = date.toIso8601String().split('T')[0];
      final jsonString = prefs.getString('meal_entries_$dateKey');
      if (jsonString == null || jsonString.isEmpty) continue;

      try {
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        var order = 0;
        for (final entry in decoded.entries) {
          final mealType = entry.key as String;
          final items = entry.value;
          if (items is! List) continue;
          final hour = _mealTypeHours[mealType] ?? 9;
          for (var i = 0; i < items.length; i++) {
            final item = items[i];
            if (item is! Map<String, dynamic>) continue;
            final foodName = item['foodName'] as String? ?? item['name'] as String? ?? mealType;
            final calories = (item['calories'] as num?)?.toInt();
            final note = calories != null ? '$calories ккал' : null;
            final dateTime = DateTime(date.year, date.month, date.day, hour, 0, 0)
                .add(Duration(minutes: order * 15));
            order++;
            mealEvents.add(CalendarEvent(
              id: 'meal_${dateKey}_${mealType}_$i',
              userId: userId,
              category: _categoryMealPlanning,
              title: '$mealType: $foodName',
              dateTime: dateTime,
              note: note,
              createdAt: dateTime,
              updatedAt: dateTime,
            ));
          }
        }
      } catch (_) {}
    }
    return mealEvents;
  }

  /// Загружает записи о физической активности из SharedPreferences и конвертирует в CalendarEvent
  Future<List<CalendarEvent>> _loadActivityEntriesAsEvents([DateTime? month]) async {
    final targetMonth = month ?? selectedMonth;
    final activityEvents = <CalendarEvent>[];
    final prefs = await SharedPreferences.getInstance();
    final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
    final userId = SupabaseService.instance.getCurrentUser()?.id ?? 'local';

    for (var day = 1; day <= lastDay; day++) {
      final date = DateTime(targetMonth.year, targetMonth.month, day);
      final dateKey = date.toIso8601String().split('T')[0];
      final jsonString = prefs.getString('activity_entries_$dateKey');
      if (jsonString == null || jsonString.isEmpty) continue;

      try {
        final decoded = jsonDecode(jsonString);
        if (decoded is! List) continue;
        for (var i = 0; i < decoded.length; i++) {
          final item = decoded[i];
          if (item is! Map<String, dynamic>) continue;
          final workoutName = item['workoutName'] as String? ?? 'Тренировка';
          final duration = (item['duration'] as num?)?.toInt();
          final calories = (item['calories'] as num?)?.toInt();
          DateTime dateTime;
          try {
            final completedAt = item['completedAt'] as String?;
            dateTime = completedAt != null
                ? DateTime.parse(completedAt)
                : DateTime(date.year, date.month, date.day, 12, 0, 0);
          } catch (_) {
            dateTime = DateTime(date.year, date.month, date.day, 12, 0, 0);
          }
          final parts = <String>[];
          if (duration != null && duration > 0) parts.add('$duration мин');
          if (calories != null && calories > 0) parts.add('$calories ккал');
          final note = parts.isNotEmpty ? parts.join(', ') : null;
          activityEvents.add(CalendarEvent(
            id: 'activity_${dateKey}_$i',
            userId: userId,
            category: _categoryPhysicalActivities,
            title: workoutName,
            dateTime: dateTime,
            note: note,
            createdAt: dateTime,
            updatedAt: dateTime,
          ));
        }
      } catch (_) {}
    }
    return activityEvents;
  }

  static const _localCalendarKey = 'calendar_entries_local';

  /// Загружает локально сохранённые события (встречи) из SharedPreferences
  Future<List<CalendarEvent>> _loadLocalCalendarEvents([DateTime? month]) async {
    final targetMonth = month ?? selectedMonth;
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_localCalendarKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return [];
      final result = <CalendarEvent>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) continue;
        try {
          final event = CalendarEvent.fromJson(item);
          if (event.dateTime.year == targetMonth.year &&
              event.dateTime.month == targetMonth.month) {
            result.add(event);
          }
        } catch (_) {}
      }
      return result;
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveEventLocally(CalendarEvent event) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_localCalendarKey);
      final List<Map<String, dynamic>> list = jsonString != null
          ? (jsonDecode(jsonString) as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList()
          : [];

      final json = event.toJson();
      json['id'] = event.id.startsWith('temp_')
          ? 'local_${DateTime.now().millisecondsSinceEpoch}'
          : event.id;
      list.add(json);
      await prefs.setString(_localCalendarKey, jsonEncode(list));
    } catch (_) {}
  }

  Future<void> _updateEventLocally(CalendarEvent event) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_localCalendarKey);
      if (jsonString == null || jsonString.isEmpty) return;

      final list = (jsonDecode(jsonString) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      final idx = list.indexWhere((e) => e['id'] == event.id);
      if (idx < 0) return;
      list[idx] = event.toJson();
      await prefs.setString(_localCalendarKey, jsonEncode(list));
    } catch (_) {}
  }

  Future<void> _deleteEventLocally(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_localCalendarKey);
      if (jsonString == null || jsonString.isEmpty) return;

      final list = (jsonDecode(jsonString) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      list.removeWhere((e) => e['id'] == id);
      await prefs.setString(_localCalendarKey, jsonEncode(list));
    } catch (_) {}
  }

  bool get _isSupabaseAvailable =>
      SupabaseService.instance.isAvailable &&
      SupabaseService.instance.getCurrentUser() != null;

  Future<void> _loadEvents() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      await CalendarDependencies.instance.initialize();
      final result = await CalendarDependencies.instance.getCalendarEventsUseCase
          .execute();
      if (!mounted) return;
      List<CalendarEvent> calendarEvents;
      if (result.isSuccess) {
        calendarEvents = result.events;
      } else {
        calendarEvents = CalendarService.getMockEvents();
      }
      final mealEvents = await _loadMealEntriesAsEvents();
      final activityEvents = await _loadActivityEntriesAsEvents();
      final localEvents = await _loadLocalCalendarEvents();
      if (!mounted) return;
      setState(() {
        events = [...calendarEvents, ...mealEvents, ...activityEvents, ...localEvents];
        events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        isLoading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;
      final mealEvents = await _loadMealEntriesAsEvents();
      final activityEvents = await _loadActivityEntriesAsEvents();
      final localEvents = await _loadLocalCalendarEvents();
      if (!mounted) return;
      setState(() {
        events = [...CalendarService.getMockEvents(), ...mealEvents, ...activityEvents, ...localEvents];
        events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        isLoading = false;
        error = null;
      });
    }
  }

  bool _matchesCategoryFilter(CalendarEvent e) {
    if (selectedCategories.isEmpty) return true;
    return selectedCategories.contains(e.category);
  }

  List<CalendarEvent> get eventsForSelectedDay {
    return events
        .where((e) =>
            e.dateTime.year == selectedMonth.year &&
            e.dateTime.month == selectedMonth.month &&
            e.dateTime.day == selectedDay &&
            _matchesCategoryFilter(e))
        .toList();
  }

  Map<int, List<CalendarEvent>> get eventsByDay {
    final map = <int, List<CalendarEvent>>{};
    for (final e in events) {
      if (e.dateTime.year == selectedMonth.year &&
          e.dateTime.month == selectedMonth.month &&
          _matchesCategoryFilter(e)) {
        map.putIfAbsent(e.dateTime.day, () => []).add(e);
      }
    }
    return map;
  }

  void _toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories = Set.from(selectedCategories)..remove(category);
      } else {
        selectedCategories = Set.from(selectedCategories)..add(category);
      }
    });
  }

  /// Обработчик клика по карточке: фильтр + прокрутка к первому событию
  void _onStatCardTap(String category) {
    final wasSelected = selectedCategories.contains(category);
    _toggleCategory(category);
    if (!wasSelected) {
      // Прокрутка фильтров, чтобы чип категории был полностью виден
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final chipKey = _filterChipKeys[category];
        if (chipKey?.currentContext != null) {
          Scrollable.ensureVisible(
            chipKey!.currentContext!,
            alignment: 0.5,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
      // Прокрутка к первому событию категории
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final key = _scrollToEventKeys[category];
        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            alignment: 0.2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
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
    if (category == _categoryMealPlanning) return context.primary;
    if (category == _categoryPhysicalActivities) return context.warning;
    if (category == _categoryAppointments) return context.tertiary;
    return context.onSurfaceVariant;
  }

  String _categoryDisplayName(String category) {
    if (category == _categoryMealPlanning) return 'Планирование питания';
    if (category == _categoryPhysicalActivities) return 'Физическая активность';
    if (category == _categoryAppointments) return 'Встречи и события';
    return category;
  }

  IconData _categoryIcon(String category) {
    if (category == _categoryMealPlanning) return Icons.restaurant_menu;
    if (category == _categoryPhysicalActivities) return Icons.directions_run;
    if (category == _categoryAppointments) return Icons.event;
    return Icons.circle;
  }

  /// Корректирует selectedDay при смене месяца (например, 31 → февраль → 28/29)
  void _onMonthChanged(DateTime newMonth) {
    final lastDay = DateTime(newMonth.year, newMonth.month + 1, 0).day;
    setState(() {
      selectedMonth = newMonth;
      selectedDay = selectedDay > lastDay ? lastDay : selectedDay;
    });
    _mergeMealEntriesForMonth(newMonth);
  }

  /// Подгружает записи о питании, активности и локальных событиях для месяца и объединяет с текущими
  Future<void> _mergeMealEntriesForMonth(DateTime month) async {
    final mealEvents = await _loadMealEntriesAsEvents(month);
    final activityEvents = await _loadActivityEntriesAsEvents(month);
    final localEvents = await _loadLocalCalendarEvents(month);
    if (!mounted) return;
    setState(() {
      events = events
          .where((e) =>
              !e.id.startsWith('meal_') &&
              !e.id.startsWith('activity_') &&
              !e.id.startsWith('local_'))
          .toList();
      events.addAll(mealEvents);
      events.addAll(activityEvents);
      events.addAll(localEvents);
      events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicCard,
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
                : RefreshIndicator(
                    onRefresh: _loadEvents,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: _getResponsivePadding(constraints.maxWidth),
                          ),
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const SizedBox(height: 12),
                        // Карточки-статистика (по выбранному месяцу, tap = фильтр)
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.restaurant_menu,
                                label: 'Планирование питания',
                                category: _categoryMealPlanning,
                                count: events
                                    .where((e) =>
                                        e.category == _categoryMealPlanning &&
                                        e.dateTime.year == selectedMonth.year &&
                                        e.dateTime.month == selectedMonth.month)
                                    .length,
                                color: context.primary,
                                isSelected: selectedCategories
                                    .contains(_categoryMealPlanning),
                                onTap: () =>
                                    _onStatCardTap(_categoryMealPlanning),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.directions_run,
                                label: 'Физическая активность',
                                category: _categoryPhysicalActivities,
                                count: events
                                    .where((e) =>
                                        e.category == _categoryPhysicalActivities &&
                                        e.dateTime.year == selectedMonth.year &&
                                        e.dateTime.month == selectedMonth.month)
                                    .length,
                                color: context.warning,
                                isSelected: selectedCategories
                                    .contains(_categoryPhysicalActivities),
                                onTap: () =>
                                    _onStatCardTap(_categoryPhysicalActivities),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.event,
                                label: 'Встречи и события',
                                category: _categoryAppointments,
                                count: events
                                    .where((e) =>
                                        e.category == _categoryAppointments &&
                                        e.dateTime.year == selectedMonth.year &&
                                        e.dateTime.month == selectedMonth.month)
                                    .length,
                                color: context.tertiary,
                                isSelected: selectedCategories
                                    .contains(_categoryAppointments),
                                onTap: () =>
                                    _onStatCardTap(_categoryAppointments),
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
                                  _onMonthChanged(
                                      DateTime(selectedMonth.year, month));
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
                                  _onMonthChanged(
                                      DateTime(year, selectedMonth.month));
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
                                onPressed: _showAddEventSheet,
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
                                key: _filterChipKeys[_categoryMealPlanning],
                                label: 'Планирование питания',
                                color: context.primary,
                                isSelected: selectedCategories
                                    .contains(_categoryMealPlanning),
                                onTap: () =>
                                    _toggleCategory(_categoryMealPlanning),
                              ),
                              const SizedBox(width: 8),
                              _FilterChip(
                                key: _filterChipKeys[_categoryPhysicalActivities],
                                label: 'Физическая активность',
                                color: context.warning,
                                isSelected: selectedCategories
                                    .contains(_categoryPhysicalActivities),
                                onTap: () =>
                                    _toggleCategory(_categoryPhysicalActivities),
                              ),
                              const SizedBox(width: 8),
                              _FilterChip(
                                key: _filterChipKeys[_categoryAppointments],
                                label: 'Встречи',
                                color: context.tertiary,
                                isSelected: selectedCategories
                                    .contains(_categoryAppointments),
                                onTap: () =>
                                    _toggleCategory(_categoryAppointments),
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
                        ...() {
                          final assignedKeys = <String>{};
                          return eventsForSelectedDay.map((e) {
                            final key = _scrollToEventKeys.containsKey(e.category) &&
                                    !assignedKeys.contains(e.category)
                                ? _scrollToEventKeys[e.category]
                                : null;
                            if (key != null) assignedKeys.add(e.category);
                            return Padding(
                              key: key,
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _EventCard(
                                category: _categoryDisplayName(e.category),
                                categoryColor: _categoryColor(e.category),
                                categoryIcon: _categoryIcon(e.category),
                                title: e.title,
                                date:
                                    '${_weekdayName(e.dateTime.weekday)}, ${e.dateTime.day} ${_monthName(e.dateTime.month)} ${e.dateTime.year}',
                                time: e.endDateTime != null
                                    ? '${TimeOfDay.fromDateTime(e.dateTime).format(context)} – ${TimeOfDay.fromDateTime(e.endDateTime!).format(context)}'
                                    : TimeOfDay.fromDateTime(e.dateTime)
                                        .format(context),
                                location: e.location ?? '',
                                note: e.note ?? '',
                              ),
                            );
                          });
                        }(),
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
                    );
                },
              ),
            ),
      ),
    );
  }

  String get _userId =>
      SupabaseService.instance.getCurrentUser()?.id ?? 'demo_user';

  Future<void> _showAddEventSheet() async {
    final result = await _showEventFormSheet(
      context: context,
      userId: _userId,
    );
    if (result == null || !mounted) return;
    final event = result as CalendarEvent;

    if (_isSupabaseAvailable) {
      try {
        await CalendarDependencies.instance.initialize();
        final createResult =
            await CalendarDependencies.instance.createCalendarEventUseCase
                .execute(event);
        if (!mounted) return;
        if (createResult.isSuccess) {
          _loadEvents();
        } else {
          await _saveEventLocally(event);
          if (mounted) _loadEvents();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(createResult.error ?? 'Событие добавлено')),
            );
          }
        }
      } catch (_) {
        await _saveEventLocally(event);
        if (mounted) _loadEvents();
      }
    } else {
      await _saveEventLocally(event);
      if (mounted) _loadEvents();
    }
  }

  Future<void> _showEditEventSheet(CalendarEvent event) async {
    final result = await _showEventFormSheet(
      context: context,
      initialEvent: event,
    );
    if (result == null || !mounted) return;
    final updated = result as CalendarEvent;

    if (event.id.startsWith('local_')) {
      await _updateEventLocally(updated);
      if (mounted) _loadEvents();
      return;
    }

    if (_isSupabaseAvailable) {
      try {
        await CalendarDependencies.instance.initialize();
        final updateResult =
            await CalendarDependencies.instance.updateCalendarEventUseCase
                .execute(updated);
        if (!mounted) return;
        if (updateResult.isSuccess) {
          _loadEvents();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(updateResult.error ?? 'Ошибка')),
            );
          }
        }
      } catch (_) {
        if (mounted) _loadEvents();
      }
    } else {
      if (mounted) _loadEvents();
    }
  }

  Future<void> _confirmDeleteEvent(CalendarEvent event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить событие?'),
        content: Text(
            'Событие «${event.title}» будет удалено. Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    if (event.id.startsWith('local_')) {
      await _deleteEventLocally(event.id);
      if (mounted) _loadEvents();
      return;
    }

    if (_isSupabaseAvailable) {
      try {
        await CalendarDependencies.instance.initialize();
        await CalendarDependencies.instance.calendarRepository
            .deleteEvent(event.id);
        if (mounted) _loadEvents();
      } catch (_) {
        if (mounted) {
          setState(() => events = events.where((e) => e.id != event.id).toList());
        }
      }
    } else {
      if (mounted) {
        setState(() => events = events.where((e) => e.id != event.id).toList());
      }
    }
  }
}

Future<CalendarEvent?> _showEventFormSheet({
  required BuildContext context,
  String userId = 'demo_user',
  CalendarEvent? initialEvent,
}) async {
  var title = initialEvent?.title ?? '';
  var category = initialEvent?.category ?? _categoryMealPlanning;
  var dateTime = initialEvent?.dateTime ??
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        9,
        0,
      );
  var endDateTime = initialEvent?.endDateTime ??
      dateTime.add(const Duration(hours: 1));
  var isAllDay = initialEvent?.isAllDay ?? false;
  var location = initialEvent?.location ?? '';
  var note = initialEvent?.note ?? '';
  final isEdit = initialEvent != null;

  final titleController = TextEditingController(text: title);
  final locationController = TextEditingController(text: location);
  final noteController = TextEditingController(text: note);
  var _locationLoading = false;
  var _titleError = '';

  const _inputRadius = 12.0;
  const _inputPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  final parentContext = context;
  return showModalBottomSheet<CalendarEvent>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.dynamicBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isEdit ? 'Редактировать событие' : 'Новое событие',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          color: AppColors.dynamicTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                  ),
                  const SizedBox(height: 20),
                  // Название
                  Text(
                    'Название',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: AppColors.dynamicTextPrimary),
                    onChanged: (_) {
                      if (_titleError.isNotEmpty) {
                        setModalState(() => _titleError = '');
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Название',
                      errorText: _titleError.isEmpty ? null : _titleError,
                      hintStyle: TextStyle(
                        color: AppColors.dynamicTextSecondary.withValues(alpha: 0.7),
                      ),
                      filled: true,
                      fillColor: AppColors.dynamicCard,
                      contentPadding: _inputPadding,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: AppColors.dynamicPrimary.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: const BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: const BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Категория
                  Text(
                    'Категория',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: category,
                    dropdownColor: AppColors.dynamicCard,
                    style: TextStyle(color: AppColors.dynamicTextPrimary),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.dynamicCard,
                      contentPadding: _inputPadding,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: _categoryMealPlanning,
                        child: const Text('Планирование питания'),
                      ),
                      DropdownMenuItem(
                        value: _categoryPhysicalActivities,
                        child: const Text('Физическая активность'),
                      ),
                      DropdownMenuItem(
                        value: _categoryAppointments,
                        child: const Text('Встречи'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) category = v;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Дата
                  Text(
                    'Дата',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate: dateTime,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null &&
                          ctx.mounted &&
                          (ModalRoute.of(ctx)?.isCurrent ?? false)) {
                        setModalState(() {
                          if (isAllDay) {
                            dateTime = DateTime(date.year, date.month, date.day, 0, 0);
                            endDateTime = DateTime(date.year, date.month, date.day + 1, 0, 0, 0);
                          } else {
                            dateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              dateTime.hour,
                              dateTime.minute,
                            );
                            endDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              endDateTime.hour,
                              endDateTime.minute,
                            );
                          }
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(_inputRadius),
                    child: Container(
                      padding: _inputPadding,
                      decoration: BoxDecoration(
                        color: AppColors.dynamicCard,
                        borderRadius: BorderRadius.circular(_inputRadius),
                        border: Border.all(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                        boxShadow: Theme.of(ctx).brightness == Brightness.light
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${dateTime.day}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}',
                              style: TextStyle(
                                color: AppColors.dynamicTextPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.dynamicTextSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Весь день
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Весь день',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.dynamicTextPrimary,
                        ),
                      ),
                      Switch(
                        value: isAllDay,
                        activeTrackColor: AppColors.dynamicPrimary,
                        activeThumbColor: Colors.white,
                        inactiveTrackColor: Colors.transparent,
                        inactiveThumbColor: AppColors.dynamicPrimary,
                        trackOutlineColor: WidgetStateProperty.all(AppColors.dynamicPrimary),
                        onChanged: (v) {
                            setModalState(() {
                              isAllDay = v;
                              if (v) {
                                dateTime = DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  0,
                                  0,
                                );
                                endDateTime = DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day + 1,
                                  0,
                                  0,
                                  0,
                                );
                              } else {
                                dateTime = DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  9,
                                  0,
                                );
                                endDateTime = dateTime.add(const Duration(hours: 1));
                              }
                            });
                          },
                      ),
                    ],
                  ),
                  if (!isAllDay) ...[
                  const SizedBox(height: 16),
                  // Начало
                  Text(
                    'Начало',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(dateTime),
                      );
                      if (time != null &&
                          ctx.mounted &&
                          (ModalRoute.of(ctx)?.isCurrent ?? false)) {
                        setModalState(() {
                          dateTime = DateTime(
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            time.hour,
                            time.minute,
                          );
                          if (endDateTime.isBefore(dateTime) ||
                              endDateTime.isAtSameMomentAs(dateTime)) {
                            endDateTime = dateTime.add(const Duration(hours: 1));
                          }
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(_inputRadius),
                    child: Container(
                      padding: _inputPadding,
                      decoration: BoxDecoration(
                        color: AppColors.dynamicCard,
                        borderRadius: BorderRadius.circular(_inputRadius),
                        border: Border.all(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                        boxShadow: Theme.of(ctx).brightness == Brightness.light
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: AppColors.dynamicTextPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.dynamicTextSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Конец
                  Text(
                    'Конец',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(endDateTime),
                      );
                      if (time != null &&
                          ctx.mounted &&
                          (ModalRoute.of(ctx)?.isCurrent ?? false)) {
                        setModalState(() {
                          endDateTime = DateTime(
                            endDateTime.year,
                            endDateTime.month,
                            endDateTime.day,
                            time.hour,
                            time.minute,
                          );
                          if (endDateTime.isBefore(dateTime) ||
                              endDateTime.isAtSameMomentAs(dateTime)) {
                            dateTime = endDateTime.subtract(const Duration(hours: 1));
                          }
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(_inputRadius),
                    child: Container(
                      padding: _inputPadding,
                      decoration: BoxDecoration(
                        color: AppColors.dynamicCard,
                        borderRadius: BorderRadius.circular(_inputRadius),
                        border: Border.all(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                        boxShadow: Theme.of(ctx).brightness == Brightness.light
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: AppColors.dynamicTextPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.dynamicTextSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ],
                  const SizedBox(height: 16),
                  // Место
                  Text(
                    'Место',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: locationController,
                    style: TextStyle(color: AppColors.dynamicTextPrimary),
                    decoration: InputDecoration(
                      hintText: 'Место',
                      hintStyle: TextStyle(
                        color: AppColors.dynamicTextSecondary.withValues(alpha: 0.7),
                      ),
                      filled: true,
                      fillColor: AppColors.dynamicCard,
                      contentPadding: _inputPadding,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.my_location,
                          color: AppColors.dynamicPrimary,
                          size: 22,
                        ),
                        onPressed: () async {
                          if (!ctx.mounted) return;
                          if (ModalRoute.of(ctx)?.isCurrent != true) return;
                          if (_locationLoading) return;
                          _locationLoading = true;

                          final serviceEnabled = await Geolocator.isLocationServiceEnabled();
                          if (!serviceEnabled) {
                            _locationLoading = false;
                            if (ctx.mounted && (ModalRoute.of(ctx)?.isCurrent ?? false)) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Включите геолокацию в настройках устройства',
                                  ),
                                ),
                              );
                            }
                            return;
                          }

                          var status = await Permission.locationWhenInUse.status;
                          if (!status.isGranted) {
                            status = await Permission.locationWhenInUse.request();
                          }
                          if (!status.isGranted) {
                            _locationLoading = false;
                            if (ctx.mounted && (ModalRoute.of(ctx)?.isCurrent ?? false)) {
                              if (status.isPermanentlyDenied) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Доступ к геолокации отклонён. Откройте настройки приложения.',
                                    ),
                                    action: SnackBarAction(
                                      label: 'Настройки',
                                      onPressed: () => openAppSettings(),
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Доступ к геолокации не предоставлен',
                                    ),
                                  ),
                                );
                              }
                            }
                            return;
                          }

                          try {
                            final position = await Geolocator.getCurrentPosition(
                              locationSettings: const LocationSettings(
                                accuracy: LocationAccuracy.medium,
                              ),
                            );
                            if (!ctx.mounted) {
                              _locationLoading = false;
                              return;
                            }
                            if (ModalRoute.of(ctx)?.isCurrent != true) {
                              _locationLoading = false;
                              return;
                            }

                            final placemarks = await placemarkFromCoordinates(
                              position.latitude,
                              position.longitude,
                            );

                            if (!ctx.mounted) {
                              _locationLoading = false;
                              return;
                            }
                            if (ModalRoute.of(ctx)?.isCurrent != true) {
                              _locationLoading = false;
                              return;
                            }

                            final address = placemarks.isNotEmpty
                                ? () {
                                    final p = placemarks.first;
                                    final parts = [
                                      p.street,
                                      p.subLocality,
                                      p.locality,
                                      p.administrativeArea,
                                    ].whereType<String>().where((s) => s.isNotEmpty);
                                    return parts.isNotEmpty
                                        ? parts.join(', ')
                                        : '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
                                  }()
                                : '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';

                            if (!ctx.mounted) {
                              _locationLoading = false;
                              return;
                            }
                            if (ModalRoute.of(ctx)?.isCurrent != true) {
                              _locationLoading = false;
                              return;
                            }
                            locationController.text = address;
                            setModalState(() {});
                            _locationLoading = false;

                            if (ctx.mounted && (ModalRoute.of(ctx)?.isCurrent ?? false)) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                  content: Text('Место добавлено'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            _locationLoading = false;
                            if (ctx.mounted && (ModalRoute.of(ctx)?.isCurrent ?? false)) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Ошибка: ${e.toString().split('\n').first}',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: AppColors.dynamicPrimary.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Заметка
                  Text(
                    'Заметка',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    style: TextStyle(color: AppColors.dynamicTextPrimary),
                    decoration: InputDecoration(
                      hintText: 'Заметка',
                      hintStyle: TextStyle(
                        color: AppColors.dynamicTextSecondary.withValues(alpha: 0.7),
                      ),
                      filled: true,
                      fillColor: AppColors.dynamicCard,
                      contentPadding: _inputPadding,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: Theme.of(ctx).brightness == Brightness.light
                              ? const Color(0xFFD8D8D8)
                              : AppColors.dynamicBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_inputRadius),
                        borderSide: BorderSide(
                          color: AppColors.dynamicPrimary.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(ctx).brightness == Brightness.dark
                              ? const Color(0xFF6EE7B7)
                              : AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Отмена'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.dynamicPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          final titleText = titleController.text.trim();
                          final locationText = locationController.text.trim();
                          final noteText = noteController.text.trim();
                          if (titleText.isEmpty) {
                            setModalState(() {
                              _titleError = 'Необходимо заполнить это поле';
                            });
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: const Text('Необходимо заполнить поле «Название»'),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red.shade700,
                              ),
                            );
                            return;
                          }
                          if (titleText.length < 3) {
                            setModalState(() {
                              _titleError = 'Название должно быть не менее 3 символов';
                            });
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: const Text('Название должно быть не менее 3 символов'),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red.shade700,
                              ),
                            );
                            return;
                          }
                          setModalState(() => _titleError = '');
                          final now = DateTime.now();
                          final event = isEdit
                              ? initialEvent!.copyWith(
                                  title: titleText,
                                  category: category,
                                  dateTime: dateTime,
                                  endDateTime: endDateTime,
                                  location:
                                      locationText.isEmpty ? null : locationText,
                                  note: noteText.isEmpty ? null : noteText,
                                )
                              : CalendarEvent(
                                  id: 'temp_${now.millisecondsSinceEpoch}',
                                  userId: userId,
                                  category: category,
                                  title: titleText,
                                  dateTime: dateTime,
                                  endDateTime: endDateTime,
                                  location:
                                      locationText.isEmpty
                                          ? null
                                          : locationText,
                                  note: noteText.isEmpty ? null : noteText,
                                  createdAt: now,
                                  updatedAt: now,
                                );
                          Navigator.pop(ctx, event);
                        },
                        child: Text(isEdit ? 'Сохранить' : 'Добавить'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    _locationLoading = false;
    // Отложенная очистка: даём время завершиться async-колбэкам (геолокация и т.д.),
    // чтобы избежать "TextEditingController used after disposed" и "_dependents.isEmpty"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      titleController.dispose();
      locationController.dispose();
      noteController.dispose();
    });
  });
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String category;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.category,
    required this.count,
    required this.color,
    this.isSelected = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.5) : Colors.transparent,
            width: 2,
          ),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.dynamicTextSecondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterChip({
    super.key,
    required this.label,
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
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
  final IconData categoryIcon;
  final String title;
  final String date;
  final String time;
  final String location;
  final String note;

  const _EventCard({
    required this.category,
    required this.categoryColor,
    required this.categoryIcon,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    const lightGreen = Color(0xFFE8F5E9);
    const greenAccent = Color(0xFF4CAF50);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : AppColors.dynamicCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLight ? const Color(0xFFE8E8E8) : AppColors.dynamicBorder.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: isLight ? 0.12 : 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: categoryColor.withValues(alpha: isLight ? 0.45 : 0.35),
            width: 1,
          ),
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Иконка в бледном цветном квадрате (как на скрине)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(categoryIcon, color: categoryColor, size: 24),
          ),
          const SizedBox(width: 14),
          // Основной контент: категория + название
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface,
                  ),
                ),
                if (date.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.onSurfaceVariant.withValues(alpha: 0.9),
                    ),
                  ),
                ],
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Время справа (без иконки)
          if (time.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: greenAccent,
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}

class _EventInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const _EventInfoRow({
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor ?? context.onSurfaceVariant,
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
      onPressed: () {
        if (text == 'Политика конфиденциальности') {
          Navigator.pushNamed(context, '/privacy-policy');
        } else if (text == 'Условия использования') {
          Navigator.pushNamed(context, '/terms-of-use');
        }
      },
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
