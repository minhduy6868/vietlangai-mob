import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../widgets/intro_video.dart';

/// Marketing site for Ngôn Sắc Việt — lacquer-ink business identity.
class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView>
    with TickerProviderStateMixin {
  final _scroll = ScrollController();
  late final AnimationController _enter;
  late final AnimationController _kenBurns;
  late final Animation<double> _brandOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _ctaOpacity;

  double _parallax = 0;

  static const _ink = Color(0xFF071018);
  static const _lacquer = Color(0xFFB91C2C);
  static const _gold = Color(0xFFC4A35A);
  static const _mist = Color(0xFFD7DCE3);
  static const _stone = Color(0xFFF2F4F7);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _kenBurns = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _brandOpacity = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
    );
    _titleOpacity = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.18, 0.55, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _enter,
            curve: const Interval(0.18, 0.62, curve: Curves.easeOutCubic),
          ),
        );
    _ctaOpacity = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.48, 0.85, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (reduce) {
        _enter.value = 1;
        _kenBurns.stop();
      } else {
        _enter.forward();
      }
    });
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    setState(() => _parallax = _scroll.offset * 0.28);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _enter.dispose();
    _kenBurns.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 980;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: _ink,
      body: CustomScrollView(
        controller: _scroll,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: height,
              child: _Hero(
                wide: wide,
                brandOpacity: _brandOpacity,
                titleOpacity: _titleOpacity,
                titleSlide: _titleSlide,
                ctaOpacity: _ctaOpacity,
                kenBurns: _kenBurns,
                parallax: _parallax,
                title: l10n.appTitle,
                ink: _ink,
                lacquer: _lacquer,
                gold: _gold,
                mist: _mist,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: IntroVideoPanel()),
          SliverToBoxAdapter(
            child: _AuthBand(
              lacquer: _lacquer,
              ink: _ink,
              mist: _mist,
              gold: _gold,
            ),
          ),
          SliverToBoxAdapter(
            child: _LanguagesBand(
              stone: _stone,
              ink: _ink,
              lacquer: _lacquer,
              gold: _gold,
            ),
          ),
          SliverToBoxAdapter(
            child: _FlowSection(
              ink: _ink,
              mist: _mist,
              lacquer: _lacquer,
              gold: _gold,
            ),
          ),
          SliverToBoxAdapter(
            child: _TrustMoment(ink: _ink, gold: _gold, mist: _mist),
          ),
          SliverToBoxAdapter(
            child: _CloseCta(
              title: l10n.appTitle,
              ink: _ink,
              lacquer: _lacquer,
              mist: _mist,
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.wide,
    required this.brandOpacity,
    required this.titleOpacity,
    required this.titleSlide,
    required this.ctaOpacity,
    required this.kenBurns,
    required this.parallax,
    required this.title,
    required this.ink,
    required this.lacquer,
    required this.gold,
    required this.mist,
  });

  final bool wide;
  final Animation<double> brandOpacity;
  final Animation<double> titleOpacity;
  final Animation<Offset> titleSlide;
  final Animation<double> ctaOpacity;
  final AnimationController kenBurns;
  final double parallax;
  final String title;
  final Color ink;
  final Color lacquer;
  final Color gold;
  final Color mist;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.translate(
          offset: Offset(0, parallax),
          child: AnimatedBuilder(
            animation: kenBurns,
            builder: (context, child) {
              final t = kenBurns.value;
              final scale = 1.08 + (t * 0.06);
              return Transform.scale(
                scale: scale,
                alignment: Alignment(0.15 + t * 0.1, -0.05),
                child: child,
              );
            },
            child: Image.asset(
              'assets/branding/splash.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) =>
                  ColoredBox(color: ink),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ink.withValues(alpha: 0.55),
                ink.withValues(alpha: 0.35),
                lacquer.withValues(alpha: 0.28),
                ink.withValues(alpha: 0.92),
              ],
              stops: const [0, 0.35, 0.7, 1],
            ),
          ),
        ),
        IgnorePointer(
          child: Opacity(
            opacity: 0.07,
            child: CustomPaint(painter: _GrainPainter()),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              wide ? 72 : 22,
              18,
              wide ? 72 : 22,
              wide ? 56 : 36,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: brandOpacity,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                              ),
                            ),
                            child: Image.asset(
                              'assets/branding/app_icon.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 36,
                                    height: 36,
                                    color: lacquer,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.translate_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        title,
                        style: GoogleFonts.beVietnamPro(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      if (wide) ...[
                        TextButton(
                          onPressed: () => context.go('/login'),
                          style: TextButton.styleFrom(foregroundColor: mist),
                          child: Text(
                            'Đăng nhập',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        FilledButton(
                          onPressed: () => context.go('/login?mode=register'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.12,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.28),
                              ),
                            ),
                          ),
                          child: Text(
                            'Tạo tài khoản',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                FadeTransition(
                  opacity: titleOpacity,
                  child: SlideTransition(
                    position: titleSlide,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: wide ? 720 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.beVietnamPro(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: wide ? 72 : 44,
                              height: 0.98,
                              letterSpacing: -2.2,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: 64,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [lacquer, gold]),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Dịch tiếng dân tộc trên trục tiếng Việt — giữ câu đã rà soát, mở rộng bằng mô hình khi sẵn sàng.',
                            style: GoogleFonts.beVietnamPro(
                              color: mist.withValues(alpha: 0.92),
                              fontWeight: FontWeight.w500,
                              fontSize: wide ? 20 : 16,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                FadeTransition(
                  opacity: ctaOpacity,
                  child: Wrap(
                    spacing: 14,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _PrimaryButton(
                        label: 'Bắt đầu dịch',
                        onPressed: () => context.go('/translate'),
                        lacquer: lacquer,
                      ),
                      _GhostButton(
                        label: 'Đăng nhập',
                        onPressed: () => context.go('/login'),
                        mist: mist,
                      ),
                      _GhostButton(
                        label: 'Tạo tài khoản',
                        onPressed: () => context.go('/login?mode=register'),
                        mist: mist,
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: ctaOpacity,
                  child: Text(
                    "Tày  ·  Ê Đê  ·  Chăm  ·  H'Mông  ·  Jrai",
                    style: GoogleFonts.beVietnamPro(
                      color: gold.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthBand extends StatelessWidget {
  const _AuthBand({
    required this.lacquer,
    required this.ink,
    required this.mist,
    required this.gold,
  });

  final Color lacquer;
  final Color ink;
  final Color mist;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return ColoredBox(
      color: const Color(0xFF101820),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: wide ? 72 : 22,
          vertical: wide ? 72 : 48,
        ),
        child: wide
            ? Row(
                children: [
                  Expanded(child: _authCopy(gold, mist)),
                  const SizedBox(width: 40),
                  _authActions(context, lacquer, mist),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _authCopy(gold, mist),
                  const SizedBox(height: 24),
                  _authActions(context, lacquer, mist),
                ],
              ),
      ),
    );
  }

  Widget _authCopy(Color gold, Color mist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tài khoản thành viên',
          style: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 32,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Đăng nhập email/mật khẩu, tạo tài khoản mới, hoặc tiếp tục bằng Google khi Client ID đã cấu hình.',
          style: GoogleFonts.beVietnamPro(
            color: mist.withValues(alpha: 0.72),
            fontSize: 15,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Google Sign-In dùng GOOGLE_CLIENT_ID (web) + GOOGLE_CLIENT_IDS trên API.',
          style: GoogleFonts.beVietnamPro(
            color: gold.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _authActions(BuildContext context, Color lacquer, Color mist) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _PrimaryButton(
          label: 'Đăng nhập',
          onPressed: () => context.go('/login'),
          lacquer: lacquer,
        ),
        _GhostButton(
          label: 'Tạo tài khoản',
          onPressed: () => context.go('/login?mode=register'),
          mist: mist,
        ),
        _GhostButton(
          label: 'Google trên trang đăng nhập',
          onPressed: () => context.go('/login'),
          mist: mist,
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.lacquer,
  });

  final String label;
  final VoidCallback onPressed;
  final Color lacquer;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final scale = _down ? 0.97 : (_hover ? 1.03 : 1.0);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _down = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
            decoration: BoxDecoration(
              color: _hover ? const Color(0xFFD12335) : widget.lacquer,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: widget.lacquer.withValues(alpha: _hover ? 0.45 : 0.25),
                  blurRadius: _hover ? 28 : 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: GoogleFonts.beVietnamPro(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  const _GhostButton({
    required this.label,
    required this.onPressed,
    required this.mist,
  });

  final String label;
  final VoidCallback onPressed;
  final Color mist;

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _hover ? 0.1 : 0.04),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withValues(alpha: _hover ? 0.55 : 0.28),
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.beVietnamPro(
              color: widget.mist,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguagesBand extends StatelessWidget {
  const _LanguagesBand({
    required this.stone,
    required this.ink,
    required this.lacquer,
    required this.gold,
  });

  final Color stone;
  final Color ink;
  final Color lacquer;
  final Color gold;

  static const _langs = [
    ('Tày', 'tyz'),
    ('Ê Đê', 'rad'),
    ('Chăm', 'cjm'),
    ("H'Mông", 'hmn'),
    ('Jrai', 'jra'),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return ColoredBox(
      color: stone,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.92,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 72 : 22,
            vertical: wide ? 88 : 56,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Năm ngôn ngữ.\nMột trục tiếng Việt.',
                style: GoogleFonts.beVietnamPro(
                  color: ink,
                  fontWeight: FontWeight.w900,
                  fontSize: wide ? 48 : 32,
                  height: 1.08,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Anh đi qua tiếng Việt. Không trộn chính tả, không bịa câu dân tộc.',
                style: GoogleFonts.beVietnamPro(
                  color: ink.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              for (var i = 0; i < _langs.length; i++) ...[
                if (i > 0)
                  Divider(height: 1, color: ink.withValues(alpha: 0.1)),
                _LangRow(
                  name: _langs[i].$1,
                  code: _langs[i].$2,
                  ink: ink,
                  accent: i.isEven ? lacquer : gold,
                  wide: wide,
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangRow extends StatefulWidget {
  const _LangRow({
    required this.name,
    required this.code,
    required this.ink,
    required this.accent,
    required this.wide,
  });

  final String name;
  final String code;
  final Color ink;
  final Color accent;
  final bool wide;

  @override
  State<_LangRow> createState() => _LangRowState();
}

class _LangRowState extends State<_LangRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(_hover ? 10 : 0, 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: _hover ? 28 : 14,
              height: 2,
              color: widget.accent,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.name,
                style: GoogleFonts.beVietnamPro(
                  color: widget.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: widget.wide ? 34 : 26,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            Text(
              widget.code,
              style: GoogleFonts.beVietnamPro(
                color: widget.ink.withValues(alpha: 0.35),
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowSection extends StatelessWidget {
  const _FlowSection({
    required this.ink,
    required this.mist,
    required this.lacquer,
    required this.gold,
  });

  final Color ink;
  final Color mist;
  final Color lacquer;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 960;
    final steps = [
      (
        lacquer,
        'Chọn hướng',
        'Dân tộc ↔ Việt là đường chính; Anh chỉ đi qua tiếng Việt.',
      ),
      (
        gold,
        'Dịch có kiểm',
        'Cặp đã duyệt lấy từ glossary. Câu tự do dùng neural khi mô hình sẵn sàng.',
      ),
      (
        const Color(0xFF2A7A62),
        'Góp & học',
        'Cộng đồng gửi câu đã kiểm; học liệu gắn di sản từng ngôn ngữ.',
      ),
    ];

    return ColoredBox(
      color: ink,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * (wide ? 0.95 : 1.35),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 72 : 22,
            vertical: wide ? 88 : 56,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ba bước rõ ràng',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: wide ? 44 : 30,
                  letterSpacing: -1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Từ câu nguồn đến bản dịch có nguồn gốc — không vòng vo.',
                style: GoogleFonts.beVietnamPro(
                  color: mist.withValues(alpha: 0.72),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      if (i > 0)
                        Container(
                          width: 1,
                          height: 180,
                          margin: const EdgeInsets.symmetric(horizontal: 28),
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      Expanded(
                        child: _FlowStep(
                          color: steps[i].$1,
                          title: steps[i].$2,
                          body: steps[i].$3,
                          mist: mist,
                        ),
                      ),
                    ],
                  ],
                )
              else
                Column(
                  children: [
                    for (final step in steps) ...[
                      _FlowStep(
                        color: step.$1,
                        title: step.$2,
                        body: step.$3,
                        mist: mist,
                      ),
                      const SizedBox(height: 28),
                    ],
                  ],
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowStep extends StatelessWidget {
  const _FlowStep({
    required this.color,
    required this.title,
    required this.body,
    required this.mist,
  });

  final Color color;
  final String title;
  final String body;
  final Color mist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 36, height: 3, color: color),
        const SizedBox(height: 18),
        Text(
          title,
          style: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: GoogleFonts.beVietnamPro(
            color: mist.withValues(alpha: 0.74),
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _TrustMoment extends StatelessWidget {
  const _TrustMoment({
    required this.ink,
    required this.gold,
    required this.mist,
  });

  final Color ink;
  final Color gold;
  final Color mist;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return ColoredBox(
      color: const Color(0xFF101820),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.88,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 72 : 22,
            vertical: 64,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Niềm tin từ ngữ liệu',
                style: GoogleFonts.beVietnamPro(
                  color: gold,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Text(
                  'Không bịa câu tiếng dân tộc. Bản đưa vào mô hình phải verified hoặc approved.',
                  style: GoogleFonts.beVietnamPro(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: wide ? 42 : 28,
                    height: 1.2,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  "Chữ Chăm Akhar Thrah và chính tả H'Mông trong nước được tách lớp riêng — không trộn RPA hải ngoại.",
                  style: GoogleFonts.beVietnamPro(
                    color: mist.withValues(alpha: 0.7),
                    fontSize: 16,
                    height: 1.55,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseCta extends StatelessWidget {
  const _CloseCta({
    required this.title,
    required this.ink,
    required this.lacquer,
    required this.mist,
  });

  final String title;
  final Color ink;
  final Color lacquer;
  final Color mist;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return ColoredBox(
      color: ink,
      child: Padding(
        padding: EdgeInsets.fromLTRB(wide ? 72 : 22, 88, wide ? 72 : 22, 48),
        child: Column(
          children: [
            Text(
              'Bắt đầu với $title',
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: wide ? 40 : 28,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Đăng nhập, tạo tài khoản, hoặc mở ứng dụng dịch ngay.',
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                color: mist.withValues(alpha: 0.7),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _PrimaryButton(
                  label: 'Bắt đầu dịch',
                  onPressed: () => context.go('/translate'),
                  lacquer: lacquer,
                ),
                _GhostButton(
                  label: 'Đăng nhập',
                  onPressed: () => context.go('/login'),
                  mist: mist,
                ),
                _GhostButton(
                  label: 'Tạo tài khoản',
                  onPressed: () => context.go('/login?mode=register'),
                  mist: mist,
                ),
              ],
            ),
            const SizedBox(height: 56),
            Text(
              '© ${DateTime.now().year} $title',
              style: GoogleFonts.beVietnamPro(
                color: Colors.white.withValues(alpha: 0.28),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final rng = math.Random(7);
    for (var i = 0; i < 900; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawRect(Rect.fromLTWH(x, y, 1.1, 1.1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
