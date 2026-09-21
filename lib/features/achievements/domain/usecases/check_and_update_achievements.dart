import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/achievements/domain/entities/achievement.dart';
import 'package:quittr/features/achievements/domain/repositories/achievement_repository.dart';

class CheckAndUpdateAchievements {
  final AchievementRepository repository;

  CheckAndUpdateAchievements(this.repository);

  Future<Either<Failure, List<Achievement>>> call(int streakDays) async {
    return await repository.checkAndUpdateAchievements(streakDays);
  }
}
