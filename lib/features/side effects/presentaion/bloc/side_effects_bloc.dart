import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/side%20effects/domian/entites/side_effect.dart';
import 'package:quittr/features/side%20effects/domian/usecases/get_side_effects.dart';

part 'side_effects_event.dart';
part 'side_effects_state.dart';

class SideEffectsBloc extends Bloc<SideEffectsEvent, SideEffectsState> {
  final GetSideEffects getSideEffects;
  SideEffectsBloc(this.getSideEffects) : super(SideEffectsInitial()) {
    on<SideEffectsFadeIn>(_onFadeIn);
    on<SideEffectsFadeOut>(_onFadeOut);
    on<SideEffectsGetEvent>(_getSideEffects);
  }

  _getSideEffects(SideEffectsGetEvent event,
      Emitter<SideEffectsState> emit) async {
    emit(SideEffectsLoading());

    final result = await getSideEffects.call(NoParams());

    result.fold((failure) => emit(SideEffectsError(failure.message)),
        (motivationalQuotes) {
      emit(SideEffectsSuccess(motivationalQuotes, 0, 1.0, true));
    });
  }


  _onFadeIn(
      SideEffectsFadeIn event, Emitter<SideEffectsState> emit) {
    if (state is SideEffectsSuccess) {
      final currentState = state as SideEffectsSuccess;

      final nextIndex = (currentState.currentQuoteIndex + 1) %
          currentState.sideEffects.length;
      emit(currentState.copyWith(currentQuoteIndex: nextIndex, opacity: 1.0));
    }
  }


   _onFadeOut(SideEffectsFadeOut event,
      Emitter<SideEffectsState> emit) async {
    if (state is SideEffectsSuccess) {
      final currentState = state as SideEffectsSuccess;

      // Fade out current quote
      emit(currentState.copyWith(opacity: 0.0, buttonPressed: true));

      // Wait for fade-out animation to complete (1 second)
      await Future.delayed(const Duration(milliseconds: 500));

      // Calculate next index
      final nextIndex = (currentState.currentQuoteIndex + 1) %
          currentState.sideEffects.length;

      // Update index with opacity 0.0 (invisible)
      emit(currentState.copyWith(
        currentQuoteIndex: nextIndex,
        opacity: 0.0,
      ));

      // Small delay to ensure UI updates before fade-in
      await Future.delayed(const Duration(milliseconds: 50));

      // Fade in new quote
      emit(currentState.copyWith(
          currentQuoteIndex: nextIndex, opacity: 1.0, buttonPressed: false));
    }
  }


}
