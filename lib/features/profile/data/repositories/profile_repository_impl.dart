import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/profile/domain/entities/profile.dart';
import 'package:quittr/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseStorage _storage;

  ProfileRepositoryImpl({
    required firebase_auth.FirebaseAuth auth,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _storage = storage;

  @override
  Profile? get currentProfile {
    final user = _auth.currentUser;
    if (user == null) return null;

    return Profile(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(Profile profile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      await user.updateDisplayName(profile.displayName);
      if (profile.photoUrl != null) {
        await user.updatePhotoURL(profile.photoUrl);
      }

      return Right(Profile(
        uid: user.uid,
        displayName: profile.displayName,
        email: user.email,
        photoUrl: profile.photoUrl,
      ));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfilePhoto(String imagePath) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      // Upload to Firebase Storage
      final file = File(imagePath);
      final ref = _storage.ref().child('profile_photos/${user.uid}');

      // Upload with metadata to ensure proper content type
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked': 'true'},
      );
      await ref.putFile(file, metadata);

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      // Update user profile
      await user.updatePhotoURL(downloadUrl);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
