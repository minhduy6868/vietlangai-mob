import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class IntroVideoPanel extends StatefulWidget {
  const IntroVideoPanel({super.key});

  @override
  State<IntroVideoPanel> createState() => _IntroVideoPanelState();
}

class _IntroVideoPanelState extends State<IntroVideoPanel> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    final controller = VideoPlayerController.asset(
      'assets/branding/ngonsacviet-intro.mp4',
    );
    _controller = controller;
    controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          controller
            ..setLooping(true)
            ..setVolume(0)
            ..play();
          setState(() {});
        })
        .catchError((_) {
          if (mounted) setState(() => _failed = true);
        });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 960;
    final controller = _controller;

    return ColoredBox(
      color: const Color(0xFF0B141C),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * (wide ? 0.92 : 1.05),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 72 : 22,
            vertical: wide ? 72 : 48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Giới thiệu Ngôn Sắc Việt',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: wide ? 40 : 28,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Đoạn phim ngắn do Grok Imagine dựng từ ảnh thương hiệu — không chữ, chỉ không khí cao nguyên.',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ColoredBox(
                    color: Colors.black,
                    child:
                        _failed ||
                            controller == null ||
                            !controller.value.isInitialized
                        ? Image.asset(
                            'assets/branding/splash.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.expand(),
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: controller.value.size.width,
                                  height: controller.value.size.height,
                                  child: VideoPlayer(controller),
                                ),
                              ),
                              Positioned(
                                right: 14,
                                bottom: 14,
                                child: Material(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(999),
                                  child: IconButton(
                                    tooltip: controller.value.volume == 0
                                        ? 'Bật tiếng'
                                        : 'Tắt tiếng',
                                    onPressed: () {
                                      final muted =
                                          controller.value.volume == 0;
                                      controller.setVolume(muted ? 1 : 0);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      controller.value.volume == 0
                                          ? Icons.volume_off_rounded
                                          : Icons.volume_up_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
