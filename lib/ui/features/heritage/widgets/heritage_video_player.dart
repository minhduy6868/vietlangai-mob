import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeritageVideoPlayer extends StatefulWidget {
  const HeritageVideoPlayer({required this.url, super.key});

  final String url;

  @override
  State<HeritageVideoPlayer> createState() => _HeritageVideoPlayerState();
}

class _HeritageVideoPlayerState extends State<HeritageVideoPlayer> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant HeritageVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _controller?.dispose();
      _failed = false;
      _initController();
    }
  }

  void _initController() {
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller = controller;
    controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          controller.setLooping(true);
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
    final theme = Theme.of(context);
    final controller = _controller;

    if (_failed) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_off_outlined, size: 36),
              SizedBox(height: 8),
              Text('Không phát được video trên thiết bị này'),
            ],
          ),
        ),
      );
    }

    if (controller == null || !controller.value.isInitialized) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final ratio = controller.value.aspectRatio > 0 ? controller.value.aspectRatio : 16 / 9;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: ColoredBox(
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: ratio.clamp(0.75, 2.2),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayer(controller),
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                        setState(() {});
                      },
                      child: AnimatedOpacity(
                        opacity: controller.value.isPlaying ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(999),
                          child: IconButton(
                            iconSize: 18,
                            constraints: const BoxConstraints.tightFor(width: 34, height: 34),
                            padding: EdgeInsets.zero,
                            tooltip: controller.value.volume == 0 ? 'Bật tiếng' : 'Tắt tiếng',
                            onPressed: () {
                              controller.setVolume(controller.value.volume == 0 ? 1 : 0);
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              colors: VideoProgressColors(
                playedColor: theme.colorScheme.primary,
                bufferedColor: Colors.white30,
                backgroundColor: Colors.white12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
