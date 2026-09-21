part of 'detox_bloc.dart';

@immutable
sealed class DetoxEvent {}

class StartAppEvent extends DetoxEvent {}
class ShowTimeSelectionEvent extends DetoxEvent {}
class UpdateDurationEvent extends DetoxEvent {
  final int durationMinutes;
  UpdateDurationEvent(this.durationMinutes);
}
class StartBreathingEvent extends DetoxEvent {
  final int durationMinutes;
  StartBreathingEvent(this.durationMinutes);
}
class UpdateBreathingPhaseEvent extends DetoxEvent {}
class CompleteDetoxEvent extends DetoxEvent {}
class TickTimerEvent extends DetoxEvent {}