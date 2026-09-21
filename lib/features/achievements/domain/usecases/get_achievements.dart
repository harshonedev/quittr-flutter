import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/achievements/domain/entities/achievement.dart';
import 'package:quittr/features/achievements/domain/repositories/achievement_repository.dart';

class GetAchievements {
  final AchievementRepository repository;

  GetAchievements(this.repository);

  Future<Either<Failure, List<Achievement>>> call() async {
    return await repository.getAchievements();
  }
}
