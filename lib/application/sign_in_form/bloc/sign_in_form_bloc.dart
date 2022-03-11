// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_practice_flutter/domain/auth/auth_failure.dart';
import 'package:ddd_practice_flutter/domain/auth/i_auth_facade.dart';
import 'package:ddd_practice_flutter/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<_EmailChanged>(
      (event, emit) => emit(
        state.copyWith(
            emailAddress: EmailAddress(event.email),
            authFailureOrSuccessOption: none()),
      ),
    );
    on<_PasswordChanged>(
      (event, emit) => emit(
        state.copyWith(
            password: Password(event.password),
            authFailureOrSuccessOption: none()),
      ),
    );
    on<_SignInPressed>(
      (event, emit) => _performActionOnAuthFacadeWithEmailAndPassword(
        _authFacade.signInWithEmailAndPassword,
      ),
    );
    on<_RegisterPressed>(
      (event, emit) => _performActionOnAuthFacadeWithEmailAndPassword(
        _authFacade.registerWithEmailAndPassword,
      ),
    );
    on<_SignInWithGooglePressed>((event, emit) async {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );

      final failureOrSuccess = await _authFacade.signInWithGoogle();
      emit(
        state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess),
        ),
      );
    });
  }

  _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );
      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    emit(
      state.copyWith(
        isSubmitting: false,
        useValidation: true,
        // The bottom line (optionOf) equivalent is:
        // failureOrSuccess != null ? some(failureOrSuccess) : none()
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }
}
