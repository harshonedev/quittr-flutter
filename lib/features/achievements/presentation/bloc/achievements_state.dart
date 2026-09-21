part of 'achievements_bloc.dart';

abstract class AchievementsState extends Equatable {
  const AchievementsState();

  @override
  List<Object> get props => [];
}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoading extends AchievementsState {}

class AchievementsLoaded extends AchievementsState {
  final List<Achievement> achievements;
  final int totalPoints;
  final List<Achievement> newlyUnlocked;

  const AchievementsLoaded({
    required this.achievements,
    required this.totalPoints,
    required this.newlyUnlocked,
  });

  @override
  List<Object> get props => [achievements, totalPoints, newlyUnlocked];
}

class AchievementsError extends AchievementsState {
  final String message;

  const AchievementsError(this.message);

  @override
  List<Object> get props => [message];
}

class AchievementUnlocked extends AchievementsState {
  final Achievement achievement;

  const AchievementUnlocked(this.achievement);

  @override
  List<Object> get props => [achievement];
}
