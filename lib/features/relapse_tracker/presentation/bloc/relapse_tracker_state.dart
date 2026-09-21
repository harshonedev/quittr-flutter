
part of 'relapse_tracker_bloc.dart';

@immutable
sealed class RelapseTrackerState {}

final class RelapseTrackerInitial extends RelapseTrackerState {}

final class RelapseTrackerSuccess extends RelapseTrackerState {}

final class RelapseTrackerFailure extends RelapseTrackerState {}

final class RelapseTrackerLoading extends RelapseTrackerState {}

final class RelapseTrackerPledgeConfirmed extends RelapseTrackerState {}

final class RelapseTrackerTimerRunning extends RelapseTrackerState {
  final Duration elapsedTime;

  RelapseTrackerTimerRunning(this.elapsedTime);
}
