import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_event.dart';
import 'forgot_state.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  ForgotBloc() : super(const ForgotState()) {
    on<FgEmailChanged>(
      (e, emit) =>
          emit(state.copyWith(email: e.email, error: null, sent: false)),
    );
    on<FgSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(FgSubmitted e, Emitter<ForgotState> emit) async {
    if (!state.canSubmit) return;
    emit(state.copyWith(loading: true, error: null, sent: false));
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    // Demo: coi như đã gửi mail thành công
    emit(state.copyWith(loading: false, sent: true));
  }
}
