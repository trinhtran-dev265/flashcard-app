import 'dart:ui';
import 'package:flashcard_fe/src/features/auth/presentation/page/login_page.dart';
import 'package:flashcard_fe/src/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final int kanjiCount;
  const ProfilePage({super.key, required this.email, required this.kanjiCount});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              ProfileBloc()
                ..add(ProfileLoaded(email: email, kanjiCount: kanjiCount)),
      child: const _ProfileScaffold(),
    );
  }
}

class _ProfileScaffold extends StatelessWidget {
  const _ProfileScaffold();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (p, c) => p.loggedOut != c.loggedOut,
      listener: (context, state) {
        if (state.loggedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            // gradient iOS26
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1B1734),
                    Color(0xFF302A6B),
                    Color(0xFF0F6C76),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: BlocConsumer<ProfileBloc, ProfileState>(
                        listenWhen:
                            (p, c) =>
                                p.passwordChanged != c.passwordChanged ||
                                p.error != c.error,
                        listener: (context, state) {
                          if (state.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                          if (state.passwordChanged) {
                            Navigator.of(
                              context,
                            ).pop(); // đóng dialog nếu đang mở
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đổi mật khẩu thành công!'),
                              ),
                            );
                            context.read<ProfileBloc>().add(
                              const ResetChangePasswordForm(),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.account_circle_rounded,
                                size: 96,
                                color: Colors.white70,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                state.email,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Total Kanji: ${state.kanjiCount}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Change password
                              _GlassButton(
                                icon: Icons.lock_outline_rounded,
                                label: 'Change Password',
                                onTap: () => _showChangePasswordDialog(context),
                              ),
                              const SizedBox(height: 12),

                              // Logout
                              _GlassButton(
                                icon: Icons.logout_rounded,
                                label: 'Log out',
                                color: Colors.redAccent,
                                onTap:
                                    () => context.read<ProfileBloc>().add(
                                      const LogoutPressed(),
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _GlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? Colors.white;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(icon, color: baseColor, size: 22),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: baseColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showChangePasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) {
      // dùng lại cùng ProfileBloc từ page:
      return BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Change Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Old password
                        TextField(
                          obscureText: state.obscureOld,
                          onChanged:
                              (v) => context.read<ProfileBloc>().add(
                                OldPasswordChanged(v),
                              ),
                          decoration: InputDecoration(
                            labelText: 'Old Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.obscureOld
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  () => context.read<ProfileBloc>().add(
                                    const ToggleOldObscure(),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // New password
                        TextField(
                          obscureText: state.obscureNew,
                          onChanged:
                              (v) => context.read<ProfileBloc>().add(
                                NewPasswordChanged(v),
                              ),
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.obscureNew
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  () => context.read<ProfileBloc>().add(
                                    const ToggleNewObscure(),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Confirm password
                        TextField(
                          obscureText: state.obscureConfirm,
                          onChanged:
                              (v) => context.read<ProfileBloc>().add(
                                ConfirmPasswordChanged(v),
                              ),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  () => context.read<ProfileBloc>().add(
                                    const ToggleConfirmObscure(),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed:
                                  state.canSubmitChange
                                      ? () => context.read<ProfileBloc>().add(
                                        const ChangePasswordSubmitted(),
                                      )
                                      : null,
                              child:
                                  state.loading
                                      ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
