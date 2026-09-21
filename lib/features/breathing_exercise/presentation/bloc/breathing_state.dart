part of 'breathing_bloc.dart';

@immutable
sealed class BreathingState {
  final double progress;
  final String breathingText;

  const BreathingState({required this.progress, required this.breathingText});
}

final class BreathingInitial extends BreathingState {
  const BreathingInitial()
      : super(
          progress: 0.0,
          breathingText: "Breathe in\nwhen the ball goes up",
        );
}

final class BreathingUpdated extends BreathingState {
  const BreathingUpdated({
    required super.progress,
    required super.breathingText,
  });
}
