import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/auth/domain/repositories/auth_repository.dart';
import 'package:quittr/features/relapse_tracker/domain/entities/streak.dart';
import 'package:quittr/features/relapse_tracker/domain/repositories/relapse_tracker_repository.dart';

class GetCurrentStreak implements UseCase<Stream<Streak>, NoParams> {
  final RelapseTrackerRepository repository;
  final AuthRepository authRepository; // For getting current user

  GetCurrentStreak(this.repository, this.authRepository);

  @override
  Either<Failure, Stream<Streak>> call(NoParams params) {
    final user = authRepository.currentUser;
    if (user == null) throw const AuthFailure('User not authenticated');
    return repository.getCurrentStreak(user.id);
  }
}
