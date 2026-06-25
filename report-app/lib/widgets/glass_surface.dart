import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

/// Panel semi-transparan dengan efek kaca — menyesuaikan mode terang / gelap.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blur = true,
    this.opacity = 0.88,
    this.tint,
    this.borderColor,
    this.elevation = 0,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool blur;
  final double opacity;
  final Color? tint;
  final Color? borderColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final surface = tint ?? palette.surfaceElevated;
    final border = borderColor ?? palette.glassBorder;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? AppDecorations.cardShadow(elevation: elevation, dark: palette.isDark)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: blur
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: _fill(surface, border, child),
              )
            : _fill(surface, border, child),
      ),
    );
  }

  Widget _fill(Color surface, Color border, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
