part of 'motivational_quotes_bloc.dart';

@immutable
sealed class MotivationalQuotesEvent {}

final class MotivationalQuotesGetEvent extends MotivationalQuotesEvent {}

final class MotivationalQuotesStartTimer extends MotivationalQuotesEvent {}

final class MotivationalQuotesFadeOut extends MotivationalQuotesEvent {}

final class MotivationalQuotesFadeIn extends MotivationalQuotesEvent {}
