import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_practice_flutter/domain/notes/note.dart';
import 'package:ddd_practice_flutter/injection.dart';
import 'package:ddd_practice_flutter/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:ddd_practice_flutter/presentation/notes/note_form/widgets/add_todo_tile_widget.dart';
import 'package:ddd_practice_flutter/presentation/notes/note_form/widgets/body_field_widget.dart';
import 'package:ddd_practice_flutter/presentation/notes/note_form/widgets/color_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../application/notes/note_form/bloc/note_form_bloc.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;
  const NoteFormPage({Key? key, this.editedNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => getIt<NoteFormBloc>()
        ..add(
          NoteFormEvent.initialized(
            optionOf(editedNote),
          ),
        )),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (previous, current) =>
            previous.saveFailureOrSuccessOption !=
            current.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () => null,
            (some) => some.fold(
              (l) => FlushbarHelper.createError(
                message: l.when(
                  unexpected: () => 'Unexpected error, please contact support',
                  insufficientPermissions: () => 'Insufficient permissions',
                  unableToUpdate: () => "Couldn't update the note",
                ),
              ).show(context),
              (r) => context.router.pop(),
            ),
          );
        },
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) {
          return Stack(children: [
            NoteFormPageScaffold(editedNote: editedNote),
            SavingInProgressOverlay(isSaving: state.isSaving),
          ]);
        },
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;
  const SavingInProgressOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: isSaving ? Colors.black.withOpacity(0.5) : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(
                  'Saving...',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key? key,
    required this.editedNote,
  }) : super(key: key);

  final Note? editedNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editedNote == null ? 'New Note' : 'Edit Note',
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NoteFormBloc>().add(
                    const NoteFormEvent.saved(),
                  );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
              autovalidateMode: state.showErrorMessages
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    BodyField(),
                    ColorField(),
                    AddTodoListTile(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
