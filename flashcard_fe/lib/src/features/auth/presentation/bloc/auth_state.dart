import 'package:equatable/equatable.dart';

/// Dùng chung cho cả Login / Register / Forgot
class AuthState extends Equatable {
  final String email;
  final String password;
  final String confirm;

  final bool obscure;
  final bool obscureConfirm;

  final bool loading;
  final String? error;

  /// Dùng cho các flow riêng:
  /// - Login: success = đăng nhập thành công
  /// - Register: success = tạo tài khoản thành công
  /// - Forgot: sent = email reset đã gửi
  final bool success;
  final bool sent;

  const AuthState({
    this.email = '',
    this.password = '',
    this.confirm = '',
    this.obscure = true,
    this.obscureConfirm = true,
    this.loading = false,
    this.error,
    this.success = false,
    this.sent = false,
  });

  /// Xác định có thể submit được ở từng flow
  bool get canLogin => email.contains('@') && password.length >= 6 && !loading;

  bool get canRegister =>
      email.contains('@') &&
      password.length >= 6 &&
      confirm == password &&
      !loading;

  bool get canForgot => email.contains('@') && !loading;

  AuthState copyWith({
    String? email,
    String? password,
    String? confirm,
    bool? obscure,
    bool? obscureConfirm,
    bool? loading,
    String? error,
    bool? success,
    bool? sent,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirm: confirm ?? this.confirm,
      obscure: obscure ?? this.obscure,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
      sent: sent ?? this.sent,
    );
  }

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
    sent,
  ];
}
