import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/constants/string_constants.dart';
import 'package:quittr/features/detox/presentation/bloc/detox_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DetoxScreen extends StatefulWidget {
  const DetoxScreen({super.key});

  @override
  State<DetoxScreen> createState() => _DetoxScreenState();
}

class _DetoxScreenState extends State<DetoxScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late DetoxBloc _detoxBloc;
  final double _minSize = 150;
  final double _maxSize = 250;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );


    // Add listener to make breathing continuous
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });

    _detoxBloc = DetoxBloc();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _detoxBloc.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _detoxBloc,
      child: BlocConsumer<DetoxBloc, DetoxState>(
        listener: (context, state) {
          if (state is DetoxSuccess) {
            if (state.screenState == DetoxScreenState.breathing) {
              // Always start with inhale (forward from 0)
              if (!_breathingController.isAnimating) {
                _breathingController.forward(from: 0.0);
              }
            } else if (state.screenState == DetoxScreenState.complete) {
              Future.delayed(const Duration(seconds: 2), () {
                context.pop();
              });
            }
          }
        },
        builder: (context, state) {
          if (state is DetoxSuccess) {
            return Scaffold(
              backgroundColor: Colors.teal[200],
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Detox',
                  style: TextStyle(color: Colors.black87),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    context.pop();
                    context.read<DetoxBloc>().add(StartAppEvent());
                  },
                ),
              ),
              body: SafeArea(
                child: _buildContent(context, state),
              ),
            );
          }
          return const Center(child: Text("Something Went Wrong"));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DetoxSuccess state) {
    switch (state.screenState) {
      case DetoxScreenState.intro:
        return _buildIntroScreen();
      case DetoxScreenState.timeSelection:
        return _buildTimeSelectionScreen(context);
      case DetoxScreenState.breathing:
        return _buildBreathingScreen(state);
      case DetoxScreenState.complete:
        return _buildCompletionScreen(context);
    }
  }

  Widget _buildIntroScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Detox is recommended as soon as possible after porn use',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF084B40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelectionScreen(BuildContext context) {
    final durations = [1, 5, 10, 15, 20, 30];

    return BlocBuilder<DetoxBloc, DetoxState>(
      builder: (context, state) {
        final detoxState = state as DetoxSuccess;
        final selectedDuration = detoxState.selectedDurationMinutes ?? 1;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'How long was your porn session?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF084B40),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  itemExtent: 50,
                  scrollController: FixedExtentScrollController(
                    initialItem: durations.indexOf(selectedDuration),
                  ),
                  onSelectedItemChanged: (index) {
                    context.read<DetoxBloc>().add(
                          UpdateDurationEvent(durations[index]),
                        );
                  },
                  children: durations.map((duration) {
                    return Center(
                      child: Text(
                        '$duration ${duration == 1 ? 'minute' : 'minutes'}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF084B40),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<DetoxBloc>()
                        .add(StartBreathingEvent(selectedDuration));
                  },
                  child: const Text(
                    'Begin detox',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBreathingScreen(DetoxSuccess state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //this is the timer if needed in future
        // Text(
        //   _formatTime(state.remainingSeconds),
        //   style: const TextStyle(
        //     fontSize: 20,
        //     color: Color(0xFF084B40),
        //   ),
        // ),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                // Smooth transition between min and max size
                final size = _minSize +
                    ((_maxSize - _minSize) * _breathingController.value);

                // Determine if currently in inhale or exhale phase
                // First half of animation cycle is inhale, second half is exhale
                final isInhaling =
                    _breathingController.status == AnimationStatus.forward;

                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isInhaling ? 'Inhale' : 'Exhale',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  try {
                    final url = Uri.parse(Constants.podcastUrl);
                    // url to url
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication
                        );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Something went wrong'),
                        ),
                      );
                    }
                  } catch (e) {
                    debugPrint('Error launching URL: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error launching URL'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Listen to this podcast',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF084B40),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_outward, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Detox Complete',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF084B40),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Great job! You\'ve completed your detox session.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF084B40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
