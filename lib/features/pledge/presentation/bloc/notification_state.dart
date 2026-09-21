part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

class NotificationScheduled extends NotificationState {}
class NotificationError extends NotificationState {
  final String error;
  NotificationError({required this.error});
}


final class RelapseTrackerPledgeConfirmed extends NotificationState {}



final class RelapseTrackerSuccess extends NotificationState {}

final class RelapseTrackerFailure extends NotificationState {}

final class RelapseTrackerLoading extends NotificationState {}

