import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<RegEmailChanged>(
      (e, emit) =>
          emit(state.copyWith(email: e.email, error: null, success: false)),
    );
    on<RegPasswordChanged>(
      (e, emit) => emit(
        state.copyWith(password: e.password, error: null, success: false),
      ),
    );
    on<RegConfirmChanged>(
      (e, emit) =>
          emit(state.copyWith(confirm: e.confirm, error: null, success: false)),
    );
    on<RegToggleObscure>(
      (e, emit) => emit(state.copyWith(obscure: !state.obscure)),
    );
    on<RegToggleConfirmObscure>(
      (e, emit) => emit(state.copyWith(obscureConfirm: !state.obscureConfirm)),
    );
    on<RegSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(RegSubmitted e, Emitter<RegisterState> emit) async {
    if (!state.canSubmit) return;
    emit(state.copyWith(loading: true, error: null, success: false));
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    // Demo: luôn thành công nếu canSubmit = true
    emit(state.copyWith(loading: false, success: true));
  }
}
