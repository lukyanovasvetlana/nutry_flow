import 'package:flutter/material.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:nutry_flow/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:nutry_flow/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:nutry_flow/features/meal_plan/presentation/screens/meal_plan_screen.dart';
import 'package:nutry_flow/features/exercise/presentation/screens/exercise_screen_redesigned.dart';

import 'package:nutry_flow/shared/theme/app_styles.dart';
import 'package:nutry_flow/shared/theme/theme_manager.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _selectedIndex = 0;

  List<Widget> _buildScreens() {
    return <Widget>[
      const DashboardScreen(),
      const CalendarScreen(),
      ExerciseScreenRedesigned(
        key: const ValueKey('exercise_screen'),
        onBackPressed: () {
          if (mounted) {
            setState(() {
              _selectedIndex = 0; // Переключаем на дашборд
            });
          }
        },
      ),
      NotificationsScreen(
        key: const ValueKey('notifications_screen'),
        onBackPressed: () {
          if (mounted) {
            setState(() {
              _selectedIndex = 0; // Переключаем на дашборд
            });
          }
        },
      ),
      const MealPlanScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager();

    return ListenableBuilder(
      listenable: themeManager,
      builder: (context, child) {
        return AnimatedTheme(
          data: themeManager.currentTheme == ThemeMode.dark
              ? themeManager.darkTheme
              : themeManager.lightTheme,
          duration: const Duration(milliseconds: 150),
          child: _buildMainScreen(themeManager),
        );
      },
    );
  }

  Widget _buildMainScreen(ThemeManager themeManager) {
    final currentTheme = themeManager.currentTheme;

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
              title: Text(
                'NutryFlow',
                style: AppStyles.headlineMedium.copyWith(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
              ),
              centerTitle: false,
              actions: [
                ListenableBuilder(
                  listenable: themeManager,
                  builder: (context, child) {
                    return IconButton(
                      icon: Icon(
                        themeManager.themeIcon,
                        color: Theme.of(context).appBarTheme.foregroundColor,
                      ),
                      onPressed: () {
                        themeManager.toggleTheme();
                      },
                    );
                  },
                ),
              ],
            )
          : null,
      body: IndexedStack(
        key: ValueKey('indexed_stack_${_selectedIndex}_${currentTheme.name}'),
        index: _selectedIndex,
        children: _buildScreens(),
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(context),
    );
  }

  Widget _buildCustomBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor =
        theme.bottomNavigationBarTheme.selectedItemColor ?? AppColors.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey;
    final backgroundColor = theme.bottomNavigationBarTheme.backgroundColor ??
        theme.scaffoldBackgroundColor;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Индекс 0: Главная
          _buildNavItem(
            context: context,
            icon: Icons.dashboard,
            label: 'Главная',
            index: 0,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          // Индекс 1: Календарь
          _buildNavItem(
            context: context,
            icon: Icons.calendar_today,
            label: 'Календарь',
            index: 1,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          // Индекс 2: Упражнения (кнопка +)
          _buildCenterButton(context, selectedColor),
          // Индекс 3: Уведомления
          _buildNavItem(
            context: context,
            icon: Icons.notifications,
            label: 'Уведомления',
            index: 3,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          // Индекс 4: Питание
          _buildNavItem(
            context: context,
            icon: Icons.restaurant_menu,
            label: 'Питание',
            index: 4,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? selectedColor : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context, Color selectedColor) {
    final isSelected = _selectedIndex == 2;
    return Expanded(
      key: const ValueKey('exercise_button'),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = 2; // Упражнения - ExerciseScreenRedesigned
          });
        },
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedColor
                  : selectedColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: selectedColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.add,
              color: isSelected ? Colors.white : selectedColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

class _PeriodDropdown extends StatefulWidget {
  @override
  State<_PeriodDropdown> createState() => _PeriodDropdownState();
}

class _PeriodDropdownState extends State<_PeriodDropdown> {
  String month = 'September';
  String year = '2025';
  String week = 'Week 2';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: month,
          items: [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December'
          ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
          onChanged: (v) => setState(() => month = v!),
        ),
        SizedBox(width: 4),
        DropdownButton<String>(
          value: year,
          items: ['2025', '2026', '2027', '2028', '2029', '2030']
              .map((y) => DropdownMenuItem(value: y, child: Text(y)))
              .toList(),
          onChanged: (v) => setState(() => year = v!),
        ),
        SizedBox(width: 4),
        DropdownButton<String>(
          value: week,
          items: List.generate(12, (i) => 'Week ${i + 1}')
              .map((w) => DropdownMenuItem(value: w, child: Text(w)))
              .toList(),
          onChanged: (v) => setState(() => week = v!),
        ),
      ],
    );
  }
}
