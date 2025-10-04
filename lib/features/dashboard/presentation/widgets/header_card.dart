import 'package:flutter/material.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../../shared/theme/app_colors.dart';

class HeaderCard extends StatelessWidget {
  final UserProfile? userProfile;

  const HeaderCard({super.key, this.userProfile});

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return _buildEmptyProfile(context);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            // Верхняя секция с аватаром и основной информацией
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildBasicInfo(context),
                ),
                _buildEditButton(context),
              ],
            ),
            const SizedBox(height: 16),
            // Нижняя секция с дополнительной информацией
            _buildAdditionalInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.green, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: userProfile?.avatarUrl != null
            ? NetworkImage(userProfile!.avatarUrl!)
            : null,
        child:
            userProfile?.avatarUrl == null ? _buildAvatarPlaceholder() : null,
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    final String? name = userProfile?.fullName;
    if (name != null && name.isNotEmpty) {
      // Показать инициалы
      final String initials = name
          .split(' ')
          .take(2)
          .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
          .join('');

      return Text(
        initials,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.green,
        ),
      );
    } else {
      // Показать иконку
      return Icon(
        Icons.person,
        size: 32,
        color: Colors.grey.shade400,
      );
    }
  }

  Widget _buildBasicInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userProfile?.fullName ?? 'Имя не указано',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          userProfile?.email ?? 'Email не указан',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        if (userProfile?.age != null) ...[
          const SizedBox(height: 4),
          Text(
            '${userProfile!.age} лет',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/profile-settings');
        },
        icon: Icon(
          Icons.edit,
          color: AppColors.green,
          size: 20,
        ),
        tooltip: 'Редактировать профиль',
      ),
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final completeness = _calculateCompleteness();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildInfoChip(
            'Заполнено',
            '${completeness.toStringAsFixed(0)}%',
            _getCompletenessColor(completeness),
          ),
          const SizedBox(width: 12),
          if (userProfile?.bmi != null)
            _buildInfoChip(
              'ИМТ',
              userProfile!.bmi!.toStringAsFixed(1),
              _getBMIColor(userProfile!.bmi!),
            ),
          const Spacer(),
          Icon(
            userProfile?.profileCompleteness == 1.0
                ? Icons.verified_user
                : Icons.info_outline,
            color: userProfile?.profileCompleteness == 1.0
                ? AppColors.green
                : Colors.orange,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProfile(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Профиль не заполнен',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Заполните информацию о себе для персонализации',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/profile-settings');
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Заполнить профиль'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateCompleteness() {
    if (userProfile == null) return 0.0;

    return userProfile!.profileCompleteness * 100;
  }

  Color _getCompletenessColor(double completeness) {
    if (completeness >= 80) return AppColors.green;
    if (completeness >= 50) return AppColors.yellow;
    return AppColors.orange;
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return AppColors.yellow; // Недостаток веса
    if (bmi <= 24.9) return AppColors.green; // Норма
    if (bmi <= 29.9) return AppColors.orange; // Избыток
    return Colors.red; // Ожирение
  }
}
