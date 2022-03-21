import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ddd_practice_flutter/application/notes/note_actor/bloc/note_actor_bloc.dart';
import 'package:ddd_practice_flutter/application/notes/note_watcher/bloc/note_watcher_bloc.dart';
import 'package:ddd_practice_flutter/domain/auth/bloc/auth_bloc.dart';
import 'package:ddd_practice_flutter/injection.dart';
import 'package:ddd_practice_flutter/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(
              const NoteWatcherEvent.watchAllStarted(),
            ),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            state.maybeMap(
              orElse: () => {},
              unauthenticated: (_) => context.router.replace(
                const SignInRoute(),
              ),
            );
          }),
          BlocListener<NoteActorBloc, NoteActorState>(
              listener: (context, state) {
            state.maybeMap(
              deleteFailure: (state) {
                FlushbarHelper.createError(
                  duration: const Duration(seconds: 5),
                  message: state.noteFailure.when(
                      unexpected: () =>
                          'Unexpected error, please contact support',
                      insufficientPermissions: () => 'Insufficient permissions',
                      unableToUpdate: () =>
                          'Unexpected error, please contact support'),
                ).show(context);
              },
              orElse: () {},
            );
          })
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes Overview'),
            leading: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => context.read<AuthBloc>().add(
                    const AuthEvent.signedOut(),
                  ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.indeterminate_check_box),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEvent.signedOut());
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
