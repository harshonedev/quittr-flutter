part of 'quotes_bloc.dart';


@immutable
sealed class QuotesState {}

final class QuotesInitial extends QuotesState {}

final class QuotesLoading extends QuotesState {}

final class QuotesSuccess extends QuotesState {
  final List<Quotes> quotes;
  final int currentQuoteIndex;
  final double opacity;

  QuotesSuccess({
    required this.quotes,
    required this.currentQuoteIndex,
    required this.opacity,
  });

  QuotesSuccess copyWith({
    List<Quotes>? quotes,
    int? currentQuoteIndex,
    double? opacity,
  }) {
    return QuotesSuccess(
      quotes: quotes ?? this.quotes,
      currentQuoteIndex: currentQuoteIndex ?? this.currentQuoteIndex,
      opacity: opacity ?? this.opacity,
    );
  }
}

final class QuotesFailure extends QuotesState {
  final String message;

  QuotesFailure(this.message);
}