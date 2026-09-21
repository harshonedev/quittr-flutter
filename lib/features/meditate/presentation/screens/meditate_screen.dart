import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/meditate/presentation/bloc/quotes_bloc.dart';
import 'package:rive/rive.dart';

class MeditateScreen extends StatefulWidget {
  const MeditateScreen({super.key});

  @override
  State<MeditateScreen> createState() => _MeditateScreenState();
}

class _MeditateScreenState extends State<MeditateScreen> {
  final sl = GetIt.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuotesBloc(sl())..add(QuotesGetEvent()),
      child: Scaffold(
        body: BlocListener<AchievementsBloc, AchievementsState>(
          listener: (context, state) {
            if (state is AchievementUnlocked) {
              // Show a snackbar or any other UI element to indicate the achievement
              debugPrint("Achievement unlocked: ${state.achievement.title}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "New Achievement Unlocked: +${state.achievement.pointsAwarded} points"),
                ),
              );
            }

            if (state is AchievementsError) {
              // Handle failure state if needed
              debugPrint("Error unlocking achievement: ${state.message}");
            }
          },
          child: BlocBuilder<QuotesBloc, QuotesState>(
            builder: (context, state) {
              if (state is QuotesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is QuotesSuccess) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: RiveAnimation.asset(
                        'assets/animations/sky_moon_night.riv',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Reflect and breathe",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(height: 20),
                                    AnimatedOpacity(
                                      opacity: state.opacity,
                                      duration:
                                          const Duration(milliseconds: 1200),
                                      child: Text(
                                        state.quotes[state.currentQuoteIndex]
                                            .text,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                onPressed: () {
                                  // Trigger the meditation achievement
                                  try {
                                    context.read<AchievementsBloc>().add(
                                        UnlockAchievementEvent(
                                            UnlockAchievementEvent
                                                .firstMeditation));
                                  } catch (e) {
                                    debugPrint(
                                        "Error unlocking meditation achievement: $e");
                                  }

                                  context.pop();
                                },
                                child: const Text("Finish Reflecting"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (state is QuotesFailure) {
                return Center(child: Text(state.message));
              }

              return const Center(child: Text("No quotes"));
            },
          ),
        ),
      ),
    );
  }
}
