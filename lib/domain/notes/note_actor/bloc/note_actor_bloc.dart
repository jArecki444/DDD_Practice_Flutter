import 'package:bloc/bloc.dart';
import 'package:ddd_practice_flutter/domain/notes/i_note_repository.dart';
import 'package:ddd_practice_flutter/domain/notes/note.dart';
import 'package:ddd_practice_flutter/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository)
      : super(
          const NoteActorState.initial(),
        ) {
    on<NoteActorEvent>(
      (event, emit) {
        event.map(
          deleted: (eventData) {
            emit(
              const NoteActorState.actionInProgress(),
            );
            _noteRepository.delete(eventData.note).then(
              (failureOrSuccess) {
                failureOrSuccess.fold(
                  (failure) => emit(
                    NoteActorState.deleteFailure(failure),
                  ),
                  (_) => emit(
                    const NoteActorState.deleteSuccess(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
