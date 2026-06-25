import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Animasi ilustrasi backpacker yang sedang mengerjakan tugas — khusus layar login.
class LoginTaskWorkerAnimation extends StatefulWidget {
  const LoginTaskWorkerAnimation({
    super.key,
    this.height = 190,
    this.embedded = false,
  });

  /// Di dalam kartu login (latar terang) — lebih kontras dan terlihat jelas.
  final bool embedded;
  final double height;

  @override
  State<LoginTaskWorkerAnimation> createState() => _LoginTaskWorkerAnimationState();
}

class _LoginTaskWorkerAnimationState extends State<LoginTaskWorkerAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      margin: widget.embedded ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
      decoration: widget.embedded
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.secondary.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.embedded ? 14 : 0),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _TaskWorkerScenePainter(
                progress: _controller.value,
                embedded: widget.embedded,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
    );
  }
}

class _TaskWorkerScenePainter extends CustomPainter {
  _TaskWorkerScenePainter({required this.progress, required this.embedded});

  final double progress;
  final bool embedded;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final groundY = size.height * (embedded ? 0.9 : 0.88);
    if (!embedded) _paintGround(canvas, size, groundY);
    _paintDesk(canvas, size, groundY);
    _paintChair(canvas, size, groundY);
    _paintWorker(canvas, size, groundY);
    _paintLaptop(canvas, size, groundY);
    _paintFloatingTasks(canvas, size);
    _paintSparkles(canvas, size);
  }

  void _paintGround(Canvas canvas, Size size, double groundY) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.06),
        ],
      ).createShader(Rect.fromLTWH(0, groundY - 24, size.width, 24));
    canvas.drawRect(Rect.fromLTWH(0, groundY - 24, size.width, 24), paint);
  }

  void _paintDesk(Canvas canvas, Size size, double groundY) {
    final deskTop = groundY - 52;
    final deskRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.28, deskTop, size.width * 0.44, 8),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      deskRect,
      Paint()..color = (embedded ? AppColors.border : Colors.white).withValues(alpha: embedded ? 0.9 : 0.22),
    );

    final legPaint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = (embedded ? AppColors.textSecondary : Colors.white).withValues(alpha: embedded ? 0.45 : 0.16);
    canvas.drawLine(
      Offset(size.width * 0.34, deskTop + 8),
      Offset(size.width * 0.34, groundY - 6),
      legPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.66, deskTop + 8),
      Offset(size.width * 0.66, groundY - 6),
      legPaint,
    );
  }

  void _paintChair(Canvas canvas, Size size, double groundY) {
    final seatCenter = Offset(size.width * 0.38, groundY - 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: seatCenter, width: 34, height: 10),
        const Radius.circular(5),
      ),
      Paint()..color = AppColors.trail.withValues(alpha: embedded ? 0.75 : 0.55),
    );

    final backCenter = Offset(size.width * 0.36, groundY - 42);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: backCenter, width: 10, height: 34),
        const Radius.circular(5),
      ),
      Paint()..color = AppColors.trail.withValues(alpha: embedded ? 0.65 : 0.45),
    );
  }

  void _paintWorker(Canvas canvas, Size size, double groundY) {
    final t = progress * math.pi * 2;
    final bob = math.sin(t) * 2.2;
    final base = Offset(size.width * 0.42, groundY - 28 + bob);

    final legPaint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF2C3E50).withValues(alpha: 0.85);
    canvas.drawLine(base, base + const Offset(-10, 18), legPaint);
    canvas.drawLine(base, base + const Offset(8, 18), legPaint);

    final torsoTop = base + Offset(0, -34);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: torsoTop + const Offset(0, -16), width: 30, height: 36),
        const Radius.circular(10),
      ),
      Paint()..color = AppColors.primary.withValues(alpha: 0.92),
    );

    final headCenter = torsoTop + const Offset(0, -42);
    canvas.drawCircle(
      headCenter,
      13,
      Paint()..color = const Color(0xFFFFDBAC).withValues(alpha: 0.95),
    );

    final hairPath = Path()
      ..moveTo(headCenter.dx - 13, headCenter.dy - 2)
      ..quadraticBezierTo(headCenter.dx, headCenter.dy - 18, headCenter.dx + 13, headCenter.dy - 2);
    canvas.drawPath(
      hairPath,
      Paint()
        ..color = AppColors.adventureDark.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: torsoTop + const Offset(-18, -8),
          width: 14,
          height: 18,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = AppColors.trail.withValues(alpha: 0.85),
    );

    final leftShoulder = torsoTop + const Offset(-12, -24);
    canvas.drawLine(
      leftShoulder,
      leftShoulder + const Offset(-16, 10),
      Paint()
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.primary.withValues(alpha: 0.85),
    );

    final armSwing = math.sin(t * 2.4) * 8;
    final rightShoulder = torsoTop + const Offset(12, -24);
    final rightHand = rightShoulder + Offset(14 + armSwing * 0.15, 6 + armSwing);
    canvas.drawLine(
      rightShoulder,
      rightHand,
      Paint()
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.primary.withValues(alpha: 0.85),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.52, groundY - 46),
        width: 14,
        height: 9,
      ),
      Paint()..color = Colors.white.withValues(alpha: embedded ? 1 : 0.75),
    );
  }

  void _paintLaptop(Canvas canvas, Size size, double groundY) {
    final t = progress * math.pi * 2;
    final deskTop = groundY - 52;
    final laptopBase = Rect.fromCenter(
      center: Offset(size.width * 0.56, deskTop - 4),
      width: 58,
      height: 6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(laptopBase, const Radius.circular(3)),
      Paint()..color = const Color(0xFFCBD5E1).withValues(alpha: 0.9),
    );

    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.56, deskTop - 18),
        width: 50,
        height: 32,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      screenRect,
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.92),
    );

    final linePaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      final phase = (progress + i * 0.12) % 1.0;
      final widthFactor = 0.35 + math.sin(phase * math.pi * 2) * 0.12;
      linePaint.color = (i.isEven ? AppColors.primary : AppColors.secondary)
          .withValues(alpha: 0.55 + math.sin(phase * math.pi * 2) * 0.25);
      final y = deskTop - 28 + i * 7.0;
      canvas.drawLine(
        Offset(size.width * 0.56 - 18, y),
        Offset(size.width * 0.56 - 18 + 36 * widthFactor, y),
        linePaint,
      );
    }

    if (math.sin(t * 6) > 0) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * 0.56 + 8, deskTop - 30, 2, 10),
        Paint()..color = AppColors.secondary.withValues(alpha: 0.9),
      );
    }
  }

  void _paintFloatingTasks(Canvas canvas, Size size) {
    final tasks = [
      (Icons.assignment_turned_in_outlined, 0.0, Offset(size.width * 0.12, size.height * 0.22)),
      (Icons.handyman_outlined, 0.28, Offset(size.width * 0.82, size.height * 0.18)),
      (Icons.check_circle_outline, 0.56, Offset(size.width * 0.88, size.height * 0.52)),
      (Icons.local_shipping_outlined, 0.78, Offset(size.width * 0.1, size.height * 0.58)),
    ];

    for (final (icon, phase, anchor) in tasks) {
      final t = (progress + phase) % 1.0;
      final floatY = math.sin(t * math.pi * 2) * 10;
      final floatX = math.cos(t * math.pi * 2) * 6;
      final pos = anchor + Offset(floatX, floatY);
      final scale = 0.92 + math.sin(t * math.pi * 2) * 0.06;
      final done = t > 0.72 && t < 0.88;

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.scale(scale);

      final cardRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 54, height: 34),
        const Radius.circular(10),
      );
      canvas.drawRRect(
        cardRect,
        Paint()..color = (embedded ? Colors.white : Colors.white).withValues(alpha: embedded ? 0.92 : 0.14),
      );
      canvas.drawRRect(
        cardRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = (embedded ? AppColors.primary : Colors.white).withValues(alpha: embedded ? 0.2 : 0.1),
      );

      _drawIcon(
        canvas,
        icon,
        done
            ? AppColors.secondary
            : (embedded ? AppColors.primary : Colors.white.withValues(alpha: 0.88)),
      );

      if (done) {
        canvas.drawCircle(
          const Offset(20, -10),
          6,
          Paint()..color = AppColors.secondary.withValues(alpha: 0.95),
        );
        _drawIcon(canvas, Icons.check, Colors.white, size: 8, offset: const Offset(20, -10));
      }

      canvas.restore();
    }
  }

  void _paintSparkles(Canvas canvas, Size size) {
    final sparklePhase = (progress * 1.6) % 1.0;
    if (sparklePhase > 0.75) return;

    final alpha = (1 - (sparklePhase / 0.75)) * 0.7;
    final paint = Paint()..color = AppColors.sand.withValues(alpha: alpha);
    final origin = Offset(size.width * 0.62, size.height * 0.42);

    for (var i = 0; i < 5; i++) {
      final angle = i * (math.pi * 2 / 5) + progress * math.pi * 2;
      final dist = 12 + sparklePhase * 28;
      final p = origin + Offset(math.cos(angle) * dist, math.sin(angle) * dist);
      canvas.drawCircle(p, 2.2, paint);
    }
  }

  void _drawIcon(
    Canvas canvas,
    IconData icon,
    Color color, {
    double size = 18,
    Offset offset = Offset.zero,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      offset - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _TaskWorkerScenePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.embedded != embedded;
}
