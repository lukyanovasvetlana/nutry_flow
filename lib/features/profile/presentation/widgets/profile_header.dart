import 'package:flutter/material.dart';
import '../../../../shared/design/tokens/theme_tokens.dart';
import '../../domain/entities/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.onAvatarTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primary,
            context.primaryContainer,
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and Edit Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar
              GestureDetector(
                onTap: onAvatarTap,
                child: Stack(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.shadow.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: context.surface,
                        backgroundImage: profile.avatarUrl != null
                            ? NetworkImage(profile.avatarUrl!)
                            : null,
                        child: profile.avatarUrl == null
                            ? Text(
                                profile.initials,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: context.primary,
                                ),
                              )
                            : null,
                      ),
                    ),
                    if (onAvatarTap != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: context.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.primary,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: context.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Edit Button
              if (onEditTap != null)
                IconButton(
                  onPressed: onEditTap,
                  icon: Icon(
                    Icons.edit,
                    color: context.onPrimary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: context.surface.withValues(alpha: 0.2),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            profile.fullName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          if (profile.email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              profile.email,
              style: TextStyle(
                fontSize: 14,
                color: context.onPrimary.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 16),

          // Basic Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.cake,
                label: 'Возраст',
                value: '${profile.age} лет',
                context: context,
              ),
              _buildStatItem(
                icon: Icons.monitor_weight,
                label: 'Вес',
                value: profile.weight != null
                    ? '${profile.weight} кг'
                    : 'Не указан',
                context: context,
              ),
              _buildStatItem(
                icon: Icons.height,
                label: 'Рост',
                value: profile.height != null
                    ? '${profile.height} см'
                    : 'Не указан',
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: context.onPrimary.withValues(alpha: 0.8),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: context.onPrimary.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: context.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
