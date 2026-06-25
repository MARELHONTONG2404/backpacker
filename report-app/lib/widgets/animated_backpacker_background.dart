import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Background animasi — alur tugas marketplace Backpacker (auth & halaman utama).
class AnimatedBackpackerBackground extends StatefulWidget {
  const AnimatedBackpackerBackground({
    super.key,
    this.subtle = false,
    this.night = false,
  });

  /// Mode halaman utama: animasi lebih lembut agar konten tetap terbaca.
  final bool subtle;

  /// Mode gelap untuk halaman utama.
  final bool night;

  @override
  State<AnimatedBackpackerBackground> createState() => _AnimatedBackpackerBackgroundState();
}

class _AnimatedBackpackerBackgroundState extends State<AnimatedBackpackerBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(
                    painter: _BackpackerMeshPainter(
                      progress: t,
                      subtle: widget.subtle,
                      night: widget.night,
                    ),
                  ),
                  if (!widget.subtle) _authOverlay(),
                  ..._floatingIcons(t, constraints),
                  ..._orbitTasks(t, constraints),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _authOverlay() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.05),
            Colors.black.withValues(alpha: 0.28),
          ],
        ),
      ),
    );
  }

  List<Widget> _floatingIcons(double t, BoxConstraints constraints) {
    final specs = [
      (Icons.backpack_rounded, 0.0, 46.0, AppColors.primary),
      (Icons.explore_outlined, 0.18, 38.0, AppColors.trail),
      (Icons.route_outlined, 0.36, 42.0, AppColors.trailLight),
      (Icons.place_outlined, 0.54, 36.0, AppColors.primary),
      (Icons.hiking_outlined, 0.72, 34.0, AppColors.secondary),
      (Icons.star_outline_rounded, 0.88, 32.0, AppColors.sand),
    ];

    return specs.map((spec) {
      final (icon, phase, size, color) = spec;
      final angle = (t + phase) * math.pi * 2;
      final dx = 0.5 + math.cos(angle) * (widget.subtle ? 0.28 : 0.34);
      final dy = 0.5 + math.sin(angle * 0.85 + phase) * (widget.subtle ? 0.22 : 0.3);
      final opacity = widget.subtle
          ? 0.05 + math.sin(angle) * 0.015
          : 0.1 + math.sin(angle) * 0.05;

      return Positioned(
        left: dx * constraints.maxWidth - size / 2,
        top: dy * constraints.maxHeight - size / 2,
        child: Transform.rotate(
          angle: math.sin(angle) * 0.18,
          child: Icon(
            icon,
            size: size,
            color: (widget.subtle ? AppColors.primary : color).withValues(alpha: opacity),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _orbitTasks(double t, BoxConstraints constraints) {
    if (widget.subtle) return const [];

    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final orbitCenters = [
      Offset(w * 0.2, h * 0.22),
      Offset(w * 0.78, h * 0.28),
      Offset(w * 0.82, h * 0.72),
    ];

    return orbitCenters.asMap().entries.map((entry) {
      final i = entry.key;
      final center = entry.value;
      final angle = (t + i * 0.33) * math.pi * 2;
      final radius = 28.0 + i * 8;
      final pos = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius * 0.7);

      return Positioned(
        left: pos.dx - 5,
        top: pos.dy - 5,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (i.isEven ? AppColors.primary : AppColors.secondary).withValues(alpha: 0.75),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _BackpackerMeshPainter extends CustomPainter {
  _BackpackerMeshPainter({
    required this.progress,
    required this.subtle,
    required this.night,
  });

  final double progress;
  final bool subtle;
  final bool night;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBaseGradient(canvas, size);
    _paintAurora(canvas, size);
    _paintBlobs(canvas, size);
    _paintFlowLines(canvas, size);
    _paintNodes(canvas, size);
    if (!subtle) {
      _paintCompass(canvas, size);
      _paintGrid(canvas, size);
      _paintParticles(canvas, size);
    } else {
      _paintSubtleTrail(canvas, size);
    }
  }

  void _paintCompass(Canvas canvas, Size size) {
    final center = Offset(size.width - 56, 56);
    final angle = progress * math.pi * 2;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.18);
    canvas.drawCircle(center, 22, ring);

    final needle = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.sand.withValues(alpha: 0.75);
    final tip = center + Offset(math.cos(angle - math.pi / 2) * 16, math.sin(angle - math.pi / 2) * 16);
    canvas.drawLine(center, tip, needle);
  }

  void _paintSubtleTrail(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.82)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.72, size.width * 0.92, size.height * 0.78);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.trail.withValues(alpha: 0.12);
    canvas.drawPath(path, paint);
  }

  void _paintBaseGradient(Canvas canvas, Size size) {
    final shift = progress * math.pi * 2;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(
          math.cos(shift) * 0.6,
          math.sin(shift) * 0.6,
        ),
        end: Alignment(
          -math.cos(shift + 1.2) * 0.8,
          -math.sin(shift + 1.2) * 0.8,
        ),
        colors: subtle
            ? (night
                ? [
                    const Color(0xFF0B1017),
                    Color.lerp(const Color(0xFF0B1017), AppColors.primary, 0.12)!,
                    Color.lerp(const Color(0xFF101A28), AppColors.trail, 0.18)!,
                    const Color(0xFF0F1419),
                  ]
                : [
                    const Color(0xFFEEF4F8),
                    Color.lerp(const Color(0xFFEEF4F8), AppColors.primary, 0.08)!,
                    Color.lerp(const Color(0xFFE8F5EE), AppColors.trail, 0.12)!,
                    AppColors.background,
                  ])
            : [
                AppColors.adventureDark,
                Color.lerp(const Color(0xFF1D3557), AppColors.primary, 0.5 + math.sin(shift) * 0.08)!,
                Color.lerp(AppColors.trail, AppColors.primary, 0.45 + math.cos(shift) * 0.12)!,
                Color.lerp(AppColors.primaryDark, AppColors.trail, 0.35)!,
              ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintAurora(Canvas canvas, Size size) {
    final shift = progress * math.pi * 2;
    for (var i = 0; i < 3; i++) {
      final phase = shift + i * 1.1;
      final path = Path();
      path.moveTo(0, size.height * (0.35 + i * 0.12));
      for (var x = 0.0; x <= size.width; x += 8) {
        final y = size.height * (0.35 + i * 0.12) +
            math.sin((x / size.width) * math.pi * 2 + phase) * (subtle ? 18 : 32);
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final colors = [
        AppColors.primary,
        AppColors.secondary,
        const Color(0xFF764ba2),
      ];
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors[i].withValues(alpha: subtle ? 0.04 : 0.12),
            colors[i].withValues(alpha: 0),
          ],
        ).createShader(Offset.zero & size);
      canvas.drawPath(path, paint);
    }
  }

  void _paintBlobs(Canvas canvas, Size size) {
    final blobs = [
      (AppColors.primary, 0.0, 0.24),
      (const Color(0xFF764ba2), 0.33, 0.2),
      (AppColors.secondary, 0.66, 0.18),
    ];

    for (final (color, phase, radiusFactor) in blobs) {
      final angle = (progress + phase) * math.pi * 2;
      final cx = size.width * (0.5 + math.cos(angle) * 0.3);
      final cy = size.height * (0.45 + math.sin(angle * 1.1) * 0.24);
      final radius = size.shortestSide * radiusFactor;
      final opacity = subtle ? 0.14 : 0.32 + math.sin(angle) * 0.1;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: radius));

      canvas.drawCircle(Offset(cx, cy), radius, paint);
    }
  }

  void _paintFlowLines(Canvas canvas, Size size) {
    final paths = _taskFlowPaths(size);
    for (var i = 0; i < paths.length; i++) {
      final path = paths[i];
      final phase = (progress + i * 0.2) % 1.0;

      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = subtle ? 1.4 : 2.2
        ..color = (subtle ? AppColors.primary : Colors.white).withValues(alpha: subtle ? 0.1 : 0.2)
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, linePaint);

      final metrics = path.computeMetrics().first;
      final dotPos = metrics.length * phase;
      final tangent = metrics.getTangentForOffset(dotPos);
      if (tangent != null) {
        final dotColor = i.isEven ? AppColors.primary : AppColors.secondary;
        final dotPaint = Paint()
          ..color = dotColor.withValues(alpha: subtle ? 0.45 : 0.85);
        canvas.drawCircle(tangent.position, subtle ? 4 : 6, dotPaint);

        final glowPaint = Paint()
          ..color = dotColor.withValues(alpha: subtle ? 0.15 : 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawCircle(tangent.position, subtle ? 10 : 14, glowPaint);
      }
    }
  }

  List<Path> _taskFlowPaths(Size size) {
    final w = size.width;
    final h = size.height;

    Path curve(Offset start, Offset end, double arch) {
      final path = Path()..moveTo(start.dx, start.dy);
      path.quadraticBezierTo(
        (start.dx + end.dx) / 2 + arch,
        (start.dy + end.dy) / 2 - arch.abs(),
        end.dx,
        end.dy,
      );
      return path;
    }

    return [
      curve(Offset(w * 0.06, h * 0.22), Offset(w * 0.9, h * 0.4), w * 0.1),
      curve(Offset(w * 0.1, h * 0.74), Offset(w * 0.84, h * 0.56), -w * 0.07),
      curve(Offset(w * 0.5, h * 0.06), Offset(w * 0.5, h * 0.94), w * 0.14),
    ];
  }

  void _paintNodes(Canvas canvas, Size size) {
    final nodes = [
      Offset(size.width * 0.14, size.height * 0.26),
      Offset(size.width * 0.86, size.height * 0.36),
      Offset(size.width * 0.18, size.height * 0.72),
      Offset(size.width * 0.8, size.height * 0.64),
      Offset(size.width * 0.5, size.height * 0.48),
    ];

    for (var i = 0; i < nodes.length; i++) {
      final pulse = 0.5 + math.sin((progress + i * 0.15) * math.pi * 2) * 0.5;
      final center = nodes[i];
      final ringColor = subtle ? AppColors.primary : Colors.white;

      final outer = Paint()
        ..color = ringColor.withValues(alpha: subtle ? 0.08 : 0.14 + pulse * 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      canvas.drawCircle(center, 12 + pulse * 5, outer);

      final inner = Paint()
        ..color = (i == 4 ? AppColors.secondary : AppColors.primary)
            .withValues(alpha: subtle ? 0.35 : 0.6 + pulse * 0.25);
      canvas.drawCircle(center, 4.5 + pulse * 2, inner);
    }
  }

  void _paintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;
    const step = 44.0;
    final offset = (progress * step) % step;

    for (var x = -step; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x + offset, 0), Offset(x + offset, size.height), paint);
    }
    for (var y = -step; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y + offset), Offset(size.width, y + offset), paint);
    }
  }

  void _paintParticles(Canvas canvas, Size size) {
    const count = 24;
    for (var i = 0; i < count; i++) {
      final phase = (progress + i / count) % 1.0;
      final x = (i * 37.0 + phase * size.width) % size.width;
      final y = (i * 53.0 + math.sin(phase * math.pi * 2) * 40 + size.height * 0.5) % size.height;
      final alpha = 0.08 + math.sin(phase * math.pi * 2) * 0.06;
      canvas.drawCircle(
        Offset(x, y),
        1.2 + (i % 3) * 0.4,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackpackerMeshPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.subtle != subtle ||
      oldDelegate.night != night;
}
