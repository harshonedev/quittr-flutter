import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:quittr/features/achievements/data/models/achievement_model.dart';
import 'package:quittr/features/achievements/domain/entities/achievement.dart';

abstract class AchievementDataSource {
  /// Get all achievements
  Future<List<AchievementModel>> getAchievements();

  /// Save all achievements
  Future<void> saveAchievements(List<AchievementModel> achievements);

  /// Get total achievement points
  Future<int> getTotalPoints();
}

class AchievementLocalDataSource implements AchievementDataSource {
  final GetStorage storage;
  static const String achievementsKey = 'achievements';
  final Logger logger = Logger();

  AchievementLocalDataSource({required this.storage});

  @override
  Future<List<AchievementModel>> getAchievements() async {
    try {
      final achievementsJson = storage.read<List<dynamic>>(achievementsKey);
      logger.d('Achievements JSON: $achievementsJson');

      if (achievementsJson == null) {
        // Return default predefined achievements if none exist
        final defaultAchievements = _getDefaultAchievements();
        await saveAchievements(defaultAchievements);
        return defaultAchievements;
      }

      return achievementsJson
          .map(
              (json) => AchievementModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error, return default achievements
      final defaultAchievements = _getDefaultAchievements();
      await saveAchievements(defaultAchievements);
      return defaultAchievements;
    }
  }

  @override
  Future<void> saveAchievements(List<AchievementModel> achievements) async {
    final achievementsJson =
        achievements.map((achievement) => achievement.toJson()).toList();
    await storage.write(achievementsKey, achievementsJson);
    logger.d('Achievements saved: $achievementsJson');
  }

  @override
  Future<int> getTotalPoints() async {
    final achievements = await getAchievements();
    return achievements
        .where((a) => a.isUnlocked)
        .fold(0, (sum, a) async => (await sum )+ a.pointsAwarded);
  }

  /// Returns a list of default predefined achievements
  List<AchievementModel> _getDefaultAchievements() {
    return [
      // Streak-based achievements
      const AchievementModel(
        id: 'streak_1_day',
        title: 'First Step',
        description: 'Complete your first day without a relapse',
        pointsAwarded: 10,
        iconName: 'foot_print',
        isUnlocked: false,
        requiredDays: 1,
        type: AchievementType.streak,
      ),
      const AchievementModel(
        id: 'streak_3_days',
        title: 'Three-Day Triumph',
        description: 'Stay addiction-free for 3 days',
        pointsAwarded: 20,
        iconName: 'calendar_3',
        isUnlocked: false,
        requiredDays: 3,
        type: AchievementType.streak,
      ),
      const AchievementModel(
        id: 'streak_7_days',
        title: 'One Week Wonder',
        description: 'Complete a full week without relapsing',
        pointsAwarded: 50,
        iconName: 'calendar_week',
        isUnlocked: false,
        requiredDays: 7,
        type: AchievementType.streak,
      ),
      const AchievementModel(
        id: 'streak_14_days',
        title: 'Fortnight Warrior',
        description: 'Stay addiction-free for two weeks',
        pointsAwarded: 100,
        iconName: 'calendar_2w',
        isUnlocked: false,
        requiredDays: 14,
        type: AchievementType.streak,
      ),
      const AchievementModel(
        id: 'streak_30_days',
        title: 'Monthly Champion',
        description: 'Complete a full month without relapsing',
        pointsAwarded: 200,
        iconName: 'calendar_month',
        isUnlocked: false,
        requiredDays: 30,
        type: AchievementType.streak,
      ),
      const AchievementModel(
        id: 'streak_90_days',
        title: 'Quarterly Victory',
        description: 'Stay addiction-free for 90 days',
        pointsAwarded: 500,
        iconName: 'calendar_3m',
        isUnlocked: false,
        requiredDays: 90,
        type: AchievementType.streak,
      ),
      const AchievementModel(
        id: 'streak_180_days',
        title: 'Half-Year Hero',
        description: 'Complete 6 months without relapsing',
        pointsAwarded: 1000,
        iconName: 'calendar_6m',
        isUnlocked: false,
        requiredDays: 180,
        type: AchievementType.streak,
      ),
      const AchievementModel(
        id: 'streak_365_days',
        title: 'One Year Milestone',
        description: 'Stay addiction-free for a full year',
        pointsAwarded: 2000,
        iconName: 'calendar_year',
        isUnlocked: false,
        requiredDays: 365,
        type: AchievementType.streak,
      ),

      // Action-based achievements
      const AchievementModel(
        id: 'action_pledge',
        title: 'Promise Keeper',
        description: 'Make your first pledge',
        pointsAwarded: 15,
        iconName: 'handshake',
        isUnlocked: false,
        requiredDays: 0,
        type: AchievementType.action,
      ),
      const AchievementModel(
        id: 'action_journal',
        title: 'Dear Diary',
        description: 'Write your first journal entry',
        pointsAwarded: 15,
        iconName: 'book',
        isUnlocked: false,
        requiredDays: 0,
        type: AchievementType.action,
      ),
      const AchievementModel(
        id: 'action_meditate',
        title: 'Inner Peace',
        description: 'Complete your first meditation session',
        pointsAwarded: 15,
        iconName: 'meditation',
        isUnlocked: false,
        requiredDays: 0,
        type: AchievementType.action,
      ),
      const AchievementModel(
        id: 'action_breathing',
        title: 'Deep Breather',
        description: 'Complete your first breathing exercise',
        pointsAwarded: 15,
        iconName: 'breathing',
        isUnlocked: false,
        requiredDays: 0,
        type: AchievementType.action,
      ),

      // Milestone achievements
      const AchievementModel(
        id: 'milestone_reason',
        title: 'Purpose Finder',
        description: 'Add your first reason for quitting',
        pointsAwarded: 20,
        iconName: 'lightbulb',
        isUnlocked: false,
        requiredDays: 0,
        type: AchievementType.milestone,
      ),
      const AchievementModel(
        id: 'milestone_learn',
        title: 'Knowledge Seeker',
        description: 'Read an article from the library',
        pointsAwarded: 20,
        iconName: 'school',
        isUnlocked: false,
        requiredDays: 0,
        type: AchievementType.milestone,
      ),
    ];
  }
}
