import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



part 'craving_controll_event.dart';
part 'craving_controll_state.dart';

class CravingControllBloc
    extends Bloc<CravingControllEvent, CravingControllState> {
  static const int breathInDuration = 4;
  static const int breathOutDuration = 4;
  static const double minCircleSize = 150.0;
  static const double maxCircleSize = 250.0;

  Timer? _phaseTimer;
  Timer? _animationTimer;
  static const int animationFps = 60;

  CravingControllBloc()
      : super(CravingControllSuccess(
          isBreathingIn: false,
          breathingText: "",
          duration: Duration.zero,
          targetCircleSize: minCircleSize,
          currentCircleSize: minCircleSize,
        )) {
    on<StartBreathing>(_onStartBreathing);
    on<PhaseCompleted>(_onPhaseCompleted);
    on<ResetBreathing>(_onResetBreathing);
    on<UpdateAnimation>(_onUpdateAnimation);
  }

  void _onStartBreathing(
      StartBreathing event, Emitter<CravingControllState> emit) {
    _phaseTimer?.cancel();
    _animationTimer?.cancel();
    
    emit(CravingControllSuccess(
      isBreathingIn: true,
      breathingText: "Take a deep breath in",
      duration: Duration(seconds: breathInDuration),
      targetCircleSize: maxCircleSize,
      currentCircleSize: minCircleSize,
    ));
    
    _startAnimation(emit, true);
    
    _phaseTimer = Timer(const Duration(seconds: breathInDuration), () {
      add(PhaseCompleted());
    });
  }

  void _onPhaseCompleted(
      PhaseCompleted event, Emitter<CravingControllState> emit) {
    _phaseTimer?.cancel();
    _animationTimer?.cancel();

    if (state is CravingControllSuccess) {
      final currentState = state as CravingControllSuccess;
      if (currentState.isBreathingIn) {
        emit(CravingControllSuccess(
          isBreathingIn: false,
          breathingText: "Now breathe out slowly",
          duration: Duration(seconds: breathOutDuration),
          targetCircleSize: minCircleSize,
          currentCircleSize: currentState.currentCircleSize,
        ));

        _startAnimation(emit, false);

        _phaseTimer = Timer(Duration(seconds: breathOutDuration), () {
          add(PhaseCompleted());
        });
      } else {
        emit(CravingControllSuccess(
          isBreathingIn: true,
          breathingText: "Take a deep breath in",
          duration: Duration(seconds: breathInDuration),
          targetCircleSize: maxCircleSize,
          currentCircleSize: currentState.currentCircleSize,
        ));

        _startAnimation(emit, true);

        _phaseTimer = Timer(Duration(seconds: breathInDuration), () {
          add(PhaseCompleted());
        });
      }
    }
  }

  void _startAnimation(Emitter<CravingControllState> emit, bool isBreathingIn) {
    final CravingControllSuccess currentState = state as CravingControllSuccess;
    final int totalFrames = (isBreathingIn ? breathInDuration : breathOutDuration) * animationFps;
    final double startSize = currentState.currentCircleSize;
    final double endSize = isBreathingIn ? maxCircleSize : minCircleSize;
    final double step = (endSize - startSize) / totalFrames;
    
    int frameCount = 0;
    
    _animationTimer = Timer.periodic(Duration(milliseconds: (1000 / animationFps).round()), (timer) {
      frameCount++;
      if (frameCount >= totalFrames) {
        timer.cancel();
        return;
      }
      
      add(UpdateAnimation(startSize + (step * frameCount)));
    });
  }
  
  void _onUpdateAnimation(UpdateAnimation event, Emitter<CravingControllState> emit) {
    if (state is CravingControllSuccess) {
      final currentState = state as CravingControllSuccess;
      emit(CravingControllSuccess(
        isBreathingIn: currentState.isBreathingIn,
        breathingText: currentState.breathingText,
        duration: currentState.duration,
        targetCircleSize: currentState.targetCircleSize,
        currentCircleSize: event.newSize,
      ));
    }
  }

  void _onResetBreathing(
      ResetBreathing event, Emitter<CravingControllState> emit) {
    _phaseTimer?.cancel();
    _animationTimer?.cancel();
    emit(CravingControllSuccess(
      isBreathingIn: false,
      breathingText: "",
      duration: Duration.zero,
      targetCircleSize: minCircleSize,
      currentCircleSize: minCircleSize,
    ));
  }

  @override
  Future<void> close() {
    _phaseTimer?.cancel();
    _animationTimer?.cancel();
    return super.close();
  }
}