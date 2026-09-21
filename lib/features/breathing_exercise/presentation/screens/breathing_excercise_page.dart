import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/breathing_exercise/presentation/bloc/breathing_bloc.dart';
import 'package:quittr/features/breathing_exercise/presentation/widgets/breathing_path_painter.dart';

class BreathingExcercisePage extends StatefulWidget {
  const BreathingExcercisePage({super.key});

  @override
  State<BreathingExcercisePage> createState() => _BreathingExcercisePageState();
}

class _BreathingExcercisePageState extends State<BreathingExcercisePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..addListener(() {
        context.read<BreathingBloc>().add(
              UpdateBreathingProgress(_controller.value),
            );
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    BreathingBloc().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Responsive dimensions
    final bool isSmallScreen = screenWidth < 360;
    final bool isLandscape = screenWidth > screenHeight;

    // Dynamic sizes based on screen dimensions
    final textSize = isSmallScreen ? 20.0 : 24.0;
    final buttonTextSize = isSmallScreen ? 16.0 : 18.0;
    final verticalSpacing = screenHeight * 0.04;

    // Breathing animation sizing
    final animationWidth = screenWidth;
    final animationHeight = isLandscape
        ? screenHeight * 0.45 // Less height in landscape
        : screenHeight * 0.55; // More height in portrait

    return BlocBuilder<BreathingBloc, BreathingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1B2E),
          body: SafeArea(
            child: BlocListener<AchievementsBloc, AchievementsState>(
              listener: (context, state) {
                if (state is AchievementUnlocked) {
                  // Show a snackbar or any other UI element to indicate the achievement
                  debugPrint(
                      "Achievement unlocked: ${state.achievement.title}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "New Achievement Unlocked: +${state.achievement.pointsAwarded} points"),
                      action: SnackBarAction(
                        label: 'See',
                        onPressed: () {
                          // Save the route to navigate to
                          final String achievementsRoute = '/achievements';
                          // Use a safe way to navigate with GoRouter
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              GoRouter.of(context).push(achievementsRoute);
                            }
                          });
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
              child: isLandscape
                  ? _buildLandscapeLayout(
                      state: state,
                      textSize: textSize,
                      buttonTextSize: buttonTextSize,
                      animationWidth: animationWidth,
                      animationHeight: animationHeight,
                      spacing: verticalSpacing,
                    )
                  : _buildPortraitLayout(
                      state: state,
                      textSize: textSize,
                      buttonTextSize: buttonTextSize,
                      animationWidth: animationWidth,
                      animationHeight: animationHeight,
                      spacing: verticalSpacing,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortraitLayout({
    required BreathingState state,
    required double textSize,
    required double buttonTextSize,
    required double animationWidth,
    required double animationHeight,
    required double spacing,
  }) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: Text(
                state.breathingText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSize,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: spacing),
            SizedBox(
              width: animationWidth,
              height: animationHeight,
              child: CustomPaint(
                painter: BreathingPathPainter(progress: state.progress),
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing * 0.5),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Trigger the breathing exercise achievement
                    try {
                      context.read<AchievementsBloc>().add(
                          UnlockAchievementEvent(
                              UnlockAchievementEvent.firstBreathingExercise));
                    } catch (e) {
                      debugPrint("Error unlocking breathing achievement: $e");
                    }

                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: spacing * 0.3, horizontal: spacing * 0.3),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A1B2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Finish Exercise',
                    style: TextStyle(
                        fontSize: buttonTextSize, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing * 0.5),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout({
    required BreathingState state,
    required double textSize,
    required double buttonTextSize,
    required double animationWidth,
    required double animationHeight,
    required double spacing,
  }) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: SizedBox(
                height: animationHeight,
                child: CustomPaint(
                  painter: BreathingPathPainter(progress: state.progress),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing * 0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.breathingText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: textSize,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Trigger the breathing exercise achievement
                          try {
                            context.read<AchievementsBloc>().add(
                                UnlockAchievementEvent(UnlockAchievementEvent
                                    .firstBreathingExercise));
                          } catch (e) {
                            debugPrint(
                                "Error unlocking breathing achievement: $e");
                          }

                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: spacing * 0.3,
                              horizontal: spacing * 0.3),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1A1B2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'Finish Exercise',
                          style: TextStyle(
                              fontSize: buttonTextSize,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
