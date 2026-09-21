import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'detox_event.dart';
part 'detox_state.dart';

class DetoxBloc extends Bloc<DetoxEvent, DetoxState> {
  Timer? _screenTransitionTimer;
  Timer? _breathingPhaseTimer;
  Timer? _sessionTimer;

  static const int breathingCycleDuration = 8;

  DetoxBloc()
      : super(DetoxSuccess(
            screenState: DetoxScreenState.intro, selectedDurationMinutes: 1)) {
    on<StartAppEvent>(_onStartApp);
    on<ShowTimeSelectionEvent>(_onShowTimeSelection);
    on<UpdateDurationEvent>(_onUpdateDuration);
    on<StartBreathingEvent>(_onStartBreathing);
    on<UpdateBreathingPhaseEvent>(_onUpdateBreathingPhase);
    on<CompleteDetoxEvent>(_onCompleteDetox);
    on<TickTimerEvent>(_onTickTimer);

    add(StartAppEvent());
  }

  void _onStartApp(StartAppEvent event, Emitter<DetoxState> emit) {
    emit(DetoxSuccess(
        screenState: DetoxScreenState.intro, selectedDurationMinutes: 1));

    // Cancel any existing timer first to prevent memory leaks
    _screenTransitionTimer?.cancel();

    _screenTransitionTimer = Timer(const Duration(seconds: 2), () {
      // Check if the bloc is closed before adding an event
      if (!isClosed) {
        add(ShowTimeSelectionEvent());
      }
    });
  }

  void _onShowTimeSelection(
      ShowTimeSelectionEvent event, Emitter<DetoxState> emit) {
    final currentState = state as DetoxSuccess;
    emit(currentState.copyWith(screenState: DetoxScreenState.timeSelection));
  }

  void _onUpdateDuration(UpdateDurationEvent event, Emitter<DetoxState> emit) {
    final currentState = state as DetoxSuccess;
    emit(currentState.copyWith(selectedDurationMinutes: event.durationMinutes));
  }

  void _onStartBreathing(StartBreathingEvent event, Emitter<DetoxState> emit) {
    final totalSeconds = event.durationMinutes * 60;

    emit(DetoxSuccess(
      screenState: DetoxScreenState.breathing,
      selectedDurationMinutes: event.durationMinutes,
      isBreathingIn: true,
      remainingSeconds: totalSeconds,
      hasCompletedSession: false,
    ));

    // Cancel existing timers first
    _breathingPhaseTimer?.cancel();
    _sessionTimer?.cancel();

    _breathingPhaseTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!isClosed) {
        add(UpdateBreathingPhaseEvent());
      }
    });

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isClosed) {
        add(TickTimerEvent());
      }
    });
  }

  void _onTickTimer(TickTimerEvent event, Emitter<DetoxState> emit) {
    final currentState = state as DetoxSuccess;
    final newSeconds = currentState.remainingSeconds - 1;

    if (newSeconds <= 0) {
      _sessionTimer?.cancel();
      _breathingPhaseTimer?.cancel();
      if (!isClosed) {
        add(CompleteDetoxEvent());
      }
    } else {
      emit(currentState.copyWith(remainingSeconds: newSeconds));
    }
  }

  void _onUpdateBreathingPhase(
      UpdateBreathingPhaseEvent event, Emitter<DetoxState> emit) {
    final currentState = state as DetoxSuccess;
    emit(currentState.copyWith(isBreathingIn: !currentState.isBreathingIn));
  }

  void _onCompleteDetox(CompleteDetoxEvent event, Emitter<DetoxState> emit) {
    emit(DetoxSuccess(
      screenState: DetoxScreenState.complete,
      selectedDurationMinutes: (state as DetoxSuccess).selectedDurationMinutes,
      hasCompletedSession: true,
      remainingSeconds: 0,
    ));
  }

  @override
  Future<void> close() {
    _screenTransitionTimer?.cancel();
    _breathingPhaseTimer?.cancel();
    _sessionTimer?.cancel();
    return super.close();
  }
}
