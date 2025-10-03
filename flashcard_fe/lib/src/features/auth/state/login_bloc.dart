import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
LoginBloc() : super(const LoginState()) {
on<EmailChanged>((e, emit) => emit(state.copyWith(email: e.email, error: null)));
on<PasswordChanged>((e, emit) => emit(state.copyWith(password: e.password, error: null)));
on<ToggleObscure>((e, emit) => emit(state.copyWith(obscure: !state.obscure)));
on<Submitted>(_onSubmitted);
}


Future<void> _onSubmitted(Submitted e, Emitter<LoginState> emit) async {
if (!state.canSubmit) return;
emit(state.copyWith(loading: true, error: null));


// Fake API delay
await Future<void>.delayed(const Duration(milliseconds: 1400));


// Demo rule: email chứa "demo" & pass = "password" mới coi là đúng
if (state.email.contains('demo') && state.password == 'password') {
emit(state.copyWith(loading: false));
// Ở sản phẩm thật: điều hướng sang Home
} else {
emit(state.copyWith(loading: false, error: 'Email hoặc mật khẩu chưa đúng.'));
}
}
}