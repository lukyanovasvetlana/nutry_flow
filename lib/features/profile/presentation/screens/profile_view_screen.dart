import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/profile_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../di/profile_dependencies.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_goals_card.dart';
import 'profile_edit_screen.dart';

class ProfileViewScreen extends StatefulWidget {
  final String userId;

  const ProfileViewScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileDependencies.createProfileBloc();
    _profileBloc.add(LoadProfile(widget.userId));
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => _profileBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Профиль',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToEditProfile(context, state.profile),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки профиля',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _profileBloc.add(LoadProfile(widget.userId)),
                      child: Text('Повторить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ProfileLoaded || state is ProfileUpdating || state is ProfileUpdated) {
              final profile = state is ProfileLoaded
                  ? state.profile
                  : state is ProfileUpdating
                      ? state.profile
                      : (state as ProfileUpdated).profile;

              return RefreshIndicator(
                onRefresh: () async {
                  _profileBloc.add(RefreshProfile(widget.userId));
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header with Avatar and Basic Info
                      ProfileHeader(
                        profile: profile,
                        onAvatarTap: () => _showAvatarOptions(context),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Personal Information Card
                      ProfileInfoCard(profile: profile),
                      
                      SizedBox(height: 16),
                      
                      // Health Stats Card
                      ProfileStatsCard(profile: profile),
                      
                      SizedBox(height: 16),
                      
                      // Goals and Targets Card
                      ProfileGoalsCard(profile: profile),
                      
                      SizedBox(height: 16),
                      
                      // Quick Actions
                      _buildQuickActions(context, profile),
                      
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, UserProfile profile) {
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
              'Быстрые действия',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.edit,
                    label: 'Редактировать',
                    color: Colors.blue,
                    onTap: () => _navigateToEditProfile(context, profile),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.camera_alt,
                    label: 'Фото',
                    color: Colors.green,
                    onTap: () => _showAvatarOptions(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.share,
                    label: 'Поделиться',
                    color: Colors.orange,
                    onTap: () => _shareProfile(context, profile),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.settings,
                    label: 'Настройки',
                    color: Colors.grey,
                    onTap: () => _openSettings(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, UserProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _profileBloc,
          child: ProfileEditScreen(userProfile: profile),
        ),
      ),
    ).then((updated) {
      if (updated == true) {
        _profileBloc.add(RefreshProfile(widget.userId));
      }
    });
  }

  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Изменить фото профиля',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildAvatarOption(
                    context,
                    icon: Icons.camera_alt,
                    label: 'Камера',
                    onTap: () {
                      Navigator.pop(context);
                      _uploadAvatar(context, 'camera');
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildAvatarOption(
                    context,
                    icon: Icons.photo_library,
                    label: 'Галерея',
                    onTap: () {
                      Navigator.pop(context);
                      _uploadAvatar(context, 'gallery');
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildAvatarOption(
                    context,
                    icon: Icons.delete,
                    label: 'Удалить',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _deleteAvatar(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final optionColor = color ?? Colors.green;
    
    return Material(
      color: optionColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(
                icon,
                color: optionColor,
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: optionColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _uploadAvatar(BuildContext context, String source) {
    // Simulate image path
    final imagePath = source == 'camera' ? '/camera/image.jpg' : '/gallery/image.jpg';
    
    _profileBloc.add(UploadAvatar(widget.userId, imagePath));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Загрузка фото...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteAvatar(BuildContext context) {
    _profileBloc.add(DeleteAvatar(widget.userId));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Фото удалено'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _shareProfile(BuildContext context, UserProfile profile) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Функция "Поделиться" будет доступна в следующих версиях'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Настройки будут доступны в следующих версиях'),
        duration: Duration(seconds: 2),
      ),
    );
  }
} 