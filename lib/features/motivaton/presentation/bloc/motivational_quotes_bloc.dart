import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/motivaton/domain/entity/motivational_quotes.dart';
import 'package:quittr/features/motivaton/domain/usecases/get_motivationalQuotes.dart';

part 'motivational_quotes_event.dart';
part 'motivational_quotes_state.dart';

class MotivationalQuotesBloc
    extends Bloc<MotivationalQuotesEvent, MotivationalQuotesState> {
  final GetMotivationalquotes getMotivationalquoates;
  MotivationalQuotesBloc(this.getMotivationalquoates)
      : super(MotivationalQuotesInitial()) {
    on<MotivationalQuotesFadeIn>(_onFadeIn);
    on<MotivationalQuotesFadeOut>(_onFadeOut);
    on<MotivationalQuotesGetEvent>(_getMotivationalQuotes);
  }

  _getMotivationalQuotes(MotivationalQuotesGetEvent event,
      Emitter<MotivationalQuotesState> emit) async {
    emit(MotivationalQuotesLoading());

    final result = await getMotivationalquoates.call(NoParams());

    result.fold((failure) => emit(MotivationalQuotesError(failure.message)),
        (motivationalQuotes) {
      emit(MotivationalQuotesSuccess(motivationalQuotes, 0, 1.0, true));
    });
  }

  _onFadeIn(
      MotivationalQuotesFadeIn event, Emitter<MotivationalQuotesState> emit) {
    if (state is MotivationalQuotesSuccess) {
      final currentState = state as MotivationalQuotesSuccess;

      final nextIndex = (currentState.currentQuoteIndex + 1) %
          currentState.motivationalQuotes.length;
      emit(currentState.copyWith(currentQuoteIndex: nextIndex, opacity: 1.0));
    }
  }

  _onFadeOut(MotivationalQuotesFadeOut event,
      Emitter<MotivationalQuotesState> emit) async {
    if (state is MotivationalQuotesSuccess) {
      final currentState = state as MotivationalQuotesSuccess;

      // Fade out current quote
      emit(currentState.copyWith(opacity: 0.0, buttonPressed: true));

      // Wait for fade-out animation to complete (1 second)
      await Future.delayed(const Duration(milliseconds: 500));

      // Calculate next index
      final nextIndex = (currentState.currentQuoteIndex + 1) %
          currentState.motivationalQuotes.length;

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
