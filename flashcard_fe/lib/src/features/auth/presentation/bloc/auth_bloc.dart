import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    /* ---------------- field changes ---------------- */
    on<EmailChanged>((e, emit) {
      emit(
        state.copyWith(
          email: e.email,
          error: null,
          success: false,
          sent: false,
        ),
      );
    });

    on<PasswordChanged>((e, emit) {
      emit(
        state.copyWith(
          password: e.password,
          error: null,
          success: false,
          sent: false,
        ),
      );
    });

    on<ConfirmChanged>((e, emit) {
      emit(
        state.copyWith(
          confirm: e.confirm,
          error: null,
          success: false,
          sent: false,
        ),
      );
    });

    /* ---------------- toggles ---------------- */
    on<ToggleObscure>((e, emit) {
      emit(state.copyWith(obscure: !state.obscure));
    });

    on<ToggleConfirmObscure>((e, emit) {
      emit(state.copyWith(obscureConfirm: !state.obscureConfirm));
    });

    /* ---------------- submits ---------------- */
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<ForgotSubmitted>(_onForgotSubmitted);

    /* ---------------- reset ---------------- */
    on<AuthReset>((e, emit) => emit(const AuthState()));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted e,
    Emitter<AuthState> emit,
  ) async {
    if (!state.canLogin) return;
    emit(
      state.copyWith(loading: true, error: null, success: false, sent: false),
    );
    await Future<void>.delayed(const Duration(milliseconds: 900));

    // Demo rule: đúng tài khoản thì success
    if (state.email.trim() == 'demo@demo.com' && state.password == '123456') {
      emit(state.copyWith(loading: false, success: true));
    } else {
      emit(
        state.copyWith(loading: false, error: 'Email hoặc mật khẩu chưa đúng.'),
      );
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted e,
    Emitter<AuthState> emit,
  ) async {
    if (!state.canRegister) return;
    emit(
      state.copyWith(loading: true, error: null, success: false, sent: false),
    );
    await Future<void>.delayed(const Duration(milliseconds: 900));

    // Demo: canRegister đã pass validate => coi như đăng ký thành công
    emit(state.copyWith(loading: false, success: true));
  }

  Future<void> _onForgotSubmitted(
    ForgotSubmitted e,
    Emitter<AuthState> emit,
  ) async {
    if (!state.canForgot) return;
    emit(
      state.copyWith(loading: true, error: null, success: false, sent: false),
    );
    await Future<void>.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(loading: false, sent: true));
  }
}
