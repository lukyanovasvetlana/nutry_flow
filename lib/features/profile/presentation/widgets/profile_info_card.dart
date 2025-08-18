import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileInfoCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Личная информация',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            // Personal Details
            _buildInfoRow(
              icon: Icons.person,
              label: 'Полное имя',
              value: profile.fullName,
            ),

            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: profile.email,
            ),

            if (profile.phone?.isNotEmpty == true)
              _buildInfoRow(
                icon: Icons.phone,
                label: 'Телефон',
                value: profile.phone ?? '',
              ),

            if (profile.dateOfBirth != null)
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Дата рождения',
                value: _formatDate(profile.dateOfBirth!),
              ),

            if (profile.gender != null)
              _buildInfoRow(
                icon: Icons.person_outline,
                label: 'Пол',
                value: profile.gender!.displayName,
              ),

            if (profile.activityLevel != null)
              _buildInfoRow(
                icon: Icons.fitness_center,
                label: 'Уровень активности',
                value: profile.activityLevel!.displayName,
              ),

            // Health Information
            if (profile.allergies.isNotEmpty ||
                profile.healthConditions.isNotEmpty) ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Здоровье',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              if (profile.allergies.isNotEmpty)
                _buildInfoRow(
                  icon: Icons.warning,
                  label: 'Аллергии',
                  value: profile.allergies.join(', '),
                  valueColor: Colors.orange.shade700,
                ),
              if (profile.healthConditions.isNotEmpty)
                _buildInfoRow(
                  icon: Icons.medical_services,
                  label: 'Состояние здоровья',
                  value: profile.healthConditions.join(', '),
                  valueColor: Colors.blue.shade700,
                ),
            ],

            // Dietary Preferences
            if (profile.dietaryPreferences.isNotEmpty) ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Предпочтения в питании',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.dietaryPreferences.map((pref) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 14,
                          color: Colors.green.shade600,
                        ),
                        SizedBox(width: 4),
                        Text(
                          pref.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value.isEmpty ? 'Не указано' : value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: value.isEmpty
                        ? Colors.grey.shade400
                        : valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
