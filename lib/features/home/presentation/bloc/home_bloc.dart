import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/services/rating_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RatingService _ratingService;
  HomeBloc({required RatingService ratingService})
      : _ratingService = ratingService,
        super(HomeInitialState()) {
    on<StartTrackUssageTimeEvent>((event, emit) {
      // Handle events here
      _ratingService.startTrackingUsageTime(() {
        add(ShowRatingDialogEvent());
      });
    });
    on<OpenPlayStoreEvent>((event, emit) {
      _ratingService.openPlayStore();
    });
    on<ShowRatingDialogEvent>((event, emit) {
      emit(ShowRatingDialogState());
    });
    on<SetLastRatingPromptEvent>((event, emit) {
      _ratingService.setLastRatingPrompt();
    });
  }

  @override
  Future<void> close() {
    _ratingService.dispose();
    return super.close();
  }
}

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartTrackUssageTimeEvent extends HomeEvent {}

class OpenPlayStoreEvent extends HomeEvent {}

class ShowRatingDialogEvent extends HomeEvent {}

class SetLastRatingPromptEvent extends HomeEvent {}

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}

class ShowRatingDialogState extends HomeState {}
