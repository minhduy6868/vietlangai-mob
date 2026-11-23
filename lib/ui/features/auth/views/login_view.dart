import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../data/wiring.dart';
import '../../../core/app_feedback.dart';
import '../../../core/app_theme.dart';
import '../auth_validation.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/auth_form_widgets.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({this.initialRegister = false, super.key});

  final bool initialRegister;

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _name = TextEditingController();
  final _emailFocus = FocusNode();

  late bool _register;
  bool _loading = false;
  bool _googleLoading = false;
  bool _remember = true;
  bool _acceptedTerms = false;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _nameError;
  String? _termsError;

  late final AnimationController _bgMotion;

  @override
  void initState() {
    super.initState();
    _register = widget.initialRegister;
    _bgMotion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant LoginView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRegister != widget.initialRegister) {
      setState(() => _register = widget.initialRegister);
    }
  }

  @override
  void dispose() {
    _bgMotion.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _name.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _switchMode(bool register) {
    if (_register == register || _loading || _googleLoading) return;
    setState(() {
      _register = register;
      _emailError = null;
      _passwordError = null;
      _confirmError = null;
      _nameError = null;
      _termsError = null;
    });
    // Keep URL in sync with hash routes from landing.
    context.go(register ? '/register' : '/login');
  }

  bool _validate() {
    final emailError = AuthValidation.email(_email.text);
    final passwordError = AuthValidation.password(
      _password.text,
      requireStrong: _register,
    );
    final nameError =
        _register ? AuthValidation.displayName(_name.text) : null;
    final confirmError = _register
        ? AuthValidation.confirmPassword(_password.text, _confirm.text)
        : null;
    final termsError =
        _register ? AuthValidation.termsAccepted(_acceptedTerms) : null;

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
      _nameError = nameError;
      _confirmError = confirmError;
      _termsError = termsError;
    });

    return emailError == null &&
        passwordError == null &&
        nameError == null &&
        confirmError == null &&
        termsError == null;
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 920;
    final busy = _loading || _googleLoading;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _bgMotion,
            builder: (context, child) {
              final t = Curves.easeInOut.transform(_bgMotion.value);
              return Transform.scale(
                scale: 1.06 + (t * 0.04),
                child: Transform.translate(
                  offset: Offset(t * -12, t * -6),
                  child: child,
                ),
              );
            },
            child: Image.asset(
              'assets/branding/auth-backdrop.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/branding/splash.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const ColoredBox(color: Color(0xFFF8F5EF)),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0x66F8F5EF),
                  Color(0x33F8F5EF),
                  Color(0x88F8F5EF),
                ],
              ),
            ),
          ),
          // Soft cultural ribbon accent (bottom-left)
          Positioned(
            left: -40,
            bottom: -20,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: 220,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.88),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 40 : 20,
                vertical: wide ? 28 : 16,
              ),
              child: Row(
                children: [
                  if (wide)
                    Expanded(
                      flex: 11,
                      child: _BrandPanel(
                        onBack: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/translate');
                          }
                        },
                      ),
                    ),
                  if (wide) const SizedBox(width: 28),
                  Expanded(
                    flex: wide ? 9 : 1,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: _AuthCard(
                          register: _register,
                          busy: busy,
                          loading: _loading,
                          googleLoading: _googleLoading,
                          remember: _remember,
                          acceptedTerms: _acceptedTerms,
                          email: _email,
                          password: _password,
                          confirm: _confirm,
                          name: _name,
                          emailFocus: _emailFocus,
                          emailError: _emailError,
                          passwordError: _passwordError,
                          confirmError: _confirmError,
                          nameError: _nameError,
                          termsError: _termsError,
                          showBack: !wide,
                          onBack: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/translate');
                            }
                          },
                          onRemember: (v) =>
                              setState(() => _remember = v ?? true),
                          onTerms: (v) => setState(() {
                            _acceptedTerms = v ?? false;
                            _termsError = null;
                          }),
                          onSwitch: _switchMode,
                          onSubmit: _submit,
                          onGoogle: _google,
                          onFocusEmail: () => _emailFocus.requestFocus(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    final l10n = AppLocalizations.of(context);
    final result = await ref.read(authViewModelProvider.notifier).submitEmail(
          register: _register,
          email: _email.text.trim(),
          password: _password.text,
          displayName: _name.text.trim(),
          successLoginLabel: 'Đăng nhập thành công',
          successRegisterLabel: 'Đăng ký thành công',
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.ok) {
      if (!_register && !_remember) {
        await ref.read(tokenStoreProvider).clearRefresh();
      }
      if (!mounted) return;
      showAppSnack(context, result.message!, tone: AppFeedbackTone.success);
      context.go('/translate');
      return;
    }
    if (!mounted) return;
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

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: onBack,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.72),
              ),
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2A1C18)),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/branding/logo-mark.svg',
              width: 72,
              height: 72,
            ),
            const SizedBox(height: 18),
            Text(
              'Ngôn Sắc Việt',
              style: GoogleFonts.literata(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryColor,
                height: 1.05,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '— Gìn giữ tiếng nói, kết nối văn hóa —',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentAmber,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cùng nhau bảo tồn và lan tỏa những giá trị ngôn ngữ '
              'quý báu của các dân tộc Việt Nam.',
              style: GoogleFonts.beVietnamPro(
                fontSize: 15.5,
                height: 1.55,
                color: const Color(0xFF3D2C28),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.register,
    required this.busy,
    required this.loading,
    required this.googleLoading,
    required this.remember,
    required this.acceptedTerms,
    required this.email,
    required this.password,
    required this.confirm,
    required this.name,
    required this.emailFocus,
    required this.emailError,
    required this.passwordError,
    required this.confirmError,
    required this.nameError,
    required this.termsError,
    required this.showBack,
    required this.onBack,
    required this.onRemember,
    required this.onTerms,
    required this.onSwitch,
    required this.onSubmit,
    required this.onGoogle,
    required this.onFocusEmail,
  });

  final bool register;
  final bool busy;
  final bool loading;
  final bool googleLoading;
  final bool remember;
  final bool acceptedTerms;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirm;
  final TextEditingController name;
  final FocusNode emailFocus;
  final String? emailError;
  final String? passwordError;
  final String? confirmError;
  final String? nameError;
  final String? termsError;
  final bool showBack;
  final VoidCallback onBack;
  final ValueChanged<bool?> onRemember;
  final ValueChanged<bool?> onTerms;
  final ValueChanged<bool> onSwitch;
  final VoidCallback onSubmit;
  final VoidCallback onGoogle;
  final VoidCallback onFocusEmail;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.96),
      elevation: 18,
      shadowColor: const Color(0x55000000),
      borderRadius: BorderRadius.circular(22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final offset = Tween<Offset>(
                begin: Offset(register ? 0.08 : -0.08, 0),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offset, child: child),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(register ? 'register' : 'login'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showBack)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: onBack,
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                      Text(
                        register ? 'Đăng ký' : 'Đăng nhập',
                        style: GoogleFonts.literata(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryColor,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        register
                            ? 'Tạo tài khoản để góp câu, học và đồng bộ tiến độ trên Ngôn Sắc Việt.'
                            : 'Chào mừng bạn trở lại! Hãy đăng nhập để tiếp tục hành trình khám phá ngôn ngữ Việt.',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13.5,
                          height: 1.45,
                          color: const Color(0xFF6D5C54),
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (register) ...[
                        AuthLightField(
                          controller: name,
                          label: 'Họ và tên',
                          hint: 'Nhập họ và tên',
                          prefixIcon: Icons.badge_outlined,
                          errorText: nameError,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 14),
                      ],
                      AuthLightField(
                        controller: email,
                        label: 'Email',
                        hint: 'Nhập email',
                        prefixIcon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        errorText: emailError,
                        focusNode: emailFocus,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),
                      AuthLightField(
                        controller: password,
                        label: 'Mật khẩu',
                        hint: 'Nhập mật khẩu',
                        obscure: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        errorText: passwordError,
                        textInputAction: register
                            ? TextInputAction.next
                            : TextInputAction.done,
                        onSubmitted: (_) {
                          if (!register && !busy) onSubmit();
                        },
                      ),
                      if (register) ...[
                        const SizedBox(height: 14),
                        AuthLightField(
                          controller: confirm,
                          label: 'Xác nhận mật khẩu',
                          hint: 'Nhập lại mật khẩu',
                          obscure: true,
                          prefixIcon: Icons.lock_person_outlined,
                          errorText: confirmError,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            if (!busy) onSubmit();
                          },
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile(
                          value: acceptedTerms,
                          onChanged: busy ? null : onTerms,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppTheme.primaryColor,
                          title: Text(
                            'Tôi đồng ý với điều khoản sử dụng của Ngôn Sắc Việt.',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12.5,
                              height: 1.35,
                              color: const Color(0xFF5A4A44),
                            ),
                          ),
                        ),
                        if (termsError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, bottom: 4),
                            child: Text(
                              termsError!,
                              style: GoogleFonts.beVietnamPro(
                                color: const Color(0xFFD64545),
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ] else ...[
                        const SizedBox(height: 4),
                        CheckboxListTile(
                          value: remember,
                          onChanged: busy ? null : onRemember,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppTheme.primaryColor,
                          title: Text(
                            'Ghi nhớ đăng nhập trên thiết bị này',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12.5,
                              color: const Color(0xFF5A4A44),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          onPressed: busy ? null : onSubmit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            disabledBackgroundColor:
                                AppTheme.primaryColor.withValues(alpha: 0.45),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      register ? 'Đăng ký' : 'Đăng nhập',
                                      style: GoogleFonts.beVietnamPro(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Color(0xFFE6DDD4))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              register
                                  ? 'Hoặc đăng ký với'
                                  : 'Hoặc đăng nhập với',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: const Color(0xFF9A8B84),
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: Color(0xFFE6DDD4))),
                        ],
                      ),
                      const SizedBox(height: 14),
                      GoogleSignInButton(
                        loading: googleLoading,
                        onPressed: busy ? null : onGoogle,
                      ),
                      const SizedBox(height: 10),
                      AuthSocialButton(
                        label: 'Tiếp tục với Email',
                        onPressed: busy ? null : onFocusEmail,
                        leading: const Icon(
                          Icons.mail_outline_rounded,
                          size: 18,
                          color: Color(0xFF6D5C54),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              register
                                  ? 'Đã có tài khoản? '
                                  : 'Chưa có tài khoản? ',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13.5,
                                color: const Color(0xFF6D5C54),
                              ),
                            ),
                            TextButton(
                              onPressed: busy
                                  ? null
                                  : () => onSwitch(!register),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                register ? 'Đăng nhập' : 'Đăng ký ngay',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
