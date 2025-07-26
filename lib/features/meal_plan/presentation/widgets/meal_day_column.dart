import 'package:flutter/material.dart';
import 'meal_card.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class MealDayColumn extends StatelessWidget {
  final int day;
  final String selectedMealType;
  const MealDayColumn({required this.day, required this.selectedMealType, Key? key}) : super(key: key);

  static const days = [
    'Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'
  ];
  static const dates = [
    '3 сен', '4 сен', '5 сен', '6 сен', '7 сен', '8 сен', '9 сен'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Color(0x11000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок дня
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  days[day],
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  dates[day],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
          // Карточка приёма пищи
          Padding(
            padding: EdgeInsets.all(16),
            child: _getMealCard(),
          ),
        ],
      ),
    );
  }

  Widget _getMealCard() {
    switch (selectedMealType) {
      case 'Завтрак':
        return MealCard(
          type: 'Завтрак', 
          color: AppColors.green, 
          title: _breakfasts[day]
        );
      case 'Обед':
        return MealCard(
          type: 'Обед', 
          color: AppColors.yellow, 
          title: _lunches[day]
        );
      case 'Перекус':
        return MealCard(
          type: 'Перекус', 
          color: AppColors.gray, 
          title: _snacks[day]
        );
      case 'Ужин':
        return MealCard(
          type: 'Ужин', 
          color: AppColors.orange, 
          title: _dinners[day]
        );
      default:
        return MealCard(
          type: 'Завтрак', 
          color: AppColors.green, 
          title: _breakfasts[day]
        );
    }
  }

  static const _breakfasts = [
    'Яичница со шпинатом и цельнозерновым тостом',
    'Тост с авокадо и яйцом-пашот',
    'Черничный протеиновый смузи',
    'Овсянка с миндальной пастой и ягодами',
    'Греческий йогурт с гранолой и медом',
    'Смузи-боул с фруктами и семенами чиа',
    'Чиа-пудинг с клубникой',
  ];
  static const _lunches = [
    'Куриный ролл с авокадо и шпинатом',
    'Салат с киноа, запечёнными овощами и фетой',
    'Греческий салат с фетой и оливками',
    'Овощное рагу с тофу и бурым рисом',
    'Куриная грудка с киноа и капустой кейл',
    'Салат с тунцом, шпинатом и нутом',
    'Средиземноморский кускус с овощами-гриль',
  ];
  static const _snacks = [
    'Яблоко с миндальной пастой',
    'Греческий йогурт с ягодами',
    'Морковные палочки с хумусом',
    'Смесь орехов и сухофруктов',
    'Творог с фруктами',
    'Смузи из шпината и банана',
    'Тост с авокадо и семенами',
  ];
  static const _dinners = [
    'Лосось на гриле с овощами',
    'Говядина с овощами и бурым рисом',
    'Курица с бататом и брокколи',
    'Вегетарианская паста с томатным соусом',
    'Тофу на гриле с киноа и зеленью',
    'Запечённая рыба с кускусом и спаржей',
    'Индейка с цветной капустой',
  ];
} 