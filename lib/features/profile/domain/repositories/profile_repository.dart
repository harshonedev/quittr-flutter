import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Profile? get currentProfile;
  Future<Either<Failure, Profile>> updateProfile(Profile profile);
  Future<Either<Failure, void>> updateProfilePhoto(String imagePath);
}
