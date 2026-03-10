import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:nutry_flow/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:nutry_flow/features/profile/presentation/screens/unified_profile_screen.dart';
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

  // Список иконок для навигации
  final List<IconData> _iconList = [
    Icons.dashboard,
    Icons.restaurant_menu,
    Icons.add, // Центральная кнопка (будет заменена на FloatingActionButton)
    Icons.calendar_today,
    Icons.person,
  ];

  List<Widget> _buildScreens() {
    return <Widget>[
      const DashboardScreen(),
      const MealPlanScreen(),
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
      const CalendarScreen(),
      UnifiedProfileScreen(
        key: const ValueKey('profile_screen'),
        onBackPressed: () {
          if (mounted) {
            setState(() {
              _selectedIndex = 0; // Переключаем на дашборд
            });
          }
        },
      ),
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
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
      floatingActionButton: _buildCenterButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildAnimatedBottomNavBar(context),
    );
  }

  Widget _buildAnimatedBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor =
        theme.bottomNavigationBarTheme.selectedItemColor ?? AppColors.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey;
    final backgroundColor =
        theme.bottomNavigationBarTheme.backgroundColor ??
            AppColors.dynamicCard;

    // Создаем список иконок без центральной (индекс 2)
    final List<IconData> navIcons = [
      _iconList[0], // Главная
      _iconList[1], // Питание
      _iconList[3], // Календарь
      _iconList[4], // Профиль
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBottomNavigationBar.builder(
          itemCount: navIcons.length,
          tabBuilder: (int index, bool isActive) {
            // Маппинг индексов: 0->0, 1->1, 2->3, 3->4
            final actualIndex = index == 0
                ? 0
                : index == 1
                    ? 1
                    : index == 2
                        ? 3
                        : 4;
            final icon = navIcons[index];
            final label = _getLabelForIndex(actualIndex);

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive ? selectedColor : unselectedColor,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive ? selectedColor : unselectedColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            );
          },
          activeIndex: _getActiveNavIndex(),
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          backgroundColor: backgroundColor,
          elevation: 0,
          shadow: const Shadow(color: Colors.transparent, blurRadius: 0),
          borderColor: Colors.transparent,
          borderWidth: 0,
          safeAreaValues: const SafeAreaValues(bottom: true),
          height: kBottomNavigationBarHeight,
          onTap: (index) {
            // Маппинг индексов обратно: 0->0, 1->1, 2->3, 3->4
            final actualIndex = index == 0
                ? 0
                : index == 1
                    ? 1
                    : index == 2
                        ? 3
                        : 4;
            setState(() {
              _selectedIndex = actualIndex;
            });
          },
        ),
      ],
    );
  }

  int _getActiveNavIndex() {
    // Маппинг: 0->0, 1->1, 3->2, 4->3
    if (_selectedIndex == 0) {
      return 0; // Главная
    } else if (_selectedIndex == 1) {
      return 1; // Питание
    } else if (_selectedIndex == 3) {
      return 2; // Календарь
    } else if (_selectedIndex == 4) {
      return 3; // Профиль
    }
    return 0;
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Главная';
      case 1:
        return 'Питание';
      case 3:
        return 'Календарь';
      case 4:
        return 'Профиль';
      default:
        return '';
    }
  }

  Widget _buildCenterButton(BuildContext context) {
    final borderColor = AppColors.dynamicPrimary;

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 3,
        ),
        boxShadow: [
          // Подсветка обводки
          BoxShadow(
            color: borderColor.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: borderColor.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          // Дополнительная подсветка
          BoxShadow(
            color: borderColor.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: CircleBorder(
          side: BorderSide(
            color: borderColor,
            width: 5,
          ),
        ),
        child: InkWell(
          key: const ValueKey('exercise_button'),
          onTap: () {
            setState(() {
              _selectedIndex = 2; // Упражнения - ExerciseScreenRedesigned
            });
          },
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Icons.add,
              color: borderColor,
              size: 30,
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
