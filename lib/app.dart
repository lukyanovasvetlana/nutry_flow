import 'package:flutter/material.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:nutry_flow/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:nutry_flow/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:nutry_flow/features/meal_plan/presentation/screens/meal_plan_screen.dart';
import 'package:nutry_flow/features/exercise/presentation/screens/exercise_screen.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return _buildMainScreen();
  }

  Widget _buildMainScreen() {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              title: Text('NutryFlow', style: AppStyles.headlineMedium),
              centerTitle: false,
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
                 backgroundColor: AppColors.background,
         selectedItemColor: AppColors.button,
         unselectedItemColor: Colors.grey[600],
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
            'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
          ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
          onChanged: (v) => setState(() => month = v!),
        ),
        SizedBox(width: 4),
        DropdownButton<String>(
          value: year,
          items: [
            '2025', '2026', '2027', '2028', '2029', '2030'
          ].map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
          onChanged: (v) => setState(() => year = v!),
        ),
        SizedBox(width: 4),
        DropdownButton<String>(
          value: week,
          items: List.generate(12, (i) => 'Неделя ${i + 1}')
              .map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
          onChanged: (v) => setState(() => week = v!),
        ),
      ],
    );
  }
} 