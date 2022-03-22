import 'package:ddd_practice_flutter/application/notes/note_watcher/bloc/note_watcher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UncompletedSwitch extends StatefulWidget {
  const UncompletedSwitch({Key? key}) : super(key: key);

  @override
  State<UncompletedSwitch> createState() => _UncompletedSwitchState();
}

class _UncompletedSwitchState extends State<UncompletedSwitch> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: InkResponse(
        onTap: () {
          context.read<NoteWatcherBloc>().add(
                _isChecked
                    ? const NoteWatcherEvent.watchUncompletedStarted()
                    : const NoteWatcherEvent.watchAllStarted(),
              );
          setState(() {
            _isChecked = !_isChecked;
          });
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: _isChecked
              ? const Icon(Icons.check_box_outline_blank, key: Key('outline'))
              : const Icon(Icons.indeterminate_check_box, key: Key('filled')),
        ),
      ),
    );
  }
}
