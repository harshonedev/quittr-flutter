part of 'achievements_bloc.dart';

abstract class AchievementsEvent extends Equatable {
  const AchievementsEvent();

  @override
  List<Object> get props => [];
}

class LoadAchievementsEvent extends AchievementsEvent {}

class UnlockAchievementEvent extends AchievementsEvent {
  final String achievementId;

  const UnlockAchievementEvent(this.achievementId);

  @override
  List<Object> get props => [achievementId];

  // Predefined action types for consistency
  static const String firstPledge = 'action_pledge';
  static const String firstJournal = 'action_journal';
  static const String firstMeditation = 'action_meditate';
  static const String firstBreathingExercise = 'action_breathing';

  // Predefined milestone types for consistency
  static const String addReason = 'milestone_reason';
  static const String readArticle = 'milestone_learn';
  static const String addProfilePhoto = 'milestone_photo';
}

class CheckStreakAchievementsEvent extends AchievementsEvent {
  final int streakDays;

  const CheckStreakAchievementsEvent(this.streakDays);

  @override
  List<Object> get props => [streakDays];
}
