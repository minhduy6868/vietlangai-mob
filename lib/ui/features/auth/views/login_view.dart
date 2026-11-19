import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../core/app_feedback.dart';
import '../../../core/app_theme.dart';
import '../../../core/brand_assets.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/auth_form_widgets.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({this.initialRegister = false, super.key});

  final bool initialRegister;

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  late bool _register;
  bool _loading = false;
  bool _googleLoading = false;

  @override
  void initState() {
    super.initState();
    _register = widget.initialRegister;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 880;

    return Scaffold(
      backgroundColor: const Color(0xFF071018),
      body: Row(
        children: [
          if (wide)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/branding/splash.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(color: Color(0xFF071018)),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF071018).withValues(alpha: 0.35),
                          const Color(0xFF071018).withValues(alpha: 0.92),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(48),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Text(
                          'Giữ tiếng dân tộc bằng câu đã duyệt và mô hình sẵn sàng phục vụ.',
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 24,
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/');
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const BrandLogo(size: 56, radius: 14),
                      const SizedBox(height: 20),
                      Text(
                        _register ? l10n.register : l10n.login,
                        style: GoogleFonts.beVietnamPro(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _register
                            ? 'Tạo tài khoản để góp câu và đồng bộ tiến độ học.'
                            : 'Đăng nhập để dịch, học và đóng góp ngữ liệu.',
                        style: GoogleFonts.beVietnamPro(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),
                      GoogleSignInButton(
                        loading: _googleLoading,
                        onPressed: _loading ? null : _google,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white.withValues(alpha: 0.14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'hoặc email',
                              style: GoogleFonts.beVietnamPro(
                                color: Colors.white.withValues(alpha: 0.45),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white.withValues(alpha: 0.14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      AuthTextField(
                        controller: _email,
                        label: l10n.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      AuthTextField(
                        controller: _password,
                        label: l10n.password,
                        obscure: true,
                      ),
                      if (_register) ...[
                        const SizedBox(height: 12),
                        AuthTextField(controller: _name, label: l10n.displayName),
                      ],
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: (_loading || _googleLoading)
                              ? null
                              : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _loading
                                ? l10n.loading
                                : (_register ? l10n.register : l10n.login),
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: (_loading || _googleLoading)
                            ? null
                            : () => setState(() => _register = !_register),
                        child: Text(
                          _register ? l10n.haveAccount : l10n.needAccount,
                          style: GoogleFonts.beVietnamPro(
                            color: const Color(0xFFC4A35A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final l10n = AppLocalizations.of(context);
    final result = await ref.read(authViewModelProvider.notifier).submitEmail(
          register: _register,
          email: _email.text.trim(),
          password: _password.text,
          displayName: _name.text.trim(),
          successLoginLabel: l10n.login,
          successRegisterLabel: l10n.register,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.ok) {
      showAppSnack(context, result.message!, tone: AppFeedbackTone.success);
      context.go('/translate');
      return;
    }
    await showAppAlert(
      context,
      title: l10n.account,
      message: result.error!,
      tone: AppFeedbackTone.error,
    );
  }

  Future<void> _google() async {
    setState(() => _googleLoading = true);
    final result = await ref.read(authViewModelProvider.notifier).submitGoogle(
          emailFallback: _email.text.trim(),
        );
    if (!mounted) return;
    setState(() => _googleLoading = false);
    if (result.ok) {
      showAppSnack(context, result.message!, tone: AppFeedbackTone.success);
      context.go('/translate');
      return;
    }
    await showAppAlert(
      context,
      title: 'Google',
      message: result.error!,
      tone: AppFeedbackTone.error,
    );
  }
}
