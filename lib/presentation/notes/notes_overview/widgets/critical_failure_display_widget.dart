import 'package:ddd_practice_flutter/domain/notes/note_failure.dart';
import 'package:flutter/material.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;
  const CriticalFailureDisplay({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Oops, something went wrong:',
          ),
          Text(failure.maybeMap(
            insufficientPermissions: (_) => 'Insufficient permissions',
            orElse: () => 'Please contact support',
          )),
        ],
      ),
    );
  }
}
