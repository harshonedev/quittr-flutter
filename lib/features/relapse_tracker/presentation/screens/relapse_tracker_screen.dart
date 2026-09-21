
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quittr/core/pref%20utils/pref_utils.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/pledge/presentation/screens/pledge_screen.dart';
import 'package:quittr/features/relapse_tracker/presentation/bloc/relapse_tracker_bloc.dart';
import 'package:quittr/features/relapse_tracker/presentation/widgets/relapse_action_button.dart';
import '../widgets/progress_bar.dart';

class RelapseTrackerScreen extends StatefulWidget {
  const RelapseTrackerScreen({super.key});

  @override
  State<RelapseTrackerScreen> createState() => _RelapseTrackerScreenState();
}

class _RelapseTrackerScreenState extends State<RelapseTrackerScreen> {
  late RelapseTrackerBloc _relapseTrackerBloc;

  @override
  void initState() {
    super.initState();
    _relapseTrackerBloc = context.read<RelapseTrackerBloc>();
    // user = (context.read<AuthBloc>().state as AuthAuthenticated).user.isNewUser;

    if (PrefUtils().getRelapsedDates().isNotEmpty) {
      _relapseTrackerBloc.add(RelapseTrackerStartTimerEvent());
    }

    // // Load the last elapsed time from preferences
    // Duration lastElapsedTime =
    //     user ? Duration.zero : PrefUtils().getLastRelapsedTime();

    // // Start the timer with the last elapsed time
    // _relapseTrackerBloc.add(
    //   RelapseTrackerPledgeStartTimerEvent(lastElapsedTime: lastElapsedTime),
    // );

    //   _relapseTrackerBloc = context.read<RelapseTrackerBloc>();
    // final authState = context.read<AuthBloc>().state as AuthAuthenticated;
    // user = authState.user.isNewUser;
  }

  @override
  void dispose() {
    _relapseTrackerBloc.add(RelapseTrackerEndTimerEvent());
    // _relapseTrackerBloc.close();
    super.dispose();
  }

  double daysPassedSinceRelapse(DateTime lastRelapsedDate) {
    final today = DateTime.now();
    return today.difference(lastRelapsedDate).inDays.toDouble();
  }

  // double calculateProgressPercentage(DateTime lastRelapsedDate, int totalDays) {

  //   double daysPassed = daysPassedSinceRelapse(lastRelapsedDate);
  //   double progress = daysPassed / totalDays;
  //   return progress.clamp(0.0, 1.0); // Ensures the value stays between 0 and 1
  // }

  double calculateProgressPercentage(
      List<DateTime> relapseDates, int totalDays) {
    if (relapseDates.isEmpty) {
      return 0.0; // Return 0 progress if no relapse dates exist
    }

    DateTime lastRelapsedDate = relapseDates.last;
    double daysPassed =
        DateTime.now().difference(lastRelapsedDate).inDays.toDouble();
    double progress = daysPassed / totalDays;
    return progress.clamp(0.0, 1.0); // Ensures the value stays between 0 and 1
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('RESET'),
        content: const Text('Are you sure you want to reset the whole Timer?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              _relapseTrackerBloc
                  .add(RelapseTrackerResetTimerEvent()); // Reset the timer
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AchievementsBloc, AchievementsState>(
      listener: (context, state) {
        if (state is AchievementUnlocked) {
          // Show a snackbar or any other UI element to indicate the achievement
          debugPrint("Achievement unlocked: ${state.achievement.title}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "New Achievement Unlocked: +${state.achievement.pointsAwarded} points"),
              action: SnackBarAction(
                label: 'See',
                onPressed: () {
                  // Handle the action when the user taps the button
                  context.push('/achievements');
                },
              ),
            ),
          );
        }

        if (state is AchievementsError) {
          // Handle failure state if needed
          debugPrint("Error unlocking achievement: ${state.message}");
        }
      },
      child: BlocBuilder<RelapseTrackerBloc, RelapseTrackerState>(
        builder: (context, state) {
          var dateList = PrefUtils().getRelapsedDates().isEmpty;
          return Scaffold(
            floatingActionButton: dateList
                ? FloatingActionButton.extended(
                    onPressed: () {
                      PrefUtils().setRelapsedDates([DateTime.now()]);
                      _relapseTrackerBloc.add(RelapseTrackerStartTimerEvent());
                    },
                    label: Text("Get started"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    icon: Icon(Icons.timer_outlined),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withAlpha(255),
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  )
                : FloatingActionButton.extended(
                    onPressed: () {
                      // PrefUtils().resetTimer();
                      context.push('/craving-control');
                    },
                    label: Text("Panic Button"),
                    icon: Icon(Icons.timer_outlined),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.error.withAlpha(255),
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.emoji_events_outlined),
                  onPressed: () {
                    // Navigate to achievements screen
                    context.push('/achievements');

                    // Check if the user has unlocked any streak-based achievements
                    if (state is RelapseTrackerTimerRunning) {
                      // Calculate streak days
                      final streakDays = state.elapsedTime.inDays;

                      // Check if achievements should be unlocked based on streak days
                      if (streakDays > 0) {
                        final achievementsBloc =
                            context.read<AchievementsBloc>();
                        achievementsBloc
                            .add(CheckStreakAchievementsEvent(streakDays));
                      }
                    }
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Main streak display
                    BlocBuilder<RelapseTrackerBloc, RelapseTrackerState>(
                        builder: (context, state) {
                      Duration elapsedTime = Duration.zero;
                      if (state is RelapseTrackerTimerRunning) {
                        elapsedTime = state.elapsedTime;
                      }

                      return Column(
                        children: [
                          Text(
                            "You've been porn-free for:",
                            style: GoogleFonts.poppins(
                              fontSize:
                                  MediaQuery.sizeOf(context).height * 0.015,
                            ),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            "${elapsedTime.inDays} days",
                            style: GoogleFonts.poppins(
                              fontSize:
                                  MediaQuery.sizeOf(context).height * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${elapsedTime.inHours.remainder(24)}h ${elapsedTime.inMinutes.remainder(60)}m ${elapsedTime.inSeconds.remainder(60)}s",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 32),
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RelapseActionButton(
                          icon: Icons.handshake_outlined,
                          label: 'Pledge',
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true, // Allow full height
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  initialChildSize:
                                      0.7, // Set to 70% of the screen height
                                  minChildSize: 0.4,
                                  maxChildSize: 1,
                                  expand: false,
                                  builder: (context, scrollController) {
                                    return PledgeScreen(); // Your PledgeScreen
                                  },
                                );
                              },
                            );
                          },
                        ),
                        RelapseActionButton(
                          icon: Icons.self_improvement_outlined,
                          label: 'Meditate',
                          onTap: () {
                            context.push('/meditation');
                          },
                        ),
                        RelapseActionButton(
                          icon: Icons.refresh_outlined,
                          label: 'Reset',
                          onTap: () {
                            _showSignOutDialog(context);
                          },
                        ),
                        // Removed the "More" button
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Progress bars
                    // ProgressBar(
                    //   label: 'Brain Rewiring',

                    //   progress: calculateProgressPercentage(
                    //       DateTime.parse(
                    //           PrefUtils().getRelapsedDates().last.toString()),
                    //       90),
                    //   progressText:
                    //       "${(calculateProgressPercentage(DateTime.parse(PrefUtils().getRelapsedDates().last.toString()), 90) * 100).toStringAsFixed(1)} %", // Display percentage with 2 decimal places
                    // ),

                    ProgressBar(
                      label: 'Brain Rewiring',
                      progress: calculateProgressPercentage(
                          PrefUtils().getRelapsedDates(), // Pass the whole list
                          90),
                      progressText:
                          "${(calculateProgressPercentage(PrefUtils().getRelapsedDates(), // Pass the whole list
                              90) * 100).toStringAsFixed(1)} %",
                    ),
                    const SizedBox(height: 16),
                    ProgressBar(
                      label: '28 Day Challenge',
                      progress: 0.0,
                      progressText: '0%',
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 5),
                        child: Text(
                          "Main",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withAlpha(80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                        ),
                        child: Column(
                          children: [
                            _RelapseMenuItem(
                              icon: Icons
                                  .lightbulb_outline, // Better icon for motivation/change
                              iconColor: Colors
                                  .orange.shade800, // Motivation/change related
                              title: 'Reason for Change',
                              onTap: () => context.push('/reasons'),
                            ),
                            Divider(
                              height: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                            // Removed the "Chat" menu item
                            _RelapseMenuItem(
                                icon: Icons
                                    .school_outlined, // Better icon for learning
                                iconColor:
                                    Colors.teal.shade700, // Education/growth
                                title: 'Learn',
                                onTap: () => context.push('/articles')),
                            Divider(
                              height: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                            _RelapseMenuItem(
                              icon: Icons
                                  .emoji_events_outlined, // Already good icon for achievements
                              iconColor:
                                  Colors.amber.shade800, // Achievement/rewards
                              title: 'Achievements',
                              onTap: () {
                                // Navigate to achievements screen
                                context.push('/achievements');

                                // Check if user has unlocked any streak-based achievements
                                if (state is RelapseTrackerTimerRunning) {
                                  // Calculate streak days
                                  final streakDays = state.elapsedTime.inDays;

                                  // Check if achievements should be unlocked based on streak days
                                  if (streakDays > 0) {
                                    final achievementsBloc =
                                        context.read<AchievementsBloc>();
                                    achievementsBloc.add(
                                        CheckStreakAchievementsEvent(
                                            streakDays));
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 5),
                        child: Text(
                          "Mindfulness",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withAlpha(80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                        ),
                        child: Column(
                          children: [
                            _RelapseMenuItem(
                              icon: Icons
                                  .healing, // Better represents side effects/health impacts
                              iconColor: Colors.red.shade800,
                              title: 'Side Effects',
                              onTap: () => context.push('/side-effects'),
                            ),
                            Divider(
                              height: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                            _RelapseMenuItem(
                              icon: Icons
                                  .rocket_launch, // Better represents motivation/progress
                              iconColor: Colors.green.shade700,
                              title: 'Motivation',
                              onTap: () => context.push('/motivation'),
                            ),
                            Divider(
                              height: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                            _RelapseMenuItem(
                              icon: Icons
                                  .self_improvement, // Better represents breathing/meditation
                              iconColor: Colors.blue.shade600,
                              title: 'Breathe Exercise',
                              onTap: () => context.push('/breathing'),
                            ),
                            Divider(
                              height: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                            _RelapseMenuItem(
                              icon: Icons
                                  .psychology_outlined, // Brain/mind control related icon
                              iconColor: Colors.teal
                                  .shade600, // Teal represents control/calmness
                              title: 'Craving Control',
                              onTap: () => context.push('/craving-control'),
                            ),
                            Divider(
                              height: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                            _RelapseMenuItem(
                              icon: Icons
                                  .healing, // Medical/health related icon for detox
                              iconColor: Colors.purple
                                  .shade600, // Purple represents healing/cleansing
                              title: 'Detox',
                              onTap: () => context.push('/detox'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RelapseMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const _RelapseMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 10,
          bottom: 2,
          top: 2,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? Theme.of(context).colorScheme.primary)
                      .withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
