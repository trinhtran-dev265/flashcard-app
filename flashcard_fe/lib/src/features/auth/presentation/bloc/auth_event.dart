import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/* --------------------- FIELD CHANGES --------------------- */

class EmailChanged extends AuthEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ConfirmChanged extends AuthEvent {
  final String confirm;
  const ConfirmChanged(this.confirm);

  @override
  List<Object?> get props => [confirm];
}

/* --------------------- TOGGLES --------------------- */

class ToggleObscure extends AuthEvent {
  const ToggleObscure();
}

class ToggleConfirmObscure extends AuthEvent {
  const ToggleConfirmObscure();
}

/* --------------------- SUBMIT EVENTS --------------------- */

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted();
}

class RegisterSubmitted extends AuthEvent {
  const RegisterSubmitted();
}

class ForgotSubmitted extends AuthEvent {
  const ForgotSubmitted();
}

/* --------------------- RESET --------------------- */

class AuthReset extends AuthEvent {
  const AuthReset();
}
