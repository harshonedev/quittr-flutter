import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/reason/domain/entities/reason.dart';
import 'package:quittr/features/reason/domain/usecases/add_reason.dart';
import 'package:quittr/features/reason/domain/usecases/get_reasons.dart';
import 'package:quittr/features/reason/domain/usecases/delete_reason.dart';


class ReasonBloc extends Bloc<ReasonEvent, ReasonState> {
  final AddReason _addReason;
  final GetReasons _getReasons;
  final DeleteReason _deleteReason;

  ReasonBloc({
    required AddReason addReason,
    required GetReasons getReasons,
    required DeleteReason deleteReason,
  })  : _addReason = addReason,
        _getReasons = getReasons,
        _deleteReason = deleteReason,
        super(ReasonInitialState()) {
    on<AddReasonEvent>(_onAddReason);
    on<FetchReasonsEvent>(_onFetchReasons);
    on<DeleteReasonEvent>(_onDeleteReason);
  }

  void _onAddReason(
    AddReasonEvent event,
    Emitter<ReasonState> emit,
  ) async {
    if (state is! ReasonLoadedState) {
      emit(ReasonErrorState(message: "Please fetch reasons first."));
      return;
    }
    final currentState = state as ReasonLoadedState;
    emit(ReasonLoadingState());
    try {
      final response =
          await _addReason(AddReasonParams(reasonText: event.reasonText));
      response.fold(
        (failure) => emit(ReasonErrorState(message: failure.message)),
        (savedReason) {
          emit(currentState.copyWith(
            reasons: List.from(currentState.reasons)..add(savedReason),
          ));
        },
      );
    } catch (e) {
      emit(ReasonErrorState(message: e.toString()));
    }
  }

  void _onFetchReasons(
    FetchReasonsEvent event,
    Emitter<ReasonState> emit,
  ) async {
    emit(ReasonLoadingState());
    try {
      final response = await _getReasons(NoParams());
      response.fold(
        (failure) => emit(ReasonErrorState(message: failure.message)),
        (reasons) {
          emit(ReasonLoadedState(reasons: reasons));
        },
      );
    } catch (e) {
      emit(ReasonErrorState(message: e.toString()));
    }
  }

  void _onDeleteReason(
    DeleteReasonEvent event,
    Emitter<ReasonState> emit,
  ) async {
    if (state is! ReasonLoadedState) {
      emit(ReasonErrorState(message: "Please fetch reasons first."));
      return;
    }
    final currentState = state as ReasonLoadedState;
    emit(ReasonLoadingState());
    try {
      final response = await _deleteReason(DeleteReasonParams(id: event.id));
      response.fold(
        (failure) => emit(ReasonErrorState(message: failure.message)),
        (_) {
          emit(currentState.copyWith(
            reasons: List.from(currentState.reasons)
              ..removeWhere((reason) => reason.id == event.id),
          ));
        },
      );
    } catch (e) {
      emit(ReasonErrorState(message: e.toString()));
    }
  }
}

abstract class ReasonEvent {}

class AddReasonEvent extends ReasonEvent {
  final String reasonText;
  AddReasonEvent({required this.reasonText});
}

class FetchReasonsEvent extends ReasonEvent {}

class DeleteReasonEvent extends ReasonEvent {
  final String id;
  DeleteReasonEvent({required this.id});
}

// States
abstract class ReasonState {}

class ReasonInitialState extends ReasonState {}

class ReasonLoadingState extends ReasonState {}

class ReasonLoadedState extends ReasonState {
  final List<Reason> reasons;

  ReasonLoadedState({required this.reasons});

  ReasonLoadedState copyWith({
    List<Reason>? reasons,
  }) {
    return ReasonLoadedState(
      reasons: reasons ?? this.reasons,
    );
  }
}

class ReasonErrorState extends ReasonState {
  final String message;

  ReasonErrorState({required this.message});
}

