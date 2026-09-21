import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/features/library/presentation/bloc/podcast_player_bloc.dart';
import 'package:rive/rive.dart' as rive;
import 'package:quittr/core/injection_container.dart' as di;

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PodcastPlayerBloc(getPodcasts: di.sl())..add(LoadPodcasts()),
      child: BlocListener<PodcastPlayerBloc, PodcastPlayerState>(
        listener: (context, state) {
          if (state.status == PlayerStatus.initial &&
              state.currentPodcast != null) {
            context
                .read<PodcastPlayerBloc>()
                .add(PlayPodcast(state.currentPodcast!));
          }
        },
        child: Scaffold(
          body: BlocBuilder<PodcastPlayerBloc, PodcastPlayerState>(
            builder: (context, state) {
              if (state.status == PlayerStatus.loading) {
                return Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: rive.RiveAnimation.asset(
                        'assets/animations/sky_moon_night.riv',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // const Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (state.status == PlayerStatus.error) {
                return Center(child: Text('Error: ${state.errorMessage}'));
              } else if (state.currentPodcast == null) {
                return const Center(child: Text('No podcast available'));
              }

              return SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: rive.RiveAnimation.asset(
                        'assets/animations/sky_moon_night.riv',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.currentPodcast!.title,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 40),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              key: ValueKey(
                                  state.status == PlayerStatus.playing),
                              onTap: () {
                                if (state.status == PlayerStatus.playing) {
                                  context
                                      .read<PodcastPlayerBloc>()
                                      .add(PausePodcast());
                                } else {
                                  context
                                      .read<PodcastPlayerBloc>()
                                      .add(PlayPodcast(state.currentPodcast!));
                                }
                              },
                              child: Transform.scale(
                                scale: 1,
                                child: // Inside the IconButton/AnimatedSwitcher widget:
                                    Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.blueAccent,
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.4),
                                        blurRadius: 15,
                                        spreadRadius: 4,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      child: Icon(
                                        state.status == PlayerStatus.playing
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 48,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            state.status == PlayerStatus.playing
                                ? 'Now Playing'
                                : 'Paused',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
