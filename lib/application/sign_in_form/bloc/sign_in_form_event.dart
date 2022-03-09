part of 'sign_in_form_bloc.dart';

@freezed
class SignInFormEvent with _$SignInFormEvent {
  const factory SignInFormEvent.emailChanged(String email) = _EmailChanged;
  const factory SignInFormEvent.passwordChanged(String password) =
      _PasswordChanged;
  const factory SignInFormEvent.registerPressed() = _RegisterPressed;
  const factory SignInFormEvent.signInPressed() = _SignInPressed;
  const factory SignInFormEvent.signInWithGooglePressed() =
      _SignInWithGooglePressed;
}
