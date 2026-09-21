// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quittr/core/pref%20utils/pref_utils.dart';
// import 'package:quittr/features/auth/domain/entities/user.dart';
// import 'package:quittr/features/auth/presentation/bloc/auth_bloc.dart';

// part 'relapse_tracker_event.dart';
// part 'relapse_tracker_state.dart';

// class RelapseTrackerBloc
//     extends Bloc<RelapseTrackerEvent, RelapseTrackerState> {
//   Timer? _timer;
//   Duration _elapsedTime = PrefUtils().getLastRelapsedTime();
//    User? user;

//   RelapseTrackerBloc() : super(RelapseTrackerInitial()) {
//     on<RelapseTrackerPledgeConfirmEvent>(_onRelapseTrackerPledgeConfirmEvent);
//     on<RelapseTrackerBottomSheetOpenEvent>(
//         _onRelapseTrackerPledgeBottomSheetEvent);
//     on<RelapseTrackerPledgeStartTimerEvent>(_onStartTimer);
//     on<RelapseTrackerPledgeEndTimerEvent>(_onStopTimer);
//     on<RelapseTrackerPledgeUpdateTimerEvent>(_onUpdateTimer);
//     on<RelapseTrackerPledgeSaveTimerEvent>(_onSaveTimer);
//     on<RelapseTrackerLoadTimerEvent>(_onLoadTimer);
//   }

//   @override
//   Future<void> close() {
//     _timer?.cancel();
//     return super.close();
//   }

//   void _onSaveTimer(RelapseTrackerPledgeSaveTimerEvent event,
//       Emitter<RelapseTrackerState> emit) {
//     PrefUtils().setLastRelapsedTime( event.elapsedTime);
//   }

//   void _onLoadTimer(
//       RelapseTrackerLoadTimerEvent event, Emitter<RelapseTrackerState> emit) {
//     Duration lastElapsedTime = PrefUtils().getLastRelapsedTime();
//     _elapsedTime = lastElapsedTime;
//     emit(RelapseTrackerTimerRunning(lastElapsedTime));
//     print("Loaded timer: $_elapsedTime"); // Debug log
//   }

//   void _onStartTimer(RelapseTrackerPledgeStartTimerEvent event,
//       Emitter<RelapseTrackerState> emit) {
//     // Set the elapsed time to the last elapsed time passed from the event
//     _elapsedTime = event.lastElapsedTime ?? Duration.zero;

//     // Cancel existing timer if one exists
//     _timer?.cancel();

//     emit(RelapseTrackerTimerRunning(_elapsedTime));

//     // Start a new timer that updates every second
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _elapsedTime += const Duration(seconds: 1);
//       add(RelapseTrackerPledgeUpdateTimerEvent(_elapsedTime));
//     });

//     // Save the elapsed time immediately
//     PrefUtils().setLastRelapsedTime(_elapsedTime);
//     print("Auto-saving timer: ${_elapsedTime.inSeconds} seconds");
//   }

//   void _onUpdateTimer(RelapseTrackerPledgeUpdateTimerEvent event,
//       Emitter<RelapseTrackerState> emit) {
//     emit(RelapseTrackerTimerRunning(event.elapsedTime));
//   }

//   void _onStopTimer(RelapseTrackerPledgeEndTimerEvent event,
//       Emitter<RelapseTrackerState> emit) {
//     _timer?.cancel();
//     add(RelapseTrackerPledgeSaveTimerEvent(_elapsedTime));
//     emit(RelapseTrackerTimerRunning(_elapsedTime));
//   }

//   void _onRelapseTrackerPledgeConfirmEvent(
//       RelapseTrackerPledgeConfirmEvent event,
//       Emitter<RelapseTrackerState> emit) async {
//     emit(RelapseTrackerLoading());
//     await Future.delayed(Duration.zero);
//     emit(RelapseTrackerPledgeConfirmed());
//   }

//   void _onRelapseTrackerPledgeBottomSheetEvent(
//       RelapseTrackerBottomSheetOpenEvent event,
//       Emitter<RelapseTrackerState> emit) async {
//     emit(RelapseTrackerLoading());
//     await Future.delayed(Duration.zero);
//     emit(RelapseTrackerInitial());
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/pref%20utils/pref_utils.dart';

part 'relapse_tracker_event.dart';
part 'relapse_tracker_state.dart';

class RelapseTrackerBloc
    extends Bloc<RelapseTrackerEvent, RelapseTrackerState> {
  Timer? _timer;
  final PrefUtils _prefUtils = PrefUtils();
  //final DateTime _elapsedTime = DateTime.now();

  RelapseTrackerBloc() : super(RelapseTrackerInitial()) {
    on<RelapseTrackerStartTimerEvent>(_onStartTimer);
    on<RelapseTrackerResetTimerEvent>(_onResetTimer);
    on<RelapseTrackerUpdateTimerEvent>(_onUpdateTimer);
    on<RelapseTrackerEndTimerEvent>(_onEndTimer);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onStartTimer(
      RelapseTrackerStartTimerEvent event, Emitter<RelapseTrackerState> emit) {
    List<DateTime> relapsedDates = _prefUtils.getRelapsedDates();
    DateTime startTime;

    if (relapsedDates.isEmpty) {
      // If no relapsed dates, start from now
      startTime = DateTime.now();
    } else {
      // Use the last saved date from the list
      startTime = relapsedDates.last;
    }

    // Calculate the elapsed time
    Duration elapsedTime = DateTime.now().difference(startTime);

    // Cancel existing timer if one exists
    _timer?.cancel();

    // Start a new timer that updates every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime += const Duration(seconds: 1);
      add(RelapseTrackerUpdateTimerEvent(elapsedTime));
    });

    emit(RelapseTrackerTimerRunning(elapsedTime));
  }

  void _onResetTimer(
      RelapseTrackerResetTimerEvent event, Emitter<RelapseTrackerState> emit) {
    _timer?.cancel();
    _prefUtils.resetTimer();
    emit(RelapseTrackerTimerRunning(Duration.zero));

  }

  void _onUpdateTimer(
      RelapseTrackerUpdateTimerEvent event, Emitter<RelapseTrackerState> emit) {
    emit(RelapseTrackerTimerRunning(event.lastTime ?? Duration.zero));
  }

  void _onEndTimer(
      RelapseTrackerEndTimerEvent event, Emitter<RelapseTrackerState> emit) {
    _timer?.cancel();
  }
}
