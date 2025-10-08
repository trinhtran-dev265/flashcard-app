import 'package:equatable/equatable.dart';

abstract class ForgotEvent extends Equatable {
  const ForgotEvent();
  @override
  List<Object?> get props => [];
}

class FgEmailChanged extends ForgotEvent {
  final String email;
  const FgEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class FgSubmitted extends ForgotEvent {}
