part of 'side_effects_bloc.dart';

@immutable
sealed class SideEffectsEvent {}


final class SideEffectsGetEvent extends SideEffectsEvent {}

final class SideEffectsStartTimer extends SideEffectsEvent {}

final class SideEffectsFadeOut extends SideEffectsEvent {}

final class SideEffectsFadeIn extends SideEffectsEvent {}
