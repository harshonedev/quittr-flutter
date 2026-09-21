import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'breathing_event.dart';
part 'breathing_state.dart';

class BreathingBloc extends Bloc<BreathingEvent, BreathingState> {
  BreathingBloc() : super(BreathingInitial()) {
    on<UpdateBreathingProgress>(_onUpdateProgress);
  }

  void _onUpdateProgress(
    UpdateBreathingProgress event,
    Emitter<BreathingState> emit,
  ) {
    String breathingText;

    if (event.progress < 1 / 3) {
      breathingText = "Breathe in\nwhen the ball goes up";
    } else if (event.progress < 2 / 3) {
      breathingText = "Hold\nwhen it stays flat";
    } else {
      breathingText = "Breathe out\nwhen the ball goes down";
    }

    emit(BreathingUpdated(
      progress: event.progress,
      breathingText: breathingText,
    ));
  }
}
