import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;
  
  const LoadProfile(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

class UpdateProfile extends ProfileEvent {
  final UserProfile profile;
  
  const UpdateProfile(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

class UploadAvatar extends ProfileEvent {
  final String userId;
  final String imagePath;
  
  const UploadAvatar(this.userId, this.imagePath);
  
  @override
  List<Object?> get props => [userId, imagePath];
}

class DeleteAvatar extends ProfileEvent {
  final String userId;
  
  const DeleteAvatar(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

class RefreshProfile extends ProfileEvent {
  final String userId;
  
  const RefreshProfile(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  
  const ProfileLoaded(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  
  const ProfileError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ProfileUpdating extends ProfileState {
  final UserProfile profile;
  
  const ProfileUpdating(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

class ProfileUpdated extends ProfileState {
  final UserProfile profile;
  
  const ProfileUpdated(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

class AvatarUploading extends ProfileState {
  final UserProfile profile;
  
  const AvatarUploading(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

class AvatarUploaded extends ProfileState {
  final UserProfile profile;
  
  const AvatarUploaded(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  ProfileBloc({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _updateUserProfileUseCase = updateUserProfileUseCase,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UploadAvatar>(_onUploadAvatar);
    on<DeleteAvatar>(_onDeleteAvatar);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    print('🟪 ProfileBloc: Loading profile for user: ${event.userId}');
    emit(ProfileLoading());
    
    try {
      final result = await _getUserProfileUseCase.execute(event.userId);
      
      if (result.isSuccess) {
        print('🟪 ProfileBloc: Profile loaded successfully');
        emit(ProfileLoaded(result.profile!));
      } else {
        print('🟪 ProfileBloc: Failed to load profile: ${result.error}');
        emit(ProfileError(result.error ?? 'Failed to load profile'));
      }
    } catch (e) {
      print('🟪 ProfileBloc: Exception loading profile: $e');
      emit(ProfileError('An unexpected error occurred'));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    print('🟪 ProfileBloc: Updating profile for user: ${event.profile.id}');
    emit(ProfileUpdating(event.profile));
    
    try {
      final result = await _updateUserProfileUseCase.execute(event.profile);
      
      if (result.isSuccess) {
        print('🟪 ProfileBloc: Profile updated successfully');
        emit(ProfileUpdated(result.profile!));
      } else {
        print('🟪 ProfileBloc: Failed to update profile: ${result.error}');
        emit(ProfileError(result.error ?? 'Failed to update profile'));
      }
    } catch (e) {
      print('🟪 ProfileBloc: Exception updating profile: $e');
      emit(ProfileError('An unexpected error occurred'));
    }
  }

  Future<void> _onUploadAvatar(UploadAvatar event, Emitter<ProfileState> emit) async {
    print('🟪 ProfileBloc: Uploading avatar for user: ${event.userId}');
    
    // Get current profile first
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      emit(ProfileError('Profile not loaded'));
      return;
    }
    
    emit(AvatarUploading(currentState.profile));
    
    try {
      // Simulate avatar upload - in real app, this would be handled by repository
      await Future.delayed(Duration(seconds: 2));
      
      final updatedProfile = currentState.profile.copyWith(
        avatarUrl: 'https://example.com/avatar/${event.userId}.jpg',
      );
      
      final result = await _updateUserProfileUseCase.execute(updatedProfile);
      
      if (result.isSuccess) {
        print('🟪 ProfileBloc: Avatar uploaded successfully');
        emit(AvatarUploaded(result.profile!));
      } else {
        print('🟪 ProfileBloc: Failed to upload avatar: ${result.error}');
        emit(ProfileError(result.error ?? 'Failed to upload avatar'));
      }
    } catch (e) {
      print('🟪 ProfileBloc: Exception uploading avatar: $e');
      emit(ProfileError('An unexpected error occurred'));
    }
  }

  Future<void> _onDeleteAvatar(DeleteAvatar event, Emitter<ProfileState> emit) async {
    print('🟪 ProfileBloc: Deleting avatar for user: ${event.userId}');
    
    // Get current profile first
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      emit(ProfileError('Profile not loaded'));
      return;
    }
    
    emit(ProfileUpdating(currentState.profile));
    
    try {
      final updatedProfile = currentState.profile.copyWith(
        avatarUrl: null,
      );
      
      final result = await _updateUserProfileUseCase.execute(updatedProfile);
      
      if (result.isSuccess) {
        print('🟪 ProfileBloc: Avatar deleted successfully');
        emit(ProfileUpdated(result.profile!));
      } else {
        print('🟪 ProfileBloc: Failed to delete avatar: ${result.error}');
        emit(ProfileError(result.error ?? 'Failed to delete avatar'));
      }
    } catch (e) {
      print('🟪 ProfileBloc: Exception deleting avatar: $e');
      emit(ProfileError('An unexpected error occurred'));
    }
  }

  Future<void> _onRefreshProfile(RefreshProfile event, Emitter<ProfileState> emit) async {
    print('🟪 ProfileBloc: Refreshing profile for user: ${event.userId}');
    
    // Don't show loading state for refresh
    try {
      final result = await _getUserProfileUseCase.execute(event.userId);
      
      if (result.isSuccess) {
        print('🟪 ProfileBloc: Profile refreshed successfully');
        emit(ProfileLoaded(result.profile!));
      } else {
        print('🟪 ProfileBloc: Failed to refresh profile: ${result.error}');
        emit(ProfileError(result.error ?? 'Failed to refresh profile'));
      }
    } catch (e) {
      print('🟪 ProfileBloc: Exception refreshing profile: $e');
      emit(ProfileError('An unexpected error occurred'));
    }
  }
} 