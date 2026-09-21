import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/library/domain/entities/podcast.dart';

abstract class PodcastRepository {
  Future<Either<Failure, Podcast>> getPodcasts();
}
