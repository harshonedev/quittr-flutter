part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuizQuestion> questions;
  final int currentQuestionIndex;
  final Map answers;

  const QuizLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.answers,
  });

  QuizQuestion get currentQuestion => questions[currentQuestionIndex];
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  @override
  List<Object> get props => [questions, currentQuestionIndex, answers];
}

class QuizCompleted extends QuizState {
  final Map answers;

  const QuizCompleted({required this.answers});

  @override
  List<Object> get props => [answers];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object> get props => [message];
}
