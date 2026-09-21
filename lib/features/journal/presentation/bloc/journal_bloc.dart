import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/journal/domain/entities/journal_entry.dart';
import 'package:quittr/features/journal/domain/usecases/add_journal_entry.dart';
import 'package:quittr/features/journal/domain/usecases/get_journal_entries.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final AddJournalEntry _addJournalEntry;
  final GetJournalEntries _getJournalEntries;

  JournalBloc({
    required addJournalEntry,
    required GetJournalEntries getJournalEntries,
  })  : _addJournalEntry = addJournalEntry,
        _getJournalEntries = getJournalEntries,
        super(JournalInitialState()) {
    on<AddJournalEntryEvent>(_onAddJournalEntry);
    on<FetchJournalEntriesEvent>(_onFetchJournalEntries);
  }

  void _onAddJournalEntry(
    AddJournalEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    if (state is! JournalLoadedState) {
      emit(JournalErrorState(message: "Please fetch journal entries first."));
    }
    final currentState = state as JournalLoadedState;
    emit(JournalLoadingState());
    try {
      final addJournalEntryParams = AddJournalEntryParams(
        title: event.title,
        description: event.description,
      );
      final response = await _addJournalEntry(addJournalEntryParams);
      response.fold(
        (failure) => emit(JournalErrorState(message: failure.message)),
        (savedEntry) {
          // Assuming savedEntry is of type JournalEntry
          emit(currentState.copyWith(
            entries: List.from(currentState.entries)..add(savedEntry),
          ));
        },
      );
    } catch (e) {
      emit(JournalErrorState(message: e.toString()));
    }
  }

  void _onFetchJournalEntries(
    FetchJournalEntriesEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoadingState());
    try {
      final response = await _getJournalEntries(NoParams());
      response.fold(
        (failure) => emit(JournalErrorState(message: failure.message)),
        (entries) {
          // Assuming entries is a List<JournalEntry>
          emit(JournalLoadedState(entries: entries));
        },
      );
    } catch (e) {
      emit(JournalErrorState(message: e.toString()));
    }
  }
}

abstract class JournalEvent {}

class AddJournalEntryEvent extends JournalEvent {
  final String title;
  final String description;

  AddJournalEntryEvent({required this.title, required this.description});
}

class FetchJournalEntriesEvent extends JournalEvent {}

abstract class JournalState {}

class JournalInitialState extends JournalState {}

class JournalLoadingState extends JournalState {}

class JournalLoadedState extends JournalState {
  final List<JournalEntry> entries;

  JournalLoadedState({required this.entries});

  JournalLoadedState copyWith({
    List<JournalEntry>? entries,
  }) {
    return JournalLoadedState(
      entries: entries ?? this.entries,
    );
  }
}

class JournalErrorState extends JournalState {
  final String message;

  JournalErrorState({required this.message});
}
