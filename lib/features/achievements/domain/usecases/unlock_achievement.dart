import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/achievements/domain/entities/achievement.dart';
import 'package:quittr/features/achievements/domain/repositories/achievement_repository.dart';

class UnlockAchievement {
  final AchievementRepository repository;

  UnlockAchievement(this.repository);

  Future<Either<Failure, Achievement?>> call(String achievementId) async {
    return await repository.unlockAchievement(achievementId);
  }
}
