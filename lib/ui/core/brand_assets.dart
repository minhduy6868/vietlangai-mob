import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Shared brand marks for splash, app bar, login and dialogs.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    this.size = 72,
    this.radius = 18,
    super.key,
  });

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        'assets/branding/app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Icon(
            Icons.translate_rounded,
            color: Colors.white,
            size: size * 0.45,
          ),
        ),
      ),
    );
  }
}

class BrandMarkRow extends StatelessWidget {
  const BrandMarkRow({
    required this.title,
    this.subtitle,
    this.logoSize = 40,
    super.key,
  });

  final String title;
  final String? subtitle;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        BrandLogo(size: logoSize, radius: logoSize * 0.28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
