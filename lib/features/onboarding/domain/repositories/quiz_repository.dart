import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import '../entities/quiz_question.dart';

abstract class QuizRepository {
  Future<Either<Failure, List<QuizQuestion>>> getQuizQuestions();
}
