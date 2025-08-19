import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final List<String> _genders = ['Мужской', 'Женский', 'Другой'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите фото'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppColors.green),
                title: const Text('Галерея'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.green),
                title: const Text('Камера'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.green,
              onPrimary: Colors.white,
              onSurface: Color(0xFF2D3748),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль сохранен!')),
      );
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
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
          onPressed: () => Navigator.pushReplacementNamed(context, '/registration'),
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
                        color: AppColors.green, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),
                _buildFormFields(),
                const SizedBox(height: 40),
                _buildSaveButton(),
                const SizedBox(height: 16),
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
            backgroundImage:
                _profileImage != null ? FileImage(_profileImage!) : null,
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
                color: AppColors.green,
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
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 2,
          shadowColor: AppColors.green.withValues(alpha: 0.4),
        ),
        child: const Text(
          'Сохранить',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/onboarding');
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
