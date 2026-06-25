import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_palette.dart';
import '../theme/app_theme.dart';
import 'app_animations.dart';

/// Judul brand "Backpacker" dengan animasi shimmer & badge petualangan.
class BackpackerBrandTitle extends StatelessWidget {
  const BackpackerBrandTitle({
    super.key,
    this.compact = false,
    this.light = false,
    this.showSubtitle = true,
    this.showLogo = true,
    this.logoSize,
  });

  final bool compact;
  final bool light;
  final bool showSubtitle;
  final bool showLogo;
  final double? logoSize;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final titleColor = light ? Colors.white : palette.textPrimary;
    final subtitleColor = light ? Colors.white.withValues(alpha: 0.88) : AppColors.primary;
    final resolvedLogoSize = logoSize ?? (compact ? 36 : 72);

    final titleColumn = Column(
      crossAxisAlignment: compact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerBrandText(
          text: l10n.appName,
          style: (compact
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context).textTheme.headlineMedium)
              ?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w800,
            letterSpacing: compact ? -0.2 : -0.8,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 2),
          Text(
            l10n.appSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: subtitleColor,
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: compact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (!compact && showLogo) ...[
          AnimatedBrandLogo(size: resolvedLogoSize),
          const SizedBox(height: 16),
          titleColumn,
          if (showSubtitle) ...[
            const SizedBox(height: 8),
            JourneyTrailBar(height: 3, width: 120, light: light),
          ],
        ] else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLogo) ...[
                AnimatedBrandLogo(size: resolvedLogoSize),
                const SizedBox(width: 10),
              ],
              Flexible(child: titleColumn),
            ],
          ),
      ],
    );
  }
}

/// Teks brand dengan efek shimmer gradasi petualangan.
class ShimmerBrandText extends StatefulWidget {
  const ShimmerBrandText({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  State<ShimmerBrandText> createState() => _ShimmerBrandTextState();
}

class _ShimmerBrandTextState extends State<ShimmerBrandText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(_controller.value * 2, 0),
              colors: const [
                AppColors.trail,
                AppColors.primary,
                AppColors.sand,
                AppColors.primary,
                AppColors.trail,
              ],
              stops: const [0, 0.25, 0.5, 0.75, 1],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: child,
        );
      },
      child: Text(widget.text, style: widget.style),
    );
  }
}

/// Garis jejak perjalanan animasi — simbol "backpacker on the move".
class JourneyTrailBar extends StatefulWidget {
  const JourneyTrailBar({
    super.key,
    this.width = double.infinity,
    this.height = 4,
    this.light = false,
  });

  final double width;
  final double height;
  final bool light;

  @override
  State<JourneyTrailBar> createState() => _JourneyTrailBarState();
}

class _JourneyTrailBarState extends State<JourneyTrailBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height + 16,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _JourneyTrailPainter(
              progress: _controller.value,
              light: widget.light,
              barHeight: widget.height,
            ),
          );
        },
      ),
    );
  }
}

class _JourneyTrailPainter extends CustomPainter {
  _JourneyTrailPainter({
    required this.progress,
    required this.light,
    required this.barHeight,
  });

  final double progress;
  final bool light;
  final double barHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final path = Path();
    path.moveTo(0, y);
    for (var x = 0.0; x <= size.width; x += 4) {
      path.lineTo(x, y + math.sin((x / size.width) * math.pi * 3) * 3);
    }

    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = barHeight
      ..strokeCap = StrokeCap.round
      ..color = (light ? Colors.white : AppColors.primary).withValues(alpha: 0.2);
    canvas.drawPath(path, trailPaint);

    final metrics = path.computeMetrics().first;
    final walkerPos = metrics.length * progress;
    final tangent = metrics.getTangentForOffset(walkerPos);
    if (tangent != null) {
      final glow = Paint()
        ..color = (light ? Colors.white : AppColors.primary).withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(tangent.position, 10, glow);

      final iconPaint = Paint()..color = light ? Colors.white : AppColors.primary;
      canvas.drawCircle(tangent.position, 5, iconPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _JourneyTrailPainter old) => old.progress != progress;
}

/// Badge kecil "Backpacker" untuk kartu & header.
class BackpackerBadge extends StatelessWidget {
  const BackpackerBadge({super.key, this.light = false});

  final bool light;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: light ? null : AppColors.brandGradient,
        color: light ? Colors.white.withValues(alpha: 0.18) : null,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: light ? Colors.white.withValues(alpha: 0.35) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.backpack_outlined,
            size: 12,
            color: light ? Colors.white : Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            l10n.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dekorasi jejak mengambang di belakang hero/kartu.
class FloatingTrailDecoration extends StatefulWidget {
  const FloatingTrailDecoration({super.key, this.opacity = 0.12});

  final double opacity;

  @override
  State<FloatingTrailDecoration> createState() => _FloatingTrailDecorationState();
}

class _FloatingTrailDecorationState extends State<FloatingTrailDecoration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _FloatingTrailPainter(
            progress: _controller.value,
            opacity: widget.opacity,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _FloatingTrailPainter extends CustomPainter {
  _FloatingTrailPainter({required this.progress, required this.opacity});

  final double progress;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 4; i++) {
      final phase = progress + i * 0.25;
      final x = size.width * (0.12 + i * 0.22) + math.sin(phase * math.pi * 2) * 14;
      final y = size.height * (0.25 + (i % 2) * 0.45) + math.cos(phase * math.pi * 2) * 18;
      canvas.drawCircle(
        Offset(x, y),
        4 + math.sin(phase * math.pi * 2) * 2,
        Paint()..color = Colors.white.withValues(alpha: opacity * (0.4 + i * 0.12)),
      );
    }

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * (0.3 + math.sin(progress * math.pi * 2) * 0.08),
      size.width,
      size.height * 0.55,
    );
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: opacity * 1.5);
    _drawDashedPath(canvas, path, dashPaint, dashLength: 6, gap: 5, phase: progress * 20);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint,
      {required double dashLength, required double gap, required double phase}) {
    for (final metric in path.computeMetrics()) {
      var distance = -phase;
      while (distance < metric.length) {
        final start = metric.getTangentForOffset(math.max(0, distance));
        final end = metric.getTangentForOffset(math.min(metric.length, distance + dashLength));
        if (start != null && end != null && distance >= 0) {
          canvas.drawLine(start.position, end.position, paint);
        }
        distance += dashLength + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingTrailPainter old) => old.progress != progress;
}
