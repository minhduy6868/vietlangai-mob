import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'app_feedback.dart';

class SpeechPlayButton extends StatefulWidget {
  const SpeechPlayButton({
    required this.buildUrl,
    this.compact = true,
    this.enabled = true,
    this.tooltip = 'Nghe phát âm',
    this.label = 'Nghe phát âm',
    this.playingLabel = 'Dừng đọc',
    super.key,
  });

  final String Function() buildUrl;
  final bool compact;
  final bool enabled;
  final String tooltip;
  final String label;
  final String playingLabel;

  @override
  State<SpeechPlayButton> createState() => _SpeechPlayButtonState();
}

class _SpeechPlayButtonState extends State<SpeechPlayButton> {
  static _SpeechPlayButtonState? _activeState;

  VideoPlayerController? _controller;
  bool _loading = false;
  bool _playing = false;
  String? _loadedUrl;

  @override
  void dispose() {
    if (_activeState == this) {
      _activeState = null;
    }
    _disposeController();
    super.dispose();
  }

  void _disposeController() {
    final ctrl = _controller;
    _controller = null;
    _loadedUrl = null;
    if (ctrl != null) {
      ctrl.removeListener(_onPlayerUpdate);
      ctrl.dispose();
    }
  }

  void _onPlayerUpdate() {
    final ctrl = _controller;
    if (ctrl == null || !mounted) return;
    final val = ctrl.value;
    if (!val.isInitialized) return;
    if (val.isCompleted && _playing) {
      setState(() => _playing = false);
      if (_activeState == this) {
        _activeState = null;
      }
    }
  }

  Future<void> _stopPlayback() async {
    final ctrl = _controller;
    if (ctrl != null && ctrl.value.isInitialized && ctrl.value.isPlaying) {
      await ctrl.pause();
      await ctrl.seekTo(Duration.zero);
    }
    if (mounted) {
      setState(() {
        _loading = false;
        _playing = false;
      });
    }
    if (_activeState == this) {
      _activeState = null;
    }
  }

  Future<void> _togglePlay() async {
    if (!widget.enabled) return;
    if (_playing || _loading) {
      await _stopPlayback();
      return;
    }

    if (_activeState != null && _activeState != this) {
      await _activeState!._stopPlayback();
    }

    final url = widget.buildUrl();
    if (url.isEmpty) return;

    setState(() => _loading = true);
    try {
      if (_controller == null || _loadedUrl != url) {
        _disposeController();
        final ctrl = VideoPlayerController.networkUrl(Uri.parse(url));
        _controller = ctrl;
        _loadedUrl = url;
        ctrl.addListener(_onPlayerUpdate);
        await ctrl.initialize();
      } else {
        await _controller!.seekTo(Duration.zero);
      }
      if (!mounted) return;
      _activeState = this;
      await _controller!.setVolume(1.0);
      await _controller!.play();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _playing = true;
      });
    } catch (_) {
      _disposeController();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _playing = false;
      });
      showAppSnack(
        context,
        'Không phát được âm thanh đọc câu này.',
        tone: AppFeedbackTone.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = _playing || _loading;

    if (widget.compact) {
      return IconButton(
        visualDensity: VisualDensity.compact,
        tooltip: active ? widget.playingLabel : widget.tooltip,
        onPressed: widget.enabled ? _togglePlay : null,
        icon: _loading
            ? SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              )
            : Icon(
                _playing
                    ? Icons.stop_circle_outlined
                    : Icons.volume_up_rounded,
                size: 20,
                color: _playing
                    ? theme.colorScheme.primary
                    : null,
              ),
      );
    }

    return OutlinedButton.icon(
      onPressed: widget.enabled ? _togglePlay : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: active ? Colors.white : theme.colorScheme.primary,
        backgroundColor: active
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withValues(alpha: 0.08),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: active ? 1 : 0.3),
        ),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      icon: _loading
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: active ? Colors.white : theme.colorScheme.primary,
              ),
            )
          : Icon(
              _playing ? Icons.stop_circle_outlined : Icons.volume_up_rounded,
              size: 16,
            ),
      label: Text(
        _loading ? 'Đang tải âm...' : (_playing ? widget.playingLabel : widget.label),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
