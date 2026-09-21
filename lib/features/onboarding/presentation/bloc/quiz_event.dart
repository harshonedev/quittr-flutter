part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizQuestions extends QuizEvent {}

class AnswerQuestion extends QuizEvent {
  final String selectedOption;

  const AnswerQuestion(this.selectedOption);

  @override
  List<Object> get props => [selectedOption];
}
