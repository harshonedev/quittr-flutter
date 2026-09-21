part of 'detox_bloc.dart';

@immutable
sealed class DetoxState {}

final class DetoxSuccess extends DetoxState {
  final DetoxScreenState screenState;
  final int? selectedDurationMinutes;
  final bool isBreathingIn;
  final int remainingSeconds;
  final bool hasCompletedSession;

  DetoxSuccess({
    required this.screenState,
    this.selectedDurationMinutes,
    this.isBreathingIn = true,
    this.remainingSeconds = 0,
    this.hasCompletedSession = false,
  });

  DetoxSuccess copyWith({
    DetoxScreenState? screenState,
    int? selectedDurationMinutes,
    bool? isBreathingIn,
    int? remainingSeconds,
    bool? hasCompletedSession,
  }) {
    return DetoxSuccess(
      screenState: screenState ?? this.screenState,
      selectedDurationMinutes:
          selectedDurationMinutes ?? this.selectedDurationMinutes,
      isBreathingIn: isBreathingIn ?? this.isBreathingIn,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      hasCompletedSession: hasCompletedSession ?? this.hasCompletedSession,
    );
  }
}

enum DetoxScreenState { intro, timeSelection, breathing, complete }
