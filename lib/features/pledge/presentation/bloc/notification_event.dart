part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class ScheduleNotificationEvent extends NotificationEvent {
    final String title;
  final String body;
  final Duration delay;

  ScheduleNotificationEvent({
    required this.title,
    required this.body,
    required this.delay,
  });
}


final class RelapseTrackerPledgeConfirmEvent extends NotificationEvent {}

final class RelapseTrackerBottomSheetOpenEvent extends NotificationEvent {}

