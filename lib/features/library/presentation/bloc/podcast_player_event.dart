part of 'podcast_player_bloc.dart';

abstract class PodcastPlayerEvent extends Equatable {
  const PodcastPlayerEvent();

  @override
  List<Object?> get props => [];
}

class LoadPodcasts extends PodcastPlayerEvent {}

class PlayPodcast extends PodcastPlayerEvent {
  final Podcast podcast;
  const PlayPodcast(this.podcast);
  @override
  List<Object?> get props => [podcast];
}

class PausePodcast extends PodcastPlayerEvent {}

class ResumePodcast extends PodcastPlayerEvent {}

class EndPodcast extends PodcastPlayerEvent {}