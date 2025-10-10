import 'dart:ui';
import 'package:flashcard_fe/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard_fe/src/features/auth/presentation/widget/glass_field.dart';
import 'package:flashcard_fe/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flashcard_fe/src/features/auth/presentation/bloc/auth_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LiquidScaffold(child: Center(child: _GlassForgotCard()));
  }
}

class _LiquidScaffold extends StatelessWidget {
  final Widget child;
  const _LiquidScaffold({required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B1734),
                  Color(0xFF302A6B),
                  Color(0xFF0F6C76),
                ],
              ),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _GlassForgotCard extends StatelessWidget {
  const _GlassForgotCard();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width > 560 ? 480.0 : width - 32.0;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.28),
                width: 1.0,
              ),
            ),
            child: const _ForgotForm(),
          ),
        ),
      ),
    );
  }
}

class _ForgotForm extends StatelessWidget {
  const _ForgotForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen:
          (a, b) =>
              a.error != b.error ||
              a.success != b.success ||
              a.loading != b.loading ||
              a.sent != b.sent,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state.sent && state.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã gửi email khôi phục mật khẩu.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.lock_reset_rounded),
                const SizedBox(width: 10),
                Text(
                  'Forgot password',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GlassField(
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => context.read<AuthBloc>().add(EmailChanged(v)),
              leading: const Icon(Icons.alternate_email_rounded, size: 20),
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed:
                  state.canForgot
                      ? () =>
                          context.read<AuthBloc>().add(const ForgotSubmitted())
                      : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child:
                  state.loading
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Send reset link'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to login'),
            ),
          ],
        );
      },
    );
  }
}
