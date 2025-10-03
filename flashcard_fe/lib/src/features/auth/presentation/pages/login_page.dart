import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state/login_bloc.dart';
import '../../state/login_event.dart';
import '../../state/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LiquidScaffold(child: Center(child: _GlassLoginCard()));
  }
}

class _LiquidScaffold extends StatefulWidget {
  final Widget child;
  const _LiquidScaffold({required this.child});

  @override
  State<_LiquidScaffold> createState() => _LiquidScaffoldState();
}

class _LiquidScaffoldState extends State<_LiquidScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient nền (deep purple → indigo → cyan)
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

          AnimatedBuilder(
            animation: _ac,
            builder: (context, child) {
              final t = _ac.value;
              return Stack(
                children: [
                  _blob(
                    left: size.width * (0.1 + 0.05 * t),
                    top: size.height * (0.1 + 0.03 * (1 - t)),
                    diameter: size.width * 0.6,
                    color: const Color(0xFF8A80FF).withValues(alpha: 0.25),
                  ),
                  _blob(
                    left: size.width * (0.55 - 0.08 * t),
                    top: size.height * (0.65 - 0.04 * (1 - t)),
                    diameter: size.width * 0.7,
                    color: const Color(0xFF00D1FF).withValues(alpha: 0.22),
                  ),
                  _blob(
                    left: size.width * (0.3 + 0.06 * (1 - t)),
                    top: size.height * (0.35 + 0.05 * t),
                    diameter: size.width * 0.5,
                    color: const Color(0xFFFF6ED1).withValues(alpha: 0.18),
                  ),
                ],
              );
            },
          ),

          Positioned(right: 24, top: 56, child: _specularDot()),
          Positioned(left: 32, bottom: 64, child: _specularDot(size: 9)),

          // Nội dung
          SafeArea(child: widget.child),
        ],
      ),
    );
  }

  Widget _blob({
    required double left,
    required double top,
    required double diameter,
    required Color color,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }

  Widget _specularDot({double size = 12}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 12, spreadRadius: 2, color: Colors.white24),
        ],
        color: Colors.white,
      ),
    );
  }
}

class _GlassLoginCard extends StatelessWidget {
  const _GlassLoginCard();

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
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: const _LoginForm(),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen:
          (prev, curr) =>
              prev.error != curr.error || prev.loading != curr.loading,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.lock_outline_rounded),
                const SizedBox(width: 10),
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Email
            _GlassField(
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => context.read<LoginBloc>().add(EmailChanged(v)),
              leading: const Icon(Icons.alternate_email_rounded, size: 20),
            ),
            const SizedBox(height: 12),

            _GlassField(
              hintText: 'Password',
              obscureText: state.obscure,
              onChanged:
                  (v) => context.read<LoginBloc>().add(PasswordChanged(v)),
              leading: const Icon(Icons.key_rounded, size: 20),
              trailing: IconButton(
                onPressed: () => context.read<LoginBloc>().add(ToggleObscure()),
                icon: Icon(
                  state.obscure
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Mẹo: thử email chứa "demo" và mật khẩu "password"',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed:
                  state.canSubmit
                      ? () => context.read<LoginBloc>().add(Submitted())
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
                      : const Text('Sign in'),
            ),

            const SizedBox(height: 14),
            TextButton(onPressed: () {}, child: const Text('Forgot password?')),
          ],
        );
      },
    );
  }
}

class _GlassField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? leading;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _GlassField({
    required this.hintText,
    this.obscureText = false,
    this.leading,
    this.trailing,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final baseFill = Colors.white.withValues(alpha: 0.06);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.white.withValues(alpha: 0.28),
        width: 1,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: leading,
          suffixIcon: trailing,
          hintText: hintText,
          filled: true,
          fillColor: baseFill,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.55),
              width: 1.2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
