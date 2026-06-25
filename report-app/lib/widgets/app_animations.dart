import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Animasi masuk sekali — fade + slide dari bawah.
class EntranceFadeSlide extends StatefulWidget {
  const EntranceFadeSlide({
    super.key,
    required this.child,
    this.index = 0,
    this.delay = const Duration(milliseconds: 40),
    this.duration = const Duration(milliseconds: 420),
    this.offsetY = 18,
  });

  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  @override
  State<EntranceFadeSlide> createState() => _EntranceFadeSlideState();
}

class _EntranceFadeSlideState extends State<EntranceFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offsetY / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future<void>.delayed(widget.delay * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Logo Backpacker dengan pulse halus — auth & splash.
class AnimatedBrandLogo extends StatefulWidget {
  const AnimatedBrandLogo({
    super.key,
    this.size = 64,
    this.compact = false,
  });

  final double size;
  final bool compact;

  @override
  State<AnimatedBrandLogo> createState() => _AnimatedBrandLogoState();
}

class _AnimatedBrandLogoState extends State<AnimatedBrandLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
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
        final t = _controller.value;
        final pulse = 0.94 + math.sin(t * math.pi * 2) * 0.06;
        final bounce = math.sin(t * math.pi * 2) * 3;
        final glow = 0.2 + math.sin(t * math.pi * 2) * 0.16;
        final orbitAngle = t * math.pi * 2;

        return Transform.translate(
          offset: Offset(0, bounce),
          child: SizedBox(
            width: widget.size * 1.35,
            height: widget.size * 1.35,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ...List.generate(5, (i) {
                  final angle = orbitAngle + i * (math.pi * 2 / 5);
                  final radius = widget.size * 0.52;
                  return Transform.translate(
                    offset: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
                    child: Container(
                      width: 5 + (i.isEven ? 1.0 : 0),
                      height: 5 + (i.isEven ? 1.0 : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (i.isEven ? AppColors.sand : AppColors.trailLight)
                            .withValues(alpha: 0.55 + math.sin(angle) * 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(widget.size * 0.26),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: glow),
                          blurRadius: 22,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: AppColors.trail.withValues(alpha: glow * 0.5),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.backpack_rounded,
                      color: Colors.white,
                      size: widget.size * 0.48,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Loading indicator dengan ikon marketplace.
class BrandedLoadingIndicator extends StatefulWidget {
  const BrandedLoadingIndicator({super.key, this.size = 36, this.color});

  final double size;
  final Color? color;

  @override
  State<BrandedLoadingIndicator> createState() => _BrandedLoadingIndicatorState();
}

class _BrandedLoadingIndicatorState extends State<BrandedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tone = widget.color ?? AppColors.primary;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 2.5,
                value: null,
                color: tone.withValues(alpha: 0.35 + _controller.value * 0.25),
              ),
              Transform.rotate(
                angle: _controller.value * 6.28,
                child: Icon(
                  Icons.backpack_outlined,
                  size: widget.size * 0.42,
                  color: tone,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
