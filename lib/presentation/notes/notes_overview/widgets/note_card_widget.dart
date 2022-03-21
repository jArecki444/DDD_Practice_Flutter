import 'package:ddd_practice_flutter/domain/notes/note.dart';
import 'package:ddd_practice_flutter/domain/notes/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.body.getOrCrash(),
              style: const TextStyle(fontSize: 18),
            ),
            if (note.todos.length > 0) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ...note.todos
                      .getOrCrash()
                      .map(
                        (todo) => TodoDisplay(
                          todo: todo,
                        ),
                      )
                      .iter
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todo;
  const TodoDisplay({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        todo.done
            ? const Icon(
                Icons.check_box,
                color: Colors.green,
              )
            : const Icon(
                Icons.check_box_outline_blank,
                color: Colors.grey,
              ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            todo.name.getOrCrash(),
          ),
        )
      ],
    );
  }
}
