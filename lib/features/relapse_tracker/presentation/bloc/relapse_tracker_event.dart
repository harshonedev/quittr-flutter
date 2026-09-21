// part of 'relapse_tracker_bloc.dart';

// @immutable
// sealed class RelapseTrackerEvent {}

// final class RelapseTrackerPledgeConfirmEvent extends RelapseTrackerEvent {}

// final class RelapseTrackerBottomSheetOpenEvent extends RelapseTrackerEvent {}

// final class RelapseTrackerPledgeStartTimerEvent extends RelapseTrackerEvent {
//   final Duration? lastElapsedTime;

//   RelapseTrackerPledgeStartTimerEvent({this.lastElapsedTime });
// }

// final class RelapseTrackerPledgeEndTimerEvent extends RelapseTrackerEvent {}

// final class RelapseTrackerPledgeUpdateTimerEvent extends RelapseTrackerEvent {
//   final Duration elapsedTime;
// //
//   RelapseTrackerPledgeUpdateTimerEvent(this.elapsedTime);
// }

// final class RelapseTrackerPledgeSaveTimerEvent extends RelapseTrackerEvent {
//   final Duration elapsedTime;

//   RelapseTrackerPledgeSaveTimerEvent(this.elapsedTime);
// }

// final class RelapseTrackerLoadTimerEvent extends RelapseTrackerEvent {}

part of 'relapse_tracker_bloc.dart';

@immutable
sealed class RelapseTrackerEvent {}

final class RelapseTrackerStartTimerEvent extends RelapseTrackerEvent {}

final class RelapseTrackerResetTimerEvent extends RelapseTrackerEvent {}

final class RelapseTrackerUpdateTimerEvent extends RelapseTrackerEvent {
  final Duration? lastTime;

  RelapseTrackerUpdateTimerEvent(this.lastTime);
}

final class RelapseTrackerEndTimerEvent extends RelapseTrackerEvent {}
