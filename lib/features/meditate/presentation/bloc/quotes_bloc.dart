import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/meditate/domain/entities/quotes.dart';
import 'package:quittr/features/meditate/domain/usecases/get_quotes.dart';

part 'quotes_event.dart';
part 'quotes_state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  final GetQuotes getQuotes;
  Timer? _quoteTimer;

  QuotesBloc(this.getQuotes) : super(QuotesInitial()) {
    // Remove the incorrect event handler
    // on<QuotesEvent>((_, emit) => QuotesLoading()); // This was causing the issue

    on<QuotesGetEvent>(_getQuotes);
    on<QuotesFadeOut>(_onFadeOut);
    on<QuotesFadeIn>(_onFadeIn);
  }

  void _getQuotes(QuotesGetEvent event, Emitter<QuotesState> emit) async {
    emit(QuotesLoading());

    final result = await getQuotes.call(NoParams());

    result.fold(
      (failure) => emit(QuotesFailure(failure.message)),
      (quotes) {
        emit(QuotesSuccess(
          quotes: quotes,
          currentQuoteIndex: 0,
          opacity: 1.0,
        ));
        _startQuoteTimer();
      },
    );
  }

  void _onFadeOut(QuotesFadeOut event, Emitter<QuotesState> emit) {
    if (state is QuotesSuccess) {
      final currentState = state as QuotesSuccess;
      emit(currentState.copyWith(opacity: 0.0));
    }
  }

  void _onFadeIn(QuotesFadeIn event, Emitter<QuotesState> emit) {
    if (state is QuotesSuccess) {
      final currentState = state as QuotesSuccess;
      final nextIndex =
          (currentState.currentQuoteIndex + 1) % currentState.quotes.length;
      emit(currentState.copyWith(
        currentQuoteIndex: nextIndex,
        opacity: 1.0,
      ));
    }
  }

  void _startQuoteTimer() {
    _quoteTimer?.cancel();
    _quoteTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(QuotesFadeOut());
      Future.delayed(const Duration(milliseconds: 1200), () {
        add(QuotesFadeIn());
      });
    });
  }

  @override
  Future<void> close() {
    _quoteTimer?.cancel();
    return super.close();
  }
}
