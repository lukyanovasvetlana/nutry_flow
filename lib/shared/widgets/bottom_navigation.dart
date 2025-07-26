import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onMenuTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    this.onMenuTap,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  static const String _selectedIndexKey = 'selected_nav_index';
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _loadSavedIndex();
  }

  Future<void> _loadSavedIndex() async {
    final savedIndex = await _getSavedIndex();
    if (mounted && savedIndex != _currentIndex) {
      setState(() {
        _currentIndex = savedIndex;
      });
      _handleNavigation(savedIndex);
    }
  }

  Future<void> _saveSelectedIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedIndexKey, index);
  }

  Future<int> _getSavedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedIndexKey) ?? 0;
  }

  void _handleNavigation(int index) async {
    if (index == _currentIndex) return;

    await _saveSelectedIndex(index);
    setState(() {
      _currentIndex = index;
    });

    if (index == 0 && widget.onMenuTap != null) {
      widget.onMenuTap!(index);
      return;
    }

    if (!mounted) return;

    switch (index) {
      case 0:
        // Меню обрабатывается через onMenuTap
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/calendar');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/activity');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile-settings');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile-settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Меню'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Календарь'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Активность'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
      ],
      currentIndex: _currentIndex,
      onTap: _handleNavigation,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFF9F4F2),
      selectedItemColor: AppColors.button,
      unselectedItemColor: Colors.grey[600],
    );
  }
} 