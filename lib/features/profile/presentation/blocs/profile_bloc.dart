import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;
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

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    developer.log('🔵 ProfileBloc: Loading profile for userId: ${event.userId}', name: 'ProfileBloc');
    emit(ProfileLoading());

    try {
      developer.log('🔵 ProfileBloc: Calling getUserProfileUseCase.execute', name: 'ProfileBloc');
      final result = await _getUserProfileUseCase.execute(event.userId);
      developer.log('🔵 ProfileBloc: UseCase result - isSuccess: ${result.isSuccess}', name: 'ProfileBloc');

      if (result.isSuccess && result.profile != null) {
        developer.log('🔵 ProfileBloc: Profile loaded successfully: ${result.profile?.firstName}', name: 'ProfileBloc');
        emit(ProfileLoaded(result.profile!));
      } else {
        developer.log('🔴 ProfileBloc: Failed to load profile - error: ${result.error}', name: 'ProfileBloc');
        // Показываем более информативное сообщение об ошибке
        final errorMessage = result.error ?? 'Не удалось загрузить профиль. Попробуйте обновить страницу.';
        emit(ProfileError(errorMessage));
      }
    } catch (e, stackTrace) {
      developer.log('🔴 ProfileBloc: Exception in _onLoadProfile: $e', name: 'ProfileBloc');
      developer.log('🔴 ProfileBloc: Stack trace: $stackTrace', name: 'ProfileBloc');
      emit(ProfileError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdating(event.profile));

    try {
      final result = await _updateUserProfileUseCase.execute(event.profile);

      if (result.isSuccess) {
        emit(ProfileUpdated(result.profile!));
      } else {
        emit(ProfileError(result.error ?? 'Failed to update profile'));
      }
    } catch (e) {
      emit(ProfileError('An unexpected error occurred'));
    }
  }

  Future<void> _onUploadAvatar(
      UploadAvatar event, Emitter<ProfileState> emit) async {
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
        emit(AvatarUploaded(result.profile!));
      } else {
        emit(ProfileError(result.error ?? 'Failed to upload avatar'));
      }
    } catch (e) {
      emit(ProfileError('An unexpected error occurred'));
    }
  }

  Future<void> _onDeleteAvatar(
      DeleteAvatar event, Emitter<ProfileState> emit) async {
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
        emit(ProfileUpdated(result.profile!));
      } else {
        emit(ProfileError(result.error ?? 'Failed to delete avatar'));
      }
    } catch (e) {
      emit(ProfileError('An unexpected error occurred'));
    }
  }

  Future<void> _onRefreshProfile(
      RefreshProfile event, Emitter<ProfileState> emit) async {
    // Don't show loading state for refresh
    try {
      final result = await _getUserProfileUseCase.execute(event.userId);

      if (result.isSuccess) {
        emit(ProfileLoaded(result.profile!));
      } else {
        emit(ProfileError(result.error ?? 'Failed to refresh profile'));
      }
    } catch (e) {
      emit(ProfileError('An unexpected error occurred'));
    }
  }
}
