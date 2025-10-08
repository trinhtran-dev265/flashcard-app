import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

/* screen init / data */
class ProfileLoaded extends ProfileEvent {
  final String email;
  final int kanjiCount;
  const ProfileLoaded({required this.email, required this.kanjiCount});
  @override
  List<Object?> get props => [email, kanjiCount];
}

/* change password flow */
class OldPasswordChanged extends ProfileEvent {
  final String value;
  const OldPasswordChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class NewPasswordChanged extends ProfileEvent {
  final String value;
  const NewPasswordChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ConfirmPasswordChanged extends ProfileEvent {
  final String value;
  const ConfirmPasswordChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ToggleOldObscure extends ProfileEvent {
  const ToggleOldObscure();
}

class ToggleNewObscure extends ProfileEvent {
  const ToggleNewObscure();
}

class ToggleConfirmObscure extends ProfileEvent {
  const ToggleConfirmObscure();
}

class ChangePasswordSubmitted extends ProfileEvent {
  const ChangePasswordSubmitted();
}

class ResetChangePasswordForm extends ProfileEvent {
  const ResetChangePasswordForm();
}

/* logout */
class LogoutPressed extends ProfileEvent {
  const LogoutPressed();
}
