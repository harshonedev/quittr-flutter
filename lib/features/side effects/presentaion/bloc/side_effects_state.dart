part of 'side_effects_bloc.dart';

@immutable
sealed class SideEffectsState {}

final class SideEffectsInitial extends SideEffectsState {}

final class SideEffectsLoading extends SideEffectsState {}

final class SideEffectsSuccess extends SideEffectsState {
  final List<SideEffect> sideEffects;
  final int currentQuoteIndex;
  final double opacity;
  final bool buttonPressed;

  SideEffectsSuccess(
    this.sideEffects,
    this.currentQuoteIndex,
    this.opacity,
    this.buttonPressed,
  );

  SideEffectsSuccess copyWith({
    List<SideEffect>? sideEffects,
    int? currentQuoteIndex,
    double? opacity,
    bool? buttonPressed,
  }) {
    return SideEffectsSuccess(
      sideEffects ?? this.sideEffects,
      currentQuoteIndex ?? this.currentQuoteIndex,
      opacity ?? this.opacity,
      buttonPressed ?? this.buttonPressed,
    );
  }
}

final class SideEffectsError extends SideEffectsState {
  final String error;

  SideEffectsError(this.error);
}
