import 'package:auto_route/auto_route.dart';
import 'package:ddd_practice_flutter/domain/auth/bloc/auth_bloc.dart';
import 'package:ddd_practice_flutter/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {
        state.when(
          initial: () {},
          authenticated: () => print('I am authenticated'),
          // authenticated: context.router.replace(NotesOverviewPage(),
          unauthenticated: () => context.router.replace(
            const SignInRoute(),
          ),
        );
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
