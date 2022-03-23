import 'package:ddd_practice_flutter/application/notes/note_form/bloc/note_form_bloc.dart';
import 'package:ddd_practice_flutter/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';
import 'package:ddd_practice_flutter/presentation/notes/note_form/misc/build_context_x.dart';

class AddTodoListTile extends StatelessWidget {
  const AddTodoListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) => {
        context.formTodos = state.note.todos.value.fold(
          (l) => listOf<TodoItemPrimitive>(),
          (todoItemList) => todoItemList.map(
            (_) => TodoItemPrimitive.fromDomain(_),
          ),
        ),
      },
      buildWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      builder: (context, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          leading: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.add),
          ),
          title: const Text('Add a Todo'),
          onTap: () {
            context.formTodos = context.formTodos.plusElement(
              TodoItemPrimitive.empty(),
            );
            context.read<NoteFormBloc>().add(
                  NoteFormEvent.todosChanged(
                    context.formTodos,
                  ),
                );
          },
        );
      },
    );
  }
}
