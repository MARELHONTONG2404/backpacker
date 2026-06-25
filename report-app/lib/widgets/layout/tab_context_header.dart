import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../app_animations.dart';
import '../glass_surface.dart';

class TabContextHeader extends StatelessWidget {
  const TabContextHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.embedded = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return EntranceFadeSlide(
      child: Container(
        margin: embedded ? EdgeInsets.zero : const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.16),
              color.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppDecorations.cardShadow(elevation: 0.3),
        ),
        child: GlassSurface(
          blur: false,
          borderRadius: AppLayout.cardRadius,
          opacity: 0.94,
          padding: const EdgeInsets.all(14),
          borderColor: color.withValues(alpha: 0.25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0.08)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
