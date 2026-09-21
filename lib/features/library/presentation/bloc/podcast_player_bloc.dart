import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/library/domain/entities/podcast.dart';
import 'package:quittr/features/library/domain/usecases/get_podcasts.dart';

part 'podcast_player_event.dart';
part 'podcast_player_state.dart';

class PodcastPlayerBloc extends Bloc<PodcastPlayerEvent, PodcastPlayerState> {
  final GetPodcasts _getPodcasts;
  final AudioPlayer _audioPlayer = AudioPlayer();

  PodcastPlayerBloc({required GetPodcasts getPodcasts})
      : _getPodcasts = getPodcasts,
        super(const PodcastPlayerState()) {
    on<LoadPodcasts>(_onLoadPodcasts);
    on<PlayPodcast>(_onPlayPodcast);
    on<PausePodcast>(_onPausePodcast);
    on<ResumePodcast>(_onResumePodcast);
    on<EndPodcast>(_podcastEnd);
  }

  Future<void> _onLoadPodcasts(
    LoadPodcasts event,
    Emitter<PodcastPlayerState> emit,
  ) async {
    emit(state.copyWith(status: PlayerStatus.loading));
    final result = await _getPodcasts(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: PlayerStatus.error,
        errorMessage: failure.message,
      )),
      (podcasts) => emit(state.copyWith(
        status: PlayerStatus.initial,
        podcasts: [podcasts],
        currentPodcast: [podcasts].isNotEmpty ? [podcasts].first : null,
      )),
    );
  }

  Future<void> _onPlayPodcast(
    PlayPodcast event,
    Emitter<PodcastPlayerState> emit,
  ) async {
    // emit(state.copyWith(status: PlayerStatus.loading));
    try {
      // await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(event.podcast.filePath));
      emit(state.copyWith(
        status: PlayerStatus.playing,
        currentPodcast: event.podcast,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PlayerStatus.error,
        errorMessage: 'Failed to play podcast: $e',
      ));
    }
  }

  Future<void> _onPausePodcast(
    PausePodcast event,
    Emitter<PodcastPlayerState> emit,
  ) async {
    await _audioPlayer.pause();
    emit(state.copyWith(status: PlayerStatus.paused));
  }

  Future<void> _onResumePodcast(
    ResumePodcast event,
    Emitter<PodcastPlayerState> emit,
  ) async {
    await _audioPlayer.resume();
    emit(state.copyWith(status: PlayerStatus.playing));
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }

  Future<void> _podcastEnd(
    EndPodcast event,
    Emitter<PodcastPlayerState> emit,
  ) async {
    _audioPlayer.dispose();
  }
}
