import 'package:equatable/equatable.dart';

class ForgotState extends Equatable {
  final String email;
  final bool loading;
  final String? error;
  final bool sent;
  const ForgotState({
    this.email = '',
    this.loading = false,
    this.error,
    this.sent = false,
  });
  bool get canSubmit => email.contains('@') && !loading;
  ForgotState copyWith({
    String? email,
    bool? loading,
    String? error,
    bool? sent,
  }) => ForgotState(
    email: email ?? this.email,
    loading: loading ?? this.loading,
    error: error,
    sent: sent ?? this.sent,
  );
  @override
  List<Object?> get props => [email, loading, error, sent];
}
