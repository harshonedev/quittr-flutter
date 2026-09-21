part of 'motivational_quotes_bloc.dart';

@immutable
sealed class MotivationalQuotesState {}

final class MotivationalQuotesInitial extends MotivationalQuotesState {}

final class MotivationalQuotesLoading extends MotivationalQuotesState {}

final class MotivationalQuotesSuccess extends MotivationalQuotesState {
  final List<MotivationalQuotes> motivationalQuotes;
  final int currentQuoteIndex;
  final double opacity;
  final bool buttonPressed;

  MotivationalQuotesSuccess(
    this.motivationalQuotes,
    this.currentQuoteIndex,
    this.opacity,
    this.buttonPressed
  );

  MotivationalQuotesSuccess copyWith({
    List<MotivationalQuotes>? motivationalQuotes,
    int? currentQuoteIndex,
    double? opacity,
    bool? buttonPressed,
  }) {
    return MotivationalQuotesSuccess(
      motivationalQuotes ?? this.motivationalQuotes,
      currentQuoteIndex ?? this.currentQuoteIndex,
      opacity ?? this.opacity,
      buttonPressed ?? this.buttonPressed,
    );
  }
}

final class MotivationalQuotesError extends MotivationalQuotesState {
  final String error;

  MotivationalQuotesError(this.error);
}
