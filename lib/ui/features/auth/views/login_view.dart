import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../data/wiring.dart';
import '../../../core/app_feedback.dart';
import '../../../core/brand_assets.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _register = false;
  bool _loading = false;

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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.account)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          BrandMarkRow(
            title: l10n.appTitle,
            subtitle: _register ? l10n.register : l10n.login,
            logoSize: 56,
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.email),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.password),
          ),
          if (_register) ...[
            const SizedBox(height: 12),
            TextField(controller: _name, decoration: InputDecoration(labelText: l10n.displayName)),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: Text(_loading ? l10n.loading : (_register ? l10n.register : l10n.login)),
          ),
          TextButton(
            onPressed: () => setState(() => _register = !_register),
            child: Text(_register ? l10n.haveAccount : l10n.needAccount),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final api = ref.read(apiClientProvider);
    try {
      final tokens = _register
          ? await api.guard(api.register(_email.text.trim(), _password.text, _name.text.trim()))
          : await api.guard(api.login(_email.text.trim(), _password.text));
      await ref.read(tokenStoreProvider).save(tokens);
      if (!mounted) return;
      showAppSnack(context, l10nSuccess(), tone: AppFeedbackTone.success);
      context.pop();
    } catch (error) {
      if (!mounted) return;
      await showAppAlert(
        context,
        title: AppLocalizations.of(context).account,
        message: error.toString(),
        tone: AppFeedbackTone.error,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String l10nSuccess() {
    final l10n = AppLocalizations.of(context);
    return _register ? l10n.register : l10n.login;
  }
}
