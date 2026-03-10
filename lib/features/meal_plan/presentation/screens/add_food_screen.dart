import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'food_details_screen.dart';
import 'water_tracker_notice_screen.dart';
import 'barcode_scanner_screen.dart';
import 'package:nutry_flow/features/nutrition/presentation/screens/food_search_screen.dart';
import 'package:nutry_flow/di/nutrition_dependencies.dart';

class AddFoodScreen extends StatefulWidget {
  final String mealType;
  final DateTime selectedDate;

  const AddFoodScreen({
    super.key,
    required this.mealType,
    required this.selectedDate,
  });

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _mealTypeKey = GlobalKey();
  String _searchQuery = '';
  int _selectedNavIndex = 0; // По умолчанию выбран AI
  String? _selectedFoodItem; // Выбранный элемент для подсветки
  late String _selectedMealType;

  static const List<Map<String, String>> _mealTypes = [
    {'value': 'Завтрак', 'label': 'Завтрак'},
    {'value': 'Обед', 'label': 'Обед'},
    {'value': 'Ужин', 'label': 'Ужин'},
    {'value': 'Перекус/Другое', 'label': 'Перекус'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _selectedMealType = widget.mealType;
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase().trim();
    });
  }

  String _getDateString() {
    final date = widget.selectedDate;
    final weekDays = [
      'понедельник',
      'вторник',
      'среда',
      'четверг',
      'пятница',
      'суббота',
      'воскресенье'
    ];
    final months = [
      'янв',
      'февр',
      'мар',
      'апр',
      'мая',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек'
    ];

    final weekday = weekDays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday, $month. ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicBackground,
        elevation: 0,
        centerTitle: false,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        titleSpacing: DesignTokens.spacing.lg,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              key: _mealTypeKey,
              onTap: _showMealTypeMenu,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getMealTypeLabel(_selectedMealType),
                      style: DesignTokens.typography.titleLargeStyle.copyWith(
                        color: AppColors.dynamicTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: DesignTokens.spacing.xs),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.dynamicTextSecondary,
                      size: DesignTokens.spacing.iconSmall,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              _getDateString(),
              style: DesignTokens.typography.bodySmallStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: DesignTokens.spacing.sm),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing.md,
                  vertical: DesignTokens.spacing.xs,
                ),
              ),
              child: Text(
                'Отмена',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Поисковая строка
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing.lg,
              vertical: DesignTokens.spacing.md,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.dynamicSurface,
                borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
                border: Border.all(
                  color: AppColors.dynamicBorder.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск Еды',
                  hintStyle: DesignTokens.typography.bodyMediumStyle.copyWith(
                    color: AppColors.dynamicTextSecondary,
                    fontSize: 15,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(DesignTokens.spacing.md),
                    child: Icon(
                      Icons.search,
                      color: AppColors.dynamicTextSecondary,
                      size: 22,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? Padding(
                          padding:
                              EdgeInsets.only(right: DesignTokens.spacing.xs),
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.dynamicTextSecondary,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing.md,
                    vertical: DesignTokens.spacing.md,
                  ),
                ),
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicTextPrimary,
                  fontSize: 15,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase().trim();
                  });
                },
              ),
            ),
          ),

          // Список продуктов
          Expanded(
            child: _buildFoodList(),
          ),
        ],
      ),
      floatingActionButton: _buildCenterButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildFoodList() {
    final allFoods = [
      'куриная грудка (жареная в печи, без жира, нарезанная)',
      'заливное',
      'бухта изобилия треска филе',
      'треска филе',
      'вкусвилл рис с курицей и овощами',
      'рис с курицей и овощами',
      'нектарины',
      'котлета куриная',
      'шпинат в сливках',
      'бери да ешь спагетти с курицей и грибами в сливочном соусе',
      'спагетти с грибами',
      'брауни с вишней',
      'вкусвилл омлет с курицей и сыром',
      'кио омлет с курицей',
      'омлет с курицей',
    ];

    // Фильтрация продуктов по поисковому запросу
    final filteredFoods = _searchQuery.isEmpty
        ? allFoods
        : allFoods.where((food) {
            return food.toLowerCase().contains(_searchQuery);
          }).toList();

    if (filteredFoods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.dynamicTextSecondary,
            ),
            SizedBox(height: DesignTokens.spacing.md),
            Text(
              'Продукты не найдены',
              style: DesignTokens.typography.titleMediumStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.xs),
            Text(
              'Попробуйте изменить поисковый запрос',
              style: DesignTokens.typography.bodySmallStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacing.lg),
      itemCount: filteredFoods.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: DesignTokens.spacing.sm),
      itemBuilder: (context, index) {
        return _buildFoodListItem(filteredFoods[index]);
      },
    );
  }

  Widget _buildFoodListItem(String name) {
    final isSelected = _selectedFoodItem == name;

    return InkWell(
      onTap: () async {
        setState(() {
          _selectedFoodItem = name;
        });

        await Future.delayed(const Duration(milliseconds: 200));

        if (!mounted) return;

        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(
              foodName: name,
              mealType: _selectedMealType,
            ),
          ),
        );

        if (mounted) {
          setState(() {
            _selectedFoodItem = null;
          });
        }

        if (result != null && mounted) {
          Navigator.of(context).pop(result);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing.md,
          vertical: DesignTokens.spacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.dynamicPrimary.withValues(alpha: 0.15)
              : AppColors.dynamicSurface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: AppColors.dynamicPrimary,
                  width: 2,
                )
              : Border.all(
                  color: AppColors.dynamicBorder.withValues(alpha: 0.2),
                  width: 1,
                ),
          boxShadow: !isSelected
              ? [
                  BoxShadow(
                    color: AppColors.dynamicShadow.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: isSelected
                      ? AppColors.dynamicPrimary
                      : AppColors.dynamicTextPrimary,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: DesignTokens.spacing.sm),
            Icon(
              Icons.chevron_right,
              color: isSelected
                  ? AppColors.dynamicPrimary
                  : AppColors.dynamicTextSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getMealTypeLabel(String value) {
    final match = _mealTypes.firstWhere(
      (type) => type['value'] == value,
      orElse: () => const {'value': '', 'label': ''},
    );
    return match['label'] ?? value;
  }

  Future<void> _showMealTypeMenu() async {
    final renderBox =
        _mealTypeKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (renderBox == null || overlay == null) return;

    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final rect = position & Size(renderBox.size.width, renderBox.size.height);

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      color: AppColors.dynamicCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
      ),
      items: _mealTypes
          .map(
            (type) => PopupMenuItem<String>(
              value: type['value'],
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      type['label'] ?? '',
                      style: DesignTokens.typography.bodyLargeStyle.copyWith(
                        color: AppColors.dynamicTextPrimary,
                        fontWeight: _selectedMealType == type['value']
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (_selectedMealType == type['value'])
                    Icon(
                      Icons.check,
                      color: AppColors.dynamicPrimary,
                    ),
                ],
              ),
            ),
          )
          .toList(),
    );

    if (selected != null && selected != _selectedMealType && mounted) {
      setState(() {
        _selectedMealType = selected;
      });
    }
  }

  Widget _buildBottomNavigation() {
    final theme = Theme.of(context);
    final selectedColor =
        theme.bottomNavigationBarTheme.selectedItemColor ?? AppColors.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey;
    final backgroundColor = theme.bottomNavigationBarTheme.backgroundColor ??
        theme.scaffoldBackgroundColor;

    final List<IconData> navIcons = [
      Icons.auto_awesome,
      Icons.qr_code_scanner,
    ];

    final List<String> navLabels = [
      'AI',
      'Сканер',
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBottomNavigationBar.builder(
          itemCount: navIcons.length,
          tabBuilder: (int index, bool isActive) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      navIcons[index],
                      size: 24,
                      color: isActive ? selectedColor : unselectedColor,
                    ),
                    if (index == 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.dynamicOrange,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: backgroundColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  navLabels[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive ? selectedColor : unselectedColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            );
          },
          activeIndex: _selectedNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          backgroundColor: backgroundColor,
          onTap: (index) {
            setState(() {
              _selectedNavIndex = index;
            });

            switch (index) {
              case 0:
                _showAIPremiumDialog();
                break;
              case 1:
                _openBarcodeScanner();
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    final borderColor = AppColors.dynamicPrimary;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.dynamicPrimary,
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: borderColor.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: borderColor.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _requestCameraPermission,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showAIPremiumDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.dynamicCard,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.borders.xl),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(DesignTokens.spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка закрытия
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppColors.dynamicTextSecondary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: DesignTokens.spacing.md),
                // Иллюстрация
                _buildAIIllustration(),
                SizedBox(height: DesignTokens.spacing.xl),
                // Заголовок
                Text(
                  'Используйте свой голос, чтобы быстрее регистрировать приемы пищи',
                  style: DesignTokens.typography.titleLargeStyle.copyWith(
                    color: AppColors.dynamicTextPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: DesignTokens.spacing.lg),
                // Описание
                Text(
                  'Узнайте, как Умный ассистент и другие премиум-функции могут помочь вам оставаться на верном пути и достичь своих целей',
                  style: DesignTokens.typography.bodyMediumStyle.copyWith(
                    color: AppColors.dynamicTextSecondary,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: DesignTokens.spacing.xl),
                // Кнопка "Подробнее"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const WaterTrackerNoticeScreen(
                            imageAssetPath:
                                'assets/images/subscription_phone.jpg',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dynamicPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Подробнее',
                      style: DesignTokens.typography.bodyLargeStyle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIIllustration() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.dynamicBackground,
        borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
      ),
      child: Stack(
        children: [
          // Фон с градиентом
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.dynamicPrimary.withValues(alpha: 0.1),
                  AppColors.dynamicSuccess.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
            ),
          ),
          // Иллюстрация с элементами
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacing.lg),
            child: Row(
              children: [
                // Левая часть - телефон с чатом
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Телефон
                      Container(
                        width: 80,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.dynamicCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                AppColors.dynamicBorder.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Экран телефона
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.dynamicBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 8),
                                    // Чат-пузыри
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.dynamicPrimary
                                            .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.mic,
                                            size: 12,
                                            color: AppColors.dynamicPrimary,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Голос',
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: AppColors.dynamicPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.dynamicCard,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '...',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: AppColors.dynamicTextSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Кнопка микрофона
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.dynamicPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.mic,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: DesignTokens.spacing.md),
                // Правая часть - персонаж и еда
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Персонаж (упрощенная версия)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Голова
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.dynamicWarning
                                  .withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Тело
                          Positioned(
                            top: 35,
                            child: Container(
                              width: 50,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.dynamicSuccess
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          // Телефон у уха
                          Positioned(
                            left: 45,
                            top: 20,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.dynamicCard,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.dynamicBorder,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.phone,
                                size: 10,
                                color: AppColors.dynamicTextPrimary,
                              ),
                            ),
                          ),
                          // Звуковые волны
                          ...List.generate(3, (index) {
                            return Positioned(
                              left: 50 + (index * 8),
                              top: 25,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.dynamicPrimary
                                      .withValues(alpha: 0.3 - (index * 0.1)),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: DesignTokens.spacing.sm),
                      // Миска с едой
                      Container(
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          color:
                              AppColors.dynamicSuccess.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 14,
                            color: AppColors.dynamicSuccess,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      // Разрешение уже есть, открываем камеру
      _openCamera();
    } else if (status.isDenied) {
      // Показываем диалог с запросом разрешения
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.dynamicCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
          ),
          title: Text(
            'Доступ к камере',
            style: DesignTokens.typography.titleMediumStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Для использования камеры необходимо предоставить доступ к ней. Разрешить доступ?',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: AppColors.dynamicTextSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Отмена',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.dynamicTextSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
              child: Text(
                'Разрешить',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (result == true && mounted) {
        final newStatus = await Permission.camera.request();
        if (newStatus.isGranted && mounted) {
          _openCamera();
        } else if (newStatus.isPermanentlyDenied && mounted) {
          // Показываем диалог для открытия настроек
          _showCameraSettingsDialog();
        }
      }
    } else if (status.isPermanentlyDenied) {
      // Разрешение отклонено навсегда, показываем диалог для открытия настроек
      _showCameraSettingsDialog();
    }
  }

  void _showCameraSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.dynamicCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
        ),
        title: Text(
          'Доступ к камере',
          style: DesignTokens.typography.titleMediumStyle.copyWith(
            color: AppColors.dynamicTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Доступ к камере был отклонен. Пожалуйста, разрешите доступ в настройках приложения.',
          style: DesignTokens.typography.bodyMediumStyle.copyWith(
            color: AppColors.dynamicTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Отмена',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: Text(
              'Открыть настройки',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        // TODO: Обработать изображение (распознавание еды)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Изображение получено: ${image.name}'),
            backgroundColor: AppColors.dynamicPrimary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при открытии камеры: $e'),
            backgroundColor: AppColors.dynamicError,
          ),
        );
      }
    }
  }

  void _openBarcodeScanner() {
    Navigator.of(context)
        .push<String>(
      MaterialPageRoute(
        builder: (context) => BarcodeScannerScreen(
          onScanned: (code) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Штрих-код: $code'),
                backgroundColor: AppColors.dynamicPrimary,
              ),
            );
          },
        ),
      ),
    )
        .then((barcode) {
      if (barcode == null || barcode.isEmpty || !mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => NutritionDependencies.nutritionSearchCubit,
            child: FoodSearchScreen(
              initialBarcode: barcode,
            ),
          ),
        ),
      );
    });
  }
}
