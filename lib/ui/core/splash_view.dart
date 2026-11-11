import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import 'app_theme.dart';
import 'brand_assets.dart';

/// Full-bleed branded splash for cold start.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _rise;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _rise = Tween<double>(begin: 16, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF8F5EE),
                  Color(0xFFF3E8DF),
                  Color(0xFFE9D3C8),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/branding/splash.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fade.value,
                  child: Transform.translate(
                    offset: Offset(0, _rise.value),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    const BrandLogo(size: 108, radius: 28),
                    const SizedBox(height: 28),
                    Text(
                      l10n.appTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryColor,
                            letterSpacing: -0.6,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Dịch · Học · Di sản tiếng dân tộc',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF5C463F),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tày · Ê Đê · Chăm · H\'Mông · Jrai',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF7A5F55),
                          ),
                    ),
                    const Spacer(flex: 3),
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đang khởi động…',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF7A5F55),
                          ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
