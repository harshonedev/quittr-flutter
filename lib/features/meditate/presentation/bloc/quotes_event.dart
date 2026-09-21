part of 'quotes_bloc.dart';


@immutable
sealed class QuotesEvent {}

final class QuotesGetEvent extends QuotesEvent {}

final class QuotesStartTimer extends QuotesEvent {}

final class QuotesFadeOut extends QuotesEvent {}

final class QuotesFadeIn extends QuotesEvent {}
