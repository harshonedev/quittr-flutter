import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quittr/features/achievements/domain/entities/achievement.dart';
import 'package:quittr/features/achievements/domain/usecases/check_and_update_achievements.dart';
import 'package:quittr/features/achievements/domain/usecases/get_achievements.dart';
import 'package:quittr/features/achievements/domain/usecases/get_total_points.dart';
import 'package:quittr/features/achievements/domain/usecases/unlock_achievement.dart';

part 'achievements_event.dart';
part 'achievements_state.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final GetAchievements getAchievements;
  final UnlockAchievement unlockAchievement;
  final CheckAndUpdateAchievements checkAndUpdateAchievements;
  final GetTotalPoints getTotalPoints;

  AchievementsBloc({
    required this.getAchievements,
    required this.unlockAchievement,
    required this.checkAndUpdateAchievements,
    required this.getTotalPoints,
  }) : super(AchievementsInitial()) {
    on<LoadAchievementsEvent>(_onLoadAchievements);
    on<UnlockAchievementEvent>(_onUnlockAchievement);
    on<CheckStreakAchievementsEvent>(_onCheckStreakAchievements);
  }

  Future<void> _onLoadAchievements(
    LoadAchievementsEvent event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(AchievementsLoading());

    final achievementsResult = await getAchievements();
    final pointsResult = await getTotalPoints();

    achievementsResult.fold(
      (failure) => emit(AchievementsError('Failed to load achievements')),
      (achievements) {
        pointsResult.fold(
          (failure) =>
              emit(AchievementsError('Failed to calculate total points')),
          (points) => emit(AchievementsLoaded(
            achievements: achievements,
            totalPoints: points,
            newlyUnlocked: const [],
          )),
        );
      },
    );
  }

  Future<void> _onUnlockAchievement(
    UnlockAchievementEvent event,
    Emitter<AchievementsState> emit,
  ) async {
    final result = await unlockAchievement(event.achievementId);

    result.fold(
      (failure) => emit(AchievementsError('Failed to unlock achievement')),
      (achievement) async {
        if (achievement != null) {
          // Emit the unlocked achievement state
          emit(AchievementUnlocked(achievement));
        } else {
          emit(AchievementsError('Achievement already unlocked'));
        }
      },
    );
  }

  Future<void> _onCheckStreakAchievements(
    CheckStreakAchievementsEvent event,
    Emitter<AchievementsState> emit,
  ) async {
    
      final result = await checkAndUpdateAchievements(event.streakDays);

      result.fold(
        (failure) => emit(AchievementsError('Failed to check achievements')),
        (unlockedAchievements) {
          if (unlockedAchievements.isEmpty) {
            // No new achievements, keep current state
            return;
          }
          emit(AchievementUnlocked(unlockedAchievements.first));
        },
      );
  }
}
