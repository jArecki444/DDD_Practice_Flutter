import 'package:ddd_practice_flutter/application/notes/note_watcher/bloc/note_watcher_bloc.dart';
import 'package:ddd_practice_flutter/presentation/notes/notes_overview/widgets/critical_failure_display_widget.dart';
import 'package:ddd_practice_flutter/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:ddd_practice_flutter/presentation/notes/notes_overview/widgets/note_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => Container(),
          loadInProgress: (_) => const CircularProgressIndicator(),
          loadSuccess: (state) {
            return ListView.builder(
              itemCount: state.notes.size,
              itemBuilder: (context, index) {
                final currentNote = state.notes[index];
                if (currentNote.failureOption.isSome()) {
                  return ErrorNoteCard(note: currentNote);
                }
                return NoteCard(note: currentNote);
              },
            );
          },
          loadFailure: (state) =>
              CriticalFailureDisplay(failure: state.failure),
        );
      },
    );
  }
}
