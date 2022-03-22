import 'package:another_flushbar/flushbar_helper.dart';
import 'package:ddd_practice_flutter/application/notes/note_form/bloc/note_form_bloc.dart';
import 'package:ddd_practice_flutter/domain/notes/value_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BodyField extends HookWidget {
  const BodyField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) {
        textEditingController.text = state.note.body.getOrCrash();
        FlushbarHelper.createInformation(
                message: 'NoteFormBloc, is editing? ${state.isEditing}')
            .show(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            labelText: "Note",
          ),
          maxLength: NoteBody.maxLength,
          maxLines: null,
          minLines: 5,
          validator: (value) =>
              context.read<NoteFormBloc>().state.note.body.value.fold(
                  (l) => l.maybeMap(
                        empty: (_) => "Please enter a note",
                        orElse: () => null,
                        exceedingLength: (f) =>
                            "Exceeding length: - max length: ${f.max}",
                      ),
                  (r) => null),
          onChanged: (value) => context.read<NoteFormBloc>().add(
                NoteFormEvent.bodyChanged(value),
              ),
        ),
      ),
    );
  }
}
