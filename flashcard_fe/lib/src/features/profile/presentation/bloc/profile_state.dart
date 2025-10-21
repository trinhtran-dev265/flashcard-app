import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String email;
  final int kanjiCount;

  // change password form
  final String oldPass;
  final String newPass;
  final String confirmPass;
  final bool obscureOld;
  final bool obscureNew;
  final bool obscureConfirm;
  final bool loading;
  final String? error;
  final bool passwordChanged;

  // logout
  final bool loggedOut;

  const ProfileState({
    this.email = '',
    this.kanjiCount = 0,
    this.oldPass = '',
    this.newPass = '',
    this.confirmPass = '',
    this.obscureOld = true,
    this.obscureNew = true,
    this.obscureConfirm = true,
    this.loading = false,
    this.error,
    this.passwordChanged = false,
    this.loggedOut = false,
  });

  bool get canSubmitChange =>
      oldPass.isNotEmpty &&
      newPass.length >= 6 &&
      confirmPass.isNotEmpty &&
      !loading;

  ProfileState copyWith({
    String? email,
    int? kanjiCount,
    String? oldPass,
    String? newPass,
    String? confirmPass,
    bool? obscureOld,
    bool? obscureNew,
    bool? obscureConfirm,
    bool? loading,
    String? error,
    bool? passwordChanged,
    bool? loggedOut,
  }) {
    return ProfileState(
      email: email ?? this.email,
      kanjiCount: kanjiCount ?? this.kanjiCount,
      oldPass: oldPass ?? this.oldPass,
      newPass: newPass ?? this.newPass,
      confirmPass: confirmPass ?? this.confirmPass,
      obscureOld: obscureOld ?? this.obscureOld,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      loading: loading ?? this.loading,
      error: error,
      passwordChanged: passwordChanged ?? this.passwordChanged,
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }

  factory ProfileState.initial() => const ProfileState();

  @override
  List<Object?> get props => [
    email,
    kanjiCount,
    oldPass,
    newPass,
    confirmPass,
    obscureOld,
    obscureNew,
    obscureConfirm,
    loading,
    error,
    passwordChanged,
    loggedOut,
  ];
}
