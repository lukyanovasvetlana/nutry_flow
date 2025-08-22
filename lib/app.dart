import 'package:flutter/material.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:nutry_flow/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:nutry_flow/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:nutry_flow/features/meal_plan/presentation/screens/meal_plan_screen.dart';

import 'package:nutry_flow/shared/theme/app_styles.dart';
import 'package:nutry_flow/shared/theme/theme_manager.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const DashboardScreen(),
    const CalendarScreen(),
    const NotificationsScreen(),
    const MealPlanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager(),
      builder: (context, child) {
        final currentTheme = ThemeManager().currentTheme;
        
        return AnimatedSwitcher(
          key: ValueKey('app-content-${currentTheme.name}'),
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _buildMainScreen(),
        );
      },
    );
  }

  Widget _buildMainScreen() {
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
                IconButton(
                  icon: Icon(
                    ThemeManager().themeIcon,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  onPressed: () async {
                    await ThemeManager().toggleTheme();
                  },
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Календарь',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Уведомления',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'План питания',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _PeriodDropdown extends StatefulWidget {
  @override
  State<_PeriodDropdown> createState() => _PeriodDropdownState();
}

class _PeriodDropdownState extends State<_PeriodDropdown> {
  String month = 'Сентябрь';
  String year = '2025';
  String week = 'Неделя 2';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: month,
          items: [
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
          items: List.generate(12, (i) => 'Неделя ${i + 1}')
              .map((w) => DropdownMenuItem(value: w, child: Text(w)))
              .toList(),
          onChanged: (v) => setState(() => week = v!),
        ),
      ],
    );
  }
}
