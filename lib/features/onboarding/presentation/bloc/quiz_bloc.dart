import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/repositories/quiz_repository.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository repository;

  QuizBloc({required this.repository}) : super(QuizInitial()) {
    on<LoadQuizQuestions>(_onLoadQuizQuestions);
    on<AnswerQuestion>(_onAnswerQuestion);
  }

  Future<void> _onLoadQuizQuestions(
    LoadQuizQuestions event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoading());

    final result = await repository.getQuizQuestions();
    result.fold(
      (failure) => emit(QuizError(failure.message)),
      (questions) => emit(QuizLoaded(
        questions: questions,
        currentQuestionIndex: 0,
        answers: {},
      )),
    );
  }

  void _onAnswerQuestion(
    AnswerQuestion event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final updatedAnswers = Map.from(currentState.answers)
        ..addAll({currentState.currentQuestion.id: event.selectedOption});

      if (currentState.isLastQuestion) {
        emit(QuizCompleted(answers: updatedAnswers));
      } else {
        emit(QuizLoaded(
          questions: currentState.questions,
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
          answers: updatedAnswers,
        ));
      }
    }
  }
}
