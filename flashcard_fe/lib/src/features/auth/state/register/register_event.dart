import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}

class RegEmailChanged extends RegisterEvent {
  final String email;
  const RegEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class RegPasswordChanged extends RegisterEvent {
  final String password;
  const RegPasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class RegConfirmChanged extends RegisterEvent {
  final String confirm;
  const RegConfirmChanged(this.confirm);
  @override
  List<Object?> get props => [confirm];
}

class RegToggleObscure extends RegisterEvent {}

class RegToggleConfirmObscure extends RegisterEvent {}

class RegSubmitted extends RegisterEvent {}
