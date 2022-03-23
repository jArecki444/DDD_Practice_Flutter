import 'package:another_flushbar/flushbar_helper.dart';
import 'package:ddd_practice_flutter/application/notes/note_form/bloc/note_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) => current.note.todos.isFull == previous.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            message: 'Want longer lists? Activate premium',
            button: TextButton(
              onPressed: () {},
              child: Text('BUY NOW'),
            ),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      },
      child: Container(),
    );
  }
}
