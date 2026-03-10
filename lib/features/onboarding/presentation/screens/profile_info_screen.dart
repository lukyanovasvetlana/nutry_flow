import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutry_flow/shared/design/components/buttons/nutry_save_button.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;
  bool _isLoadingGallery = false;

  final List<String> _genders = ['Мужской', 'Женский', 'Другой'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _startImagePick(ImageSource source) async {
    if (_isPickingImage) return;
    setState(() {
      _isPickingImage = true;
    });
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null && mounted) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Не удалось сделать фото: $error'
                : 'Не удалось выбрать фото: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _pickFromGalleryCustom() async {
    if (_isPickingImage || _isLoadingGallery) return;
    setState(() {
      _isLoadingGallery = true;
    });
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      final hasAccess =
          permission.isAuth || permission == PermissionState.limited;
      if (!hasAccess) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Нет доступа к фото. Разрешите в настройках.'),
            action: SnackBarAction(
              label: 'Настройки',
              onPressed: PhotoManager.openSetting,
            ),
          ),
        );
        return;
      }

      if (!mounted) return;
      final File? selectedFile = await Navigator.of(context).push<File?>(
        MaterialPageRoute(
          builder: (_) => const _GalleryPickerScreen(),
        ),
      );
      if (selectedFile != null && mounted) {
        setState(() {
          _profileImage = selectedFile;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingGallery = false;
        });
      }
    }
  }

  Future<void> _showImagePickerDialog() async {
    if (_isPickingImage) return;
    ImageSource? source;
    if (Platform.isIOS) {
      source = await showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: const Text('Галерея'),
              ),
              CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: const Text('Камера'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              isDefaultAction: true,
              child: const Text('Отмена'),
            ),
          );
        },
      );
    } else {
      source = await showModalBottomSheet<ImageSource>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.photo_library, color: AppColors.green),
                  title: const Text('Галерея'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.green),
                  title: const Text('Камера'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  title: const Center(child: Text('Отмена')),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      );
    }

    if (source != null && mounted) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (source == ImageSource.gallery) {
        await _pickFromGalleryCustom();
      } else {
        await _startImagePick(source);
      }
    }
  }

  Future<void> _selectDate() async {
    final initialDate = _selectedDate ?? DateTime.now();
    final firstDate = DateTime(1900);
    final lastDate = DateTime.now();

    // Используем кастомный bottom sheet с правильным порядком день/месяц/год
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _CustomDatePicker(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        onDateSelected: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate() &&
        _selectedGender != null &&
        _selectedDate != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _firstNameController.text);
      await prefs.setString('userLastName', _lastNameController.text);
      await prefs.setString('userGender', _selectedGender!);
      await prefs.setString('userBirthDate', _selectedDate!.toIso8601String());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль сохранен!')),
      );
      Future.microtask(() {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/goals-setup');
        }
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все поля'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ваш Профиль'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2D3748),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            final navigator = Navigator.of(context);
            Future.microtask(() {
              if (mounted) {
                navigator.pushReplacementNamed('/registration');
              }
            });
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0), // Уменьшил с 60 до 0
          child: Container(), // Пустой контейнер вместо индикатора прогресса
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildProfileImage(),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _showImagePickerDialog,
                  child: const Text(
                    'Изменить фото',
                    style: TextStyle(
                        color: AppColors.button, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),
                _buildFormFields(),
                const SizedBox(height: 72),
                _buildSaveButton(),
                const SizedBox(height: 12),
                _buildSkipButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _showImagePickerDialog,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.white,
            backgroundImage: _profileImage != null
                ? ResizeImage(
                    FileImage(_profileImage!),
                    width: 256,
                    height: 256,
                  )
                : null,
            child: _profileImage == null
                ? Icon(Icons.person_outline, size: 60, color: Colors.grey[300])
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.button,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _firstNameController,
          label: 'Имя',
          validator: (value) =>
              value == null || value.isEmpty ? 'Введите имя' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _lastNameController,
          label: 'Фамилия',
          validator: (value) =>
              value == null || value.isEmpty ? 'Введите фамилию' : null,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(),
        const SizedBox(height: 16),
        _buildDateField(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.green, width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пол',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedGender,
          items: _genders.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          validator: (value) => value == null ? 'Выберите пол' : null,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.green, width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дата рождения',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'
                      : 'Выберите дату',
                  style: TextStyle(
                    color: _selectedDate != null
                        ? const Color(0xFF2D3748)
                        : Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return NutrySaveButton(
      onPressed: _saveProfile,
      backgroundColor: AppColors.button,
      foregroundColor: Colors.white,
    );
  }

  Widget _buildSkipButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: () {
          Future.microtask(() {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/goals-setup');
            }
          });
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Пропустить',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class _GalleryPickerScreen extends StatefulWidget {
  const _GalleryPickerScreen();

  @override
  State<_GalleryPickerScreen> createState() => _GalleryPickerScreenState();
}

class _GalleryPickerScreenState extends State<_GalleryPickerScreen> {
  late Future<List<AssetEntity>> _assetsFuture;

  @override
  void initState() {
    super.initState();
    _assetsFuture = _loadAssets();
  }

  Future<List<AssetEntity>> _loadAssets() async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    if (paths.isEmpty) return [];
    return paths.first.getAssetListPaged(page: 0, size: 200);
  }

  Future<void> _selectAsset(AssetEntity asset) async {
    final file = await asset.file;
    if (!mounted) return;
    Navigator.pop(context, file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите фото'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<AssetEntity>>(
        future: _assetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final assets = snapshot.data ?? [];
          if (assets.isEmpty) {
            return const Center(child: Text('Нет фотографий'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];
              return GestureDetector(
                onTap: () => _selectAsset(asset),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FutureBuilder<Uint8List?>(
                    future: asset.thumbnailDataWithSize(
                      const ThumbnailSize(200, 200),
                    ),
                    builder: (context, snap) {
                      final bytes = snap.data;
                      if (bytes == null) {
                        return Container(color: Colors.grey[200]);
                      }
                      return Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Кастомный виджет для выбора даты с порядком день/месяц/год
class _CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;

  const _CustomDatePicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<_CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<_CustomDatePicker> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;
  late List<int> availableDays;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;
  int selectedDayIndex = 0;
  int selectedMonthIndex = 0;
  int selectedYearIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDate.day;
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year.clamp(
      widget.firstDate.year,
      widget.lastDate.year,
    );
    availableDays = _getDaysInMonth(selectedYear, selectedMonth);
    // Убеждаемся, что выбранный день существует в текущем месяце
    if (selectedDay > availableDays.length) {
      selectedDay = availableDays.length;
    }
    if (selectedDay < 1 && availableDays.isNotEmpty) {
      selectedDay = 1;
    }

    // Инициализируем контроллеры сразу с правильными значениями
    final dayIndex = availableDays.indexOf(selectedDay);
    selectedDayIndex =
        dayIndex >= 0 && dayIndex < availableDays.length ? dayIndex : 0;
    dayController = FixedExtentScrollController(
      initialItem: selectedDayIndex,
    );

    selectedMonthIndex = (selectedMonth - 1).clamp(0, 11);
    monthController = FixedExtentScrollController(
      initialItem: selectedMonthIndex,
    );

    final years = _getYears();
    final yearIndex = years.indexOf(selectedYear);
    selectedYearIndex =
        yearIndex >= 0 && yearIndex < years.length ? yearIndex : 0;
    yearController = FixedExtentScrollController(
      initialItem: selectedYearIndex,
    );
  }

  List<int> _getYears() {
    return List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    );
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  List<int> _getDaysInMonth(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  void _updateDays() {
    final newDays = _getDaysInMonth(selectedYear, selectedMonth);
    if (newDays.length != availableDays.length ||
        !newDays.contains(selectedDay)) {
      setState(() {
        availableDays = newDays;
        if (selectedDay > availableDays.length) {
          selectedDay = availableDays.length;
        }
        // Обновляем позицию контроллера дня
        final dayIndex = availableDays.indexOf(selectedDay);
        if (dayIndex >= 0 && dayIndex < availableDays.length) {
          selectedDayIndex = dayIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              dayController.jumpToItem(dayIndex);
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final years = _getYears();
    final months = List.generate(12, (index) => index + 1);

    // Отладочная информация
    debugPrint(
        'DatePicker: availableDays=${availableDays.length}, selectedDay=$selectedDay');
    debugPrint(
        'DatePicker: months=${months.length}, selectedMonth=$selectedMonth');
    debugPrint('DatePicker: years=${years.length}, selectedYear=$selectedYear');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Отмена',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Выберите дату рождения',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.button,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final selectedDate =
                        DateTime(selectedYear, selectedMonth, selectedDay);
                    if (selectedDate.isAfter(widget.lastDate) ||
                        selectedDate.isBefore(widget.firstDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Выбранная дата вне допустимого диапазона')),
                      );
                      return;
                    }
                    widget.onDateSelected(selectedDate);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Готово',
                    style: TextStyle(
                      color: AppColors.button,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Колеса прокрутки: День, Месяц, Год
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Фон с выделением выбранного элемента
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: AppColors.button.withValues(alpha: 0.3),
                            width: 1),
                        bottom: BorderSide(
                            color: AppColors.button.withValues(alpha: 0.3),
                            width: 1),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    // День
                    Expanded(
                      child: availableDays.isEmpty
                          ? const Center(child: Text('Нет данных'))
                          : CupertinoPicker(
                              scrollController: dayController,
                              itemExtent: 40,
                              diameterRatio: 1.0,
                              useMagnifier: true,
                              magnification: 1.0,
                              onSelectedItemChanged: (index) {
                                if (index >= 0 &&
                                    index < availableDays.length) {
                                  setState(() {
                                    selectedDay = availableDays[index];
                                    selectedDayIndex = index;
                                  });
                                }
                              },
                              children:
                                  availableDays.asMap().entries.map((entry) {
                                final index = entry.key;
                                final day = entry.value;
                                final isSelected = index == selectedDayIndex;
                                return Center(
                                  child: Text(
                                    day.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.button
                                          : Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    // Месяц
                    Expanded(
                      child: months.isEmpty
                          ? const Center(child: Text('Нет данных'))
                          : CupertinoPicker(
                              scrollController: monthController,
                              itemExtent: 40,
                              diameterRatio: 1.0,
                              useMagnifier: true,
                              magnification: 1.0,
                              onSelectedItemChanged: (index) {
                                if (index >= 0 && index < months.length) {
                                  setState(() {
                                    selectedMonth = months[index];
                                    selectedMonthIndex = index;
                                    _updateDays();
                                    // Обновляем позицию контроллера дня
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        final dayIndex =
                                            availableDays.indexOf(selectedDay);
                                        if (dayIndex >= 0 &&
                                            dayIndex < availableDays.length) {
                                          selectedDayIndex = dayIndex;
                                          dayController.jumpToItem(dayIndex);
                                        }
                                      }
                                    });
                                  });
                                }
                              },
                              children: months.asMap().entries.map((entry) {
                                final index = entry.key;
                                final month = entry.value;
                                final isSelected = index == selectedMonthIndex;
                                final monthNames = [
                                  'Янв',
                                  'Фев',
                                  'Мар',
                                  'Апр',
                                  'Май',
                                  'Июн',
                                  'Июл',
                                  'Авг',
                                  'Сен',
                                  'Окт',
                                  'Ноя',
                                  'Дек'
                                ];
                                return Center(
                                  child: Text(
                                    monthNames[month - 1],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.button
                                          : Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    // Год
                    Expanded(
                      child: years.isEmpty
                          ? const Center(child: Text('Нет данных'))
                          : CupertinoPicker(
                              scrollController: yearController,
                              itemExtent: 40,
                              diameterRatio: 1.0,
                              useMagnifier: true,
                              magnification: 1.0,
                              onSelectedItemChanged: (index) {
                                if (index >= 0 && index < years.length) {
                                  setState(() {
                                    selectedYear = years[index];
                                    selectedYearIndex = index;
                                    _updateDays();
                                    // Обновляем позицию контроллера дня
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        final dayIndex =
                                            availableDays.indexOf(selectedDay);
                                        if (dayIndex >= 0 &&
                                            dayIndex < availableDays.length) {
                                          selectedDayIndex = dayIndex;
                                          dayController.jumpToItem(dayIndex);
                                        }
                                      }
                                    });
                                  });
                                }
                              },
                              children: years.asMap().entries.map((entry) {
                                final index = entry.key;
                                final year = entry.value;
                                final isSelected = index == selectedYearIndex;
                                return Center(
                                  child: Text(
                                    year.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.button
                                          : Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
