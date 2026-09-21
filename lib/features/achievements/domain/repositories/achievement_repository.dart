import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/achievements/domain/entities/achievement.dart';

abstract class AchievementRepository {
  /// Get all achievements
  Future<Either<Failure, List<Achievement>>> getAchievements();

  /// Unlock an achievement
  Future<Either<Failure, Achievement?>> unlockAchievement(String achievementId);

  /// Check and update achievements based on streak days
  Future<Either<Failure, List<Achievement>>> checkAndUpdateAchievements(
      int streakDays);

  /// Get total achievement points
  Future<Either<Failure, int>> getTotalPoints();
}
