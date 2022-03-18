part of 'note_form_bloc.dart';

@freezed
class NoteFromEvent with _$NoteFromEvent {
  const factory NoteFromEvent.initialized(Option<Note> initialNoteOption) = _Initialized;
  const factory NoteFromEvent.bodyChanged(String bodyStr) = _BodyChanged;
  const factory NoteFromEvent.colorChanged(Color color) = _ColorChanged;
  const factory NoteFromEvent.todosChanged(KtList<TodoItemPrimitive> todos) =
      _TodosChanged;
  const factory NoteFromEvent.saved() = _Saved;
}