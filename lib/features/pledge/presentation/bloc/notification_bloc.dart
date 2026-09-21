import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/features/pledge/data/data%20sources/local_notification_datasource.dart';
import 'package:quittr/features/pledge/domain/usecases/schedule_notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final ScheduleNotification scheduleNotification;
  final LocalNotificationDataSourceImpl dataSource;

  NotificationBloc(this.scheduleNotification, this.dataSource)
      : super(NotificationInitial()) {
    _initialize();
    on<ScheduleNotificationEvent>(_onScheduleNotification);
     on<RelapseTrackerPledgeConfirmEvent>(_onRelapseTrackerPledgeConfirmEvent);
    on<RelapseTrackerBottomSheetOpenEvent>(
        _onRelapseTrackerPledgeBottomSheetEvent);



  }


  
  void _onRelapseTrackerPledgeConfirmEvent(
      RelapseTrackerPledgeConfirmEvent event,
      Emitter<NotificationState> emit) async {
    emit(RelapseTrackerLoading());
    await Future.delayed(Duration.zero);
    emit(RelapseTrackerPledgeConfirmed());
  }

  void _onRelapseTrackerPledgeBottomSheetEvent(
      RelapseTrackerBottomSheetOpenEvent event,
      Emitter<NotificationState> emit) async {
    emit(RelapseTrackerLoading());
    await Future.delayed(Duration.zero);
    emit(NotificationInitial());
  }





  Future<void> _initialize() async {
    try {
      await dataSource.initialize();
    } catch (e) {
      log("Notification Initialization Error: ${e.toString()}");
    }
  }

  void _onScheduleNotification(
      ScheduleNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      log("Received event to schedule notification...");

      final result = await scheduleNotification.call(
        NotificationParams(
          title: event.title,
          body: event.body,
          delay: event.delay,
        ),
      );

      result.fold(
        (failure) {
          log("Notification failed: ${failure.message}");
          emit(NotificationError(error: failure.message));
        },
        (_) {
          log("Notification scheduled successfully!!!");
          emit(NotificationScheduled());
        },
      );
    } catch (e) {
      log("Error scheduling notification: ${e.toString()}");
      emit(NotificationError(error: e.toString()));
    }
  }
}
