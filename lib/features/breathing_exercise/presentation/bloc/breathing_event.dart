part of 'breathing_bloc.dart';

@immutable
sealed class BreathingEvent {}

class UpdateBreathingProgress extends BreathingEvent {
  final double progress;

  UpdateBreathingProgress(this.progress);
}
