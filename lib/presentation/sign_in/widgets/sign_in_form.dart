import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ddd_practice_flutter/application/sign_in_form/bloc/sign_in_form_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () => {},
          (either) => either.fold(
            (l) => FlushbarHelper.createError(
              message: l.map(
                cancelledByUser: (_) => 'Cancelled',
                serverError: (_) => 'Server Error',
                emailAlreadyInUse: (_) => 'Email already in use',
                invalidEmailAndPasswordCombination: (_) =>
                    'Invalid email and password combination',
              ),
            ).show(context),
            (r) => Flushbar(
              message: 'Success',
              duration: const Duration(seconds: 2),
            )..show(context),
          ),
        );
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            autovalidateMode: state.useValidation
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  autocorrect: false,
                  onChanged: (value) => context.read<SignInFormBloc>().add(
                        SignInFormEvent.emailChanged(value),
                      ),
                  validator: (_) => context
                          .read<SignInFormBloc>()
                          .state
                          .emailAddress
                          .isValid()
                      ? null
                      : 'Invalid Email',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (value) => context.read<SignInFormBloc>().add(
                        SignInFormEvent.passwordChanged(value),
                      ),
                  validator: (_) =>
                      context.read<SignInFormBloc>().state.password.value.fold(
                            (f) => f.maybeMap(
                              shortPassword: (_) => 'Short password',
                              orElse: () => null,
                            ),
                            (correct) => null,
                          ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        child: const Text('Sign In'),
                        onPressed: () => context.read<SignInFormBloc>().add(
                              const SignInFormEvent.signInPressed(),
                            ),
                      ),
                    ),
                    Visibility(
                      visible: state.isSubmitting,
                      child: const CircularProgressIndicator(),
                    ),
                    Expanded(
                      child: TextButton(
                        child: const Text('Register'),
                        onPressed: () => context.read<SignInFormBloc>().add(
                              const SignInFormEvent.registerPressed(),
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => context.read<SignInFormBloc>().add(
                        const SignInFormEvent.signInWithGooglePressed(),
                      ),
                  child: const Text('Sign in with Google'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
