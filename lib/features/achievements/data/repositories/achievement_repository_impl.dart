import 'package:dartz/dartz.dart';
import 'package:logger/web.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/achievements/data/datasources/achievement_data_source.dart';
import 'package:quittr/features/achievements/data/models/achievement_model.dart';
import 'package:quittr/features/achievements/domain/entities/achievement.dart';
import 'package:quittr/features/achievements/domain/repositories/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementDataSource dataSource;
  final Logger logger = Logger();

  AchievementRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Achievement>>> getAchievements() async {
    try {
      final achievements = await dataSource.getAchievements();
      return Right(achievements);
    } catch (e) {
      return Left(CacheFailure("Failed to get achievements"));
    }
  }

  @override
  Future<Either<Failure, Achievement?>> unlockAchievement(
      String achievementId) async {
    try {
      // Get all achievements
      final achievements = await dataSource.getAchievements();
      if (achievements.isEmpty) {
        logger.e("No achievements found");
        return Left(CacheFailure("No achievements found")); // No achievements
      }

      logger.d("Achievements: $achievements");


      // Find the target achievement
      final achievementIndex =
          achievements.indexWhere((a) => a.id == achievementId);

      if (achievementIndex == -1) {
        return Left(CacheFailure("Achievement not found")); // Achievement not found
      }

      // Get the achievement and create an updated version
      final achievement = achievements[achievementIndex];
      logger.d("Unlocking achievement: $achievement");

      // Skip if already unlocked
      if (achievement.isUnlocked) {
        return Right(achievement);
      }

      // Create unlocked version
      final unlockedAchievement = achievement.copyWithModel(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );

      // Update the list
      achievements[achievementIndex] = unlockedAchievement;

      logger.d("Updated achievements: $achievements");

      // Save updated list
      await dataSource.saveAchievements(achievements);

      return Right(unlockedAchievement);
    } catch (e) {
      return Left(CacheFailure("Failed to unlock achievement"));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> checkAndUpdateAchievements(
      int streakDays) async {
    try {
      // Get all achievements
      final achievements = await dataSource.getAchievements();

      // Find streak-based achievements that should be unlocked
      final updatedAchievements = <AchievementModel>[];

      for (final achievement in achievements) {
        if (achievement.type == AchievementType.streak &&
            streakDays >= achievement.requiredDays &&
            !achievement.isUnlocked) {
          // Unlock this achievement
          final unlockedAchievement = achievement.copyWithModel(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
          );
          updatedAchievements.add(unlockedAchievement);
        }
      }

      if (updatedAchievements.isEmpty) {
        return Right([]); // No achievements to unlock
      }

      // Update the achievements list
      final newAchievementsList = achievements.map((a) {
        final match = updatedAchievements.firstWhere(
          (u) => u.id == a.id,
          orElse: () => a,
        );
        return match;
      }).toList();

      // Save the updated list
      await dataSource.saveAchievements(newAchievementsList);

      return Right(updatedAchievements);
    } catch (e) {
      Logger().e("Error checking and updating achievements: $e");
      return Left(CacheFailure("Failed to check and update achievements"));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalPoints() async {
    try {
      final totalPoints = await dataSource.getTotalPoints();
      return Right(totalPoints);
    } catch (e) {
      return Left(CacheFailure("Failed to get total points"));
    }
  }
}
