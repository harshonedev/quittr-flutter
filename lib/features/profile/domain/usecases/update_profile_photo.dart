import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class UpdateProfilePhoto implements UseCase<void, String> {
  final ProfileRepository repository;

  UpdateProfilePhoto(this.repository);

  @override
  Future<Either<Failure, void>> call(String imagePath) async {
    if (!await _isValidImageSize(imagePath)) {
      return const Left(
        ValidationFailure('Image size should be less than 5MB'),
      );
    }
    return repository.updateProfilePhoto(imagePath);
  }

  Future<bool> _isValidImageSize(String path) async {
    final file = File(path);
    final bytes = await file.length();
    const maxSize = 5 * 1024 * 1024; // 5MB in bytes
    return bytes <= maxSize;
  }
}
