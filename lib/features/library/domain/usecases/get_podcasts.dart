import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/library/domain/entities/podcast.dart';
import 'package:quittr/features/library/domain/repository/podcast_repository.dart';

class GetPodcasts extends UseCase<Podcast, NoParams> {
  final PodcastRepository podcastRepository;

  GetPodcasts({required this.podcastRepository});

  @override
  Future<Either<Failure, Podcast>> call(NoParams params) async {
    return await podcastRepository.getPodcasts();
  }
}
