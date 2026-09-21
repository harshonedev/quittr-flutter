part of 'craving_controll_bloc.dart';

@immutable
sealed class CravingControllState {}

class CravingControllSuccess extends CravingControllState {
  final bool isBreathingIn;
  final String breathingText;
  final Duration duration;
  final double targetCircleSize;
  final double currentCircleSize;

  CravingControllSuccess({
    required this.isBreathingIn,
    required this.breathingText,
    required this.duration,
    required this.targetCircleSize,
    required this.currentCircleSize,
  });
}