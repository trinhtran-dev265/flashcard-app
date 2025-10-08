import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileLoaded>((e, emit) {
      emit(state.copyWith(email: e.email, kanjiCount: e.kanjiCount));
    });

    on<OldPasswordChanged>(
      (e, emit) => emit(
        state.copyWith(oldPass: e.value, error: null, passwordChanged: false),
      ),
    );

    on<NewPasswordChanged>(
      (e, emit) => emit(
        state.copyWith(newPass: e.value, error: null, passwordChanged: false),
      ),
    );

    on<ConfirmPasswordChanged>(
      (e, emit) => emit(
        state.copyWith(
          confirmPass: e.value,
          error: null,
          passwordChanged: false,
        ),
      ),
    );

    on<ToggleOldObscure>(
      (e, emit) => emit(state.copyWith(obscureOld: !state.obscureOld)),
    );
    on<ToggleNewObscure>(
      (e, emit) => emit(state.copyWith(obscureNew: !state.obscureNew)),
    );
    on<ToggleConfirmObscure>(
      (e, emit) => emit(state.copyWith(obscureConfirm: !state.obscureConfirm)),
    );

    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
    on<ResetChangePasswordForm>(
      (e, emit) => emit(
        state.copyWith(
          oldPass: '',
          newPass: '',
          confirmPass: '',
          error: null,
          passwordChanged: false,
        ),
      ),
    );

    on<LogoutPressed>((e, emit) {
      // Demo: set flag -> UI điều hướng login
      emit(state.copyWith(loggedOut: true));
    });
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted e,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.canSubmitChange) return;

    if (state.newPass != state.confirmPass) {
      emit(state.copyWith(error: 'Mật khẩu không khớp!'));
      return;
    }

    emit(state.copyWith(loading: true, error: null, passwordChanged: false));
    await Future<void>.delayed(
      const Duration(milliseconds: 800),
    ); // giả lập API

    // Demo: coi như đổi mật khẩu thành công
    emit(state.copyWith(loading: false, passwordChanged: true));
  }
}
