import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/achievements/domain/repositories/achievement_repository.dart';

class GetTotalPoints {
  final AchievementRepository repository;

  GetTotalPoints(this.repository);

  Future<Either<Failure, int>> call() async {
    return await repository.getTotalPoints();
  }
}