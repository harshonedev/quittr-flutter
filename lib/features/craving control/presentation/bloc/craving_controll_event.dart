part of 'craving_controll_bloc.dart';

@immutable
sealed class CravingControllEvent {}

class StartBreathing extends CravingControllEvent {}

class PhaseCompleted extends CravingControllEvent {}

class ResetBreathing extends CravingControllEvent {}

class UpdateAnimation extends CravingControllEvent {
  final double newSize;
  
  UpdateAnimation(this.newSize);
}