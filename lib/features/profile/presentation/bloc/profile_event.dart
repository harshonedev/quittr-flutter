part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Profile profile;

  const UpdateProfile(this.profile);

  @override
  List<Object> get props => [profile];
}

class SignOut extends ProfileEvent {}

class UpdateProfilePhotoEvent extends ProfileEvent {
  final String imagePath;

  const UpdateProfilePhotoEvent(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class DeleteAccount extends ProfileEvent {}
