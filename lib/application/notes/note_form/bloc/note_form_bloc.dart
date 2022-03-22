import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_practice_flutter/domain/notes/i_note_repository.dart';
import 'package:ddd_practice_flutter/domain/notes/note.dart';
import 'package:ddd_practice_flutter/domain/notes/note_failure.dart';
import 'package:ddd_practice_flutter/domain/notes/value_objects.dart';
import 'package:ddd_practice_flutter/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<NoteFormEvent>((event, emit) async {
      await event.map(
        initialized: (eventData) {
          emit(
            eventData.initialNoteOption.fold(
              () => state,
              (initialNote) => state.copyWith(
                note: initialNote,
                isEditing: true,
              ),
            ),
          );
        },
        bodyChanged: (eventData) {
          emit(
            state.copyWith(
              note: state.note.copyWith(
                body: NoteBody(eventData.bodyStr),
              ),
              saveFailureOrSuccessOption: none(),
            ),
          );
        },
        colorChanged: (eventData) {
          emit(state.copyWith(
            note: state.note.copyWith(
              color: NoteColor(eventData.color),
            ),
            saveFailureOrSuccessOption: none(),
          ));
        },
        todosChanged: (eventData) {
          emit(
            state.copyWith(
              note: state.note.copyWith(
                todos: ThreeElementsList(
                  eventData.todos.map(
                    (primitive) => primitive.toDomain(),
                  ),
                ),
              ),
              saveFailureOrSuccessOption: none(),
            ),
          );
        },
        saved: (eventData) async {
          Either<NoteFailure, Unit> failureOrSuccess;

          emit(
            state.copyWith(
              isSaving: true,
              saveFailureOrSuccessOption: none(),
            ),
          );

          if (state.note.failureOption.isNone()) {
            failureOrSuccess = state.isEditing
                ? await _noteRepository.update(state.note)
                : await _noteRepository.create(state.note);
            emit(
              state.copyWith(
                isSaving: false,
                showErrorMessages: true,
                saveFailureOrSuccessOption: optionOf(failureOrSuccess),
              ),
            );
          } else {
            emit(
              state.copyWith(
                isSaving: false,
                showErrorMessages: true,
                saveFailureOrSuccessOption: none(),
              ),
            );
          }
        },
      );
    });
  }
}
