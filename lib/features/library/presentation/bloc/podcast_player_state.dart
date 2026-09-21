part of 'podcast_player_bloc.dart';

enum PlayerStatus { initial, loading, playing, paused, completed, error }

class PodcastPlayerState extends Equatable {
    final PlayerStatus status;
  final List<Podcast> podcasts;
  final Podcast? currentPodcast;
  final String? errorMessage;

  const PodcastPlayerState({
    this.status = PlayerStatus.initial,
    this.podcasts = const [],
    this.currentPodcast,
    this.errorMessage,
  });

  // Update copyWith method
  PodcastPlayerState copyWith({
    PlayerStatus? status,
    List<Podcast>? podcasts,
    Podcast? currentPodcast,
    String? errorMessage,
  }) {
    return PodcastPlayerState(
      status: status ?? this.status,
      podcasts: podcasts ?? this.podcasts,
      currentPodcast: currentPodcast ?? this.currentPodcast,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentPodcast, errorMessage];
}
