import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final String email;
  final String password;
  final String confirm;
  final bool obscure;
  final bool obscureConfirm;
  final bool loading;
  final String? error;
  final bool success;
  const RegisterState({
    this.email = '',
    this.password = '',
    this.confirm = '',
    this.obscure = true,
    this.obscureConfirm = true,
    this.loading = false,
    this.error,
    this.success = false,
  });
  bool get canSubmit =>
      email.contains('@') &&
      password.length >= 6 &&
      confirm == password &&
      !loading;
  RegisterState copyWith({
    String? email,
    String? password,
    String? confirm,
    bool? obscure,
    bool? obscureConfirm,
    bool? loading,
    String? error,
    bool? success,
  }) => RegisterState(
    email: email ?? this.email,
    password: password ?? this.password,
    confirm: confirm ?? this.confirm,
    obscure: obscure ?? this.obscure,
    obscureConfirm: obscureConfirm ?? this.obscureConfirm,
    loading: loading ?? this.loading,
    error: error,
    success: success ?? this.success,
  );
  @override
  List<Object?> get props => [
    email,
    password,
    confirm,
    obscure,
    obscureConfirm,
    loading,
    error,
    success,
  ];
}
