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

    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Изогнутая панель навигации с обводкой
          ClipPath(
            clipper: _CurvedNavBarClipper(),
            child: Stack(
              children: [
                // Фон NavBar
                Container(
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
                ),
                // Обводка по всему периметру
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 80),
                  painter: _NavBarBorderPainter(
                    borderColor:
                        AppColors.dynamicPrimary.withValues(alpha: 0.2),
                    borderWidth: 5,
                  ),
                ),
                // Навигационные элементы
                Row(
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
                    // Пустое место для центральной кнопки
                    Expanded(child: Container()),
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
              ],
            ),
          ),
          // Центральная кнопка "+" поверх панели
          Positioned(
            left: 0,
            right: 0,
            top: -30,
            child: Center(
              child:
                  _buildCenterButton(context, selectedColor, backgroundColor),
            ),
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

  Widget _buildCenterButton(
      BuildContext context, Color selectedColor, Color backgroundColor) {
    // Обводка цветом иконки "+", середина кнопки белая
    final borderColor = AppColors.dynamicPrimary;
    final buttonColor = Colors.white;

    // Размеры кнопки одинаковые для обеих тем
    const double buttonSize = 70.0;
    const double iconSize = 35.0;
    const double borderWidth = 10.0;

    return GestureDetector(
      key: const ValueKey('exercise_button'),
      onTap: () {
        setState(() {
          _selectedIndex = 2; // Упражнения - ExerciseScreenRedesigned
        });
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
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
            // Основная тень кнопки
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: AppColors.dynamicPrimary,
          size: iconSize,
        ),
      ),
    );
  }
}

/// CustomClipper для создания изогнутой формы NavBar с выемкой для центральной кнопки
class _CurvedNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final notchWidth = 160.0; // Увеличена ширина выемки
    final notchDepth = 40.0; // Увеличена глубина изгиба

    // Начинаем с левого верхнего угла
    path.moveTo(0, 0);

    // Линия до начала выемки слева
    path.lineTo(centerX - notchWidth / 2, 0);

    // Плавная левая часть выемки (кубическая кривая для более плавного перехода)
    path.cubicTo(
      centerX - notchWidth / 3, 0, // Первая контрольная точка
      centerX - notchWidth / 4, notchDepth * 0.5, // Вторая контрольная точка
      centerX - notchWidth / 6, notchDepth, // Конечная точка
    );

    // Плавная нижняя часть выемки (кубическая кривая)
    path.cubicTo(
      centerX - notchWidth / 12, notchDepth * 1.3, // Первая контрольная точка
      centerX + notchWidth / 12, notchDepth * 1.3, // Вторая контрольная точка
      centerX + notchWidth / 6, notchDepth, // Конечная точка
    );

    // Плавная правая часть выемки (кубическая кривая)
    path.cubicTo(
      centerX + notchWidth / 4, notchDepth * 0.5, // Первая контрольная точка
      centerX + notchWidth / 3, 0, // Вторая контрольная точка
      centerX + notchWidth / 2, 0, // Конечная точка
    );

    // Линия до правого верхнего угла
    path.lineTo(size.width, 0);

    // Правый край
    path.lineTo(size.width, size.height);

    // Нижний край
    path.lineTo(0, size.height);

    // Закрываем путь
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// CustomPainter для рисования обводки NavBar по изогнутой форме
class _NavBarBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;

  _NavBarBorderPainter({
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path();
    final centerX = size.width / 2;
    final notchWidth = 160.0;
    final notchDepth = 40.0;

    // Начинаем с левого верхнего угла
    path.moveTo(0, borderWidth / 2);

    // Линия до начала выемки слева
    path.lineTo(centerX - notchWidth / 2, borderWidth / 2);

    // Плавная левая часть выемки
    path.cubicTo(
      centerX - notchWidth / 3,
      borderWidth / 2,
      centerX - notchWidth / 4,
      notchDepth * 0.5,
      centerX - notchWidth / 6,
      notchDepth,
    );

    // Плавная нижняя часть выемки
    path.cubicTo(
      centerX - notchWidth / 12,
      notchDepth * 1.3,
      centerX + notchWidth / 12,
      notchDepth * 1.3,
      centerX + notchWidth / 6,
      notchDepth,
    );

    // Плавная правая часть выемки
    path.cubicTo(
      centerX + notchWidth / 4,
      notchDepth * 0.5,
      centerX + notchWidth / 3,
      borderWidth / 2,
      centerX + notchWidth / 2,
      borderWidth / 2,
    );

    // Линия до правого верхнего угла
    path.lineTo(size.width, borderWidth / 2);

    // Правый край
    path.lineTo(size.width - borderWidth / 2, size.height);

    // Нижний край
    path.lineTo(borderWidth / 2, size.height);

    // Левый край
    path.lineTo(0, borderWidth / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
