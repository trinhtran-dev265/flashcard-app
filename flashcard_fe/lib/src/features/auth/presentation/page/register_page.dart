import 'dart:ui';
import 'package:flashcard_fe/src/features/auth/presentation/widget/glass_field.dart';
import 'package:flashcard_fe/src/features/auth/presentation/bloc/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(),
      child: const _LiquidScaffold(child: Center(child: _GlassRegisterCard())),
    );
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

class _GlassRegisterCard extends StatelessWidget {
  const _GlassRegisterCard();

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
            child: const _RegisterForm(),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listenWhen:
          (a, b) =>
              a.error != b.error ||
              a.loading != b.loading ||
              a.success != b.success,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo tài khoản thành công!')),
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
                const Icon(Icons.person_add_alt_1_rounded),
                const SizedBox(width: 10),
                Text(
                  'Create account',
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
              onChanged:
                  (v) => context.read<RegisterBloc>().add(RegEmailChanged(v)),
              leading: const Icon(Icons.alternate_email_rounded, size: 20),
            ),
            const SizedBox(height: 12),
            GlassField(
              hintText: 'Password',
              obscureText: state.obscure,
              onChanged:
                  (v) =>
                      context.read<RegisterBloc>().add(RegPasswordChanged(v)),
              leading: const Icon(Icons.key_rounded, size: 20),
              trailing: IconButton(
                onPressed:
                    () => context.read<RegisterBloc>().add(RegToggleObscure()),
                icon: Icon(
                  state.obscure
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GlassField(
              hintText: 'Confirm password',
              obscureText: state.obscureConfirm,
              onChanged:
                  (v) => context.read<RegisterBloc>().add(RegConfirmChanged(v)),
              leading: const Icon(Icons.key_rounded, size: 20),
              trailing: IconButton(
                onPressed:
                    () => context.read<RegisterBloc>().add(
                      RegToggleConfirmObscure(),
                    ),
                icon: Icon(
                  state.obscureConfirm
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed:
                  state.canSubmit
                      ? () => context.read<RegisterBloc>().add(RegSubmitted())
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
                      : const Text('Sign up'),
            ),
            const SizedBox(height: 14),
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
