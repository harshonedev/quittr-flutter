import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_data_source.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource localDataSource;

  QuizRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<QuizQuestion>>> getQuizQuestions() async {
    try {
      final questions = await localDataSource.getQuizQuestions();
      return Right(questions);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
