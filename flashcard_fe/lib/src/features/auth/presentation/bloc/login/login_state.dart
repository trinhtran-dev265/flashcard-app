import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool obscure;
  final bool loading;
  final String? error;

  const LoginState({
    this.email = '',
    this.password = '',
    this.obscure = true,
    this.loading = false,
    this.error,
  });

  bool get canSubmit => email.contains('@') && password.length >= 6 && !loading;

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscure,
    bool? loading,
    String? error,
  }) => LoginState(
    email: email ?? this.email,
    password: password ?? this.password,
    obscure: obscure ?? this.obscure,
    loading: loading ?? this.loading,
    error: error,
  );

  @override
  List<Object?> get props => [email, password, obscure, loading, error];
}
