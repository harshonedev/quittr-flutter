import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/features/achievements/domain/entities/achievement.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/achievements/presentation/widgets/achievement_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: BlocConsumer<AchievementsBloc, AchievementsState>(
        listener: (context, state) {
          if (state is AchievementsLoaded && state.newlyUnlocked.isNotEmpty) {
            _showAchievementUnlockedDialog(context, state.newlyUnlocked.first);
          } else if (state is AchievementsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AchievementsInitial) {
            // Load achievements when the screen is first opened
            context.read<AchievementsBloc>().add(LoadAchievementsEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is AchievementsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AchievementsLoaded) {
            return _buildAchievementsList(context, state);
          } else if (state is AchievementsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AchievementsBloc>()
                          .add(LoadAchievementsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildAchievementsList(
      BuildContext context, AchievementsLoaded state) {
    final achievements = state.achievements;

    // Sort achievements: unlocked first (by unlock date), then locked by achievement type
    final sortedAchievements = List<Achievement>.from(achievements);
    sortedAchievements.sort((a, b) {
      if (a.isUnlocked && b.isUnlocked) {
        // Both unlocked: sort by unlock date descending
        return (b.unlockedAt?.compareTo(a.unlockedAt ?? DateTime.now()) ?? 0);
      } else if (a.isUnlocked) {
        // Only a is unlocked, it comes first
        return -1;
      } else if (b.isUnlocked) {
        // Only b is unlocked, it comes first
        return 1;
      } else {
        // Both locked: sort by achievement type and then required days
        if (a.type != b.type) {
          return a.type.index.compareTo(b.type.index);
        }
        return a.requiredDays.compareTo(b.requiredDays);
      }
    });

    // Group achievements by type
    final Map<AchievementType, List<Achievement>> groupedAchievements = {};
    for (final achievement in sortedAchievements) {
      if (!groupedAchievements.containsKey(achievement.type)) {
        groupedAchievements[achievement.type] = [];
      }
      groupedAchievements[achievement.type]!.add(achievement);
    }

    final List<AchievementType> types = AchievementType.values.toList();

    return CustomScrollView(
      slivers: [
        // Total points header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total Achievement Points',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.totalPoints}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
        ),

        // Achievement sections by type
        ...types.map((type) {
          final achievements = groupedAchievements[type] ?? [];
          if (achievements.isEmpty)
            return const SliverToBoxAdapter(child: SizedBox.shrink());

          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    _getTypeTitle(type),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    return AchievementCard(achievement: achievement);
                  },
                ),
              ],
            ),
          );
        }),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  String _getTypeTitle(AchievementType type) {
    switch (type) {
      case AchievementType.streak:
        return 'Streak Achievements';
      case AchievementType.action:
        return 'Action Achievements';
      case AchievementType.milestone:
        return 'Milestone Achievements';
    }
  }

  void _showAchievementUnlockedDialog(
      BuildContext context, Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Achievement Unlocked!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              achievement.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '+${achievement.pointsAwarded} points',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}
