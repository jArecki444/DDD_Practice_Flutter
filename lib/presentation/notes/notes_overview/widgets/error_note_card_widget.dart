import 'package:ddd_practice_flutter/domain/notes/note.dart';
import 'package:flutter/material.dart';

class ErrorNoteCard extends StatelessWidget {
  final Note note;
  const ErrorNoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Column(
        children: [
          Text(
            'Invalid note, please, contact support',
            style: Theme.of(context)
                .primaryTextTheme
                .bodyText2
                ?.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
