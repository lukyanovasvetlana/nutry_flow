import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  String selectedMonth = 'Сентябрь';
  String selectedYear = '2025';
  String selectedWeek = 'Неделя 2';

  void _showWeekPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  'Неделя 1',
                  'Неделя 2',
                  'Неделя 3',
                  'Неделя 4',
                  'Неделя 5',
                  'Неделя 6',
                  'Неделя 7',
                  'Неделя 8',
                  'Неделя 9',
                  'Неделя 10',
                  'Неделя 11',
                  'Неделя 12',
                ]
                    .map((week) => ListTile(
                          title: Text(week),
                          onTap: () {
                            setState(() {
                              selectedWeek = week;
                            });
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
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
                  'Декабрь',
                ]
                    .map((month) => ListTile(
                          title: Text(month),
                          onTap: () {
                            setState(() {
                              selectedMonth = month;
                            });
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  '2025',
                  '2026',
                  '2027',
                  '2028',
                  '2029',
                  '2030',
                ]
                    .map((year) => ListTile(
                          title: Text(year),
                          onTap: () {
                            setState(() {
                              selectedYear = year;
                            });
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: GestureDetector(
              onTap: _showMonthPicker,
              child: Text(
                selectedMonth,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: context.onSurface),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: 4),
          Flexible(
            child: GestureDetector(
              onTap: _showYearPicker,
              child: Text(
                selectedYear,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: context.onSurface),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: 12),
          Flexible(
            child: GestureDetector(
              onTap: _showWeekPicker,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: context.shadow.withValues(alpha: 0.07),
                        blurRadius: 2)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        selectedWeek,
                        style: TextStyle(
                            fontSize: 12,
                            color: context.onSurface,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down,
                        color: context.onSurfaceVariant, size: 16),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Icon(Icons.search, color: context.onSurfaceVariant, size: 20),
          SizedBox(width: 8),
          Icon(Icons.filter_alt_outlined,
              color: context.onSurfaceVariant, size: 20),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: context.primary,
            radius: 16,
            child: Icon(Icons.add, color: context.onPrimary, size: 18),
          ),
        ],
      ),
    );
  }
}
