import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quittr/features/profile/domain/entities/profile.dart';
import 'package:quittr/features/profile/domain/repositories/profile_repository.dart';
import 'package:quittr/features/auth/domain/repositories/auth_repository.dart';
import 'package:quittr/features/profile/domain/usecases/update_profile_photo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;
  final UpdateProfilePhoto _updateProfilePhoto;

  ProfileBloc({
    required ProfileRepository profileRepository,
    required AuthRepository authRepository,
    required UpdateProfilePhoto updateProfilePhoto,
  })  : _profileRepository = profileRepository,
        _authRepository = authRepository,
        _updateProfilePhoto = updateProfilePhoto,
        super(const ProfileState.loading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateProfilePhotoEvent>(_onUpdateProfilePhoto);
    on<SignOut>(_onSignOut);
    on<DeleteAccount>(_onDeleteAccount);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    final profile = _profileRepository.currentProfile;
    if (profile != null) {
      emit(ProfileState.loaded(profile));
    } else {
      emit(const ProfileState.error('User not found'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _profileRepository.updateProfile(event.profile);
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }

  Future<void> _onUpdateProfilePhoto(
    UpdateProfilePhotoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isUploadingPhoto: true, errorMessage: null));

    final result = await _updateProfilePhoto(event.imagePath);

    result.fold(
      (failure) => emit(state.copyWith(
        isUploadingPhoto: false,
        errorMessage: failure.message,
      )),
      (_) {
        // Reload profile to get updated photo URL
        add(LoadProfile());
      },
    );
  }

  Future<void> _onSignOut(SignOut event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (_) => emit(const ProfileState.initial()),
    );
  }

  Future<void> _onDeleteAccount(
      DeleteAccount event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _authRepository.deleteAccount();
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (_) => emit(const ProfileState.initial()),
    );
  }
}
