import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/library/data/data%20sources/podcast_data_source.dart';
import 'package:quittr/features/library/data/models/podcast_model.dart';
import 'package:quittr/features/library/domain/repository/podcast_repository.dart'
    show PodcastRepository;

class PodcastRepositoryImpl implements PodcastRepository {
  final PodcastDataSource dataSource;

  PodcastRepositoryImpl(this.dataSource);

  // @override
  // Future<Either<Failure, String>> getPodcasts() async {
  //   try {
  //     final filePath = await dataSource.getPodcastFiles();
  //     debugPrint("the file fetched is: $filePath");
  //     return Right(filePath);
  //   } on GeneralFailure catch (e) {
  //     return Left(GeneralFailure(e.message));
  //   }
  // }

  @override
Future<Either<Failure, PodcastModel>> getPodcasts() async {
  try {
    final filePath = await dataSource.getPodcastFiles();
    final podcast = PodcastModel(filePath: filePath, title: "My Podcast");
    return Right(podcast);
  } catch (e) {
    return Left(GeneralFailure(e.toString()));
  }
}
}
