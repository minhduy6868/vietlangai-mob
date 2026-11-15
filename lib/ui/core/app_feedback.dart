import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'brand_assets.dart';

/// Shared mobile feedback: snackbars, alerts, confirms.
enum AppFeedbackTone { info, success, warning, error }

Color _toneColor(BuildContext context, AppFeedbackTone tone) {
  final scheme = Theme.of(context).colorScheme;
  return switch (tone) {
    AppFeedbackTone.info => scheme.primary,
    AppFeedbackTone.success => AppTheme.accentJade,
    AppFeedbackTone.warning => AppTheme.accentAmber,
    AppFeedbackTone.error => scheme.error,
  };
}

IconData _toneIcon(AppFeedbackTone tone) {
  return switch (tone) {
    AppFeedbackTone.info => Icons.info_outline_rounded,
    AppFeedbackTone.success => Icons.check_circle_outline_rounded,
    AppFeedbackTone.warning => Icons.warning_amber_rounded,
    AppFeedbackTone.error => Icons.error_outline_rounded,
  };
}

void showAppSnack(
  BuildContext context,
  String message, {
  AppFeedbackTone tone = AppFeedbackTone.info,
  Duration duration = const Duration(seconds: 3),
}) {
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(_toneIcon(tone), color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: duration,
      backgroundColor: _toneColor(context, tone),
    ),
  );
}

Future<void> showAppAlert(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Đã hiểu',
  AppFeedbackTone tone = AppFeedbackTone.info,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Row(
        children: [
          const BrandLogo(size: 36, radius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_toneIcon(tone), color: _toneColor(context, tone), size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(message, style: const TextStyle(height: 1.4))),
            ],
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

Future<bool> showAppConfirm(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Xác nhận',
  String cancelLabel = 'Hủy',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Row(
        children: [
          const BrandLogo(size: 36, radius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: Text(message, style: const TextStyle(height: 1.4)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
